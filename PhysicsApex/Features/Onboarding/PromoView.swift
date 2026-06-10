import SwiftUI

// MARK: - 启动宣传页：首次打开的品牌时刻，集中展示核心卖点

struct PromoView: View {
    var onEnter: () -> Void
    @State private var glow = false
    @State private var appear = false

    private let features: [(icon: String, color: Color, title: String, desc: String)] = [
        ("bolt.fill", .apexLava, "降维秒杀", "每道压轴题给你一招「上帝视角」秒杀解，常规与降维双解对照"),
        ("scope", .apexEmerald, "互动模拟沙盘", "抛体 / 碰撞 / 电路…拖一拖参数，亲眼看见物理"),
        ("map.fill", .apexStarBlue, "知识全景图", "整个高考物理一图纵览，每个知识点都能点开深入"),
        ("brain.head.profile", .apexMystery, "错因诊断", "答错时点破你的直觉陷阱，似是而非一击点醒"),
        ("books.vertical.fill", .apexGold, "错题本 + 智能复习", "艾宾浩斯间隔重复，自动安排复盘"),
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "070C1D"), Color(hex: "1A1140"), Color(hex: "070C1D")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: Spacing.xl) {
                Spacer(minLength: Spacing.xxl)

                // 品牌
                VStack(spacing: Spacing.md) {
                    Image(systemName: "atom")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .top, endPoint: .bottom))
                        .shadow(color: Color.apexLava.opacity(glow ? 0.8 : 0.3), radius: glow ? 28 : 12)
                    Text("PHYSICS APEX")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
                    Text("看见物理 · 降维秒杀")
                        .font(.headline).foregroundColor(.white.opacity(0.85))
                }
                .scaleEffect(appear ? 1 : 0.85)
                .opacity(appear ? 1 : 0)

                Spacer(minLength: 0)

                // 卖点列表
                VStack(spacing: Spacing.md) {
                    ForEach(Array(features.enumerated()), id: \.offset) { i, f in
                        HStack(spacing: Spacing.md) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).fill(f.color.opacity(0.22)).frame(width: 44, height: 44)
                                Image(systemName: f.icon).font(.headline).foregroundColor(f.color)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(f.title).font(.subheadline.bold()).foregroundColor(.white)
                                Text(f.desc).font(.caption).foregroundColor(.white.opacity(0.7)).fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer(minLength: 0)
                        }
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.15 + Double(i) * 0.08), value: appear)
                    }
                }
                .padding(.horizontal, Spacing.lg)

                Spacer(minLength: 0)

                // 进入按钮
                Button(action: onEnter) {
                    HStack(spacing: 8) {
                        Text("开启物理降维之旅").fontWeight(.bold)
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(16)
                    .shadow(color: Color.apexLava.opacity(0.4), radius: 12, y: 4)
                }
                .padding(.horizontal, Spacing.xl)
                .padding(.bottom, Spacing.xxl)
                .opacity(appear ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { appear = true }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { glow = true }
        }
    }
}
