import SwiftUI

// MARK: - 公式速记：先回忆 → 再揭晓 → 自评的闪卡训练（无长文阅读页）

struct LawUniverseView: View {
    @ObservedObject private var store = LawTrainingStore.shared

    private var topics: [PhysicsTopic] {
        PhysicsTopic.allCases.filter { !LawLibrary.laws(for: $0).isEmpty }
    }
    private var allCards: [LawFlashcard] { LawFlashcardFactory.all }
    private var dueCards: [LawFlashcard] { store.dueCards(in: allCards) }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { KnowledgeAtlasView() } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "map.fill").font(.title3)
                                .foregroundStyle(LinearGradient(colors: [.apexStarBlue, .apexMystery], startPoint: .top, endPoint: .bottom))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("知识路线图").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text("一图纵览整个高考物理 · \(KnowledgeAtlas.totalPoints) 个知识点").font(AppFont.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section {
                    todayCard
                }

                ForEach(topics) { topic in
                    Section(topic.name) {
                        ForEach(LawLibrary.laws(for: topic)) { law in
                            NavigationLink {
                                LawTrainingSessionView(cards: LawFlashcardFactory.cards(for: law), title: law.name)
                            } label: {
                                deckRow(law)
                            }
                        }
                    }
                }
            }
            .navigationTitle("公式速记")
        }
    }

    // MARK: 今日训练卡

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

    // MARK: 卡组行

    private func deckRow(_ law: PhysicsLaw) -> some View {
        let mastery = store.mastery(for: law.id, cards: allCards)
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(law.name).font(AppFont.cardTitle).foregroundColor(.primary)
                Spacer()
                TagChip(text: law.stage.shortTitle, color: law.stage.color)
            }
            HStack(spacing: Spacing.md) {
                Text(law.expression)
                    .font(.system(.subheadline, design: .monospaced)).foregroundColor(.apexLava)
                    .lineLimit(1)
                Spacer()
                MasteryBadge(mastery: mastery)
            }
        }
        .padding(.vertical, 2)
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
