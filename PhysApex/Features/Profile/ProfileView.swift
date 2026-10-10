import SwiftUI

// MARK: - 我的

struct ProfileView: View {
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var appearance = AppearanceManager.shared
    @ObservedObject private var streak = StreakManager.shared
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    var body: some View {
        List {
            Section {
                if purchase.isUnlocked {
                    HStack {
                        Label("完整功能已解锁", systemImage: "checkmark.seal.fill").foregroundColor(.apexEmerald)
                        Spacer()
                        Image(systemName: "infinity").foregroundColor(.secondary)
                    }
                } else {
                    Button { showPaywall = true } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "bolt.shield.fill").font(.title2)
                                .foregroundStyle(LinearGradient(colors: [.apexLava, .apexMystery], startPoint: .top, endPoint: .bottom))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("解锁完整功能").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text("全部降维秒杀 + 三级重访，一次买断").font(AppFont.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                    }
                }
            }
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

            Section("考点掌握度") {
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

            Section("成就 · \(streak.unlockedCount)/\(streak.achievements().count)") {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.sm) {
                    ForEach(streak.achievements()) { a in
                        HStack(spacing: 6) {
                            Image(systemName: a.icon)
                                .foregroundColor(a.isUnlocked ? .apexGold : .secondary)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(a.title).font(AppFont.chip).foregroundColor(a.isUnlocked ? .primary : .secondary)
                                Text(a.description).font(.system(size: 9)).foregroundColor(.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(6)
                        .background((a.isUnlocked ? Color.apexGold : Color.secondary).opacity(0.10))
                        .cornerRadius(Radius.chip)
                    }
                }
                .padding(.vertical, 4)
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
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private func statRow(_ label: String, _ value: String, _ icon: String) -> some View {
        HStack {
            Label(label, systemImage: icon).font(.subheadline)
            Spacer()
            Text(value).font(AppFont.cardTitle).foregroundColor(.apexLava)
        }
    }
}
