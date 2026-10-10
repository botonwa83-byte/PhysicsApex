import Foundation
import SwiftUI

// MARK: - 练习记录引擎（移植自 MathApex）：答题记录 + 错题训练(手动标记+自动识别) + 专题统计

struct AnswerRecord: Codable, Identifiable {
    let id: UUID
    let problemId: String
    let timestamp: Date
    let isCorrect: Bool
    let timeSpent: TimeInterval
    let usedHint: Bool

    init(problemId: String, isCorrect: Bool, timeSpent: TimeInterval, usedHint: Bool) {
        self.id = UUID()
        self.problemId = problemId
        self.timestamp = Date()
        self.isCorrect = isCorrect
        self.timeSpent = timeSpent
        self.usedHint = usedHint
    }
}

struct ProblemStats {
    let problemId: String
    let totalAttempts: Int
    let correctCount: Int
    let lastAttempt: Date?

    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctCount) / Double(totalAttempts)
    }
    var isWeak: Bool { totalAttempts >= 2 && accuracy < 0.5 }
}

final class PracticeManager: ObservableObject {
    static let shared = PracticeManager()

    private let storageKey = "physicsapex_records_v1"
    private let flagKey = "physicsapex_flagged_v1"
    private let maxRecords = 5000

    @Published private(set) var records: [AnswerRecord] = []
    @Published private(set) var flaggedErrorIds: Set<String> = []

    init() {
        loadRecords()
        flaggedErrorIds = Set(UserDefaults.standard.stringArray(forKey: flagKey) ?? [])
    }

    // MARK: 手动标注错题

    func isFlaggedError(_ id: String) -> Bool { flaggedErrorIds.contains(id) }
    func flagError(_ id: String) { if flaggedErrorIds.insert(id).inserted { saveFlags() } }
    func unflagError(_ id: String) { if flaggedErrorIds.remove(id) != nil { saveFlags() } }
    func toggleError(_ id: String) { flaggedErrorIds.contains(id) ? unflagError(id) : flagError(id) }
    private func saveFlags() { UserDefaults.standard.set(Array(flaggedErrorIds), forKey: flagKey) }

    // MARK: 记录

    func recordAnswer(problemId: String, isCorrect: Bool, timeSpent: TimeInterval, usedHint: Bool) {
        records.append(AnswerRecord(problemId: problemId, isCorrect: isCorrect, timeSpent: timeSpent, usedHint: usedHint))
        if records.count > maxRecords { records = Array(records.suffix(maxRecords)) }
        saveRecords()

        // 同步到复习计划 + 自动掌握
        ReviewScheduler.shared.recordReview(problemId: problemId, isCorrect: isCorrect)
        let recent = records.filter { $0.problemId == problemId }.suffix(3)
        if recent.count >= 3 && recent.allSatisfy(\.isCorrect) {
            ProblemMasteryManager.shared.markMastered(problemId)
        }
    }

    // MARK: 查询

    func stats(for problemId: String) -> ProblemStats {
        let r = records.filter { $0.problemId == problemId }
        return ProblemStats(problemId: problemId, totalAttempts: r.count,
                            correctCount: r.filter(\.isCorrect).count, lastAttempt: r.last?.timestamp)
    }

    /// 错题：最近一次答错，或正确率 < 50%（做过 2 次以上）。
    func wrongProblemIds() -> Set<String> {
        var latest: [String: Bool] = [:]
        for rec in records { latest[rec.problemId] = rec.isCorrect }
        let wrongLatest = Set(latest.filter { !$0.value }.map(\.key))
        let lowAcc = Set(records.map(\.problemId)).filter { stats(for: $0).isWeak }
        return wrongLatest.union(lowAcc)
    }

    /// 错题训练 = 自动识别的错题 ∪ 手动标记，按正确率升序。
    func errorProblems(from problems: [PhysicsProblem]) -> [PhysicsProblem] {
        let ids = wrongProblemIds().union(flaggedErrorIds)
        return problems.filter { ids.contains($0.id) }
            .sorted { stats(for: $0.id).accuracy < stats(for: $1.id).accuracy }
    }

    // MARK: 总览

    var totalAnswered: Int { records.count }
    var totalCorrect: Int { records.filter(\.isCorrect).count }
    var overallAccuracy: Double { totalAnswered == 0 ? 0 : Double(totalCorrect) / Double(totalAnswered) }
    var todayAnswered: Int {
        let t = Calendar.current.startOfDay(for: Date())
        return records.filter { $0.timestamp >= t }.count
    }
    var todayCorrect: Int {
        let t = Calendar.current.startOfDay(for: Date())
        return records.filter { $0.timestamp >= t && $0.isCorrect }.count
    }

    // MARK: 持久化

    private func saveRecords() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
    private func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([AnswerRecord].self, from: data) else { return }
        records = decoded
    }
}
