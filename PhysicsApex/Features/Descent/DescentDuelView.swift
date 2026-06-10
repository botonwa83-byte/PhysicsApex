import SwiftUI

// MARK: - 双解对决剧场：常规解 vs 降维秒杀 实时赛跑
// 把 timeRatio 从一个数字变成「看得见的碾压」：两条赛道同屏开跑，
// 秒杀道几秒冲线盖章，常规道还在苦磨——计时器用题目真实 averageTime 压缩播放。

struct DescentDuelView: View {
    let problem: PhysicsProblem
    let dual: DualSolution
    var onFinish: () -> Void

    @State private var elapsed: Double = 0
    @State private var descentDone = false
    @State private var standardDone = false
    @State private var sealScale: CGFloat = 2.4
    @State private var sealOpacity: Double = 0

    private let timer = Timer.publish(every: 1.0 / 30.0, on: .main, in: .common).autoconnect()

    /// 整场对决的真实播放时长（常规道跑完的秒数），随 timeRatio 拉开但封顶。
    private var standardDur: Double { min(8.0, max(4.2, dual.timeRatio * 1.5)) }
    private var descentDur: Double { standardDur / dual.timeRatio }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "070C1D"), Color(hex: "151035"), Color(hex: "070C1D")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            CosmicStarfield(starCount: 60, meteors: true, intensity: 0.8)
                .ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                header
                HStack(alignment: .top, spacing: Spacing.md) {
                    lane(title: "常规解", icon: "tortoise.fill", accent: Color(hex: "8E9BB5"),
                         path: dual.standardMethod, duration: standardDur,
                         clockTarget: problem.averageTime, done: standardDone)
                    laneDescent
                }
                Spacer(minLength: 0)
                if standardDone { verdict.transition(.scale(scale: 0.8).combined(with: .opacity)) }
            }
            .padding(Spacing.lg)
        }
        .onReceive(timer) { _ in tick() }
        .contentShape(Rectangle())
        .onTapGesture { if standardDone { onFinish() } else { skip() } }
    }

    // MARK: 时间轴

    private func tick() {
        guard !standardDone else { return }
        elapsed += 1.0 / 30.0
        if !descentDone && elapsed >= descentDur {
            descentDone = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                sealScale = 1; sealOpacity = 1
            }
        }
        if elapsed >= standardDur {
            standardDone = true
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {}
        }
    }

    private func skip() {
        elapsed = standardDur
        if !descentDone {
            descentDone = true
            sealScale = 1; sealOpacity = 1
        }
        standardDone = true
    }

    // MARK: 子视图

    private var header: some View {
        VStack(spacing: 6) {
            Text("双 解 对 决")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
                .shadow(color: .apexLava.opacity(0.5), radius: 12)
            Text(problem.content)
                .font(AppFont.caption).foregroundColor(.white.opacity(0.75))
                .lineLimit(2).multilineTextAlignment(.center)
        }
        .padding(.top, Spacing.xl)
    }

    /// 降维赛道（带武器与盖章）。
    private var laneDescent: some View {
        lane(title: dual.weaponUsed.name, icon: "bolt.fill", accent: .apexLava,
             path: dual.descentMethod, duration: descentDur,
             clockTarget: problem.averageTime / dual.timeRatio, done: descentDone)
            .overlay(alignment: .top) {
                if descentDone {
                    seal.offset(y: 44)
                }
            }
    }

    private func lane(title: String, icon: String, accent: Color,
                      path: SolutionPath, duration: Double,
                      clockTarget: TimeInterval, done: Bool) -> some View {
        let progress = min(elapsed / duration, 1.0)
        return VStack(alignment: .leading, spacing: Spacing.md) {
            // 头部
            HStack(spacing: 6) {
                Image(systemName: icon).font(.subheadline)
                Text(title).font(.system(size: 14, weight: .heavy, design: .rounded)).lineLimit(1)
                Spacer(minLength: 0)
            }
            .foregroundColor(accent)

            // 模拟秒表（按真实平均耗时压缩播放）
            Text(clockString(progress * clockTarget))
                .font(.system(size: 30, weight: .black, design: .monospaced))
                .foregroundColor(done ? accent : .white)
                .contentTransition(.numericText())

            // 赛道进度条
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.12))
                    Capsule().fill(accent)
                        .frame(width: max(8, geo.size.width * progress))
                }
            }
            .frame(height: 8)

            // 步骤逐个点亮
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(Array(path.steps.enumerated()), id: \.element.id) { i, step in
                    let lit = progress >= Double(i + 1) / Double(path.steps.count) - 0.001
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: lit ? "checkmark.circle.fill" : "circle.dotted")
                            .font(.caption).foregroundColor(lit ? accent : .white.opacity(0.3))
                        Text(step.description)
                            .font(.system(size: 12))
                            .foregroundColor(lit ? .white : .white.opacity(0.35))
                            .lineLimit(3)
                    }
                    .animation(.easeIn(duration: 0.25), value: lit)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, minHeight: 290, alignment: .topLeading)
        .background(Color.white.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: Radius.card).stroke(done ? accent : Color.white.opacity(0.10), lineWidth: done ? 2 : 1))
        .cornerRadius(Radius.card)
    }

    /// 「已秒杀」盖章
    private var seal: some View {
        VStack(spacing: 2) {
            Image(systemName: dual.weaponUsed.icon).font(.system(size: 22, weight: .black))
            Text("已秒杀").font(.system(size: 15, weight: .black, design: .rounded))
        }
        .foregroundColor(.apexGold)
        .padding(.horizontal, 14).padding(.vertical, 8)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.apexGold, lineWidth: 2.5))
        .rotationEffect(.degrees(-12))
        .scaleEffect(sealScale)
        .opacity(sealOpacity)
        .shadow(color: .apexGold.opacity(0.6), radius: 10)
    }

    /// 终局判定
    private var verdict: some View {
        VStack(spacing: Spacing.md) {
            Text("同一道题 · 快 \(String(format: "%.0f", dual.timeRatio)) 倍")
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .leading, endPoint: .trailing))
            Text("常规约 \(clockString(problem.averageTime)) ｜ 「\(dual.weaponUsed.name)」约 \(clockString(problem.averageTime / dual.timeRatio))")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.8))
            Button(action: onFinish) {
                Text("看懂这把武器")
                    .font(.headline).foregroundColor(.white)
                    .padding(.horizontal, 30).padding(.vertical, 12)
                    .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: .apexLava.opacity(0.5), radius: 10, y: 4)
            }
        }
        .padding(.bottom, Spacing.xl)
    }

    private func clockString(_ seconds: Double) -> String {
        let s = max(0, Int(seconds.rounded()))
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}
