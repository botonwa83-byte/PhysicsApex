import SwiftUI

@main
struct PhysicsApexApp: App {
    @StateObject private var profile = StudentProfile()
    @StateObject private var appearance = AppearanceManager.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(profile)
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ObservationStationView(selectedTab: $selectedTab)
                .tabItem { Label("观测站", systemImage: "scope") }
                .tag(0)

            LabView()
                .tabItem { Label("实验场", systemImage: "atom") }
                .tag(1)

            LawUniverseView()
                .tabItem { Label("定律宇宙", systemImage: "function") }
                .tag(2)

            MoreView()
                .tabItem { Label("更多", systemImage: "ellipsis.circle") }
                .tag(3)
        }
        .tint(.apexLava)
    }
}

// MARK: - 更多

struct MoreView: View {
    @EnvironmentObject var profile: StudentProfile

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { ProfileView() } label: {
                        HStack(spacing: 12) {
                            Text(profile.currentStage.emoji).font(.title)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(profile.displayName).font(.headline)
                                Text(profile.currentStage.title)
                                    .font(.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("我的练习") {
                    NavigationLink { ErrorBookView() } label: {
                        Label("错题本", systemImage: "exclamationmark.triangle")
                    }
                    NavigationLink { ReviewView() } label: {
                        HStack {
                            Label("智能复习", systemImage: "brain.head.profile")
                            Spacer()
                            if ReviewScheduler.shared.dueCount > 0 {
                                Text("\(ReviewScheduler.shared.dueCount)")
                                    .font(AppFont.chip).foregroundColor(.white)
                                    .padding(.horizontal, 7).padding(.vertical, 2)
                                    .background(Color.apexLava).clipShape(Capsule())
                            }
                        }
                    }
                    NavigationLink { DescentView() } label: {
                        Label("降维秒杀", systemImage: "bolt.fill")
                    }
                    NavigationLink { FermiEstimationView() } label: {
                        Label("先估后算", systemImage: "dial.medium")
                    }
                    NavigationLink { DimensionTrainingView() } label: {
                        Label("单位 / 量纲", systemImage: "ruler")
                    }
                }

                Section("物理发现") {
                    NavigationLink { GiantsView() } label: {
                        Label("物理巨人", systemImage: "person.3.fill")
                    }
                    NavigationLink { ParadoxView() } label: {
                        Label("佯谬室", systemImage: "questionmark.diamond")
                    }
                }
            }
            .navigationTitle("更多")
        }
    }
}

// MARK: - 错题本（自动识别答错 ∪ 手动标记 ⭐）

struct ErrorBookView: View {
    @ObservedObject private var practice = PracticeManager.shared
    private var problems: [PhysicsProblem] { practice.errorProblems(from: ProblemBank.all) }

    var body: some View {
        Group {
            if problems.isEmpty {
                ContentUnavailableViewCompat(
                    title: "还没有错题",
                    systemImage: "checkmark.seal",
                    description: "答错的题会自动收录，也可在做题页点 ⭐ 手动收藏。"
                )
            } else {
                List {
                    Section {
                        ForEach(problems) { p in
                            NavigationLink { ProblemDetailView(problem: p) } label: {
                                errorRow(p)
                            }
                        }
                    } footer: {
                        Text("答对 3 次自动移出错题本，并安排间隔复习。")
                    }
                }
            }
        }
        .navigationTitle("错题本")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func errorRow(_ p: PhysicsProblem) -> some View {
        let s = practice.stats(for: p.id)
        return VStack(alignment: .leading, spacing: 4) {
            Text(p.content).font(.subheadline).lineLimit(2)
            HStack(spacing: 6) {
                TagChip(text: p.stage.shortTitle, color: p.stage.color)
                TagChip(text: p.topic.name, color: .apexStarBlue)
                if practice.isFlaggedError(p.id) { Image(systemName: "star.fill").font(.caption2).foregroundColor(.apexGold) }
                Spacer()
                if s.totalAttempts > 0 {
                    Text("正确率 \(Int(s.accuracy * 100))%").font(AppFont.chip).foregroundColor(.secondary)
                }
            }
        }.padding(.vertical, 2)
    }
}

// MARK: - 智能复习（SM-2 间隔重复）

struct ReviewView: View {
    @ObservedObject private var scheduler = ReviewScheduler.shared
    private var due: [PhysicsProblem] {
        let ids = Set(scheduler.dueProblems().map(\.problemId))
        return ProblemBank.all.filter { ids.contains($0.id) }
    }
    private var upcoming: [ReviewItem] { scheduler.upcomingProblems() }

    var body: some View {
        Group {
            if scheduler.totalScheduled == 0 {
                ContentUnavailableViewCompat(
                    title: "复习计划空空如也",
                    systemImage: "brain.head.profile",
                    description: "做过的题会按艾宾浩斯曲线(1/3/7/15/30/60 天)自动排期复习。"
                )
            } else {
                List {
                    Section("今日待复习 · \(due.count)") {
                        if due.isEmpty {
                            Text("今天没有到期的题，继续保持 🎉").font(.subheadline).foregroundColor(.secondary)
                        }
                        ForEach(due) { p in
                            NavigationLink { ProblemDetailView(problem: p) } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(p.content).font(.subheadline).lineLimit(2)
                                    HStack(spacing: 6) {
                                        TagChip(text: p.topic.name, color: .apexStarBlue)
                                        if let item = scheduler.reviewItem(for: p.id) {
                                            TagChip(text: "连对 \(item.correctStreak)", color: .apexEmerald)
                                        }
                                    }
                                }.padding(.vertical, 2)
                            }
                        }
                    }
                    if !upcoming.isEmpty {
                        Section("即将复习") {
                            ForEach(upcoming.prefix(10)) { item in
                                if let p = ProblemBank.all.first(where: { $0.id == item.problemId }) {
                                    HStack {
                                        Text(p.content).font(.caption).foregroundColor(.secondary).lineLimit(1)
                                        Spacer()
                                        Text("\(item.daysUntilReview) 天后").font(AppFont.chip).foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("智能复习")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 空状态（iOS16 兼容 ContentUnavailableView）

struct ContentUnavailableViewCompat: View {
    let title: String
    let systemImage: String
    let description: String
    var body: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: systemImage).font(.system(size: 48)).foregroundColor(.secondary)
            Text(title).font(.headline)
            Text(description).font(.subheadline).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, Spacing.xxl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.apexBackground.ignoresSafeArea())
    }
}
