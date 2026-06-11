import SwiftUI

// MARK: - 实验场（练习）：按章节进入，做题 + 解析

struct LabView: View {
    @EnvironmentObject var profile: StudentProfile

    /// 当前段位下、有题的章节。
    private var availableTopics: [PhysicsTopic] {
        PhysicsTopic.allCases.filter { topic in
            ProblemBank.all.contains { $0.topic == topic && $0.stage == profile.currentStage }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    stagePicker
                    topicGrid
                }
                .padding(Spacing.lg)
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("实验场")
        }
    }

    private var stagePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "选择段位", systemImage: "figure.stairs", accent: profile.currentStage.color)
            Picker("段位", selection: $profile.currentStage) {
                ForEach(Stage.allCases) { Text("\($0.emoji) \($0.shortTitle)").tag($0) }
            }
            .pickerStyle(.segmented)
            Text(profile.currentStage.subtitle).font(AppFont.caption).foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private var topicGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "\(profile.currentStage.shortTitle) · 选择章节",
                          systemImage: "square.grid.2x2", accent: profile.currentStage.color)
            if availableTopics.isEmpty {
                Text("本段位的题正在补充中，先试试其它段位吧。")
                    .font(AppFont.caption).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                    ForEach(availableTopics) { topic in
                        let count = ProblemBank.all.filter { $0.topic == topic && $0.stage == profile.currentStage }.count
                        NavigationLink { TopicProblemsView(topic: topic, stage: profile.currentStage) } label: {
                            topicCard(topic, count: count)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func topicCard(_ topic: PhysicsTopic, count: Int) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Image(systemName: topic.icon).font(.title2).foregroundColor(profile.currentStage.color)
            Text(topic.name).font(AppFont.cardTitle).foregroundColor(.primary)
            Text("\(count) 题").font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.apexCardSurface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}

// MARK: - 某段位某章节的题目列表（严格按 段位 + 章节 过滤，含付费门禁）

struct TopicProblemsView: View {
    let topic: PhysicsTopic
    let stage: Stage
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var problems: [PhysicsProblem] {
        ProblemBank.all.filter { $0.topic == topic && $0.stage == stage }
    }

    var body: some View {
        List(problems) { p in
            let locked = !purchase.isUnlocked && !ProblemBank.isFree(p.id)
            if locked {
                Button { showPaywall = true } label: { row(p, locked: true) }
            } else {
                NavigationLink { ProblemDetailView(problem: p) } label: { row(p, locked: false) }
            }
        }
        .navigationTitle("\(stage.shortTitle) · \(topic.name)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private func row(_ p: PhysicsProblem, locked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                if locked { Image(systemName: "lock.fill").font(.caption2).foregroundColor(.apexLava) }
                Text(p.content).font(.subheadline).lineLimit(3).foregroundColor(locked ? .secondary : .primary)
            }
            HStack(spacing: 6) {
                TagChip(text: p.stage.shortTitle, color: p.stage.color)
                if p.dualSolution != nil { TagChip(text: "可秒杀", color: .apexLava) }
                Spacer()
                Text(locked ? "解锁查看" : "难度 \(Int(p.difficulty * 100))")
                    .font(AppFont.chip).foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 做题 / 解析

struct ProblemDetailView: View {
    let problem: PhysicsProblem
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var practice = PracticeManager.shared
    @State private var selectedOption: String? = nil
    @State private var revealed = false
    @State private var appearedAt = Date()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // 题干
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: 6) {
                        TagChip(text: problem.stage.shortTitle, color: problem.stage.color)
                        TagChip(text: problem.topic.name, color: .apexStarBlue)
                    }
                    Text(problem.content).font(.body)
                }
                .cardSurface()

                // 选项
                if let options = problem.options {
                    VStack(spacing: Spacing.sm) {
                        ForEach(options, id: \.self) { opt in
                            optionRow(opt)
                        }
                    }
                }

                if !revealed {
                    Button {
                        revealed = true
                        let correct = selectedOption == problem.answer
                        profile.recordAnswer(correct: correct)
                        practice.recordAnswer(problemId: problem.id, isCorrect: correct,
                                              timeSpent: Date().timeIntervalSince(appearedAt), usedHint: false)
                        StreakManager.shared.recordActivity()
                    } label: {
                        Text(problem.options == nil ? "查看解析" : "提交")
                            .font(AppFont.cardTitle)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.apexLava)
                            .foregroundColor(.white)
                            .cornerRadius(Radius.inner)
                    }
                }

                if revealed {
                    if let sel = selectedOption, sel != problem.answer,
                       let mis = problem.misconception(for: sel) {
                        diagnosisCard(mis)
                    }
                    answerSection
                    solutionSection(title: "解析", path: problem.solution, accent: .apexEmerald)
                    if let dual = problem.dualSolution {
                        descentBanner(dual)
                    }
                    if let simLink = SimLibrary.link(for: problem) {
                        ProblemSimLinkCard(link: simLink)
                    }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("练习")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { appearedAt = Date() }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    practice.toggleError(problem.id)
                } label: {
                    Image(systemName: practice.isFlaggedError(problem.id) ? "star.fill" : "star")
                        .foregroundColor(.apexGold)
                }
            }
        }
    }

    private func optionRow(_ opt: String) -> some View {
        let isSelected = selectedOption == opt
        let isAnswer = opt == problem.answer
        let color: Color = revealed ? (isAnswer ? .apexEmerald : (isSelected ? .apexDanger : .secondary)) : (isSelected ? .apexLava : .secondary)
        return Button {
            if !revealed { selectedOption = opt }
        } label: {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle").foregroundColor(color)
                Text(opt).font(.subheadline).foregroundColor(.primary).multilineTextAlignment(.leading)
                Spacer()
                if revealed && isAnswer { Image(systemName: "checkmark.circle.fill").foregroundColor(.apexEmerald) }
            }
            .padding(Spacing.md)
            .background(color.opacity(0.08))
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    /// 错因诊断 · 迷思点破：精准命中学生选错的那个直觉陷阱。
    private func diagnosisCard(_ mis: Misconception) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "brain.head.profile").foregroundColor(.apexDanger)
                Text("错因诊断").font(AppFont.sectionTitle).foregroundColor(.apexDanger)
                Spacer()
            }
            diagnosisRow("你大概是这么想的", mis.youThought, "person.fill.questionmark", .apexStarBlue)
            diagnosisRow("为什么这是个坑", mis.pitfall, "exclamationmark.triangle.fill", .apexDanger)
            diagnosisRow("正确该怎么想", mis.fix, "checkmark.circle.fill", .apexEmerald)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.apexDanger.opacity(0.07))
        .cornerRadius(Radius.card)
        .overlay(RoundedRectangle(cornerRadius: Radius.card).stroke(Color.apexDanger.opacity(0.25), lineWidth: 1))
    }

    private func diagnosisRow(_ title: String, _ text: String, _ icon: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: icon).font(.subheadline).foregroundColor(color).frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppFont.chip).foregroundColor(color)
                Text(text).font(AppFont.body).foregroundColor(.primary)
            }
        }
    }

    private var answerSection: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "key.fill").foregroundColor(.apexGold)
            VStack(alignment: .leading, spacing: 4) {
                Text("答案").font(AppFont.chip).foregroundColor(.secondary)
                Text(problem.answer).font(AppFont.cardTitle).foregroundColor(.primary)
            }
            Spacer()
        }
        .cardSurface()
    }

    private func solutionSection(title: String, path: SolutionPath, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: title, systemImage: "list.number", accent: accent)
            ForEach(path.steps) { step in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(step.order). \(step.description)").font(AppFont.body).foregroundColor(.primary)
                    if !step.formula.isEmpty {
                        Text(step.formula)
                            .font(.system(.body, design: .monospaced))
                            .padding(Spacing.sm)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(accent.opacity(0.08))
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
            if !path.commonMistakes.isEmpty {
                ForEach(path.commonMistakes, id: \.self) { m in
                    Label(m, systemImage: "exclamationmark.triangle.fill")
                        .font(AppFont.caption).foregroundColor(.apexDanger)
                }
            }
        }
        .cardSurface()
    }

    private func descentBanner(_ dual: DualSolution) -> some View {
        NavigationLink { DescentDetailView(problem: problem, dual: dual) } label: {
            HStack {
                Image(systemName: "bolt.fill").foregroundColor(.apexLava)
                VStack(alignment: .leading, spacing: 2) {
                    Text("这题能被「\(dual.weaponUsed.name)」秒杀").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("看降维解法，省时约 \(String(format: "%.0f", dual.timeRatio))×").font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .padding(Spacing.lg)
            .background(Color.apexLava.opacity(0.10))
            .cornerRadius(Radius.card)
        }
        .buttonStyle(.plain)
    }
}
