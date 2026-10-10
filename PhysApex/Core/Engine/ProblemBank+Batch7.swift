import Foundation

// MARK: - 练习 Batch 7：机械振动与波 & 衰变（3 题，补齐训练地图最后 3 个节点）

extension ProblemBank {

    static let batch7: [PhysicsProblem] = [
        b7_pendulum, b7_waveMedium, b7_halfLife,
    ]

    static let b7_pendulum = PhysicsProblem(
        id: "b7_pendulum", type: .calculation, stage: .senior, topic: .wave,
        content: "某单摆摆长 L = 1 m，当地重力加速度 g 取 π² m/s²。求该单摆做小角度摆动的周期；若摆长变为 4 m，周期变为多少？",
        answer: "T₁ = 2 s（秒摆）；摆长 4 倍，周期 2 倍，T₂ = 4 s",
        difficulty: 0.5, averageTime: 100,
        hints: ["T = 2π√(L/g)", "周期与摆长的平方根成正比"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "单摆周期公式", formula: "T = 2π√(L/g)", annotation: "仅小角度（<5°）近似成立"),
            SolutionStep(order: 2, description: "代入 L=1 m、g=π²", formula: "T₁ = 2π√(1/π²) = 2 s", annotation: "周期恰为 2 s，称「秒摆」"),
            SolutionStep(order: 3, description: "摆长变 4 倍", formula: "T ∝ √L ⇒ T₂ = 2T₁ = 4 s", annotation: ""),
        ], keyInsight: "单摆周期只由摆长和 g 决定，与质量、振幅（小角度内）无关。",
           commonMistakes: ["以为摆球越重周期越短", "以为振幅越大周期越长"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "背公式代入计算", formula: "T=2π√(L/g)=2π√(1/π²)=2 s", annotation: "忘了公式就束手无策"),
                SolutionStep(order: 2, description: "重新代一遍 L=4", formula: "T=2π√(4/π²)=4 s", annotation: ""),
            ], keyInsight: "记公式、代数值。", commonMistakes: ["根号里 L/g 记成 g/L"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "量纲分析：周期只能由 L、g 凑出时间", formula: "[L]=m，[g]=m/s² ⟹ √(L/g) 是唯一的时间组合", annotation: "质量 m 根本凑不进去"),
                SolutionStep(order: 2, description: "形式即结论", formula: "T∝√(L/g) ⟹ L×4 则 T×2=4 s", annotation: "公式忘了也能秒答"),
            ], keyInsight: "量纲分析白送公式的形式：能凑出目标量纲的组合往往唯一——系数 2π 才需要动力学。", commonMistakes: []),
            weaponUsed: .dimensionalAnalysis, timeRatio: 3.5,
            detailedExplanation: "量纲分析通杀「忘公式」时刻：单摆 √(L/g)、弹簧 √(m/k) 的形式都能凑出来。注意它只定形式不定系数，2π 必须由动力学推导给出。",
            plainTalk: "忘了单摆公式？现场拼一个：周期的单位是「秒」，手里只有摆长 L（米）和 g（米/秒²）——能拼出「秒」的组合只有 √(L/g) 这一种！所以周期必然正比于 √(L/g)：摆长变 4 倍，周期变 2 倍。前面的 2π 要正经推导，但考场上比例关系已经够用。"),
        tags: ["振动与波", "简谐运动", "单摆", "降维"])

    static let b7_waveMedium = PhysicsProblem(
        id: "b7_wave_medium", type: .multipleChoice, stage: .senior, topic: .wave,
        content: "关于机械波的传播，下列说法正确的是？",
        options: ["波传播时，介质中的质点随波一起向前迁移",
                  "波的频率由波源决定，进入另一种介质后频率不变",
                  "波速由波的频率决定，频率越高传得越快",
                  "横波中质点的振动方向与波的传播方向相同"],
        answer: "波的频率由波源决定，进入另一种介质后频率不变",
        difficulty: 0.5, averageTime: 70,
        hints: ["波传的是「振动形式」和能量，不是质点本身", "v=λf 中，v 由介质定、f 由波源定"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "质点不迁移", formula: "质点只在平衡位置附近振动", annotation: "波传递的是振动形式与能量"),
            SolutionStep(order: 2, description: "三个量谁决定", formula: "f 由波源定；v 由介质定；λ = v/f 随之改变", annotation: "换介质：f 不变，v、λ 变"),
        ], keyInsight: "v=λf：频率认波源，波速认介质，波长是两者的商。",
           commonMistakes: ["以为质点随波跑", "以为频率越高波速越大"]),
        misconceptions: [
            Misconception(option: "波传播时，介质中的质点随波一起向前迁移",
                youThought: "你大概觉得波浪把水「推」着往前走。",
                pitfall: "漂在水面的树叶只上下起伏并不前进——质点只在平衡位置附近振动。",
                fix: "波传递的是振动形式和能量，介质质点不随波迁移。")
        ], tags: ["振动与波", "机械波", "错因诊断"])

    static let b7_halfLife = PhysicsProblem(
        id: "b7_half_life", type: .multipleChoice, stage: .senior, topic: .modern,
        content: "某放射性元素的半衰期为 5 天。关于半衰期，下列说法正确的是？",
        options: ["任取 4 个该原子核，5 天后必定剩下 2 个",
                  "升高温度或增大压强可以缩短半衰期",
                  "半衰期是统计规律，只对大量原子核才成立",
                  "经过 10 天，该元素的原子核将全部衰变完"],
        answer: "半衰期是统计规律，只对大量原子核才成立",
        difficulty: 0.5, averageTime: 70,
        hints: ["半衰期由核本身决定", "两个半衰期后剩 1/4，不是 0"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "统计规律", formula: "N = N₀(1/2)^(t/T)", annotation: "对个别核谈「何时衰变」没有意义"),
            SolutionStep(order: 2, description: "10 天 = 2 个半衰期", formula: "剩 N₀×(1/2)² = N₀/4", annotation: "不是衰变完"),
        ], keyInsight: "半衰期由原子核本身决定，温度、压强、化学状态都改变不了它。",
           commonMistakes: ["对少数几个核套用半衰期", "以为 2 个半衰期后全部衰变完"]),
        misconceptions: [
            Misconception(option: "升高温度或增大压强可以缩短半衰期",
                youThought: "你大概觉得加热能让一切过程变快。",
                pitfall: "衰变发生在原子核内部，温度压强只影响核外电子和分子运动，碰不到核。",
                fix: "半衰期由核本身决定，物理化学条件都无法改变。")
        ], tags: ["近代物理", "衰变", "半衰期", "错因诊断"])
}
