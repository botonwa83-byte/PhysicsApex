import Foundation
import SwiftUI

// MARK: - 学生档案（移植自 MathApex StudentProfile，加入段位）

struct PracticeRecord: Codable, Identifiable {
    let id: String
    let problemId: String
    let solvedAt: Date
    let isCorrect: Bool
    let responseTime: Double
    let hintsUsed: Int
    let usedDescentMethod: Bool   // 是否用了降维秒杀
}

final class StudentProfile: ObservableObject, Codable {
    @Published var displayName: String
    @Published var currentStage: Stage
    @Published var streak: Int
    @Published var totalProblems: Int
    @Published var correctProblems: Int
    @Published var unlockedWeapons: [String]
    @Published var completedParadoxes: [String]
    @Published var topicMastery: [String: Double]  // topic.rawValue -> 0...1

    var accuracy: Double {
        totalProblems == 0 ? 0 : Double(correctProblems) / Double(totalProblems)
    }

    enum CodingKeys: String, CodingKey {
        case displayName, currentStage, streak, totalProblems, correctProblems
        case unlockedWeapons, completedParadoxes, topicMastery
    }

    init() {
        self.displayName = "物理探险家"
        self.currentStage = .senior
        self.streak = 3
        self.totalProblems = 42
        self.correctProblems = 31
        self.unlockedWeapons = ["momentumConservation", "mechanicalEnergy"]
        self.completedParadoxes = ["galileo_tower"]
        self.topicMastery = [
            PhysicsTopic.kinematics.rawValue: 0.8,
            PhysicsTopic.newton.rawValue: 0.65,
            PhysicsTopic.energy.rawValue: 0.5,
        ]
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try c.decode(String.self, forKey: .displayName)
        currentStage = try c.decode(Stage.self, forKey: .currentStage)
        streak = try c.decode(Int.self, forKey: .streak)
        totalProblems = try c.decode(Int.self, forKey: .totalProblems)
        correctProblems = try c.decode(Int.self, forKey: .correctProblems)
        unlockedWeapons = try c.decode([String].self, forKey: .unlockedWeapons)
        completedParadoxes = try c.decode([String].self, forKey: .completedParadoxes)
        topicMastery = try c.decode([String: Double].self, forKey: .topicMastery)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(displayName, forKey: .displayName)
        try c.encode(currentStage, forKey: .currentStage)
        try c.encode(streak, forKey: .streak)
        try c.encode(totalProblems, forKey: .totalProblems)
        try c.encode(correctProblems, forKey: .correctProblems)
        try c.encode(unlockedWeapons, forKey: .unlockedWeapons)
        try c.encode(completedParadoxes, forKey: .completedParadoxes)
        try c.encode(topicMastery, forKey: .topicMastery)
    }

    // MARK: 行为

    func recordAnswer(correct: Bool) {
        totalProblems += 1
        if correct { correctProblems += 1 }
    }

    func promote(to stage: Stage) { currentStage = stage }
}
