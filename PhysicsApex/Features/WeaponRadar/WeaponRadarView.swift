import SwiftUI

// MARK: - 武器雷达 · 30 秒识局训练
// 高考生最缺的元技能：拿到压轴题的前 30 秒判断「这题该用哪把武器」。
// 玩法：只看题干（不看解法），倒计时 30 s 内从 4 把武器中选出正确的秒杀武器。
// 数据全部来自 ProblemBank.descentCases——零新增内容成本，68 道战例即题库。

struct WeaponRadarView: View {
    @AppStorage("radar_best_score") private var bestScore = 0
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    @State private var round: [PhysicsProblem] = []
    @State private var options: [PhysicsWeapon] = []
    @State private var idx = 0
    @State private var score = 0
    @State private var combo = 0
    @State private var maxCombo = 0
    @State private var picked: PhysicsWeapon?
    @State private var revealed = false
    @State private var remaining: Double = 30
    @State private var finished = false
    @State private var missed: [PhysicsProblem] = []

    private let roundSize = 10
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    private var current: PhysicsProblem? { idx < round.count ? round[idx] : nil }
    private var correctWeapon: PhysicsWeapon? { current?.dualSolution?.weaponUsed }

    var body: some View {
        ZStack {
            Color.apexBackground.ignoresSafeArea()
            if finished {
                summary
            } else if let p = current {
                quiz(p)
            }
        }
        .navigationTitle("武器雷达")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if round.isEmpty { startRound() } }
        .onReceive(timer) { _ in tickClock() }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    /// 该战例是否在免费档（与降维秒杀列表同一规则）。
    private func isCaseFree(_ p: PhysicsProblem) -> Bool {
        purchase.isUnlocked ||
        (ProblemBank.descentCases.firstIndex { $0.id == p.id } ?? .max) < PurchaseManager.freeDescentCount
    }

    // MARK: 回合控制

    private func startRound() {
        round = Array(ProblemBank.descentCases.shuffled().prefix(roundSize))
        idx = 0; score = 0; combo = 0; maxCombo = 0
        missed = []; finished = false
        nextQuestionSetup()
    }

    private func nextQuestionSetup() {
        picked = nil; revealed = false; remaining = 30
        guard let correct = correctWeapon else { return }
        let pool = Set(ProblemBank.descentCases.compactMap { $0.dualSolution?.weaponUsed }).subtracting([correct])
        options = (Array(pool.shuffled().prefix(3)) + [correct]).shuffled()
    }

    private func tickClock() {
        guard !finished, !revealed, current != nil else { return }
        remaining -= 0.1
        if remaining <= 0 { reveal(choosing: nil) }   // 超时算错
    }

    private func reveal(choosing weapon: PhysicsWeapon?) {
        guard !revealed else { return }
        picked = weapon
        revealed = true
        if weapon == correctWeapon {
            score += 1; combo += 1; maxCombo = max(maxCombo, combo)
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } else {
            combo = 0
            if let p = current { missed.append(p) }
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func advance() {
        if idx + 1 >= round.count {
            bestScore = max(bestScore, score)
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { finished = true }
        } else {
            idx += 1
            nextQuestionSetup()
        }
    }

    // MARK: 答题界面

    private func quiz(_ p: PhysicsProblem) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // 进度 + 连击 + 倒计时
                HStack {
                    Text("\(idx + 1) / \(round.count)")
                        .font(AppFont.chip).foregroundColor(.secondary)
                    if combo >= 2 {
                        Text("🔥 连击 ×\(combo)")
                            .font(AppFont.chip).foregroundColor(.apexLava)
                    }
                    Spacer()
                    clockRing
                }

                // 题干（只给局面，不给解法）
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: 6) {
                        TagChip(text: p.topic.name, color: .apexStarBlue)
                        TagChip(text: p.stage.shortTitle, color: p.stage.color)
                    }
                    Text(p.content).font(.body).foregroundColor(.primary)
                }
                .cardSurface()

                Text("这道题，你会抽哪把武器？")
                    .font(AppFont.sectionTitle).foregroundColor(.primary)

                VStack(spacing: Spacing.sm) {
                    ForEach(options) { w in
                        optionButton(w)
                    }
                }

                if revealed { feedback(p) }
            }
            .padding(Spacing.lg)
        }
    }

    private var clockRing: some View {
        ZStack {
            Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 4)
            Circle()
                .trim(from: 0, to: max(0, remaining / 30))
                .stroke(remaining > 10 ? Color.apexEmerald : Color.apexDanger,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(max(0, Int(remaining.rounded())))")
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(remaining > 10 ? .primary : .apexDanger)
        }
        .frame(width: 40, height: 40)
    }

    private func optionButton(_ w: PhysicsWeapon) -> some View {
        let isCorrect = revealed && w == correctWeapon
        let isWrongPick = revealed && w == picked && w != correctWeapon
        return Button { reveal(choosing: w) } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: w.icon).font(.subheadline).frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(w.name).font(AppFont.cardTitle)
                    if revealed {
                        Text(w.tagline).font(AppFont.caption).foregroundColor(.secondary)
                    }
                }
                Spacer()
                if isCorrect { Image(systemName: "checkmark.circle.fill").foregroundColor(.apexEmerald) }
                if isWrongPick { Image(systemName: "xmark.circle.fill").foregroundColor(.apexDanger) }
            }
            .foregroundColor(isCorrect ? .apexEmerald : (isWrongPick ? .apexDanger : .primary))
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background((isCorrect ? Color.apexEmerald : isWrongPick ? Color.apexDanger : Color.secondary).opacity(0.10))
            .overlay(RoundedRectangle(cornerRadius: Radius.inner)
                .stroke(isCorrect ? Color.apexEmerald : .clear, lineWidth: 2))
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
        .disabled(revealed)
    }

    private func feedback(_ p: PhysicsProblem) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            if let dual = p.dualSolution {
                Label(picked == correctWeapon ? "识局正确！" : (picked == nil ? "超时——考场上这题就溜了" : "差一点"),
                      systemImage: picked == correctWeapon ? "scope" : "exclamationmark.triangle.fill")
                    .font(AppFont.cardTitle)
                    .foregroundColor(picked == correctWeapon ? .apexEmerald : .apexDanger)
                Label(dual.descentMethod.keyInsight, systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                Text("「\(dual.weaponUsed.name)」省时 \(String(format: "%.0f", dual.timeRatio))× —— \(dual.weaponUsed.tagline)")
                    .font(AppFont.caption).foregroundColor(.secondary)
                Text("📡 触发信号：\(dual.weaponUsed.signals.joined(separator: " · "))")
                    .font(AppFont.caption).foregroundColor(.apexEmerald)
                // 转化钩子：从识局直达完整战例（锁定则弹付费墙）
                if isCaseFree(p) {
                    NavigationLink { DescentDetailView(problem: p, dual: dual) } label: {
                        Label("看完整战例（双解对决）", systemImage: "bolt.fill")
                            .font(AppFont.chip).foregroundColor(.apexLava)
                    }
                } else {
                    Button { showPaywall = true } label: {
                        Label("解锁查看完整战例", systemImage: "lock.fill")
                            .font(AppFont.chip).foregroundColor(.apexLava)
                    }
                }
            }
            Button(action: advance) {
                Text(idx + 1 >= round.count ? "看战报" : "下一局")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(Radius.card)
            }
            .buttonStyle(.plain)
        }
        .cardSurface()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: 战报

    private var summary: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                Image(systemName: "scope")
                    .font(.system(size: 50, weight: .black))
                    .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .top, endPoint: .bottom))
                    .padding(.top, Spacing.xxl)
                Text("识局战报")
                    .font(.system(size: 26, weight: .black, design: .rounded)).foregroundColor(.primary)
                HStack(spacing: Spacing.xl) {
                    statBlock("\(score)/\(round.count)", "识局正确")
                    statBlock("×\(maxCombo)", "最高连击")
                    statBlock("\(bestScore)/\(roundSize)", "历史最佳")
                }

                if !missed.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        SectionHeader(title: "走眼的局", systemImage: "eye.trianglebadge.exclamationmark", accent: .apexDanger)
                        ForEach(missed) { p in
                            if let dual = p.dualSolution {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(p.content).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                                    Label("\(dual.weaponUsed.name) —— \(dual.weaponUsed.tagline)", systemImage: dual.weaponUsed.icon)
                                        .font(AppFont.caption).foregroundColor(.apexLava)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .cardSurface()
                } else {
                    Label("十发十中——考场上的第一反应已经成型", systemImage: "trophy.fill")
                        .font(AppFont.cardTitle).foregroundColor(.apexGold)
                        .cardSurface()
                }

                Button { startRound() } label: {
                    Text("再来一轮")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(Radius.card)
                }
                .buttonStyle(.plain)
                Button { dismiss() } label: {
                    Text("完成").font(.subheadline).foregroundColor(.secondary)
                }
            }
            .padding(Spacing.lg)
        }
    }

    private func statBlock(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 22, weight: .black, design: .rounded)).foregroundColor(.apexLava)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
    }
}
