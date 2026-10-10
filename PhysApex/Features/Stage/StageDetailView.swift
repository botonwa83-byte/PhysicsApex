import SwiftUI

// MARK: - 段位详情：三段递进闯关的内容页（武器 + 典型题 + 三级重访）

struct StageDetailView: View {
    let stage: Stage
    @EnvironmentObject var profile: StudentProfile
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var weapons: [PhysicsWeapon] { PhysicsWeapon.allCases.filter { $0.stage == stage } }
    private var problems: [PhysicsProblem] { ProblemBank.problems(for: stage) }
    private var isCurrent: Bool { profile.currentStage == stage }
    private var unlocked: Bool { profile.currentStage.unlocks(stage) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                hero
                weaponSection
                problemSection
                revisitEntry
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(stage.shortTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                Text(stage.emoji).font(.system(size: 44))
                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.title).font(.title3.bold()).foregroundColor(.white)
                    Text(stage.subtitle).font(AppFont.caption).foregroundColor(.white.opacity(0.85))
                }
                Spacer()
            }
            Button {
                if unlocked { profile.promote(to: stage) }
            } label: {
                Text(isCurrent ? "当前段位 ✓" : (unlocked ? "设为当前段位" : "尚未解锁"))
                    .font(AppFont.cardTitle).foregroundColor(stage.color)
                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                    .background(Color.white).cornerRadius(Radius.inner)
            }
            .disabled(isCurrent || !unlocked)
            .opacity(unlocked ? 1 : 0.6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [stage.color, stage.color.opacity(0.65)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }

    private var weaponSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "本段武器", systemImage: "wand.and.stars", accent: stage.color)
            Text(unlocked ? "这些是你在本段位能用的「上帝视角」工具。" : "升到本段位即可解锁这些武器。")
                .font(AppFont.caption).foregroundColor(.secondary)
            ForEach(weapons) { w in
                HStack(spacing: Spacing.md) {
                    Image(systemName: w.icon).font(.title3).foregroundColor(stage.color).frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(w.name).font(AppFont.cardTitle).foregroundColor(.primary)
                        Text(w.tagline).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                    }
                    Spacer()
                    if !unlocked { Image(systemName: "lock.fill").font(.caption).foregroundColor(.secondary) }
                }
                .padding(Spacing.sm)
            }
        }
        .cardSurface()
    }

    private var problemSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            SectionHeader(title: "本段典型题 · \(problems.count)", systemImage: "checklist", accent: .apexStarBlue)
            if problems.isEmpty {
                Text("本段位典型题正在补充中。").font(AppFont.caption).foregroundColor(.secondary)
            }
            ForEach(problems) { p in
                let locked = !purchase.isUnlocked && !ProblemBank.isFree(p.id)
                Group {
                    if locked {
                        Button { showPaywall = true } label: { problemRow(p, locked: true) }
                    } else {
                        NavigationLink { ProblemDetailView(problem: p) } label: { problemRow(p, locked: false) }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .cardSurface()
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private func problemRow(_ p: PhysicsProblem, locked: Bool) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: locked ? "lock.fill" : (p.dualSolution != nil ? "bolt.fill" : "doc.text"))
                .foregroundColor(locked ? .apexLava : (p.dualSolution != nil ? .apexLava : .secondary))
            VStack(alignment: .leading, spacing: 2) {
                Text(p.content).font(AppFont.body).foregroundColor(locked ? .secondary : .primary).lineLimit(2)
                HStack(spacing: 6) {
                    TagChip(text: p.topic.name, color: .apexStarBlue)
                    if p.dualSolution != nil { TagChip(text: "可秒杀", color: .apexLava) }
                }
            }
            Spacer(minLength: 0)
            Text(locked ? "解锁" : "").font(AppFont.chip).foregroundColor(.secondary)
            Image(systemName: "chevron.right").font(.caption2).foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var revisitEntry: some View {
        NavigationLink { RevisitView() } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "scope").font(.title2).foregroundColor(.stageOlympiad)
                VStack(alignment: .leading, spacing: 4) {
                    Text("三级重访").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text("同一题在初中/高中/竞赛三个镜头下，看工具如何升维").font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
            .cardSurface()
        }
        .buttonStyle(.plain)
    }
}
