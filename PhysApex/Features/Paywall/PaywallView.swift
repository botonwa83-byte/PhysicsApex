import SwiftUI

// MARK: - 完整功能解锁付费墙（形态对齐 ChemApex 的 PaywallView）
//
// 入口规则（解锁方式统一）：
//   - 常驻入口：首页置顶解锁横幅、「更多」页解锁卡片
//   - 就地入口：任何被锁住的内容卡片 / 题目行 / 沙盘行，点击直接弹本视图
// 全 App 只有一个 .sheet 挂载点（PhysApexApp 的 RootView），由 PaywallPresenter 统一调度，
// 不存在"点了没反应"的死锁卡片。
// 价格一元化：App Store Connect 配置基准价，代码兜底价取 PurchaseManager.fallbackPriceDisplay。

struct PaywallView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @Environment(\.dismiss) private var dismiss

    private var priceLabel: String { purchase.product?.displayPrice ?? PurchaseManager.fallbackPriceDisplay }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroArea

                VStack(alignment: .leading, spacing: 14) {
                    benefitRow(icon: "bolt.shield.fill", color: .apexLava,
                               title: "解锁全部 \(ProblemBank.descentCases.count) 道降维快解训练",
                               desc: "同一道压轴题，常规解 8 分钟 vs 快解 30 秒——双解对照，练的是「怎么想到」")
                    benefitRow(icon: "wand.and.stars", color: .apexMystery,
                               title: "解锁全部 \(PhysicsWeapon.allCases.count) 个降维方法",
                               desc: "整体法、能量守恒、极值……每个都讲清「何时用 · 怎么用」")
                    benefitRow(icon: "atom", color: .apexEmerald,
                               title: "解锁全部互动模拟沙盘",
                               desc: "拖动参数，实时看见轨迹、受力与场的变化——把抽象公式变成看得见的现象")
                    benefitRow(icon: "target", color: .apexStarBlue,
                               title: "解锁全部 \(ProblemBank.all.count) 道分层练习 · 三级重访",
                               desc: "基础到压轴分层推进，答错按 1/3/7 天自动排期重访")
                    benefitRow(icon: "infinity", color: .apexGold,
                               title: "一次买断，永久使用",
                               desc: "无订阅、无续费，方法与内容持续更新；支持换机恢复购买")
                }
                .padding(.horizontal, 24).padding(.top, 28).padding(.bottom, 20)

                Divider().padding(.horizontal, 24)

                VStack(spacing: 6) {
                    Text("免费已开放：前 \(PurchaseManager.freeDescentCount) 道降维快解 · 前 \(PurchaseManager.freeProblemCount) 道练习 · \(PurchaseManager.freeWeaponCount) 个方法 · \(PurchaseManager.freeSandboxCount) 个沙盘；公式速记 / 每日一题 / 武器雷达 / 训练地图 永久免费")
                        .font(.footnote).foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Text("先白嫖几道快解试试手感，再解锁全套 →")
                        .font(.footnote).fontWeight(.medium).foregroundColor(.apexLava)
                }
                .padding(.vertical, 16).padding(.horizontal, 24)

                purchaseButton.padding(.horizontal, 24)

                Button { Task { await purchase.restore() } } label: {
                    Text("恢复购买").font(.footnote).foregroundColor(.secondary).underline()
                }
                .padding(.top, 12).disabled(purchase.isPurchasing)

                if purchase.product == nil, let loadError = purchase.productLoadError {
                    Text(loadError).font(.caption).foregroundColor(.apexGold)
                        .multilineTextAlignment(.center).padding(.horizontal, 24).padding(.top, 8)
                }
                if let err = purchase.errorMessage {
                    Text(err).font(.caption).foregroundColor(.apexDanger)
                        .multilineTextAlignment(.center).padding(.horizontal, 24).padding(.top, 8)
                }

                #if DEBUG
                Button("（调试）本地解锁") { purchase.debugToggle() }
                    .font(.caption2).foregroundColor(.secondary).padding(.top, 8)
                #endif

                Text("购买即视为同意[用户协议](https://botonwa83-byte.github.io/PhysicsApex/terms.html)与[隐私政策](https://botonwa83-byte.github.io/PhysicsApex/privacy.html)。付款通过 Apple 账户完成，换机后可在「恢复购买」找回。")
                    .font(.system(size: 10)).foregroundColor(.secondary)
                    .tint(.apexLava)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28).padding(.top, 16).padding(.bottom, 32)
            }
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .accessibilityIdentifier("paywallScrollView")
        .onAppear {
            if purchase.product == nil {
                Task { await purchase.loadProduct() }
            }
        }
        .onChange(of: purchase.isUnlocked) { unlocked in
            if unlocked { dismiss() }
        }
    }

    private var heroArea: some View {
        ZStack {
            LinearGradient(colors: [Color.apexLava, Color.apexMystery],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 10) {
                Image(systemName: "bolt.shield.fill").font(.system(size: 44)).foregroundColor(.white)
                Text("解锁全套解题武器").font(.system(size: 24, weight: .black, design: .rounded)).foregroundColor(.white)
                Text("不是多给你几道题，是教你怎么把题秒掉").font(.subheadline).foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 40)
        }
    }

    private var purchaseButton: some View {
        Button { Task { await purchase.purchase() } } label: {
            HStack(spacing: 10) {
                if purchase.isPurchasing { ProgressView().tint(.white) }
                else { Image(systemName: "lock.open.fill") }
                Text(purchase.isPurchasing ? "处理中…" : "立即解锁  \(priceLabel)").fontWeight(.bold)
            }
            .font(.headline).foregroundColor(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 16)
            .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(16)
            .shadow(color: Color.apexLava.opacity(0.3), radius: 10, y: 4)
        }
        .disabled(purchase.isPurchasing)
    }

    private func benefitRow(icon: String, color: Color, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(color.opacity(0.15)).frame(width: 38, height: 38)
                Image(systemName: icon).font(.subheadline).foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold).foregroundColor(.primary)
                Text(desc).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}

// MARK: - 全 App 统一的付费墙调度
//
// 任何一个被锁住的内容被点到，都走这里弹出同一个 PaywallView。
// 这么做的原因：不这么做，每个页面都要自己挂一份 @State + .sheet，
// 漏挂一个就得到一个「点了没反应」的死锁卡片——这正是之前的状态。
// 挂载点只有一处：PhysApexApp 的 RootView。

final class PaywallPresenter: ObservableObject {
    static let shared = PaywallPresenter()

    @Published var isPresented = false

    private init() {}

    @MainActor func present() { isPresented = true }
}

// MARK: - 付费锁的统一视觉
//
// 全 App 每处锁态都用同一套：金色皇冠 + 「解锁完整版」角标 + 整卡 0.7 透明度。
// 见到这个角标，点它必然弹付费墙，不存在例外。

/// 角标本体。
struct PremiumLockChip: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "crown.fill").font(.system(size: 9))
            Text("解锁完整版")
        }
        .font(AppFont.chip)
        .padding(.horizontal, 8).padding(.vertical, 4)
        .background(Color.apexGold.opacity(0.15))
        .foregroundColor(.apexGold)
        .clipShape(Capsule())
    }
}

/// 锁态的皇冠标记（卡片型锁态传大字号，行内型用默认）。
struct PremiumCrownMark: View {
    var font: Font = .subheadline

    var body: some View {
        Image(systemName: "crown.fill")
            .font(font)
            .foregroundColor(.apexGold)
    }
}

/// 页面顶部/底部的解锁横幅：皇冠 + 文案 + 价格胶囊，点击弹付费墙。
/// 对齐 ChemApex 首页 premiumBanner 的位置与形态。
struct PremiumBanner: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    private let title: String
    private let subtitle: String

    init(title: String = "解锁完整版", subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }

    private var priceLabel: String {
        purchase.product?.displayPrice ?? PurchaseManager.fallbackPriceDisplay
    }

    var body: some View {
        Button { PaywallPresenter.shared.present() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "crown.fill")
                    .font(.title3).foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.18))
                    .clipShape(RoundedRectangle(cornerRadius: Radius.inner))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(AppFont.cardTitle).foregroundColor(.white)
                    Text(subtitle).font(AppFont.caption).foregroundColor(.white.opacity(0.9)).lineLimit(2)
                }
                Spacer(minLength: 0)
                Text(priceLabel)
                    .font(AppFont.cardTitle).foregroundColor(.white)
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .background(Color.white.opacity(0.22)).clipShape(Capsule())
            }
            .padding(Spacing.lg)
            .background(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(Radius.card)
            .shadow(color: Color.apexLava.opacity(0.3), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

/// 「更多」页的解锁卡片行：皇冠 + 双行文案 + 价格胶囊。
struct PremiumUnlockRow: View {
    @ObservedObject private var purchase = PurchaseManager.shared

    private var priceLabel: String {
        purchase.product?.displayPrice ?? PurchaseManager.fallbackPriceDisplay
    }

    var body: some View {
        Button { PaywallPresenter.shared.present() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "crown.fill").font(.title3).foregroundColor(.apexGold)
                VStack(alignment: .leading, spacing: 2) {
                    Text("解锁完整版").font(.headline).foregroundColor(.primary)
                    Text("全部快解训练 · 沙盘 · 三级重访，一次买断")
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                Text(priceLabel).font(AppFont.chip).foregroundColor(.apexGold)
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}
