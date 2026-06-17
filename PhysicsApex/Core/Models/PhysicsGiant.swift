import Foundation

// MARK: - 大师思维（移植自 MathApex Hero）：RPG 属性 + 金句

struct GiantAttributes: Codable {
    let insight: Int      // 洞察力 1-10
    let creativity: Int   // 创造力 1-10
    let perseverance: Int // 毅力 1-10
    let influence: Int    // 影响力 1-10
}

struct PhysicsGiant: Identifiable, Codable {
    let id: String
    let name: String
    let nameEN: String
    let era: String
    let attributes: GiantAttributes
    let weaponSkills: [String]   // 关联武器名
    let legendStory: String
    let famousQuote: String
    let relatedParadoxes: [String]
    let portraitEmoji: String
}
