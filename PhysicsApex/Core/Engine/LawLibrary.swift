import Foundation

// MARK: - 定律宇宙 数据（每条含 适用条件 + 量纲 + 常见误用）

enum LawLibrary {
    static let all: [PhysicsLaw] = [
        PhysicsLaw(
            id: "newton2",
            name: "牛顿第二定律",
            nameEN: "Newton's Second Law",
            topic: .newton,
            stage: .senior,
            expression: "F合 = ma",
            dimension: "N = kg·m/s²",
            meaning: "合外力决定加速度；力是改变运动状态的原因，不是维持运动的原因。",
            conditions: ["惯性参考系", "宏观、低速（远小于光速）", "质量恒定"],
            commonMisuses: ["在非惯性系直接用（需加惯性力）", "把'有力'当成'有速度'", "对变质量系统直接套用"],
            applications: ["连接体问题", "斜面/传送带", "牛顿第二定律 + 圆周运动"],
            relatedWeapons: [.forceDiagram, .workEnergyTheorem]
        ),
        PhysicsLaw(
            id: "momentum_conservation",
            name: "动量守恒定律",
            nameEN: "Conservation of Momentum",
            topic: .momentum,
            stage: .senior,
            expression: "p前 = p后，即 Σmᵢvᵢ = 常量",
            dimension: "kg·m/s",
            meaning: "系统不受外力（或外力合为零）时，总动量守恒——碰撞/爆炸题的上帝视角。",
            conditions: ["系统所受合外力为零", "或：碰撞/爆炸等内力远大于外力的瞬间过程", "矢量式，注意方向"],
            commonMisuses: ["只在某一方向守恒时当成整体守恒", "把动量守恒误当动能守恒", "漏掉系统中某个物体"],
            applications: ["碰撞", "反冲/爆炸", "人船模型"],
            relatedWeapons: [.momentumConservation, .referenceFrame]
        ),
        PhysicsLaw(
            id: "mechanical_energy",
            name: "机械能守恒定律",
            nameEN: "Conservation of Mechanical Energy",
            topic: .energy,
            stage: .senior,
            expression: "Ek + Ep = 常量",
            dimension: "J = kg·m²/s²",
            meaning: "只有重力/弹力做功时，动能与势能相互转化、总量不变。",
            conditions: ["只有重力和弹力做功", "或：其他力不做功", "系统内无摩擦生热"],
            commonMisuses: ["有摩擦/空气阻力时仍用守恒", "势能零点选取不一致", "漏算弹性势能"],
            applications: ["竖直圆周/单摆", "弹簧问题", "过山车类问题"],
            relatedWeapons: [.mechanicalEnergy, .energyIntuition]
        ),
        PhysicsLaw(
            id: "work_energy",
            name: "动能定理",
            nameEN: "Work–Energy Theorem",
            topic: .energy,
            stage: .senior,
            expression: "W合 = ½mv₂² − ½mv₁²",
            dimension: "J = N·m",
            meaning: "合外力做的功等于动能的变化——不管路径多复杂，只看功的总和。",
            conditions: ["适用于任何力（含变力、摩擦力）", "标量式，功有正负"],
            commonMisuses: ["漏掉摩擦力做的负功", "把'路程'当'位移'算功", "误以为只能用于恒力"],
            applications: ["变力做功", "曲线运动求末速度", "多过程问题一步跨越"],
            relatedWeapons: [.workEnergyTheorem, .energyIntuition]
        ),
        PhysicsLaw(
            id: "lorentz",
            name: "洛伦兹力",
            nameEN: "Lorentz Force",
            topic: .magnetic,
            stage: .senior,
            expression: "F = qvB·sinθ，方向由左手/右手定则",
            dimension: "N（B 的单位 T = kg/(A·s²)）",
            meaning: "磁场对运动电荷的作用力，永远垂直于速度，只改变方向不改变速率。",
            conditions: ["电荷在磁场中运动", "θ 为 v 与 B 的夹角"],
            commonMisuses: ["以为洛伦兹力做功（它永不做功）", "正负电荷方向判错", "v 平行 B 时仍认为有力"],
            applications: ["带电粒子圆周运动", "回旋加速器", "质谱仪"],
            relatedWeapons: [.crossProduct, .symmetry]
        ),
    ]

    static func laws(for topic: PhysicsTopic) -> [PhysicsLaw] {
        all.filter { $0.topic == topic }
    }
}
