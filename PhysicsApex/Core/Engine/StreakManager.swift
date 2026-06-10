import Foundation

// MARK: - 连击 / 成就 / 距高考（移植自 MathApex StreakManager）

struct Achievement: Identifiable {
    let id: String
    let title: String
    let icon: String
    let description: String
    let isUnlocked: Bool
}

final class StreakManager: ObservableObject {
    static let shared = StreakManager()

    private let streakKey = "physicsapex_streak_v1"
    private let examDateKey = "physicsapex_gaokao_date"

    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var lastActiveDate: Date?
    @Published var gaokaoDate: Date?

    private init() {
        load()
        checkStreak()
        if currentStreak == 0 && lastActiveDate == nil { currentStreak = 3 } // 首次示例初值
    }

    // MARK: 连击

    func recordActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastActiveDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            if lastDay == today { return }
            let days = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            currentStreak = (days == 1) ? currentStreak + 1 : 1
        } else {
            currentStreak = max(currentStreak, 1)
        }
        lastActiveDate = today
        longestStreak = max(longestStreak, currentStreak)
        save()
    }

    private func checkStreak() {
        guard let last = lastActiveDate else { return }
        let today = Calendar.current.startOfDay(for: Date())
        let lastDay = Calendar.current.startOfDay(for: last)
        let days = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
        if days > 1 { currentStreak = 0; save() }
    }

    var isActiveToday: Bool {
        guard let last = lastActiveDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    // MARK: 距高考

    func setGaokaoDate(_ date: Date) { gaokaoDate = date; save() }

    var daysToGaokao: Int {
        let target = gaokaoDate ?? Self.nextGaokao()
        let today = Calendar.current.startOfDay(for: Date())
        let t = Calendar.current.startOfDay(for: target)
        return max(0, Calendar.current.dateComponents([.day], from: today, to: t).day ?? 0)
    }

    private static func nextGaokao() -> Date {
        let cal = Calendar.current
        let now = Date()
        var comps = DateComponents(); comps.month = 6; comps.day = 7
        comps.year = cal.component(.year, from: now)
        let thisYear = cal.date(from: comps) ?? now
        if thisYear > now { return thisYear }
        comps.year = (comps.year ?? 0) + 1
        return cal.date(from: comps) ?? now
    }

    // MARK: 成就

    func achievements() -> [Achievement] {
        let pm = PracticeManager.shared
        let rm = ReviewScheduler.shared
        return [
            Achievement(id: "first_10", title: "初出茅庐", icon: "flame", description: "累计做题 10 道", isUnlocked: pm.totalAnswered >= 10),
            Achievement(id: "first_50", title: "身经百战", icon: "flame.fill", description: "累计做题 50 道", isUnlocked: pm.totalAnswered >= 50),
            Achievement(id: "accuracy_70", title: "稳定发挥", icon: "target", description: "总正确率 ≥ 70%", isUnlocked: pm.totalAnswered >= 10 && pm.overallAccuracy >= 0.7),
            Achievement(id: "accuracy_90", title: "精准打击", icon: "scope", description: "总正确率 ≥ 90%", isUnlocked: pm.totalAnswered >= 20 && pm.overallAccuracy >= 0.9),
            Achievement(id: "streak_3", title: "三日不辍", icon: "calendar.badge.checkmark", description: "连续打卡 3 天", isUnlocked: longestStreak >= 3),
            Achievement(id: "streak_7", title: "一周坚持", icon: "calendar.badge.clock", description: "连续打卡 7 天", isUnlocked: longestStreak >= 7),
            Achievement(id: "review_10", title: "温故知新", icon: "brain.head.profile", description: "复习 10 道题", isUnlocked: rm.items.values.reduce(0) { $0 + $1.totalReviews } >= 10),
            Achievement(id: "descent", title: "降维打击", icon: "bolt.fill", description: "体验降维秒杀", isUnlocked: pm.totalAnswered >= 1),
        ]
    }

    var unlockedCount: Int { achievements().filter(\.isUnlocked).count }

    // MARK: 持久化

    private func save() {
        let data: [String: Any] = [
            "currentStreak": currentStreak,
            "longestStreak": longestStreak,
            "lastActiveDate": lastActiveDate?.timeIntervalSince1970 ?? 0
        ]
        UserDefaults.standard.set(data, forKey: streakKey)
        if let date = gaokaoDate { UserDefaults.standard.set(date.timeIntervalSince1970, forKey: examDateKey) }
    }

    private func load() {
        if let data = UserDefaults.standard.dictionary(forKey: streakKey) {
            currentStreak = data["currentStreak"] as? Int ?? 0
            longestStreak = data["longestStreak"] as? Int ?? 0
            if let ts = data["lastActiveDate"] as? Double, ts > 0 {
                lastActiveDate = Date(timeIntervalSince1970: ts)
            }
        }
        let ts = UserDefaults.standard.double(forKey: examDateKey)
        if ts > 0 { gaokaoDate = Date(timeIntervalSince1970: ts) }
    }
}
