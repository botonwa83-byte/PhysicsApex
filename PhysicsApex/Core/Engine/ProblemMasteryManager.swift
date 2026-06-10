import Foundation
import SwiftUI

// MARK: - 掌握度（移植自 MathApex）：连对 3 次自动标记掌握

final class ProblemMasteryManager: ObservableObject {
    static let shared = ProblemMasteryManager()

    private let masteredKey = "physicsapex_mastered_ids"

    @Published var masteredIds: Set<String> {
        didSet { save() }
    }

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: masteredKey) ?? []
        self.masteredIds = Set(saved)
    }

    private func save() {
        UserDefaults.standard.set(Array(masteredIds), forKey: masteredKey)
    }

    func isMastered(_ problemId: String) -> Bool { masteredIds.contains(problemId) }

    func toggleMastery(_ problemId: String) {
        if masteredIds.contains(problemId) { masteredIds.remove(problemId) }
        else { masteredIds.insert(problemId) }
    }

    func markMastered(_ problemId: String) { masteredIds.insert(problemId) }
    func unmarkMastered(_ problemId: String) { masteredIds.remove(problemId) }

    var masteredCount: Int { masteredIds.count }
}
