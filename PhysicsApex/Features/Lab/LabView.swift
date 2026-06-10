import SwiftUI

// MARK: - 实验场（练习）：按章节进入，做题 + 解析

struct LabView: View {
    @EnvironmentObject var profile: StudentProfile
    @State private var selectedTopic: PhysicsTopic? = nil

    private let topics = PhysicsTopic.allCases

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
            SectionHeader(title: "当前段位", systemImage: "figure.stairs", accent: profile.currentStage.color)
            Picker("段位", selection: $profile.currentStage) {
                ForEach(Stage.allCases) { Text($0.shortTitle).tag($0) }
            }
            .pickerStyle(.segmented)
        }
        .cardSurface()
    }

    private var topicGrid: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "选择章节", systemImage: "square.grid.2x2", accent: .apexStarBlue)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                ForEach(topics) { topic in
                    let count = ProblemBank.problems(for: topic).count
                    NavigationLink { TopicProblemsView(topic: topic) } label: {
                        topicCard(topic, count: count)
                    }
                    .buttonStyle(.plain)
                    .disabled(count == 0)
                    .opacity(count == 0 ? 0.4 : 1)
                }
            }
        }
    }

    private func topicCard(_ topic: PhysicsTopic, count: Int) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Image(systemName: topic.icon).font(.title2).foregroundColor(.apexStarBlue)
            Text(topic.name).font(AppFont.cardTitle).foregroundColor(.primary)
            Text(count > 0 ? "\(count) 题" : "即将上线")
                .font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.apexCardSurface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}

// MARK: - 某章节题目列表

struct TopicProblemsView: View {
    let topic: PhysicsTopic
    private var problems: [PhysicsProblem] { ProblemBank.problems(for: topic) }

    var body: some View {
        List(problems) { p in
            NavigationLink { ProblemDetailView(problem: p) } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(p.content).font(.subheadline).lineLimit(3)
                    HStack(spacing: 6) {
                        TagChip(text: p.stage.shortTitle, color: p.stage.color)
                        if p.dualSolution != nil {
                            TagChip(text: "可秒杀", color: .apexLava)
                        }
                        Spacer()
                        Text("难度 \(Int(p.difficulty * 100))")
                            .font(AppFont.chip).foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
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
                    answerSection
                    solutionSection(title: "解析", path: problem.solution, accent: .apexEmerald)
                    if let dual = problem.dualSolution {
                        descentBanner(dual)
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
