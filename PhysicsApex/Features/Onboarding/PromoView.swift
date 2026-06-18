import SwiftUI

// MARK: - 启动广告页（开头首页）：品牌 → 卖点 → 数据 → 开发者 → 版权 → 进入
// 设计参考 MathApex PromoView。开发者 Top King。

struct PromoView: View {
    var onEnter: () -> Void

    @State private var appeared = false
    @State private var glow = false

    private let features: [(icon: String, color: Color, title: String, desc: String)] = [
        ("bolt.fill", .apexLava, "降维秒杀", "每道压轴题给你一招「上帝视角」秒杀解，常规与降维双解对照"),
        ("scope", .apexEmerald, "互动模拟沙盘", "抛体 / 碰撞 / 电路…拖一拖参数，亲眼看见物理"),
        ("map.fill", .apexStarBlue, "知识路线图", "整个高考物理一图纵览，每个考点都能点开训练"),
        ("brain.head.profile", .apexMystery, "错因诊断", "答错时点破你的直觉陷阱，似是而非一击点醒"),
        ("checklist", .apexGold, "错题集 + 智能复习", "艾宾浩斯间隔重复，自动安排复盘"),
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "070C1D"), Color(hex: "1A1140"), Color(hex: "070C1D")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Logo + 品牌
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.apexLava, .apexGold], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 96, height: 96)
                                .shadow(color: Color.apexLava.opacity(glow ? 0.7 : 0.3), radius: glow ? 26 : 12)
                            Image(systemName: "atom").font(.system(size: 46, weight: .bold)).foregroundColor(.white)
                        }
                        Text("PHYSICS APEX")
                            .font(.system(size: 30, weight: .heavy, design: .rounded)).tracking(2)
                            .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
                        Text("看 见 物 理 · 降 维 秒 杀")
                            .font(.system(size: 14, weight: .medium)).tracking(2).foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 48)

                    // 超能力 Hero
                    VStack(spacing: 10) {
                        Text("装上 PhysApex，解锁「降维秒杀」超能力")
                            .font(.system(size: 18, weight: .bold)).multilineTextAlignment(.center).foregroundColor(.white)
                        Text("用守恒、对称、等效俯瞰高考压轴\n看到压轴题，一招降维就能秒")
                            .font(.system(size: 13)).multilineTextAlignment(.center).foregroundColor(.white.opacity(0.6)).lineSpacing(4)
                    }
                    .padding(.top, 28).padding(.horizontal, 24)

                    // 卖点卡片
                    VStack(spacing: 12) {
                        ForEach(Array(features.enumerated()), id: \.offset) { _, f in
                            HStack(spacing: 14) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12).fill(f.color.opacity(0.20)).frame(width: 46, height: 46)
                                    Image(systemName: f.icon).font(.system(size: 20, weight: .semibold)).foregroundColor(f.color)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(f.title).font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                                    Text(f.desc).font(.system(size: 13)).foregroundColor(.white.opacity(0.65)).lineSpacing(2).fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
                        }
                    }
                    .padding(.top, 28).padding(.horizontal, 24)

                    // 数据统计
                    HStack(spacing: 0) {
                        stat("\(KnowledgeAtlas.totalPoints)", "核心知识点")
                        statDivider
                        stat("7", "互动沙盘")
                        statDivider
                        stat("2", "套解法/题")
                    }
                    .padding(.vertical, 18).padding(.horizontal, 24)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.05)))
                    .padding(.top, 24).padding(.horizontal, 24)

                    // 开发者区
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .top, endPoint: .bottom)).frame(width: 44, height: 44)
                                Text("K").font(.system(size: 22, weight: .heavy)).foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Top King").font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                                Text("独立开发者 / 教育科技探索者").font(.system(size: 12)).foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        Text("专注教育类 App，用科技让学习更高效。PhysApex 把物理学家的「上帝视角」带进高考——守恒、对称、等效、量纲，让每道压轴题都有一招可秒杀，也让物理重新变得好玩。")
                            .font(.system(size: 13)).foregroundColor(.white.opacity(0.65)).lineSpacing(3)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.06)))
                    .padding(.top, 24).padding(.horizontal, 24)

                    // 版权
                    VStack(spacing: 4) {
                        Text("PhysApex · 物理制高点  v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.1.0")").font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                        Text("© 2026 Top King. All rights reserved.").font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
                    }
                    .padding(.top, 22).padding(.bottom, 120)
                }
                .frame(maxWidth: 600).frame(maxWidth: .infinity)
                .opacity(appeared ? 1 : 0).offset(y: appeared ? 0 : 24)
            }

            // 底部固定进入按钮
            VStack {
                Spacer()
                Button(action: onEnter) {
                    HStack(spacing: 8) {
                        Text("开 启 物 理 降 维 之 旅").fontWeight(.bold).tracking(1)
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing),
                                in: RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.apexLava.opacity(0.45), radius: 14, y: 4)
                }
                .frame(maxWidth: 600 - 48).padding(.horizontal, 24).padding(.bottom, 20)
                .background(
                    LinearGradient(colors: [Color(hex: "070C1D").opacity(0), Color(hex: "070C1D")], startPoint: .top, endPoint: .bottom)
                        .frame(height: 120).allowsHitTesting(false), alignment: .bottom
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) { appeared = true }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { glow = true }
        }
    }

    private func stat(_ n: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(n).font(.system(size: 24, weight: .heavy, design: .rounded)).foregroundColor(.apexGold)
            Text(label).font(.system(size: 12)).foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle().fill(Color.white.opacity(0.2)).frame(width: 1, height: 30)
    }
}
