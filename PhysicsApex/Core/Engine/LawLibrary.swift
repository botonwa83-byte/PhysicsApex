import Foundation

// MARK: - 定律宇宙 数据（少而精，每条都是「通透卡」）

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
            physicalImage: "力不是「维持」运动的，而是「改变」运动的——踢一脚球，球变速；不踢，它就匀速跑下去。",
            derivation: "由动量定义 p=mv 与「力是动量的变化率」F=Δp/Δt 出发，质量不变时就化简成 F=ma。它和动量定理本是同一句话。",
            meaning: "合外力决定加速度。力的方向就是加速度的方向，跟速度方向无关。",
            limitChecks: [
                LimitCheck(scenario: "合力 F → 0", result: "a → 0，速度保持不变", intuition: "不受力就匀速或静止——这正是牛顿第一定律。原来一、二定律是一家人。"),
                LimitCheck(scenario: "质量 m → 很大", result: "同样的力，a → 很小", intuition: "推汽车几乎推不动：质量就是「惰性」的度量，越大越难改变运动。"),
            ],
            conditions: ["惯性参考系", "宏观低速（远小于光速）", "质量恒定"],
            commonMisuses: ["把「有力」当成「有速度」——其实力对应的是加速度", "在非惯性系直接用（需补惯性力）"],
            applications: ["连接体问题", "斜面 / 传送带", "牛顿定律 + 圆周运动"],
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
            physicalImage: "一群人在光滑冰面上推来推去，不管怎么折腾，整体的「总动量账本」纹丝不动。",
            derivation: "来自牛顿第三定律：内力总是成对出现、等大反向，彼此抵消，所以系统总动量不会被内力改变。",
            meaning: "系统合外力为零时，总动量守恒——碰撞 / 爆炸题的上帝视角，无视中间过程多复杂。",
            limitChecks: [
                LimitCheck(scenario: "等质量弹性正碰", result: "两球交换速度", intuition: "台球母球撞上静止球，自己停下、把速度「传」过去——守恒律的经典画面。"),
                LimitCheck(scenario: "撞墙：墙的质量 M → ∞", result: "小球原速反弹，墙几乎不动", intuition: "墙改变不了自己的速度，只把小球弹回去——极端质量比下的直觉。"),
            ],
            conditions: ["系统所受合外力为零", "或：碰撞 / 爆炸瞬间内力远大于外力", "矢量式，注意方向与正负"],
            commonMisuses: ["把动量守恒误当动能守恒（非弹性碰撞动能会损失）", "只在某一方向守恒时当成整体守恒"],
            applications: ["碰撞", "反冲 / 爆炸", "人船模型"],
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
            physicalImage: "过山车——爬高时把动能「存」成势能，俯冲时再「取」回来，总账始终不变（没摩擦的话）。",
            derivation: "重力做的功 = 动能的增量（动能定理），而重力做功又等于势能的减少，两者一搭，机械能总量就守恒。",
            meaning: "只有重力 / 弹力做功时，动能与势能相互转化、总量不变。",
            limitChecks: [
                LimitCheck(scenario: "从高 h 自由下落到底", result: "v = √(2gh)，与质量无关", intuition: "真空中羽毛和铁球同速落地——mgh = ½mv² 两边的 m 约掉了。"),
                LimitCheck(scenario: "单摆摆到最低点", result: "速度最大、势能最低", intuition: "能量在两种形式间倒来倒去，此消彼长，最低点动能全满。"),
            ],
            conditions: ["只有重力和弹力做功", "其他力不做功", "系统无摩擦生热"],
            commonMisuses: ["有摩擦 / 空气阻力时仍套守恒", "势能零点选取前后不一致"],
            applications: ["竖直圆周 / 单摆", "弹簧问题", "过山车类问题"],
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
            physicalImage: "合力做的功，像往「动能账户」里存钱或取钱——余额的变化就是末动能减初动能。",
            derivation: "把 F=ma 沿位移累加（积分）：∫F dx = ∫ma dx = ½mv² 的变化。它是牛顿定律的「能量版」。",
            meaning: "合外力做的功等于动能的变化——不管路径多曲折、力是否变化，只看功的总和。",
            limitChecks: [
                LimitCheck(scenario: "合力做功 = 0", result: "动能不变，速率不变", intuition: "匀速圆周运动里向心力永远垂直速度、不做功，所以速率恒定。"),
                LimitCheck(scenario: "只有摩擦力做负功", result: "动能持续减少直到停下", intuition: "滑行的物体终会停——动能被摩擦「吃掉」变成了热。"),
            ],
            conditions: ["适用于任何力（含变力、摩擦力）", "标量式，功有正负"],
            commonMisuses: ["漏掉摩擦力做的负功", "把「路程」当「位移」算功"],
            applications: ["变力做功", "曲线运动求末速度", "多过程问题一步跨越"],
            relatedWeapons: [.workEnergyTheorem, .energyIntuition]
        ),
        PhysicsLaw(
            id: "lorentz",
            name: "洛伦兹力",
            nameEN: "Lorentz Force",
            topic: .magnetic,
            stage: .senior,
            expression: "F = qvB·sinθ",
            dimension: "N（B 的单位 T = kg/(A·s²)）",
            physicalImage: "磁场像个「拐弯器」——它只改变带电粒子的方向，从不给它提速。",
            derivation: "实验定律 F = qv×B。因为力永远垂直于速度，它在速度方向上的分量为零，所以改变方向却不改变速率。",
            meaning: "磁场对运动电荷的作用力，方向由左手 / 右手定则判定，恒垂直于速度。",
            limitChecks: [
                LimitCheck(scenario: "速度 v 平行于磁场 B", result: "F = 0，粒子直线穿过", intuition: "顺着磁场跑不拐弯——sinθ = 0，磁场对它「视而不见」。"),
                LimitCheck(scenario: "速度 v 垂直于 B", result: "做匀速圆周，半径 r = mv/qB", intuition: "恒垂直的力正好当向心力，画出一个完美的圆。"),
            ],
            conditions: ["电荷在磁场中运动", "θ 为 v 与 B 的夹角"],
            commonMisuses: ["以为洛伦兹力会做功（它永远不做功）", "v 平行 B 时仍以为有力"],
            applications: ["带电粒子圆周运动", "回旋加速器", "质谱仪"],
            relatedWeapons: [.crossProduct, .symmetry]
        ),
    ]

    static func laws(for topic: PhysicsTopic) -> [PhysicsLaw] {
        all.filter { $0.topic == topic }
    }
}
