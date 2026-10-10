import Foundation

// MARK: - 物理定律「通透卡」
// 目标：让学生"懂"而非"背"。每条定律给出 物理图像 + 来龙去脉 + 极限检验 + 边界 + 迷思。
// 诚信红线：每条定律必须带 适用条件 / 量纲 / 常见误用。

/// 极限思维检验：把某变量推到极端，看公式/现象如何变化——物理学家的"验真"绝技。
struct LimitCheck: Identifiable {
    var id: String { scenario }
    let scenario: String    // 让 X 推到极端（如"θ → 90°"）
    let result: String      // 公式/现象变成什么
    let intuition: String   // 为什么这符合（或颠覆）直觉 —— 醍醐灌顶点
}

struct PhysicsLaw: Identifiable {
    let id: String
    let name: String
    let nameEN: String
    let topic: PhysicsTopic
    let stage: Stage
    let expression: String          // 表达式
    let dimension: String           // 量纲 / 单位
    let physicalImage: String       // 🖼 一句话物理图像 / 类比（"看见"它）
    let derivation: String          // 🌱 来龙去脉（30 秒它从哪来）
    let meaning: String             // 物理意义
    let limitChecks: [LimitCheck]   // 🎚 极限检验
    let conditions: [String]        // 适用条件
    let commonMisuses: [String]     // 常见迷思 / 误用
    let applications: [String]      // 高考应用场景
    let relatedWeapons: [PhysicsWeapon]
    var latex: String? = nil        // KaTeX 表达式（有则详情页用 FormulaView 渲染，无则回退 expression 文本）
}
