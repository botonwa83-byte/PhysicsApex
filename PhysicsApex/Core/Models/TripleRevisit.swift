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
        TripleRevisit(
            id: "collision",
            scenario: "两个小球在光滑水平面上相撞。",
            emoji: "🎱",
            lenses: [
                RevisitLens(
                    stage: .junior,
                    question: "动的球撞上静止的球，会怎样？",
                    approach: "凭直觉：撞上去会把对方推动，自己慢下来，「运动」传了过去。",
                    result: "速度发生转移。",
                    insight: "碰撞的本质是「运动」在物体间转移。",
                    weapon: .energyIntuition
                ),
                RevisitLens(
                    stage: .senior,
                    question: "求碰后两球的速度。",
                    approach: "动量守恒；若是弹性碰撞再加动能守恒，联立求解。",
                    result: "等质量弹性正碰 → 交换速度。",
                    insight: "动量守恒是碰撞的铁律，不管中间多复杂。",
                    weapon: .momentumConservation
                ),
                RevisitLens(
                    stage: .olympiad,
                    question: "为什么等质量弹性碰撞总是「交换速度」？",
                    approach: "换到质心参考系：碰撞只是把两球速度同时反向，再变换回地面系。",
                    result: "质心系下碰撞高度对称，结论一眼可见。",
                    insight: "换个参考系，碰撞瞬间变得对称又简单。",
                    weapon: .referenceFrame
                ),
            ]
        ),
        TripleRevisit(
            id: "orbit",
            scenario: "卫星绕地球做圆周运动。",
            emoji: "🛰️",
            lenses: [
                RevisitLens(
                    stage: .junior,
                    question: "卫星为什么不掉下来？",
                    approach: "它其实一直在「掉」，但横向飞得够快，地面在它下方不断弯走，于是绕着地球转。",
                    result: "边掉边飞，正好绕圈。",
                    insight: "卫星一直在自由落体，只是永远「追不上」弯曲的地面。",
                    weapon: .forceDiagram
                ),
                RevisitLens(
                    stage: .senior,
                    question: "求卫星的环绕速度。",
                    approach: "万有引力提供向心力：GMm/r² = mv²/r。",
                    result: "v = √(GM/r)；近地用黄金代换得 √(gR)。",
                    insight: "引力 = 向心力，一个方程通吃天体圆周。",
                    weapon: .equivalentMethod
                ),
                RevisitLens(
                    stage: .olympiad,
                    question: "椭圆轨道上，卫星在近地点为何更快？",
                    approach: "角动量守恒（开普勒第二定律）：mvr 在近地点 r 小、v 必大。",
                    result: "近地快、远地慢，扫过面积速率恒定。",
                    insight: "守恒量（角动量）让椭圆轨道也尽在掌握。",
                    weapon: .symmetry
                ),
            ]
        ),
        TripleRevisit(
            id: "induction",
            scenario: "一根导体棒在磁场中沿导轨滑动。",
            emoji: "🧲",
            lenses: [
                RevisitLens(
                    stage: .junior,
                    question: "棒动起来会发生什么？",
                    approach: "棒切割磁感线，回路里就有了电——这就是「发电」。",
                    result: "产生感应电流。",
                    insight: "运动 + 磁场 = 电，发电机的全部秘密。",
                    weapon: .energyIntuition
                ),
                RevisitLens(
                    stage: .senior,
                    question: "求感应电动势、电流和安培力。",
                    approach: "切割式 E=BLv → I=E/R → 安培力 F=BIL。",
                    result: "一条链子串起电与力。",
                    insight: "E=BLv 是抓手，楞次定则定方向（阻碍运动）。",
                    weapon: .lenzRule
                ),
                RevisitLens(
                    stage: .olympiad,
                    question: "棒最终能达到多大速度？",
                    approach: "终态平衡法：加速度为零时安培力 = 驱动力，一步解出，绕开微分方程。",
                    result: "v_max 一个方程拿下。",
                    insight: "只问「最终稳定在哪」，跳过整个动态过程。",
                    weapon: .equivalentMethod
                ),
            ]
        ),
    ]
}
