import Foundation

// MARK: - 题库 Batch 5：磁场 & 电磁感应 & 交流（14 题）

extension ProblemBank {

    static let batch5: [PhysicsProblem] = [
        b5_ampereForce, b5_lorentzRadius, b5_lorentzNoWork, b5_cyclotronPeriod, b5_handRule,
        b5_faradayEMF, b5_cuttingEMF, b5_lenzDir, b5_inducedForce, b5_fluxChange,
        b5_rmsValue, b5_transformer, b5_acFeature, b5_powerTransmission,
    ]

    static let b5_ampereForce = PhysicsProblem(
        id: "b5_ampere_force", type: .calculation, stage: .senior, topic: .magnetic,
        content: "一根长 0.2 m 的直导线通有 3 A 电流，垂直放在磁感应强度 B=0.5 T 的匀强磁场中。求导线受的安培力。",
        answer: "F = 0.3 N", difficulty: 0.4, averageTime: 70, hints: ["F=BIL（垂直时）"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "安培力", formula: "F = BIL = 0.5×3×0.2 = 0.3 N", annotation: ""),
        ], keyInsight: "F=BIL（电流垂直磁场时）。", commonMistakes: ["与洛伦兹力公式混"]),
        tags: ["磁场", "安培力"])

    static let b5_lorentzRadius = PhysicsProblem(
        id: "b5_lorentz_r", type: .calculation, stage: .senior, topic: .magnetic,
        content: "质量 m、电荷 q 的粒子以速度 v 垂直射入磁感应强度 B 的匀强磁场。求它做圆周运动的半径。",
        answer: "r = mv/(qB)", difficulty: 0.45, averageTime: 90,
        hints: ["洛伦兹力提供向心力", "qvB=mv²/r"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "向心力", formula: "qvB = mv²/r", annotation: ""),
            SolutionStep(order: 2, description: "半径", formula: "r = mv/(qB)", annotation: ""),
        ], keyInsight: "洛伦兹力当向心力，r=mv/qB。", commonMistakes: ["半径公式记错"]),
        tags: ["磁场", "洛伦兹力"])

    static let b5_lorentzNoWork = PhysicsProblem(
        id: "b5_lorentz_nowork", type: .multipleChoice, stage: .senior, topic: .magnetic,
        content: "带电粒子在匀强磁场中只受洛伦兹力运动。关于它的速率和动能，下列正确的是？",
        options: ["速率增大", "动能增大", "速率和动能都不变", "动能减小"],
        answer: "速率和动能都不变",
        difficulty: 0.45, averageTime: 55, hints: ["洛伦兹力永远垂直速度"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "做功", formula: "F⊥v → 不做功", annotation: ""),
            SolutionStep(order: 2, description: "结论", formula: "速率、动能不变，只改变方向", annotation: ""),
        ], keyInsight: "洛伦兹力永不做功，只改方向不改速率。",
           commonMistakes: ["以为洛伦兹力让粒子加速"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "逐时刻分析受力与速度的几何关系", formula: "每一瞬间 F⊥v ⟹ W=Fscosθ 中 cos90°=0", annotation: "要在脑中追踪整条曲线"),
            ], keyInsight: "逐点几何分析做功。", commonMistakes: ["误以为转圈就是在加速"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "看公式结构：叉乘天生垂直", formula: "F = qv×B ⟹ F⊥v 恒成立", annotation: "数学结构保证，无需逐点验证"),
                SolutionStep(order: 2, description: "垂直 ⟹ 瞬时功率恒为零", formula: "P = F·v = 0 ⟹ 速率、动能永不变", annotation: "秒选"),
            ], keyInsight: "叉乘的结果天生垂直于两个乘数——洛伦兹力不做功是数学结构决定的，不是巧合。", commonMistakes: []),
            weaponUsed: .crossProduct, timeRatio: 3.0,
            detailedExplanation: "矢量叉乘视角通杀磁场力问题：F=qv×B 的结构保证磁场只能让粒子拐弯、永远无法加减速。"),
        misconceptions: [
            Misconception(option: "速率增大",
                youThought: "你大概觉得受了力就会加速。",
                pitfall: "洛伦兹力永远垂直于速度，不做功，所以速率不变。",
                fix: "它只当「拐弯器」，改变方向、不改变速率和动能。")
        ], tags: ["磁场", "洛伦兹力", "错因诊断", "降维"])

    static let b5_cyclotronPeriod = PhysicsProblem(
        id: "b5_cyclotron_t", type: .calculation, stage: .senior, topic: .magnetic,
        content: "带电粒子在匀强磁场中做匀速圆周运动。请写出它的周期表达式，并说明周期是否与速率有关。",
        answer: "T = 2πm/(qB)，与速率无关", difficulty: 0.5, averageTime: 100,
        hints: ["T=2πr/v，代入 r=mv/qB"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "代入", formula: "T = 2πr/v = 2π(mv/qB)/v", annotation: ""),
            SolutionStep(order: 2, description: "化简", formula: "T = 2πm/(qB)", annotation: "不含 v"),
        ], keyInsight: "回旋周期 T=2πm/qB，与速率、半径都无关。",
           commonMistakes: ["以为速率大周期短"]),
        tags: ["磁场", "回旋周期"])

    static let b5_handRule = PhysicsProblem(
        id: "b5_hand_rule", type: .multipleChoice, stage: .senior, topic: .magnetic,
        content: "判断通电导线在磁场中受安培力的方向，应使用？",
        options: ["右手定则", "左手定则", "右手螺旋定则", "楞次定律"],
        answer: "左手定则",
        difficulty: 0.35, averageTime: 40, hints: ["安培力/洛伦兹力用左手；感应电动势用右手"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "定则", formula: "左手：磁场穿掌、四指指电流、拇指指力", annotation: ""),
        ], keyInsight: "受力用左手；切割发电用右手；判感应电流方向用楞次定律。",
           commonMistakes: ["左右手定则混用"]),
        tags: ["磁场", "左手定则"])

    static let b5_faradayEMF = PhysicsProblem(
        id: "b5_faraday_emf", type: .calculation, stage: .senior, topic: .induction,
        content: "一个 100 匝的线圈，穿过它的磁通量在 0.2 s 内从 0.01 Wb 均匀变到 0.05 Wb。求感应电动势。",
        answer: "E = 20 V", difficulty: 0.45, averageTime: 90, hints: ["E=nΔΦ/Δt"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "法拉第定律", formula: "E = nΔΦ/Δt = 100×0.04/0.2 = 20 V", annotation: ""),
        ], keyInsight: "E=nΔΦ/Δt，看的是变化率。", commonMistakes: ["漏匝数 n"]),
        tags: ["电磁感应", "法拉第定律"])

    static let b5_cuttingEMF = PhysicsProblem(
        id: "b5_cutting_emf", type: .calculation, stage: .senior, topic: .induction,
        content: "长 0.5 m 的导体棒以 4 m/s 的速度垂直切割磁感应强度 B=0.4 T 的磁感线，棒和导轨组成回路总电阻 2 Ω。求感应电流。",
        answer: "I = 0.4 A", difficulty: 0.5, averageTime: 100,
        hints: ["E=BLv", "I=E/R"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电动势", formula: "E = BLv = 0.4×0.5×4 = 0.8 V", annotation: ""),
            SolutionStep(order: 2, description: "电流", formula: "I = E/R = 0.8/2 = 0.4 A", annotation: ""),
        ], keyInsight: "切割：E=BLv，再用欧姆定律。", commonMistakes: ["BLv 漏量"]),
        tags: ["电磁感应", "切割"])

    static let b5_lenzDir = PhysicsProblem(
        id: "b5_lenz_dir", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "条形磁铁的 N 极插向闭合线圈，关于感应电流的效果，下列正确的是？",
        options: ["感应电流帮助磁铁插入", "感应电流的磁场阻碍磁铁靠近（同名相斥）",
                  "感应电流方向与磁铁无关", "线圈被磁铁吸引"],
        answer: "感应电流的磁场阻碍磁铁靠近（同名相斥）",
        difficulty: 0.5, averageTime: 60, hints: ["楞次定律：阻碍磁通量的变化"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "楞次定律", formula: "感应电流阻碍磁通量增大", annotation: "线圈近端呈 N 极相斥"),
        ], keyInsight: "楞次定律：感应电流总是阻碍磁通量的「变化」——来拒去留。",
           commonMistakes: ["把「阻碍变化」误成「阻碍运动本身」"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "完整推导：判磁通变化 → 定感应磁场方向 → 右手定则定电流 → 再判相互作用", formula: "Φ↑ ⟹ B感反向 ⟹ 电流方向 ⟹ 近端 N 极", annotation: "四步链条，每步都可能绕错"),
            ], keyInsight: "按定义逐步推感应电流方向。", commonMistakes: ["感应磁场方向定反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "口诀直接裁决效果", formula: "「来拒去留」：N 极来 ⟹ 线圈拒之（排斥）", annotation: "秒选"),
            ], keyInsight: "楞次定律的宏观效果可以一词记牢：来拒去留、增缩减扩——选项问「效果」时无需推电流方向。", commonMistakes: []),
            weaponUsed: .lenzRule, timeRatio: 3.0,
            detailedExplanation: "楞次定则速判通杀「只问效果」的感应题：阻碍相对运动（来拒去留）、阻碍磁通变化（增反减同），口诀即答案。"),
        misconceptions: [
            Misconception(option: "感应电流帮助磁铁插入",
                youThought: "你大概觉得感应电流会顺着磁铁的运动。",
                pitfall: "楞次定律说感应电流总要「阻碍」磁通量变化——插入时排斥、拔出时吸引。",
                fix: "记口诀「来拒去留」：靠近就排斥、离开就挽留。")
        ], tags: ["电磁感应", "楞次定律", "错因诊断", "降维"])

    static let b5_inducedForce = PhysicsProblem(
        id: "b5_induced_force", type: .calculation, stage: .senior, topic: .induction,
        content: "上题的切割导体棒（E=0.8 V，I=0.4 A，B=0.4 T，L=0.5 m），求维持它匀速运动所需的外力。",
        answer: "F = 0.08 N", difficulty: 0.55, averageTime: 110,
        hints: ["匀速 → 外力=安培力", "F=BIL"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "安培力", formula: "F安 = BIL = 0.4×0.4×0.5 = 0.08 N", annotation: "阻碍运动"),
            SolutionStep(order: 2, description: "匀速", formula: "外力 = 安培力 = 0.08 N", annotation: ""),
        ], keyInsight: "匀速切割：外力恰好克服感应电流的安培力。",
           commonMistakes: ["方向或匀速条件忽略"]),
        tags: ["电磁感应", "安培力"])

    static let b5_fluxChange = PhysicsProblem(
        id: "b5_flux_change", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "线圈中产生感应电动势的根本原因是？",
        options: ["线圈中有磁通量", "穿过线圈的磁通量发生变化", "磁场很强", "线圈匝数很多"],
        answer: "穿过线圈的磁通量发生变化",
        difficulty: 0.4, averageTime: 50, hints: ["有电动势的是「变化」"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "本质", formula: "E ∝ ΔΦ/Δt", annotation: "Φ 不变则 E=0"),
        ], keyInsight: "是磁通量的「变化」生电，不是磁通量本身。",
           commonMistakes: ["以为有磁通量就有电动势"]),
        misconceptions: [
            Misconception(option: "线圈中有磁通量",
                youThought: "你大概觉得只要穿过磁场就会发电。",
                pitfall: "磁铁静止在线圈里，磁通量很大却不来电——必须「变化」才行。",
                fix: "记住 E=nΔΦ/Δt，关键是 Δ。")
        ], tags: ["电磁感应", "磁通量", "错因诊断"])

    static let b5_rmsValue = PhysicsProblem(
        id: "b5_rms", type: .calculation, stage: .senior, topic: .induction,
        content: "正弦交流电的电压峰值为 311 V。求它的有效值。(√2≈1.41)",
        answer: "U有效 ≈ 220 V", difficulty: 0.4, averageTime: 60, hints: ["U有效=U峰/√2"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "有效值", formula: "U = U峰/√2 = 311/1.41 ≈ 220 V", annotation: "家用电正是 220 V"),
        ], keyInsight: "正弦交流有效值 = 峰值/√2。", commonMistakes: ["峰值有效值搞反"]),
        tags: ["交变电流", "有效值"])

    static let b5_transformer = PhysicsProblem(
        id: "b5_transformer", type: .calculation, stage: .senior, topic: .induction,
        content: "理想变压器原线圈 1100 匝接 220 V 交流电，副线圈 100 匝。求副线圈输出电压。",
        answer: "U₂ = 20 V", difficulty: 0.45, averageTime: 80, hints: ["U₁/U₂=n₁/n₂"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电压比", formula: "U₂ = U₁·n₂/n₁ = 220×100/1100 = 20 V", annotation: ""),
        ], keyInsight: "理想变压器电压比等于匝数比。", commonMistakes: ["匝数比倒过来"]),
        tags: ["交变电流", "变压器"])

    static let b5_acFeature = PhysicsProblem(
        id: "b5_ac_feature", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "关于交流电的有效值，下列说法正确的是？",
        options: ["有效值就是峰值", "有效值按电流的热效应定义",
                  "有效值就是平均值", "有效值没有实际意义"],
        answer: "有效值按电流的热效应定义",
        difficulty: 0.45, averageTime: 55, hints: ["有效值=产生相同热量的等效直流"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "定义", formula: "同电阻、同时间产生相同热量的直流值", annotation: ""),
        ], keyInsight: "有效值是按「热效应等效」定义的，不是峰值也不是平均值。",
           commonMistakes: ["把有效值当平均值"]),
        misconceptions: [
            Misconception(option: "有效值就是平均值",
                youThought: "你大概觉得有效值是一个周期内的平均。",
                pitfall: "正弦交流一个周期电流平均值为零；有效值是按发热等效定义的（峰值/√2）。",
                fix: "有效值看热效应，不是算术平均。")
        ], tags: ["交变电流", "有效值", "错因诊断"])

    static let b5_powerTransmission = PhysicsProblem(
        id: "b5_power_trans", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "远距离输电时采用高压输电的主要原因是？",
        options: ["高压更安全", "在输送功率一定时，提高电压可减小线路电流，从而减少线路损耗",
                  "高压电传得更快", "高压可以增大输送的功率"],
        answer: "在输送功率一定时，提高电压可减小线路电流，从而减少线路损耗",
        difficulty: 0.5, averageTime: 60, hints: ["P=UI，线损=I²R线"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电流", formula: "P 一定，U↑ → I↓", annotation: ""),
            SolutionStep(order: 2, description: "线损", formula: "P损=I²R线，I↓ → 损耗↓", annotation: ""),
        ], keyInsight: "高压输电减小电流，从而大幅降低 I²R 的线路损耗。",
           commonMistakes: ["以为高压增大了输送功率"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "分步定性分析", formula: "P=UI 一定 ⟹ U↑ 则 I↓；再看 P损=I²R线 ⟹ 损耗↓", annotation: "两步定性，说不出降多少"),
            ], keyInsight: "定性两步推导。", commonMistakes: ["误以为 P损=U²/R 用输电电压"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "一条比例式看穿本质", formula: "P损 = I²R = (P/U)²R ∝ 1/U²", annotation: "电压 10 倍，损耗 1/100"),
            ], keyInsight: "把损耗写成输送电压的幂次，平方反比一目了然——这就是高压输电的全部秘密。", commonMistakes: []),
            weaponUsed: .proportion, timeRatio: 2.5,
            detailedExplanation: "比例法把「为什么用高压」从定性叙述升级为定量结论：P损∝1/U²（输送功率与线阻一定时），既快又能算数值。"),
        tags: ["交变电流", "远距离输电", "降维"])
}
