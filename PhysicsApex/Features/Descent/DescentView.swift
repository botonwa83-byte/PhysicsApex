import SwiftUI

// MARK: - 上帝视角 · 降维秒杀（灵魂卖点，含内购解锁 + 震撼动画）

struct DescentView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var cases: [PhysicsProblem] { ProblemBank.descentCases }

    private func isLocked(_ index: Int) -> Bool {
        !purchase.isUnlocked && index >= PurchaseManager.freeDescentCount
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                intro
                ForEach(Array(cases.enumerated()), id: \.element.id) { idx, p in
                    if let dual = p.dualSolution {
                        if isLocked(idx) {
                            Button { showPaywall = true } label: { lockedCard(p, dual) }
                                .buttonStyle(.plain)
                        } else {
                            NavigationLink { DescentDetailView(problem: p, dual: dual) } label: {
                                caseCard(p, dual)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                if !purchase.isUnlocked { unlockBanner }
                weaponLibrary
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("降维秒杀")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("用「上帝视角」几步拿下压轴题")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text("每个战例都有「常规解 vs 降维秒杀」双解对决，配电影级降维打击。")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexLava, Color.apexMystery],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
        .shadow(color: Color.apexLava.opacity(0.3), radius: 14, y: 8)
    }

    private func caseCard(_ p: PhysicsProblem, _ dual: DualSolution) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                TagChip(text: p.topic.name, color: .apexStarBlue)
                TagChip(text: dual.weaponUsed.name, color: .apexLava)
                Spacer()
                Text("省时 \(String(format: "%.0f", dual.timeRatio))×")
                    .font(AppFont.chip).foregroundColor(.apexGold)
            }
            Text(p.content).font(.subheadline).foregroundColor(.primary).lineLimit(3)
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill").font(.caption2)
                Text("发动降维打击").font(AppFont.chip)
                Spacer()
                Image(systemName: "chevron.right").font(.caption2)
            }
            .foregroundColor(.apexLava)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private func lockedCard(_ p: PhysicsProblem, _ dual: DualSolution) -> some View {
        ZStack {
            caseCard(p, dual).blur(radius: 4).disabled(true)
            VStack(spacing: 6) {
                Image(systemName: "lock.fill").font(.title2).foregroundColor(.apexLava)
                Text("解锁查看").font(AppFont.chip).foregroundColor(.apexLava)
            }
            .padding(Spacing.md)
            .background(.ultraThinMaterial)
            .cornerRadius(Radius.inner)
        }
    }

    private var unlockBanner: some View {
        Button { showPaywall = true } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "bolt.shield.fill").font(.title2).foregroundColor(.white)
                VStack(alignment: .leading, spacing: 2) {
                    Text("解锁全部 \(cases.count) 道战例").font(AppFont.cardTitle).foregroundColor(.white)
                    Text("一次买断，降维秒杀随便用").font(AppFont.caption).foregroundColor(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.white)
            }
            .padding(Spacing.lg)
            .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(Radius.card)
        }
        .buttonStyle(.plain)
    }

    private var weaponLibrary: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "武器库", systemImage: "wand.and.stars", accent: .apexMystery)
            ForEach(Stage.allCases) { stage in
                let weapons = PhysicsWeapon.allCases.filter { $0.stage == stage }
                Text(stage.title).font(AppFont.chip).foregroundColor(stage.color)
                FlowLayout(spacing: 8) {
                    ForEach(weapons) { w in
                        TagChip(text: w.name, color: stage.color)
                    }
                }
            }
        }
        .cardSurface()
    }
}

// MARK: - 双解对决详情（含降维打击动画）

struct DescentDetailView: View {
    let problem: PhysicsProblem
    let dual: DualSolution
    @State private var showDescent = true
    @State private var showStrike = false
    @State private var struck = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // 题干（选择题展示选项 + 标出正确答案）
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: problem.topic.name, color: .apexStarBlue)
                    Text(problem.content).font(.body)
                    if let options = problem.options {
                        VStack(spacing: Spacing.sm) {
                            ForEach(options, id: \.self) { opt in
                                optionRow(opt)
                            }
                        }
                        .padding(.top, Spacing.xs)
                    }
                }
                .cardSurface()

                // 发动降维打击（震撼按钮）
                Button { showStrike = true } label: {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "bolt.fill")
                        Text(struck ? "再看一次降维打击" : "发动降维打击").fontWeight(.bold)
                        Spacer()
                        Image(systemName: dual.weaponUsed.icon)
                    }
                    .font(.headline).foregroundColor(.white)
                    .padding(.vertical, 14).padding(.horizontal, Spacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(Radius.card)
                    .shadow(color: Color.apexLava.opacity(0.35), radius: 12, y: 6)
                }
                .buttonStyle(.plain)

                // 切换
                Picker("解法", selection: $showDescent) {
                    Text("常规解").tag(false)
                    Text("⚡️ 降维秒杀").tag(true)
                }
                .pickerStyle(.segmented)

                if showDescent {
                    weaponHeader
                    methodCard(dual.descentMethod, accent: .apexLava)
                } else {
                    methodCard(dual.standardMethod, accent: .secondary)
                }

                if let explain = dual.detailedExplanation {
                    Label(explain, systemImage: "sparkles")
                        .font(AppFont.caption).foregroundColor(.apexGold)
                        .cardSurface()
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("双解对决")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showStrike) {
            DescentStrikeView(weaponName: dual.weaponUsed.name,
                              weaponIcon: dual.weaponUsed.icon,
                              timeRatio: dual.timeRatio) {
                struck = true
                showDescent = true
                showStrike = false
            }
        }
    }

    private func optionRow(_ opt: String) -> some View {
        let isAnswer = opt == problem.answer
        return HStack(spacing: Spacing.sm) {
            Image(systemName: isAnswer ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isAnswer ? .apexEmerald : .secondary)
            Text(opt).font(.subheadline)
                .foregroundColor(isAnswer ? .primary : .secondary)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(Spacing.sm)
        .background((isAnswer ? Color.apexEmerald : Color.secondary).opacity(0.08))
        .cornerRadius(Radius.inner)
    }

    private var weaponHeader: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: dual.weaponUsed.icon).font(.title).foregroundColor(.apexLava)
            VStack(alignment: .leading, spacing: 2) {
                Text(dual.weaponUsed.name).font(AppFont.cardTitle).foregroundColor(.primary)
                Text(dual.weaponUsed.tagline).font(AppFont.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.apexLava.opacity(0.10))
        .cornerRadius(Radius.inner)
    }

    private func methodCard(_ path: SolutionPath, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            ForEach(path.steps) { step in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(step.order). \(step.description)").font(AppFont.body).foregroundColor(.primary)
                    if !step.formula.isEmpty {
                        Text(step.formula)
                            .font(.system(.body, design: .monospaced))
                            .padding(Spacing.sm)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(accent.opacity(0.10))
                            .cornerRadius(Radius.chip)
                    }
                    if !step.annotation.isEmpty {
                        Text(step.annotation).font(AppFont.caption).foregroundColor(.secondary)
                    }
                }
            }
            Divider()
            Label(path.keyInsight, systemImage: "lightbulb.fill")
                .font(AppFont.caption).foregroundColor(.apexGold)
            ForEach(path.commonMistakes, id: \.self) { m in
                Label(m, systemImage: "exclamationmark.triangle.fill")
                    .font(AppFont.caption).foregroundColor(.apexDanger)
            }
        }
        .cardSurface()
    }
}
