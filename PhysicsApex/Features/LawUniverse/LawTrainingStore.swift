import Foundation
import Combine

// MARK: - 公式速记训练进度（Leitner 盒子间隔复习，UserDefaults 持久化）

final class LawTrainingStore: ObservableObject {
    static let shared = LawTrainingStore()

    struct CardProgress: Codable {
        var box: Int = 0          // Leitner 0...3，盒子越高间隔越长
        var dueDate: Date = Date()
        var reviewCount: Int = 0
    }

    @Published private(set) var progress: [String: CardProgress] = [:]

    private let storageKey = "physapex_law_training_v1"
    /// Leitner 间隔：box 0→1天, 1→3天, 2→7天, 3→14天
    private let boxIntervals: [Int] = [1, 3, 7, 14]

    private init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: CardProgress].self, from: data) {
            progress = decoded
        }
    }

    // MARK: 查询

    /// 到期卡片 = 无记录（新卡）或 dueDate 已到
    func dueCards(in cards: [LawFlashcard], now: Date = .init()) -> [LawFlashcard] {
        cards.filter { card in
            guard let p = progress[card.id] else { return true }
            return p.dueDate <= now
        }
    }

    func dueCount(in cards: [LawFlashcard], now: Date = .init()) -> Int {
        dueCards(in: cards, now: now).count
    }

    /// 明天之前不会到期的卡片数（已掌握库存）
    func scheduledCount(in cards: [LawFlashcard]) -> Int {
        cards.count - dueCount(in: cards)
    }

    func progress(for card: LawFlashcard) -> CardProgress? {
        progress[card.id]
    }

    /// 某定律的掌握度（各卡 box 均值 / 3），未训练为 0
    func mastery(for lawId: String, cards: [LawFlashcard]) -> Double {
        let lawCards = cards.filter { $0.lawId == lawId }
        guard !lawCards.isEmpty else { return 0 }
        let total = lawCards.reduce(0.0) { sum, card in
            sum + Double(progress[card.id]?.box ?? 0)
        }
        return total / Double(lawCards.count * 3)
    }

    // MARK: 自评

    /// remembered=记牢 / fuzzy=模糊 / 都否=忘了
    func grade(_ card: LawFlashcard, remembered: Bool = false, fuzzy: Bool = false, now: Date = .init()) {
        var p = progress[card.id] ?? CardProgress()
        p.reviewCount += 1

        if remembered {
            p.box = min(p.box + 1, boxIntervals.count - 1)
            p.dueDate = now.addingTimeInterval(Double(boxIntervals[p.box]) * 86_400)
        } else if fuzzy {
            // 盒子不动，明天再练
            p.dueDate = now.addingTimeInterval(86_400)
        } else {
            p.box = 0
            p.dueDate = now.addingTimeInterval(86_400)
        }

        progress[card.id] = p
        save()
    }

    // MARK: 持久化

    private func save() {
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
