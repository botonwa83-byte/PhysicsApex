import Foundation

// MARK: - 智能复习（移植自 MathApex）：艾宾浩斯间隔重复 SM-2 风格

struct ReviewItem: Codable, Identifiable {
    var id: String { problemId }
    let problemId: String
    var nextReviewDate: Date
    var currentInterval: Int   // 天
    var correctStreak: Int
    var totalReviews: Int

    static let intervals = [1, 3, 7, 15, 30, 60]

    var isDueToday: Bool { nextReviewDate <= Date() }

    var isOverdue: Bool {
        let cal = Calendar.current
        return cal.startOfDay(for: nextReviewDate) < cal.startOfDay(for: Date())
    }

    var daysUntilReview: Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let due = cal.startOfDay(for: nextReviewDate)
        return cal.dateComponents([.day], from: today, to: due).day ?? 0
    }
}

final class ReviewScheduler: ObservableObject {
    static let shared = ReviewScheduler()

    private let storageKey = "physicsapex_review_v1"

    @Published private(set) var items: [String: ReviewItem] = [:]

    init() { loadItems() }

    /// 答题后调用，更新/创建复习计划。
    func recordReview(problemId: String, isCorrect: Bool) {
        var item = items[problemId] ?? ReviewItem(
            problemId: problemId, nextReviewDate: Date(),
            currentInterval: 0, correctStreak: 0, totalReviews: 0
        )
        item.totalReviews += 1
        if isCorrect {
            item.correctStreak += 1
            let idx = min(item.correctStreak, ReviewItem.intervals.count - 1)
            item.currentInterval = ReviewItem.intervals[idx]
        } else {
            item.correctStreak = 0
            item.currentInterval = ReviewItem.intervals[0]
        }
        item.nextReviewDate = Calendar.current.date(byAdding: .day, value: item.currentInterval, to: Date()) ?? Date()
        items[problemId] = item
        saveItems()
    }

    func dueProblems() -> [ReviewItem] {
        items.values.filter(\.isDueToday).sorted { a, b in
            if a.isOverdue != b.isOverdue { return a.isOverdue }
            return a.correctStreak < b.correctStreak
        }
    }

    var dueCount: Int { items.values.filter(\.isDueToday).count }

    func upcomingProblems() -> [ReviewItem] {
        items.values.filter { !$0.isDueToday }.sorted { $0.nextReviewDate < $1.nextReviewDate }
    }

    func reviewItem(for problemId: String) -> ReviewItem? { items[problemId] }

    var totalScheduled: Int { items.count }

    private func saveItems() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func loadItems() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([String: ReviewItem].self, from: data) else { return }
        items = decoded
    }
}
