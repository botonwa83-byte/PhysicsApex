import Foundation

// MARK: - 连击 / 距高考天数（移植自 MathApex StreakManager 精简版）

final class StreakManager: ObservableObject {
    static let shared = StreakManager()

    private let streakKey = "physicsapex_streak_v1"
    private let lastActiveKey = "physicsapex_last_active"
    private let examDateKey = "physicsapex_gaokao_date"

    @Published var currentStreak: Int = 0
    @Published var lastActiveDate: Date?
    @Published var gaokaoDate: Date?

    private init() {
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        lastActiveDate = UserDefaults.standard.object(forKey: lastActiveKey) as? Date
        gaokaoDate = UserDefaults.standard.object(forKey: examDateKey) as? Date
        if currentStreak == 0 { currentStreak = 3 } // 示例初值
    }

    func recordActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastActiveDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            if lastDay == today { return }
            let days = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            currentStreak = (days == 1) ? currentStreak + 1 : 1
        } else {
            currentStreak = 1
        }
        lastActiveDate = today
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        UserDefaults.standard.set(today, forKey: lastActiveKey)
    }

    func setGaokaoDate(_ date: Date) {
        gaokaoDate = date
        UserDefaults.standard.set(date, forKey: examDateKey)
    }

    /// 距高考天数（默认取下一个 6 月 7 日）。
    var daysToGaokao: Int {
        let target = gaokaoDate ?? Self.nextGaokao()
        let days = Calendar.current.dateComponents([.day], from: Date(), to: target).day ?? 0
        return max(0, days)
    }

    private static func nextGaokao() -> Date {
        let cal = Calendar.current
        let now = Date()
        let year = cal.component(.year, from: now)
        var comps = DateComponents()
        comps.month = 6; comps.day = 7
        comps.year = year
        let thisYear = cal.date(from: comps) ?? now
        if thisYear > now { return thisYear }
        comps.year = year + 1
        return cal.date(from: comps) ?? now
    }
}
