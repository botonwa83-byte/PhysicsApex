import SwiftUI

// MARK: - 解锁确认卡（简洁直购：价格 + 购买 + 恢复，一屏完成）
// 全 App 仅两处入口：「降维快解」页解锁横幅、「我的」页解锁卡片。

struct UnlockSheet: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss

    private var priceLabel: String { purchase.product?.displayPrice ?? "¥22" }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            // 顶部抓取条
            Capsule().fill(Color.secondary.opacity(0.3))
                .frame(width: 36, height: 5)
                .padding(.top, Spacing.sm)

            header
            benefitList
            purchaseArea
            restoreAndErrors

            Spacer(minLength: 0)

            Text("一次性买断 · 无订阅 · 付款通过 Apple 账户完成")
                .font(.system(size: 10)).foregroundColor(.secondary)
                .padding(.bottom, Spacing.md)
        }
        .padding(.horizontal, Spacing.xl)
        .background(Color.apexBackground.ignoresSafeArea())
        .onAppear {
            if purchase.product == nil {
                Task { await purchase.loadProduct() }
            }
        }
        .onChange(of: purchase.isUnlocked) { unlocked in
            if unlocked { dismiss() }
        }
    }

    // MARK: 区块

    private var header: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "bolt.shield.fill")
                .font(.system(size: 40))
                .foregroundStyle(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .top, endPoint: .bottom))
            Text("解锁完整训练功能")
                .font(.title3.bold()).foregroundColor(.primary)
            Text("一次买断，永久使用")
                .font(AppFont.caption).foregroundColor(.secondary)
        }
        .padding(.top, Spacing.xs)
    }

    private var benefitList: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            benefitRow("全部 \(ProblemBank.all.count) 道分层练习")
            benefitRow("全部 \(ProblemBank.descentCases.count) 道降维快解训练")
            benefitRow("全部三级重访 · \(PhysicsWeapon.allCases.count) 个快解方法 · 43 个模拟沙盘")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.apexLava.opacity(0.07))
        .cornerRadius(Radius.card)
    }

    private func benefitRow(_ text: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle.fill").font(.footnote).foregroundColor(.apexEmerald)
            Text(text).font(AppFont.body).foregroundColor(.primary)
        }
    }

    @ViewBuilder
    private var purchaseArea: some View {
        Button { Task { await purchase.purchase() } } label: {
            HStack(spacing: Spacing.sm) {
                if purchase.isPurchasing { ProgressView().tint(.white) }
                else { Image(systemName: "lock.open.fill") }
                Text(purchase.isPurchasing ? "处理中…" : "立即解锁  \(priceLabel)")
                    .fontWeight(.bold)
            }
            .font(.headline).foregroundColor(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 15)
            .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(14)
            .shadow(color: Color.apexLava.opacity(0.3), radius: 10, y: 4)
        }
        .disabled(purchase.isPurchasing)
    }

    @ViewBuilder
    private var restoreAndErrors: some View {
        Button { Task { await purchase.restore() } } label: {
            Text("恢复购买").font(.footnote).foregroundColor(.secondary).underline()
        }
        .padding(.top, Spacing.xs)
        .disabled(purchase.isPurchasing)

        if purchase.product == nil, let loadError = purchase.productLoadError {
            Text(loadError).font(.caption).foregroundColor(.apexGold)
                .multilineTextAlignment(.center)
        }
        if let err = purchase.errorMessage {
            Text(err).font(.caption).foregroundColor(.apexDanger)
                .multilineTextAlignment(.center)
        }

        #if DEBUG
        Button("（调试）本地解锁") { purchase.debugToggle() }
            .font(.caption2).foregroundColor(.secondary).padding(.top, Spacing.xs)
        #endif
    }
}
