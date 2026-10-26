import os
import StoreKit
import SwiftUI

// MARK: - 完整功能解锁 IAP（StoreKit 2 · 一次性买断）
//
// 产品 ID：com.physicsapex.app.full_unlock（$5.99 一次性买断，价格在 App Store Connect 配置；沿用旧 ID，老用户购买直接有效）
// 定价口径：销售地区为港澳台，ASC 定价基准货币为美元（中国大陆已移除，不再是定价参考区）。
// 免费档：练习前 10 题 + 前 10 道降维快解训练 + 1 个三级重访 + 3 个沙盘 + 10 把武器；
//        公式速记 / 每日一题 / 武器雷达 / 训练地图 永久免费（习惯与转化钩子）。
// 解锁后：138 题、68 快解训练、三级重访、30 把武器与竞赛训练全开。
// 本地 UserDefaults 缓存即时呈现，启动时 Transaction.currentEntitlements 核验防破解。
// 解锁 UI 唯一载体：Features/Paywall/PaywallView.swift，全 App 两处入口共用。

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()

    let productID = "com.physicsapex.app.full_unlock"

    /// 免费开放的各模块数量（列表里的前 N 个）。改动需同步 ContentIntegrityTests.testFreeTierPolicy。
    static let freeDescentCount = 10
    static let freeRevisitCount = 1
    static let freeWeaponCount = 10
    static let freeProblemCount = 10
    static let freeSandboxCount = 3

    // MARK: 免费档判定（全 App 唯一口径）
    //
    // 规则：列表里的前 N 个免费，其余付费。判定必须跟着「当前展示的那条列表」走，
    // 不能按全局下标算——段位页 / 章节页是过滤后的子集，用全局下标会得到「一题都不免费」的结果，
    // 用户看到的就是满屏锁。

    /// 降维快解战例（按 descentCases 顺序的前 N 道免费）
    func isDescentPremiumLocked(index: Int) -> Bool {
        !isUnlocked && index >= Self.freeDescentCount
    }

    /// 战例题本身（方法雷达用，判定口径与快解列表一致）
    func isDescentCasePremiumLocked(_ p: PhysicsProblem) -> Bool {
        guard !isUnlocked else { return false }
        let idx = ProblemBank.descentCases.firstIndex { $0.id == p.id } ?? .max
        return idx >= Self.freeDescentCount
    }

    /// 三级重访
    func isRevisitPremiumLocked(index: Int) -> Bool {
        !isUnlocked && index >= Self.freeRevisitCount
    }

    /// 互动模拟沙盘
    func isSandboxPremiumLocked(index: Int) -> Bool {
        !isUnlocked && index >= Self.freeSandboxCount
    }

    /// 方法（按 allCases 顺序的前 N 个免费）
    func isWeaponPremiumLocked(_ w: PhysicsWeapon) -> Bool {
        guard !isUnlocked else { return false }
        return (PhysicsWeapon.allCases.firstIndex(of: w) ?? 0) >= Self.freeWeaponCount
    }

    /// 练习题：按传入列表内的下标判定，每个列表各自前 N 道免费。
    func isProblemPremiumLocked(_ p: PhysicsProblem, in list: [PhysicsProblem]) -> Bool {
        guard !isUnlocked else { return false }
        return (list.firstIndex { $0.id == p.id } ?? 0) >= Self.freeProblemCount
    }

    /// 商品未就绪时的兜底展示价。销售地区为港澳台，ASC 定价基准为美元，兜底价必须与基准货币一致。
    static let fallbackPriceDisplay = "$5.99"

    @Published private(set) var isUnlocked: Bool = false
    @Published private(set) var product: Product?
    /// 商品加载失败原因：nil = 加载成功或尚未尝试。用于与购买动作的 errorMessage 区分展示。
    @Published private(set) var productLoadError: String?
    @Published private(set) var isPurchasing: Bool = false
    @Published private(set) var errorMessage: String?

    private let storageKey = "physicsapex_full_unlocked"
    private static let log = Logger(subsystem: "com.physicsapex.app", category: "purchase")
    private var updatesTask: Task<Void, Never>?

    private init() {
        isUnlocked = UserDefaults.standard.bool(forKey: storageKey)
        // 交易监听必须在 App 启动时挂载并保持整个生命周期：
        // 处理 Ask to Buy 事后批准、中断购买续接等非当场完成的交易，否则这些购买将永远无法解锁。
        updatesTask = listenForTransactions()
        Task {
            await loadProduct()
            await refreshEntitlements()
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    await transaction.finish()
                    await refreshEntitlements()
                case .unverified(_, let error):
                    Self.log.error("收到未通过校验的交易更新: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }

    @MainActor
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [productID])
            if let found = products.first {
                product = found
                productLoadError = nil
            } else {
                // 返回空数组不抛错：几乎必然是 App Store Connect 配置问题
                // （付费协议未生效 / 商品未上架或未随版本提审 / 商品 ID 不匹配），与网络无关。
                Self.log.error("商品查询返回空数组，productID=\(self.productID, privacy: .public)，疑似 ASC 配置问题")
                productLoadError = "商品暂不可用，可能是商店配置或网络问题，请稍后重试"
            }
        } catch {
            Self.log.error("商品加载失败: \(error.localizedDescription, privacy: .public)")
            productLoadError = "无法连接 App Store，请检查网络后重试（\(error.localizedDescription)）"
        }
    }

    @MainActor
    func purchase() async {
        // 商品未就绪时先现场重试一次加载，避免"点了没反应"
        if product == nil {
            await loadProduct()
        }
        guard let product else {
            errorMessage = productLoadError ?? "获取产品信息失败，请稍后重试"
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
