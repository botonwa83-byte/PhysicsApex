import SwiftUI

// MARK: - 公式速记：先回忆 → 再揭晓 → 自评的闪卡训练（无长文阅读页）
//
// 合规约定（改动前先读）：这一屏曾经按 topic 分组罗列全部 40 条定律（名称 + 表达式），
// 视觉形态等同于一本术语表 / 词条索引，是判定「含书籍杂志内容」的高频命中点。
// 现在这一屏只有训练入口：点进去直接是「回忆 → 揭晓 → 自评」的单卡流，
// 不再提供任何逐条翻阅、按类浏览形态。加回列表前，先想清楚会不会把"查资料"的观感带回来。

struct LawUniverseView: View {
    @ObservedObject private var store = LawTrainingStore.shared

    private var allCards: [LawFlashcard] { LawFlashcardFactory.all }
    private var dueCards: [LawFlashcard] { store.dueCards(in: allCards) }

    /// 掌握度最低的待练卡片优先出队（内容数字，不列出名称）。
    private var weakCards: [LawFlashcard] {
        Array(dueCards.sorted { box(of: $0) < box(of: $1) }.prefix(10))
    }

    /// 随机抽练的牌组在进入页面时抽定，避免每次重绘都换一批。
    @State private var randomCards: [LawFlashcard] = []

    var body: some View {
        NavigationStack {
            List {
                Section {
                    todayCard
                    NavigationLink { KnowledgeAtlasView() } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "figure.walk")
                                .font(.title2).foregroundColor(.apexEmerald)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("考点训练").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text("按掌握度推进的下一组考点，点开即做题")
                                    .font(AppFont.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    if !weakCards.isEmpty {
                        modeLink(cards: weakCards,
                                 title: "薄弱优先",
                                 subtitle: "掌握度最低的 \(weakCards.count) 张先练",
                                 icon: "arrow.down.circle.fill",
                                 color: .apexGold)
                    }
                    modeLink(cards: randomCards,
                             title: "随机抽练",
                             subtitle: randomCards.isEmpty ? "暂无可抽卡片" : "打乱顺序抽 \(randomCards.count) 张",
                             icon: "shuffle.circle.fill",
                             color: .apexStarBlue)
                    modeLink(cards: allCards.shuffled(),
                             title: "全部重刷",
                             subtitle: "不分排期，\(allCards.count) 张一次过",
                             icon: "arrow.triangle.2.circlepath.circle.fill",
                             color: .apexMystery)
                } header: {
                    Text("训练模式")
                } footer: {
                    Text("共 \(allCards.count) 张卡 · 今日到期 \(dueCards.count) 张 · 已排期 \(store.scheduledCount(in: allCards)) 张")
                        .font(AppFont.caption)
                }
            }
            .navigationTitle("公式速记")
            .task { randomCards = dueCards.shuffled() }
        }
    }

    private func box(of card: LawFlashcard) -> Int {
        store.progress(for: card)?.box ?? 0
    }

    // MARK: 今日训练

    private var todayCard: some View {
        NavigationLink {
            LawTrainingSessionView(cards: dueCards, title: "今日训练")
        } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: "rectangle.stack.fill")
                    .font(.title2).foregroundColor(.apexLava)
                VStack(alignment: .leading, spacing: 2) {
                    Text("今日训练").font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(dueCards.isEmpty ? "全部卡片已在复习排期中，明天再来" : "\(dueCards.count) 张到期卡片，开练")
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                if !dueCards.isEmpty {
                    Text("\(dueCards.count)")
                        .font(AppFont.chip).foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.apexLava).clipShape(Capsule())
                }
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: 训练模式入口

    private func modeLink(cards: [LawFlashcard], title: String, subtitle: String,
                          icon: String, color: Color) -> some View {
        NavigationLink {
            LawTrainingSessionView(cards: cards, title: title)
        } label: {
            HStack(spacing: Spacing.md) {
                Image(systemName: icon).font(.title3).foregroundColor(color).frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(subtitle).font(AppFont.caption).foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
            }
            .padding(.vertical, 6)
        }
        .disabled(cards.isEmpty)
    }
}

// MARK: - 掌握度徽章（0% 亮起 → 100% 满环）

struct MasteryBadge: View {
    let mastery: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: mastery >= 1 ? "checkmark.seal.fill" : "bolt.fill")
                .font(.system(size: 9))
            Text("\(Int(mastery * 100))%")
                .font(AppFont.chip)
        }
        .foregroundColor(mastery >= 0.99 ? .apexEmerald : mastery > 0 ? .apexGold : .secondary)
        .opacity(mastery > 0 ? 1 : 0.6)
    }
}
