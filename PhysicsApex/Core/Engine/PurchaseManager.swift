import StoreKit
import SwiftUI

// MARK: - 完整功能解锁 IAP（StoreKit 2 · 一次性买断）
//
// 产品 ID：com.physicsapex.app.full_unlock（¥22 一次性买断，价格在 App Store Connect 配置）
// 免费档：练习前 10 题 + 前 10 道降维战例 + 1 个三级重访 + 3 个沙盘 + 10 把武器；
//        公式训练 / 每日一题 / 武器雷达 / 训练地图 永久免费（习惯与转化钩子）。
// 解锁后：138 题、68 战例、三级重访、30 把武器与竞赛内容全开。
// 本地 UserDefaults 缓存即时呈现，启动时 Transaction.currentEntitlements 核验防破解。

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    let productID = "com.physicsapex.app.full_unlock"

    /// 免费开放的各模块数量（列表里的前 N 个）。改动需同步 ContentIntegrityTests.testFreeTierPolicy。
    static let freeDescentCount = 10
    static let freeRevisitCount = 1
    static let freeWeaponCount = 10
    static let freeProblemCount = 10
    static let freeSandboxCount = 3

    @Published private(set) var isUnlocked: Bool = false
    @Published private(set) var product: Product?
    @Published private(set) var isPurchasing: Bool = false
    @Published private(set) var errorMessage: String?

    private let storageKey = "physicsapex_full_unlocked"

    private init() {
        isUnlocked = UserDefaults.standard.bool(forKey: storageKey)
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
    }

    @MainActor
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            product = products.first
        } catch {
            // 沙盒未配置时静默失败，价格降级显示
        }
    }

    @MainActor
    func purchase() async {
        guard let product else {
            errorMessage = "获取产品信息失败，请检查网络后重试"
            return
        }
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                unlock()
            case .userCancelled:
                break
            case .pending:
                errorMessage = "购买待处理（可能需要家长确认），完成后将自动解锁"
            @unknown default:
                break
            }
        } catch {
            errorMessage = "购买失败：\(error.localizedDescription)"
        }
    }

    @MainActor
    func restore() async {
        isPurchasing = true
        errorMessage = nil
        defer { isPurchasing = false }
        do {
            try await AppStore.sync()
            await refreshEntitlements()
            if !isUnlocked { errorMessage = "未找到购买记录" }
        } catch {
            errorMessage = "恢复失败：\(error.localizedDescription)"
        }
    }

    func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result,
               tx.productID == productID,
               tx.revocationDate == nil {
                await MainActor.run { unlock() }
                return
            }
        }
    }

    @MainActor
    private func unlock() {
        isUnlocked = true
        UserDefaults.standard.set(true, forKey: storageKey)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error): throw error
        case .verified(let value): return value
        }
    }

    #if DEBUG
    /// 调试用：本地直接解锁 / 还原，便于无 ASC 时预览。
    @MainActor func debugToggle() {
        isUnlocked.toggle()
        UserDefaults.standard.set(isUnlocked, forKey: storageKey)
    }
    #endif
}
