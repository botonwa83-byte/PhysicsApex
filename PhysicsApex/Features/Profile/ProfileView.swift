import SwiftUI

// MARK: - 我的

struct ProfileView: View {
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var appearance = AppearanceManager.shared
    @ObservedObject private var streak = StreakManager.shared

    var body: some View {
        List {
            Section {
                HStack(spacing: Spacing.md) {
                    Text(profile.currentStage.emoji).font(.system(size: 48))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.displayName).font(.title3).bold()
                        TagChip(text: profile.currentStage.title, color: profile.currentStage.color)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("战绩") {
                statRow("累计练习", "\(profile.totalProblems) 题", "sum")
                statRow("正确率", "\(Int(profile.accuracy * 100))%", "target")
                statRow("连续打卡", "\(streak.currentStreak) 天", "flame.fill")
                statRow("距高考", "\(streak.daysToGaokao) 天", "calendar")
            }

            Section("章节掌握度") {
                ForEach(PhysicsTopic.allCases.filter { profile.topicMastery[$0.rawValue] != nil }) { topic in
                    let m = profile.topicMastery[topic.rawValue] ?? 0
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Label(topic.name, systemImage: topic.icon).font(.subheadline)
                            Spacer()
                            Text("\(Int(m * 100))%").font(AppFont.chip).foregroundColor(.secondary)
                        }
                        ProgressView(value: m).tint(.apexEmerald)
                    }
                    .padding(.vertical, 2)
                }
            }

            Section("外观") {
                Picker("外观", selection: $appearance.preference) {
                    ForEach(AppearancePreference.allCases) { pref in
                        Label(pref.label, systemImage: pref.icon).tag(pref)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .navigationTitle("我的")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statRow(_ label: String, _ value: String, _ icon: String) -> some View {
        HStack {
            Label(label, systemImage: icon).font(.subheadline)
            Spacer()
            Text(value).font(AppFont.cardTitle).foregroundColor(.apexLava)
        }
    }
}
