import Foundation

// MARK: - 题库 Batch 4：电场 & 电路（15 题）

extension ProblemBank {

    static let batch4: [PhysicsProblem] = [
        b4_coulomb, b4_pointField, b4_fieldLine, b4_chargeAccel, b4_potential,
        b4_capacitorQ, b4_capacitorChange, b4_ohmBasic, b4_seriesParallel, b4_elecPower,
        b4_closedCircuit, b4_terminalVoltage, b4_resistivity, b4_seriesRule, b4_jouleHeat,
    ]

    static let b4_coulomb = PhysicsProblem(
        id: "b4_coulomb", type: .calculation, stage: .senior, topic: .electricField,
        content: "真空中两个点电荷 q₁=2×10⁻⁶ C、q₂=3×10⁻⁶ C 相距 r=0.3 m。求它们间的库仑力。(k=9×10⁹)",
        answer: "F = 0.6 N", difficulty: 0.45, averageTime: 90, hints: ["F=kq₁q₂/r²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "库仑定律", formula: "F = 9×10⁹×2×10⁻⁶×3×10⁻⁶/0.09 = 0.6 N", annotation: ""),
        ], keyInsight: "库仑定律：力与电量乘积成正比、距离平方成反比。", commonMistakes: ["r 没平方"]),
        tags: ["电场", "库仑定律"])

    static let b4_pointField = PhysicsProblem(
        id: "b4_point_field", type: .calculation, stage: .senior, topic: .electricField,
        content: "点电荷 Q=4×10⁻⁸ C 在距它 0.2 m 处产生的电场强度多大？(k=9×10⁹)",
        answer: "E = 9000 N/C", difficulty: 0.45, averageTime: 80, hints: ["E=kQ/r²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "场强", formula: "E = kQ/r² = 9×10⁹×4×10⁻⁸/0.04 = 9000 N/C", annotation: ""),
        ], keyInsight: "点电荷场强 E=kQ/r²，与检验电荷无关。", commonMistakes: ["和 F 公式混"]),
        tags: ["电场", "场强"])

    static let b4_fieldLine = PhysicsProblem(
        id: "b4_field_line", type: .multipleChoice, stage: .senior, topic: .electricField,
        content: "关于电场线，下列说法正确的是？",
        options: ["电场线是真实存在的线", "电场线越密的地方场强越大",
                  "电场线可以相交", "电场线方向就是负电荷受力方向"],
        answer: "电场线越密的地方场强越大",
        difficulty: 0.4, averageTime: 50, hints: ["电场线是描述工具", "切线方向=正电荷受力方向"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "疏密", formula: "密 → 场强大", annotation: ""),
            SolutionStep(order: 2, description: "方向", formula: "切线方向 = 正电荷受力方向", annotation: "不相交"),
        ], keyInsight: "电场线是假想的描述工具：疏密表强弱、切线表方向、不相交。",
           commonMistakes: ["以为电场线真实存在或能相交"]),
        misconceptions: [
            Misconception(option: "电场线方向就是负电荷受力方向",
                youThought: "你大概把电场线方向和电荷受力方向都记成一样。",
                pitfall: "电场线方向规定为正电荷受力方向；负电荷受力与电场线相反。",
                fix: "正电荷顺着电场线受力，负电荷逆着。")
        ], tags: ["电场", "电场线", "错因诊断"])

    static let b4_chargeAccel = PhysicsProblem(
        id: "b4_charge_accel", type: .calculation, stage: .senior, topic: .electricField,
        content: "电荷量 q=2×10⁻⁶ C、质量 m=1×10⁻⁵ kg 的带电粒子，从静止经过电压 U=100 V 加速。求它获得的速度。",
        answer: "v = 200 m/s", difficulty: 0.55, averageTime: 120,
        hints: ["电场力做功 qU 转化为动能", "qU=½mv²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "动能定理", formula: "qU = ½mv²", annotation: ""),
            SolutionStep(order: 2, description: "解出", formula: "v=√(2qU/m)=√(2×2e-6×100/1e-5)=200 m/s", annotation: ""),
        ], keyInsight: "加速电场：电场力做的功 qU 全变动能。", commonMistakes: ["qU 与 ½mv² 不对应"]),
        tags: ["电场", "加速电场"])

    static let b4_potential = PhysicsProblem(
        id: "b4_potential", type: .multipleChoice, stage: .senior, topic: .electricField,
        content: "正电荷沿电场线方向（从 A 到 B）移动，下列正确的是？",
        options: ["电势升高，电势能增大", "电势降低，电势能减小",
                  "电势降低，电势能增大", "电势能不变"],
        answer: "电势降低，电势能减小",
        difficulty: 0.55, averageTime: 60, hints: ["沿电场线电势降低", "正电荷在低电势处电势能低"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电势", formula: "沿电场线方向电势降低", annotation: "φA>φB"),
            SolutionStep(order: 2, description: "电势能", formula: "Ep=qφ，正电荷 φ↓ → Ep↓", annotation: "电场力做正功"),
        ], keyInsight: "沿电场线：电势降低；正电荷电势能随之减小。",
           commonMistakes: ["把电势和电势能方向关系记反"]),
        misconceptions: [
            Misconception(option: "电势升高，电势能增大",
                youThought: "你大概觉得「顺着电场走」是往高处走。",
                pitfall: "电场线指向电势降低的方向，正电荷顺着走是电势能减小、电场力做正功。",
                fix: "沿电场线 → 电势降低；正电荷 Ep=qφ 也减小。")
        ], tags: ["电场", "电势", "错因诊断"])

    static let b4_capacitorQ = PhysicsProblem(
        id: "b4_capacitor_q", type: .calculation, stage: .senior, topic: .electricField,
        content: "电容为 C=20 μF 的电容器，两端电压 U=50 V。求它储存的电荷量。",
        answer: "Q = 1×10⁻³ C", difficulty: 0.4, averageTime: 70, hints: ["Q=CU"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电荷量", formula: "Q = CU = 20×10⁻⁶×50 = 1×10⁻³ C", annotation: ""),
        ], keyInsight: "Q=CU。", commonMistakes: ["μF 单位没换算"]),
        tags: ["电场", "电容器"])

    static let b4_capacitorChange = PhysicsProblem(
        id: "b4_cap_change", type: .multipleChoice, stage: .senior, topic: .electricField,
        content: "平行板电容器始终与电源连接（电压不变），若增大两板间距，则板上电荷量？",
        options: ["增大", "减小", "不变", "无法确定"],
        answer: "减小",
        difficulty: 0.6, averageTime: 70, hints: ["U不变", "C=εS/(4πkd)，d↑则C↓，Q=CU"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电容", formula: "d↑ → C↓", annotation: "U 由电源保持不变"),
            SolutionStep(order: 2, description: "电荷", formula: "Q=CU，C↓ → Q↓", annotation: ""),
        ], keyInsight: "接电源 U 不变：抓 C 的变化再用 Q=CU。",
           commonMistakes: ["把「接电源」当成「断开后 Q 不变」"]),
        misconceptions: [
            Misconception(option: "不变",
                youThought: "你大概以为电荷量总是守恒不变。",
                pitfall: "只有「断开电源」后 Q 才不变；这里一直接着电源，U 不变、C 变、Q 随之变。",
                fix: "接电源抓 U 不变（Q=CU 随 C 变）；断电源抓 Q 不变（U=Q/C 随 C 变）。")
        ], tags: ["电场", "电容器动态", "错因诊断"])

    static let b4_ohmBasic = PhysicsProblem(
        id: "b4_ohm_basic", type: .calculation, stage: .senior, topic: .circuit,
        content: "一段电阻为 5 Ω 的导体，两端加 10 V 电压。求通过它的电流。",
        answer: "I = 2 A", difficulty: 0.3, averageTime: 50, hints: ["I=U/R"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "欧姆定律", formula: "I = U/R = 10/5 = 2 A", annotation: ""),
        ], keyInsight: "I=U/R。", commonMistakes: ["公式记反"]),
        tags: ["电路", "欧姆定律"])

    static let b4_seriesParallel = PhysicsProblem(
        id: "b4_series_parallel", type: .calculation, stage: .senior, topic: .circuit,
        content: "两个电阻 R₁=6 Ω 和 R₂=3 Ω。求它们串联和并联时的总电阻。",
        answer: "串联 9 Ω；并联 2 Ω", difficulty: 0.4, averageTime: 80,
        hints: ["串联相加", "并联倒数相加"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "串联", formula: "R = R₁+R₂ = 9 Ω", annotation: ""),
            SolutionStep(order: 2, description: "并联", formula: "1/R=1/6+1/3 ⟹ R=2 Ω", annotation: ""),
        ], keyInsight: "串联相加、并联倒数和。", commonMistakes: ["并联直接相加"]),
        tags: ["电路", "串并联"])

    static let b4_elecPower = PhysicsProblem(
        id: "b4_elec_power", type: .calculation, stage: .senior, topic: .circuit,
        content: "一个灯泡接在 220 V 电路中，通过它的电流为 0.5 A。求灯泡的功率。",
        answer: "P = 110 W", difficulty: 0.35, averageTime: 60, hints: ["P=UI"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电功率", formula: "P = UI = 220×0.5 = 110 W", annotation: ""),
        ], keyInsight: "P=UI。", commonMistakes: ["纯电阻才能用 P=I²R=U²/R"]),
        tags: ["电路", "电功率"])

    static let b4_closedCircuit = PhysicsProblem(
        id: "b4_closed_circuit", type: .calculation, stage: .senior, topic: .circuit,
        content: "电源电动势 E=6 V、内阻 r=0.5 Ω，外接 R=2.5 Ω 的电阻。求电路中的电流和路端电压。",
        answer: "I = 2 A；U端 = 5 V", difficulty: 0.5, averageTime: 110,
        hints: ["E=I(R+r)", "U端=IR 或 E−Ir"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "求电流", formula: "I = E/(R+r) = 6/3 = 2 A", annotation: ""),
            SolutionStep(order: 2, description: "路端电压", formula: "U = IR = 2×2.5 = 5 V", annotation: "= E−Ir"),
        ], keyInsight: "闭合电路欧姆定律 E=I(R+r)。", commonMistakes: ["忘了内阻"]),
        tags: ["电路", "闭合电路"])

    static let b4_terminalVoltage = PhysicsProblem(
        id: "b4_terminal_v", type: .multipleChoice, stage: .senior, topic: .circuit,
        content: "闭合电路中，当外电阻 R 增大时，路端电压如何变化？",
        options: ["增大", "减小", "不变", "先增后减"],
        answer: "增大",
        difficulty: 0.55, averageTime: 65, hints: ["U端=E−Ir，R↑则I↓"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电流", formula: "R↑ → I=E/(R+r)↓", annotation: ""),
            SolutionStep(order: 2, description: "路端电压", formula: "U=E−Ir，I↓ → U↑", annotation: ""),
        ], keyInsight: "外阻增大 → 电流减小 → 内阻分压减小 → 路端电压升高。",
           commonMistakes: ["以为外阻大电流大"]),
        misconceptions: [
            Misconception(option: "减小",
                youThought: "你大概觉得电阻大了，电压就被「拖」小了。",
                pitfall: "外阻增大使总电流减小，内阻 Ir 分压减小，路端电压 U=E−Ir 反而升高。",
                fix: "记住 U端=E−Ir：R↑→I↓→Ir↓→U↑。")
        ], tags: ["电路", "路端电压", "错因诊断"])

    static let b4_resistivity = PhysicsProblem(
        id: "b4_resistivity", type: .calculation, stage: .senior, topic: .circuit,
        content: "一根均匀导线电阻为 R。若把它均匀拉长为原来的 2 倍（体积不变），求拉长后的电阻。",
        answer: "4R", difficulty: 0.6, averageTime: 120,
        hints: ["R=ρL/S", "体积不变：L×2则S减半"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "长度变化", formula: "L→2L", annotation: ""),
            SolutionStep(order: 2, description: "体积不变截面变化", formula: "S→S/2", annotation: ""),
            SolutionStep(order: 3, description: "新电阻", formula: "R'=ρ(2L)/(S/2)=4ρL/S=4R", annotation: ""),
        ], keyInsight: "拉长导线：长度和截面同时变，电阻变 4 倍。",
           commonMistakes: ["只考虑长度变 2 倍"]),
        tags: ["电路", "电阻定律"])

    static let b4_seriesRule = PhysicsProblem(
        id: "b4_series_rule", type: .multipleChoice, stage: .junior, topic: .circuit,
        content: "关于串联电路，下列说法正确的是？",
        options: ["各处电流相等", "各电阻两端电压相等", "总电阻小于任一分电阻", "电流分流"],
        answer: "各处电流相等",
        difficulty: 0.3, averageTime: 45, hints: ["串联是一条路，电流处处相等"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "串联特征", formula: "I 处处相等，U 分压，R 相加", annotation: ""),
        ], keyInsight: "串联电流相等、电压分配；并联电压相等、电流分配。",
           commonMistakes: ["把串联并联规律记混"]),
        tags: ["电路", "串联"])

    static let b4_jouleHeat = PhysicsProblem(
        id: "b4_joule", type: .calculation, stage: .senior, topic: .circuit,
        content: "电阻 R=10 Ω 通过 2 A 的电流，持续 5 分钟。求它产生的热量。",
        answer: "Q = 12000 J", difficulty: 0.4, averageTime: 80, hints: ["Q=I²Rt，时间用秒"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "焦耳定律", formula: "Q = I²Rt = 4×10×300 = 12000 J", annotation: "5 min=300 s"),
        ], keyInsight: "Q=I²Rt，时间务必用秒。", commonMistakes: ["时间用分钟"]),
        tags: ["电路", "焦耳热"])
}
