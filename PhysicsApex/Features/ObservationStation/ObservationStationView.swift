import SwiftUI

// MARK: - 观测站（首页）
// 布局优先级对齐 MathApex：核心卖点(降维秒杀 + 三段进阶)置顶 C 位，再到今日行动、进度、探索。

struct ObservationStationView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var streak = StreakManager.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    // ① 核心卖点 C 位
                    descentHero
                    stageHero
                    revisitEntry

                    // ② 今日 — 行动区
                    sectionHeader("今日")
                    statsCard
                    dailyChallengeCard
                    todayMission

                    // ③ 探索
                    sectionHeader("探索")
                    simulationTeaser
                    paradoxTeaser
                    giantsTeaser
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                .padding(.bottom, Spacing.xxl)
            }
            .background(Color.apexBackground.ignoresSafeArea())
            .navigationTitle("PhysicsApex")
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title).font(.title3.bold()).foregroundColor(.primary)
            Spacer()
        }
        .padding(.top, Spacing.xs)
    }

    // MARK: ① 卖点 C 位

    /// 灵魂卖点：降维秒杀（满色渐变 hero，对标 MathApex secondKillHero）
    private var descentHero: some View {
        NavigationLink { DescentView() } label: {
            VStack(alignment: .leading, spacing: Spacing.md) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "bolt.fill").font(.title3).foregroundColor(.white)
                    Text("降维秒杀")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(ProblemBank.descentCases.count) 道压轴")
                        .font(.caption2).foregroundColor(.white.opacity(0.9))
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.white.opacity(0.9))
                }
                Text("用「上帝视角」俯瞰高考压轴 · 常规法 vs 降维秒杀")
                    .font(.subheadline).foregroundColor(.white.opacity(0.92))
                HStack(spacing: Spacing.sm) {
                    ForEach(["动量守恒", "等效法", "对称", "微元"], id: \.self) { w in
                        Text(w)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(Color.white.opacity(0.18))
                            .cornerRadius(7)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.xl)
            .background(
                ZStack {
                    LinearGradient(colors: [Color.apexLava, Color.apexMystery],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    CosmicStarfield(starCount: 36, meteors: true, intensity: 0.8)
                }
            )
            .cornerRadius(Radius.hero)
            .shadow(color: Color.apexLava.opacity(0.3), radius: 14, y: 8)
        }
        .buttonStyle(.plain)
    }

    /// 差异化卖点：三段递进闯关（紧随其后，仍是卖点区）
    private var stageHero: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: 6) {
                Image(systemName: "figure.stairs").foregroundColor(.apexGold)
                Text("三段递进闯关").font(AppFont.sectionTitle)
                Spacer()
                Text("同一题，三级重访").font(AppFont.chip).foregroundColor(.secondary)
            }
            ForEach(Stage.allCases) { stage in
                stageRow(stage)
            }
        }
        .cardSurface()
    }

    /// 物理专属创新入口：三级重访
    private var revisitEntry: some View {
        NavigationLink { RevisitView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "scope")
                    .font(.title2).foregroundColor(.stageOlympiad)
                VStack(alignment: .leading, spacing: 4) {
                    Text("三级重访 · 同一题三个镜头").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("初中→高中→竞赛，看解题工具如何一级级升维").font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .cardSurface()
        }
        .buttonStyle(.plain)
    }

    private func stageRow(_ stage: Stage) -> some View {
        let isCurrent = stage == profile.currentStage
        let unlocked = profile.currentStage.unlocks(stage)
        return NavigationLink {
            StageDetailView(stage: stage)
        } label: {
            HStack(spacing: Spacing.md) {
                Text(stage.emoji).font(.title2).opacity(unlocked ? 1 : 0.5)
                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.title).font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(stage.subtitle).font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                if isCurrent {
                    TagChip(text: "进行中", color: stage.color)
                } else if !unlocked {
                    Image(systemName: "lock.fill").font(.caption).foregroundColor(.secondary)
                }
                Image(systemName: "chevron.right").font(.caption2).foregroundColor(.secondary)
            }
            .padding(Spacing.md)
            .background(isCurrent ? stage.color.opacity(0.12) : Color.clear)
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    // MARK: ② 今日

    private var statsCard: some View {
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

    private var dailyChallengeCard: some View {
        let done = DailyChallenge.isDoneToday(DailyChallenge.today.id)
        return NavigationLink { DailyChallengeView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "calendar.badge.clock").font(.title2)
                    .foregroundColor(done ? .apexEmerald : .apexLava)
                VStack(alignment: .leading, spacing: 2) {
                    Text("今日一题").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(done ? "今日已完成 ✅，明天再来" : "今天的一道精选秒杀题，来挑战")
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                if done {
                    Image(systemName: "checkmark.seal.fill").foregroundColor(.apexEmerald)
                } else {
                    Image(systemName: "chevron.right").foregroundColor(.secondary)
                }
            }
            .cardSurface()
        }
        .buttonStyle(.plain)
    }

    private var todayMission: some View {
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
            .cardSurface()
        }
        .buttonStyle(.plain)
    }

    // MARK: ③ 探索

    private var simulationTeaser: some View {
        NavigationLink { SimulationHubView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "scope").font(.title2).foregroundColor(.apexEmerald)
                VStack(alignment: .leading, spacing: 4) {
                    Text("互动模拟沙盘").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("拖一拖参数，看抛体/碰撞/振动实时演化——看见物理").font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .cardSurface()
        }
        .buttonStyle(.plain)
    }

    private var paradoxTeaser: some View {
        Group {
            if let p = ParadoxData.all.first {
                NavigationLink { ParadoxDetailView(paradox: p) } label: {
                    HStack(spacing: Spacing.md) {
                        Image(systemName: p.category.icon).font(.title2).foregroundColor(p.category.color)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("今日佯谬 · \(p.title)").font(AppFont.cardTitle).foregroundColor(.primary)
                            Text(p.hook).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundColor(.secondary)
                    }
                    .cardSurface()
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var giantsTeaser: some View {
        NavigationLink { GiantsView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "person.3.fill").font(.title2).foregroundColor(.apexStarBlue)
                VStack(alignment: .leading, spacing: 4) {
                    Text("物理巨人").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("牛顿 · 爱因斯坦 · 法拉第 · 费曼——越学越上头").font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .cardSurface()
        }
        .buttonStyle(.plain)
    }
}
