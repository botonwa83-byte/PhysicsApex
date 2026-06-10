import Foundation

// MARK: - 三级重访（PhysicsApex 物理专属创新）
// 一个物理情境，初中/高中/竞赛三个镜头切换——亲眼看解题工具如何一级级「升维」。
// 数学没有这种「同一现象、不同维度工具」的天然层次；这是物理段位体系的独家玩法。

struct RevisitLens: Identifiable {
    var id: String { stage.rawValue }
    let stage: Stage
    let question: String     // 这个段位问什么
    let approach: String     // 用什么方法 / 武器
    let result: String       // 得到什么
    let insight: String      // 一句话顿悟
    let weapon: PhysicsWeapon?
}

struct TripleRevisit: Identifiable {
    let id: String
    let scenario: String     // 共同情境（一句话）
    let emoji: String
    let lenses: [RevisitLens] // 3 个，按段位升序

    func lens(for stage: Stage) -> RevisitLens? {
        lenses.first { $0.stage == stage }
    }
}

enum RevisitData {
    static let all: [TripleRevisit] = [
        TripleRevisit(
            id: "incline",
            scenario: "一个木块放在斜面上，倾角可以改变。",
            emoji: "📐",
            lenses: [
                RevisitLens(
                    stage: .junior,
                    question: "倾角变大，木块会不会滑下来？",
                    approach: "把重力分成「沿斜面」和「压斜面」两份，比较下滑力与摩擦力谁大。",
                    result: "存在一个临界角，超过就下滑。",
                    insight: "下滑力随角增大、摩擦力随角减小，必然有个临界点。",
                    weapon: .forceDiagram
                ),
                RevisitLens(
                    stage: .senior,
                    question: "给定倾角和摩擦因数，求下滑加速度与到底端的速度。",
                    approach: "牛顿第二定律求合力得 a = g(sinθ − μcosθ)，再用 v²=2aL。",
                    result: "a = 4 m/s²，v ≈ 6.3 m/s（典型数值）。",
                    insight: "牛顿定律 → 加速度 → 运动学，标准两步走。",
                    weapon: .workEnergyTheorem
                ),
                RevisitLens(
                    stage: .olympiad,
                    question: "斜面也能自由滑动（在光滑地面上），木块和斜面如何一起运动？",
                    approach: "对「木块+斜面」系统用动量守恒(水平方向)，配合能量守恒，免去逐个受力。",
                    result: "几步给出两者速度关系，无需联立一堆方程。",
                    insight: "把两个物体看成一个系统，守恒律直接跳过复杂的相互作用力。",
                    weapon: .momentumConservation
                ),
            ]
        ),
        TripleRevisit(
            id: "projectile",
            scenario: "从高处水平抛出一个小球。",
            emoji: "🎯",
            lenses: [
                RevisitLens(
                    stage: .junior,
                    question: "抛得快的球会先落地吗？",
                    approach: "竖直方向都是自由落体，水平快慢不影响下落时间。",
                    result: "同时落地，快的落得远。",
                    insight: "平抛 = 水平匀速 + 竖直自由落体，两方向互不干扰。",
                    weapon: .graphMethod
                ),
                RevisitLens(
                    stage: .senior,
                    question: "求落地时间、射程和落地速度方向。",
                    approach: "分方向列式：t=√(2h/g)，x=v₀t，tanα=gt/v₀。",
                    result: "时间只由高度定，速度方向由两分量合成。",
                    insight: "运动分解是平抛的万能钥匙。",
                    weapon: .graphMethod
                ),
                RevisitLens(
                    stage: .olympiad,
                    question: "斜面上的平抛，落点离斜面最远处在哪？",
                    approach: "沿斜面/垂直斜面建系，用对称性或极值一眼定最远点。",
                    result: "免去对时间求导，几何直接给出。",
                    insight: "换一个「贴合问题」的坐标系，难题瞬间退化。",
                    weapon: .symmetry
                ),
            ]
        ),
    ]
}
