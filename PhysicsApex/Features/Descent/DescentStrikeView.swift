import SwiftUI

// MARK: - 降维打击 · 电影级动画（震撼人心的卖点时刻）
// 流程：题目浮现 → 升维俯瞰(题目缩小飞向星空) → 武器自天而降劈下(闪光+冲击) → 「秒杀」定格。

struct DescentStrikeView: View {
    let weaponName: String
    let weaponIcon: String
    let timeRatio: Double
    var onFinish: () -> Void

    @State private var phase = 0
    @State private var problemScale: CGFloat = 1
    @State private var problemY: CGFloat = 0
    @State private var problemOpacity: Double = 0
    @State private var weaponY: CGFloat = -420
    @State private var weaponScale: CGFloat = 0.3
    @State private var flash: Double = 0
    @State private var shockwave: CGFloat = 0
    @State private var showVerdict = false
    @State private var starsOn = false

    var body: some View {
        ZStack {
            // 深空背景
            LinearGradient(colors: [Color(hex: "070C1D"), Color(hex: "1A1140"), Color(hex: "070C1D")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            StarField(active: starsOn)

            // 冲击波
            Circle()
                .stroke(Color.apexLava.opacity(0.6), lineWidth: 3)
                .frame(width: shockwave, height: shockwave)
                .opacity(shockwave > 0 ? max(0, 1 - shockwave / 700) : 0)

            // 题目（升维俯瞰中缩小飞走）
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.apexStarBlue, lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
                    .frame(width: 150, height: 96)
                Text("压轴题").font(.headline).foregroundColor(.apexStarBlue)
            }
            .scaleEffect(problemScale)
            .offset(y: problemY)
            .opacity(problemOpacity)

            // 武器自天而降
            VStack(spacing: 10) {
                Image(systemName: weaponIcon)
                    .font(.system(size: 64, weight: .black))
                    .foregroundStyle(LinearGradient(colors: [.white, .apexGold], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .apexLava, radius: 24)
                Text(weaponName)
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundColor(.white)
            }
            .scaleEffect(weaponScale)
            .offset(y: weaponY)
            .opacity(phase >= 2 ? 1 : 0)

            // 白闪
            Color.white.opacity(flash).ignoresSafeArea()

            // 判定定格
            if showVerdict {
                VStack(spacing: 14) {
                    Text("秒 杀")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .apexLava.opacity(0.6), radius: 16)
                    Text("「\(weaponName)」从高维俯瞰，此题显然")
                        .font(.headline).foregroundColor(.white.opacity(0.9))
                    Text("省时约 \(String(format: "%.0f", timeRatio))×")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.apexEmerald)
                        .padding(.horizontal, 16).padding(.vertical, 6)
                        .background(Color.apexEmerald.opacity(0.15)).clipShape(Capsule())

                    Button(action: onFinish) {
                        Text("查看降维解法")
                            .font(.headline).foregroundColor(.white)
                            .padding(.horizontal, 28).padding(.vertical, 12)
                            .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 8)
                }
                .transition(.scale(scale: 0.6).combined(with: .opacity))
            }
        }
        .onAppear(perform: runSequence)
        // 容错：允许点击任意处直接跳过
        .contentShape(Rectangle())
        .onTapGesture { if showVerdict { onFinish() } }
    }

    private func runSequence() {
        starsOn = true
        // 1) 题目浮现
        withAnimation(.easeIn(duration: 0.5)) { problemOpacity = 1 }
        phase = 1
        // 2) 升维俯瞰：题目缩小飞向星空
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 1.1)) {
                problemScale = 0.18
                problemY = -260
            }
            phase = 2
            // 3) 武器降临
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.55)) {
                    weaponY = 0
                    weaponScale = 1
                }
                // 4) 命中：白闪 + 冲击波
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.38) {
                    withAnimation(.easeOut(duration: 0.12)) { flash = 0.9 }
                    withAnimation(.easeIn(duration: 0.4).delay(0.12)) { flash = 0 }
                    shockwave = 1
                    withAnimation(.easeOut(duration: 0.6)) { shockwave = 700 }
                    let gen = UIImpactFeedbackGenerator(style: .heavy)
                    gen.impactOccurred()
                    // 5) 判定
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showVerdict = true }
                    }
                }
            }
        }
    }
}

private struct StarField: View {
    let active: Bool
    private let stars: [(CGPoint, CGFloat, Double)] = (0..<60).map { _ in
        (CGPoint(x: .random(in: 0...1), y: .random(in: 0...1)),
         CGFloat.random(in: 1...3), Double.random(in: 0.3...0.9))
    }
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<stars.count, id: \.self) { i in
                    Circle()
                        .fill(Color.white)
                        .frame(width: stars[i].1, height: stars[i].1)
                        .position(x: stars[i].0.x * geo.size.width, y: stars[i].0.y * geo.size.height)
                        .opacity(active ? stars[i].2 : 0)
                        .animation(.easeIn(duration: 0.8).delay(Double(i) * 0.005), value: active)
                }
            }
        }
        .ignoresSafeArea()
    }
}
