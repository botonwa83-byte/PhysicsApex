import Foundation

// MARK: - 物理定律（对应 MathApex 的 Formula；物理特有：适用条件 + 量纲 + 常见误用）
// 诚信红线：每条定律必须带 适用条件 / 量纲 / 常见误用。

struct PhysicsLaw: Identifiable, Codable {
    let id: String
    let name: String
    let nameEN: String
    let topic: PhysicsTopic
    let stage: Stage
    let expression: String          // 表达式（Unicode 文本）
    let dimension: String           // 量纲 / 单位，如 "N = kg·m/s²"
    let meaning: String             // 物理意义（直观理解）
    let conditions: [String]        // 适用条件（物理 app 的专业底线）
    let commonMisuses: [String]     // 常见误用
    let applications: [String]      // 高考应用场景
    let relatedWeapons: [PhysicsWeapon]
}
