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
                    NavigationLink { DescentView() } label: {
                        Label("降维秒杀", systemImage: "bolt.fill")
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

// MARK: - 错题本（一期占位：展示最近练习）

struct ErrorBookView: View {
    var body: some View {
        List {
            Section {
                ForEach(ProblemBank.all) { p in
                    NavigationLink { ProblemDetailView(problem: p) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(p.content).font(.subheadline).lineLimit(2)
                            HStack(spacing: 6) {
                                TagChip(text: p.stage.shortTitle, color: p.stage.color)
                                TagChip(text: p.topic.name, color: .apexStarBlue)
                            }
                        }.padding(.vertical, 2)
                    }
                }
            } header: {
                Text("收录的题目")
            } footer: {
                Text("一期演示：错题自动收录 + 艾宾浩斯间隔重复将在二期接入。")
            }
        }
        .navigationTitle("错题本")
        .navigationBarTitleDisplayMode(.inline)
    }
}
