import Foundation

// MARK: - 单位 / 量纲训练（物理独家技能）
// 两部分：量纲速查（核心物理量拆成基本量）+ 用量纲推公式（不推导，直接「猜」出公式形式）。

/// 核心物理量的单位与量纲。
struct PhysicalQuantity: Identifiable {
    let id: String
    let name: String
    let symbol: String
    let siUnit: String       // SI 单位（如 "N"）
    let dimension: String    // 基本量纲（如 "M·L·T⁻²"）
    let breakdown: String    // 拆解（如 "kg·m/s²"）
    let meaning: String      // 一句话含义
}

/// 用量纲推公式：已知一个量依赖哪些量，靠量纲配平定出公式形式。
struct DimensionDerivation: Identifiable {
    let id: String
    let target: String           // 求什么（如 "单摆周期 T"）
    let depends: [String]        // 依赖的量（带量纲）
    let setup: String            // 假设的幂次形式
    let balancing: [String]      // 配平步骤
    let result: String           // 推出的形式（差一个无量纲系数）
    let realFormula: String      // 真实公式
    let insight: String          // 醍醐灌顶点
}

enum DimensionData {

    // MARK: 量纲速查
    static let quantities: [PhysicalQuantity] = [
        PhysicalQuantity(id: "force", name: "力", symbol: "F", siUnit: "N", dimension: "M·L·T⁻²", breakdown: "kg·m/s²", meaning: "改变运动状态的作用，F=ma。"),
        PhysicalQuantity(id: "energy", name: "能量 / 功", symbol: "E, W", siUnit: "J", dimension: "M·L²·T⁻²", breakdown: "kg·m²/s²", meaning: "做功或储存的本领，W=Fs。"),
        PhysicalQuantity(id: "power", name: "功率", symbol: "P", siUnit: "W", dimension: "M·L²·T⁻³", breakdown: "kg·m²/s³", meaning: "做功的快慢，P=W/t。"),
        PhysicalQuantity(id: "pressure", name: "压强", symbol: "p", siUnit: "Pa", dimension: "M·L⁻¹·T⁻²", breakdown: "kg/(m·s²)", meaning: "单位面积上的力，p=F/S。"),
        PhysicalQuantity(id: "momentum", name: "动量", symbol: "p", siUnit: "kg·m/s", dimension: "M·L·T⁻¹", breakdown: "kg·m/s", meaning: "运动的「冲劲」，p=mv。"),
        PhysicalQuantity(id: "charge", name: "电荷量", symbol: "Q", siUnit: "C", dimension: "I·T", breakdown: "A·s", meaning: "电的多少，Q=It。"),
        PhysicalQuantity(id: "efield", name: "电场强度", symbol: "E", siUnit: "V/m", dimension: "M·L·T⁻³·I⁻¹", breakdown: "kg·m/(A·s³)", meaning: "单位电荷受的力，E=F/q。"),
        PhysicalQuantity(id: "freq", name: "频率", symbol: "f", siUnit: "Hz", dimension: "T⁻¹", breakdown: "1/s", meaning: "每秒振动次数，f=1/T。"),
    ]

    // MARK: 用量纲推公式
    static let derivations: [DimensionDerivation] = [
        DimensionDerivation(
            id: "pendulum",
            target: "单摆周期 T",
            depends: ["摆长 L → 量纲 L", "重力加速度 g → 量纲 L·T⁻²", "（试试加上质量 m → M）"],
            setup: "设 T = k · Lᵃ · gᵇ（k 为无量纲常数）",
            balancing: [
                "[T] = Lᵃ · (L·T⁻²)ᵇ = L^(a+b) · T^(−2b)",
                "对比左边 T¹：T 的幂 −2b = 1 ⟹ b = −1/2",
                "L 的幂 a + b = 0 ⟹ a = 1/2",
            ],
            result: "T ∝ √(L / g)",
            realFormula: "T = 2π√(L / g)",
            insight: "质量 m 根本配不进去——量纲直接告诉你：单摆周期与质量无关！连推导都省了。"
        ),
        DimensionDerivation(
            id: "freefall",
            target: "自由下落 h 后的速度 v",
            depends: ["下落高度 h → 量纲 L", "重力加速度 g → 量纲 L·T⁻²"],
            setup: "设 v = k · gᵃ · hᵇ",
            balancing: [
                "[v] = (L·T⁻²)ᵃ · Lᵇ = L^(a+b) · T^(−2a)",
                "对比 v 的量纲 L·T⁻¹：T 幂 −2a = −1 ⟹ a = 1/2",
                "L 幂 a + b = 1 ⟹ b = 1/2",
            ],
            result: "v ∝ √(g·h)",
            realFormula: "v = √(2g·h)",
            insight: "量纲只差一个无量纲系数（这里是 √2）。形式一秒猜出，细节再补。"
        ),
        DimensionDerivation(
            id: "orbit",
            target: "第一宇宙速度 v",
            depends: ["引力常量 G → 量纲 M⁻¹·L³·T⁻²", "地球质量 M → 量纲 M", "地球半径 R → 量纲 L"],
            setup: "设 v = k · Gᵃ · Mᵇ · Rᶜ",
            balancing: [
                "M 幂：−a + b = 0",
                "T 幂：−2a = −1 ⟹ a = 1/2 ⟹ b = 1/2",
                "L 幂：3a + c = 1 ⟹ c = −1/2",
            ],
            result: "v ∝ √(G·M / R)",
            realFormula: "v = √(G·M / R) ≈ 7.9 km/s",
            insight: "三个基本量纲、三个方程，刚好锁死指数。竞赛里这是「不会做也能蒙对形式」的神技。"
        ),
    ]
}
