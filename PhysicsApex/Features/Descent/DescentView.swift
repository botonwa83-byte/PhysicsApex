import SwiftUI

// MARK: - 上帝视角 · 降维秒杀（灵魂模块）

struct DescentView: View {
    private var cases: [PhysicsProblem] { ProblemBank.descentCases }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                intro
                ForEach(cases) { p in
                    if let dual = p.dualSolution {
                        NavigationLink { DescentDetailView(problem: p, dual: dual) } label: {
                            caseCard(p, dual)
                        }
                        .buttonStyle(.plain)
                    }
                }
                weaponLibrary
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("降维秒杀")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("用「上帝视角」工具几步拿下压轴题")
                .font(AppFont.cardTitle).foregroundColor(.primary)
            Text("每个战例都有「常规解 vs 降维秒杀」双解对决。降维武器多为更高维的思维方式——用于秒选填、给大题定方向或检验答案。")
                .font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(
            LinearGradient(colors: [Color.apexGold.opacity(0.15), Color.apexLava.opacity(0.10)],
                           startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(Radius.hero)
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
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

// MARK: - 双解对决详情

struct DescentDetailView: View {
    let problem: PhysicsProblem
    let dual: DualSolution
    @State private var showDescent = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // 题干
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: problem.topic.name, color: .apexStarBlue)
                    Text(problem.content).font(.body)
                }
                .cardSurface()

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
    }

    private var weaponHeader: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: dual.weaponUsed.icon)
                .font(.title)
                .foregroundColor(.apexLava)
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
