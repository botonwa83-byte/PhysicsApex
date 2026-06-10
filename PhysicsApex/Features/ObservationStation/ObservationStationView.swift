import SwiftUI

// MARK: - 观测站（首页）：段位脊梁 + 今日任务 + 降维秒杀入口

struct ObservationStationView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var streak = StreakManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    headerCard
                    stageLadder
                    descentEntry
                    todayMission
                    paradoxTeaser
                }
                .padding(Spacing.lg)
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("观测站")
        }
    }

    // 顶部：连击 + 距高考
    private var headerCard: some View {
        HStack(spacing: Spacing.lg) {
            statBlock(value: "\(streak.currentStreak)", label: "连续天数", icon: "flame.fill", color: .apexLava)
            Divider().frame(height: 44)
            statBlock(value: "\(streak.daysToGaokao)", label: "距高考", icon: "calendar", color: .apexStarBlue)
            Divider().frame(height: 44)
            statBlock(value: "\(Int(profile.accuracy * 100))%", label: "正确率", icon: "target", color: .apexEmerald)
        }
        .frame(maxWidth: .infinity)
        .cardSurface()
    }

    private func statBlock(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundColor(color)
            Text(value).font(AppFont.bigStat(24)).foregroundColor(.primary)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // 段位阶梯：app 的脊梁
    private var stageLadder: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "闯关进阶", systemImage: "figure.stairs", accent: .apexGold)
            ForEach(Stage.allCases) { stage in
                stageRow(stage)
            }
        }
        .cardSurface()
    }

    private func stageRow(_ stage: Stage) -> some View {
        let isCurrent = stage == profile.currentStage
        let unlocked = profile.currentStage.unlocks(stage)
        return Button {
            if unlocked { profile.promote(to: stage) }
        } label: {
            HStack(spacing: Spacing.md) {
                Text(stage.emoji)
                    .font(.title2)
                    .opacity(unlocked ? 1 : 0.35)
                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.title)
                        .font(AppFont.cardTitle)
                        .foregroundColor(unlocked ? .primary : .secondary)
                    Text(stage.subtitle)
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                if isCurrent {
                    TagChip(text: "进行中", color: stage.color)
                } else if !unlocked {
                    Image(systemName: "lock.fill").font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(Spacing.md)
            .background(isCurrent ? stage.color.opacity(0.12) : Color.clear)
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    // 降维秒杀入口（灵魂模块）
    private var descentEntry: some View {
        NavigationLink { DescentView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "bolt.fill")
                    .font(.title)
                    .foregroundStyle(LinearGradient(colors: [.apexGold, .apexLava], startPoint: .top, endPoint: .bottom))
                VStack(alignment: .leading, spacing: 4) {
                    Text("上帝视角 · 降维秒杀").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("一道压轴题，两种解法——看守恒/对称/几何如何几步拿下")
                        .font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .padding(Spacing.lg)
            .background(
                LinearGradient(colors: [Color.apexGold.opacity(0.15), Color.apexLava.opacity(0.10)],
                               startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(Radius.hero)
            .overlay(RoundedRectangle(cornerRadius: Radius.hero).stroke(Color.apexLava.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // 今日任务
    private var todayMission: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "今日任务", systemImage: "checklist", accent: .apexEmerald)
            Button {
                streak.recordActivity()
                selectedTab = 1
            } label: {
                HStack {
                    Image(systemName: "play.circle.fill").font(.title2).foregroundColor(.apexEmerald)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("练 5 道 \(profile.currentStage.shortTitle) 题").font(AppFont.body).foregroundColor(.primary)
                        Text("巩固今天的连击").font(AppFont.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundColor(.secondary)
                }
                .padding(Spacing.md)
                .background(Color.apexEmerald.opacity(0.10))
                .cornerRadius(Radius.inner)
            }
            .buttonStyle(.plain)
        }
        .cardSurface()
    }

    // 佯谬预告
    private var paradoxTeaser: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "今日佯谬", systemImage: "questionmark.diamond", accent: .apexMystery)
            if let p = ParadoxData.all.first {
                NavigationLink { ParadoxDetailView(paradox: p) } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(p.title).font(AppFont.cardTitle).foregroundColor(.primary)
                        Text(p.hook).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.md)
                    .background(p.category.color.opacity(0.10))
                    .cornerRadius(Radius.inner)
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
    }
}
