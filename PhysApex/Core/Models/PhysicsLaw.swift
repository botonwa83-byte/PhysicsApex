import Foundation

// MARK: - 公式卡片数据
// 约束（改动前先读）：只保留闪卡会渲染的字段。曾经的 nameEN / derivation(来龙去脉) /
// applications(应用场景) / relatedWeapons 四个字段零渲染却是完整词条文案，
// 堆起来让数据包看起来像一部工具书——已删除，勿再加回静态知识型字段。

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
    let topic: PhysicsTopic
    let stage: Stage
    let expression: String          // 表达式
    let dimension: String           // 量纲 / 单位
    let physicalImage: String       // 🖼 一句话物理图像 / 类比（"看见"它）
    let meaning: String             // 物理意义
    let limitChecks: [LimitCheck]   // 🎚 极限检验
    let conditions: [String]        // 适用条件
    let commonMisuses: [String]     // 常见迷思 / 误用
    var latex: String? = nil        // KaTeX 表达式（有则详情页用 FormulaView 渲染，无则回退 expression 文本）
}
