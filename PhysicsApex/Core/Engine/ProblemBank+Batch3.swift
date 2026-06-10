import Foundation

// MARK: - 题库 Batch 3：功和能（13 题）

extension ProblemBank {

    static let batch3: [PhysicsProblem] = [
        b3_workAngle, b3_carPower, b3_kineticTheorem, b3_pendulumEnergy, b3_workSign,
        b3_springPE, b3_gravityWork, b3_conveyor, b3_powerType, b3_roughIncline,
        b3_mechEnergyCond, b3_rollerCoaster, b3_crane,
    ]

    static let b3_workAngle = PhysicsProblem(
        id: "b3_work_angle", type: .calculation, stage: .senior, topic: .energy,
        content: "用 50 N 的力沿与水平方向成 37° 的方向拉物体，使物体在水平面上前进 4 m。求这个力做的功。(cos37°=0.8)",
        answer: "W = 160 J", difficulty: 0.4, averageTime: 80, hints: ["W=Fscosθ，θ 是力与位移夹角"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "功", formula: "W = Fscosθ = 50×4×0.8 = 160 J", annotation: ""),
        ], keyInsight: "功 = 力沿位移方向的分量 × 位移。", commonMistakes: ["漏掉 cosθ"]),
        tags: ["功", "功的计算"])

    static let b3_carPower = PhysicsProblem(
        id: "b3_car_power", type: .calculation, stage: .senior, topic: .energy,
        content: "汽车额定功率 60 kW，在水平路面以恒定阻力 2000 N 行驶。求它能达到的最大速度。",
        answer: "v_max = 30 m/s", difficulty: 0.55, averageTime: 120,
        hints: ["最大速度时牵引力=阻力", "P=Fv"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "最大速度时", formula: "F牵 = f = 2000 N，a=0", annotation: ""),
            SolutionStep(order: 2, description: "求速度", formula: "v = P/F = 60000/2000 = 30 m/s", annotation: ""),
        ], keyInsight: "额定功率下的最大速度：牵引力恰好等于阻力。",
           commonMistakes: ["以为最大速度时还在加速"]),
        tags: ["功率", "机车启动"])

    static let b3_kineticTheorem = PhysicsProblem(
        id: "b3_kinetic_thm", type: .calculation, stage: .senior, topic: .energy,
        content: "质量 2 kg 的物体初速度 3 m/s，在水平面上受到 6 N 的水平拉力前进 5 m（不计摩擦）。用动能定理求末速度。",
        answer: "v = 6 m/s", difficulty: 0.45, averageTime: 100,
        hints: ["W合=½mv²−½mv₀²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "动能定理", formula: "Fs = ½mv² − ½mv₀²", annotation: ""),
            SolutionStep(order: 2, description: "解出", formula: "6×5 = ½×2×v² − ½×2×9 ⟹ v=6 m/s", annotation: ""),
        ], keyInsight: "动能定理：合外力做功 = 动能变化。", commonMistakes: ["忘了初动能"]),
        tags: ["动能定理"])

    static let b3_pendulumEnergy = PhysicsProblem(
        id: "b3_pendulum_e", type: .calculation, stage: .senior, topic: .energy,
        content: "长 L 的摆球从水平位置由静止摆下。用机械能守恒求它到达最低点的速度。(g 已知)",
        answer: "v = √(2gL)", difficulty: 0.45, averageTime: 90,
        hints: ["下降高度=L", "mgL=½mv²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "机械能守恒", formula: "mgL = ½mv²", annotation: "只有重力做功"),
            SolutionStep(order: 2, description: "解出", formula: "v = √(2gL)", annotation: "与质量无关"),
        ], keyInsight: "只有重力做功 → 机械能守恒，质量约掉。", commonMistakes: ["下降高度算错"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想用牛顿定律沿弧分析", formula: "圆弧上张力、重力分量都随位置变 ⟹ 变力变加速度", annotation: "高中数学解不动这个微分方程"),
            ], keyInsight: "牛顿定律在曲线变力问题上卡壳。", commonMistakes: ["误用匀加速公式"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "张力始终垂直速度不做功，只有重力做功 ⟹ 机械能守恒", formula: "mgL = ½mv²", annotation: "无视全部过程细节"),
                SolutionStep(order: 2, description: "解出", formula: "v = √(2gL)", annotation: "一步，质量自动约掉"),
            ], keyInsight: "守恒量只看首末态——过程越复杂，守恒律越显威力。", commonMistakes: []),
            weaponUsed: .mechanicalEnergy, timeRatio: 4.0,
            detailedExplanation: "机械能守恒通杀「只有重力/弹力做功」的曲线运动：摆、轨道、滑面，过程再花哨也只算首末两态。"),
        tags: ["机械能守恒", "单摆", "降维"])

    static let b3_workSign = PhysicsProblem(
        id: "b3_work_sign", type: .multipleChoice, stage: .senior, topic: .energy,
        content: "关于力做功的正负，下列说法正确的是？",
        options: ["摩擦力一定做负功", "向心力做正功", "重力对下落物体做正功", "支持力一定做正功"],
        answer: "重力对下落物体做正功",
        difficulty: 0.45, averageTime: 55, hints: ["W=Fscosθ，看力与位移夹角"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "下落", formula: "重力与位移同向 → 正功", annotation: ""),
            SolutionStep(order: 2, description: "向心力", formula: "垂直速度 → 不做功", annotation: ""),
        ], keyInsight: "做功正负看力与位移的夹角；向心力不做功。",
           commonMistakes: ["以为摩擦力总做负功（静摩擦可做正功）"]),
        misconceptions: [
            Misconception(option: "摩擦力一定做负功",
                youThought: "你大概觉得摩擦总是阻碍、做负功。",
                pitfall: "传送带带动物体时，静摩擦是动力、做正功；走路时地面摩擦也做正功。",
                fix: "看摩擦力方向与位移方向：同向正功、反向负功。")
        ], tags: ["功", "功的正负", "错因诊断"])

    static let b3_springPE = PhysicsProblem(
        id: "b3_spring_pe", type: .calculation, stage: .senior, topic: .energy,
        content: "竖直弹簧上端连一质量 m 的物块，物块从弹簧原长处由静止下压，下降 h 到最低点（速度为零）。已知该过程重力做功，求弹簧储存的弹性势能。",
        answer: "E弹 = mgh", difficulty: 0.5, averageTime: 110,
        hints: ["始末动能都为零", "能量守恒：重力做的功全变弹性势能"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "始末动能为零", formula: "ΔEk = 0", annotation: ""),
            SolutionStep(order: 2, description: "能量守恒", formula: "mgh = E弹", annotation: "重力势能转弹性势能"),
        ], keyInsight: "弹性势能不会算公式？用功能关系绕过去。",
           commonMistakes: ["想用 ½kx² 但不知 k"]),
        tags: ["弹性势能", "功能关系"])

    static let b3_gravityWork = PhysicsProblem(
        id: "b3_gravity_work", type: .multipleChoice, stage: .senior, topic: .energy,
        content: "质量 m 的物体从高 h 处沿不同路径（直线、曲线、斜面）下滑到地面。重力对它做的功？",
        options: ["路径越长做功越多", "三种路径做功都等于 mgh", "曲线路径做功最少", "与路径有关，无法确定"],
        answer: "三种路径做功都等于 mgh",
        difficulty: 0.4, averageTime: 50, hints: ["重力做功只看高度差"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "重力做功", formula: "W = mgh", annotation: "只与起末高度差有关"),
        ], keyInsight: "重力做功与路径无关，只看竖直高度差。",
           commonMistakes: ["以为路径越长做功越多"]),
        misconceptions: [
            Misconception(option: "路径越长做功越多",
                youThought: "你大概觉得走得远、重力做功就多。",
                pitfall: "重力是「保守力」，做功只取决于高度差，与路径长短无关。",
                fix: "三条路径高度差都是 h，重力做功都是 mgh。")
        ], tags: ["功", "重力做功", "错因诊断"])

    static let b3_conveyor = PhysicsProblem(
        id: "b3_conveyor", type: .calculation, stage: .senior, topic: .energy,
        content: "水平传送带以 2 m/s 匀速运行，把质量 1 kg 的工件（初速度为零）轻放上去，工件与带间动摩擦因数 μ=0.5。求工件从滑动到与带共速过程中，因摩擦产生的热量。(g=10)",
        answer: "Q = 2 J", difficulty: 0.7, averageTime: 200,
        hints: ["Q=f·Δs相对", "Δs相对 = 带的位移 − 工件位移"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "加速阶段", formula: "a=μg=5 m/s²，到 2 m/s 用 t=0.4 s", annotation: ""),
            SolutionStep(order: 2, description: "相对位移", formula: "带走 0.8 m，工件走 0.4 m，Δs相对=0.4 m", annotation: ""),
            SolutionStep(order: 3, description: "生热", formula: "Q = μmg·Δs相对 = 5×0.4 = 2 J", annotation: ""),
        ], keyInsight: "摩擦生热 Q=f×相对滑动距离，不是 f×某个物体的位移。",
           commonMistakes: ["用工件位移或带位移代替相对位移"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "分段算运动学再相减", formula: "t=v/a=0.4 s；x件=½at²=0.4 m；x带=vt=0.8 m", annotation: "三个量逐一算"),
                SolutionStep(order: 2, description: "代生热公式", formula: "Q=μmg(x带−x件)=5×0.4=2 J", annotation: ""),
            ], keyInsight: "逐段运动学硬算相对位移。", commonMistakes: ["用工件位移当相对位移"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "画 v-t 图：带是水平线，工件是过原点斜线", formula: "共速前两线围成三角形", annotation: "相对位移=两图线间面积"),
                SolutionStep(order: 2, description: "面积差秒读", formula: "Δs=½×2×0.4=0.4 m ⟹ Q=μmg·Δs=2 J", annotation: "一眼"),
            ], keyInsight: "v-t 图上「两线之间的面积」就是相对位移——传送带生热问题的标准秒杀。", commonMistakes: []),
            weaponUsed: .graphMethod, timeRatio: 3.0,
            detailedExplanation: "图像法通杀传送带：共速点是交点、相对滑动是线间面积，比分段运动学少算一半的量。"),
        tags: ["能量守恒", "传送带", "摩擦生热", "降维"])

    static let b3_powerType = PhysicsProblem(
        id: "b3_power_type", type: .multipleChoice, stage: .senior, topic: .energy,
        content: "汽车以恒定牵引力由静止加速。关于其牵引力的功率，下列正确的是？",
        options: ["功率恒定不变", "功率随速度增大而增大", "功率随速度增大而减小", "功率始终为零"],
        answer: "功率随速度增大而增大",
        difficulty: 0.45, averageTime: 55, hints: ["P=Fv，F恒定"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "瞬时功率", formula: "P = Fv，F 恒定", annotation: "v↑ → P↑"),
        ], keyInsight: "恒力加速时，瞬时功率随速度线性增大。",
           commonMistakes: ["把恒力当成恒功率"]),
        misconceptions: [
            Misconception(option: "功率恒定不变",
                youThought: "你大概觉得牵引力不变，功率也就不变。",
                pitfall: "P=Fv，力不变但速度在增大，功率随之增大。恒力 ≠ 恒功率。",
                fix: "恒力启动：功率 P=Fv 越来越大；恒功率启动才是 F 越来越小。")
        ], tags: ["功率", "机车启动", "错因诊断"])

    static let b3_roughIncline = PhysicsProblem(
        id: "b3_rough_incline", type: .calculation, stage: .senior, topic: .energy,
        content: "物体以 8 m/s 的初速度冲上倾角 30° 的粗糙斜面，动摩擦因数 μ=√3/3，求它沿斜面上滑的最大距离。(g=10, sin30°=0.5, cos30°=√3/2)",
        answer: "s = 3.2 m", difficulty: 0.65, averageTime: 170,
        hints: ["上滑减速，动能定理", "重力分量和摩擦都做负功"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "动能定理", formula: "−(mgsinθ+μmgcosθ)s = 0 − ½mv₀²", annotation: ""),
            SolutionStep(order: 2, description: "代入", formula: "a=g(sinθ+μcosθ)=10(0.5+0.5)=10；s=v₀²/2a=64/20=3.2 m", annotation: ""),
        ], keyInsight: "上滑：重力分量与摩擦力都做负功。", commonMistakes: ["漏掉摩擦或符号错"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "受力分解求加速度", formula: "a = g(sinθ+μcosθ) = 10 m/s²", annotation: "先画受力图、分解重力"),
                SolutionStep(order: 2, description: "再套运动学公式", formula: "s = v₀²/(2a) = 64/20 = 3.2 m", annotation: "两阶段"),
            ], keyInsight: "牛顿定律 + 运动学两步走。", commonMistakes: ["分解时 sin/cos 用反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "全程一个动能定理，不求加速度", formula: "−(mgsinθ+μmgcosθ)s = 0 − ½mv₀²", annotation: "力×位移直接对账"),
                SolutionStep(order: 2, description: "解出", formula: "s = v₀²/[2g(sinθ+μcosθ)] = 3.2 m", annotation: "一步"),
            ], keyInsight: "只问「位移和速度」不问「时间」的题，动能定理跳过加速度直达答案。", commonMistakes: []),
            weaponUsed: .workEnergyTheorem, timeRatio: 2.5,
            detailedExplanation: "动能定理通杀「不问时间」的动力学题：把牛顿定律+运动学的两步合成一步功能对账。"),
        tags: ["动能定理", "斜面", "降维"])

    static let b3_mechEnergyCond = PhysicsProblem(
        id: "b3_mech_cond", type: .multipleChoice, stage: .senior, topic: .energy,
        content: "关于机械能守恒，下列说法正确的是？",
        options: ["只要物体受外力，机械能就不守恒", "只有重力和弹力做功时，机械能守恒",
                  "机械能守恒就是动能守恒", "有摩擦力机械能也一定守恒"],
        answer: "只有重力和弹力做功时，机械能守恒",
        difficulty: 0.45, averageTime: 55, hints: ["守恒条件看「谁做功」"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "条件", formula: "只有重力/弹力做功（其它力不做功）", annotation: ""),
        ], keyInsight: "机械能守恒条件是「只有重力弹力做功」，不是「不受外力」。",
           commonMistakes: ["把守恒条件理解成不受外力"]),
        misconceptions: [
            Misconception(option: "只要物体受外力，机械能就不守恒",
                youThought: "你大概觉得有外力机械能就会变。",
                pitfall: "比如绳的拉力、支持力虽是外力但不做功，机械能照样守恒。",
                fix: "看的是「做功的力」是不是只有重力弹力，而不是有没有外力。")
        ], tags: ["机械能守恒", "守恒条件", "错因诊断"])

    static let b3_rollerCoaster = PhysicsProblem(
        id: "b3_roller", type: .multipleChoice, stage: .junior, topic: .energy,
        content: "过山车从最高点俯冲到最低点（忽略摩擦）。关于动能和势能，下列正确的是？",
        options: ["动能和势能都增大", "重力势能转化为动能", "机械能减少", "动能转化为势能"],
        answer: "重力势能转化为动能",
        difficulty: 0.3, averageTime: 40, hints: ["下降时高度减小、速度增大"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "下降", formula: "Ep↓ → Ek↑", annotation: "总机械能不变"),
        ], keyInsight: "下降过程：重力势能变动能，此消彼长。",
           commonMistakes: ["以为机械能减少"]),
        tags: ["能量转化", "机械能守恒"])

    static let b3_crane = PhysicsProblem(
        id: "b3_crane", type: .calculation, stage: .senior, topic: .energy,
        content: "起重机将质量 500 kg 的货物以 0.5 m/s 的速度匀速竖直吊起。求起重机对货物做功的功率。(g=10)",
        answer: "P = 2500 W", difficulty: 0.4, averageTime: 80,
        hints: ["匀速 → 拉力=重力", "P=Fv"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "匀速", formula: "F = mg = 5000 N", annotation: ""),
            SolutionStep(order: 2, description: "功率", formula: "P = Fv = 5000×0.5 = 2500 W", annotation: ""),
        ], keyInsight: "匀速吊起：拉力等于重力，P=Fv。", commonMistakes: ["忘了匀速时合力为零"]),
        tags: ["功率"])
}
