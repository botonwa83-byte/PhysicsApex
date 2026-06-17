import Foundation

// MARK: - 练习 Batch 2：圆周运动 & 万有引力 & 动量（13 题）

extension ProblemBank {

    static let batch2: [PhysicsProblem] = [
        b2_centripetal, b2_conicalPendulum, b2_centripetalSource, b2_verticalTop, b2_turntable,
        b2_orbitCompare, b2_centralMass, b2_gVsHeight, b2_recoil, b2_elasticCollision,
        b2_manBoat, b2_momentumCond, b2_buffer,
    ]

    static let b2_centripetal = PhysicsProblem(
        id: "b2_centripetal", type: .calculation, stage: .senior, topic: .circular,
        content: "质量 0.5 kg 的小球用绳拴住，在水平面内做半径 1 m、线速度 2 m/s 的匀速圆周运动。求绳的拉力（提供向心力）。",
        answer: "F = 2 N", difficulty: 0.4, averageTime: 80, hints: ["F=mv²/r"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "向心力", formula: "F = mv²/r = 0.5×4/1 = 2 N", annotation: ""),
        ], keyInsight: "向心力由绳的拉力提供。", commonMistakes: ["忘了平方 v²"]),
        tags: ["圆周运动", "向心力"])

    static let b2_conicalPendulum = PhysicsProblem(
        id: "b2_conical", type: .calculation, stage: .senior, topic: .circular,
        content: "圆锥摆：长 L 的细线一端固定，另一端小球在水平面内做匀速圆周运动，线与竖直方向夹角 θ。求小球运动的周期。",
        answer: "T = 2π√(Lcosθ/g)", difficulty: 0.65, averageTime: 180,
        hints: ["竖直方向：Tcosθ=mg", "水平方向：Tsinθ 提供向心力，r=Lsinθ"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "竖直平衡", formula: "Tcosθ = mg", annotation: ""),
            SolutionStep(order: 2, description: "水平向心", formula: "Tsinθ = mω²r = mω²Lsinθ", annotation: "约去 sinθ"),
            SolutionStep(order: 3, description: "求周期", formula: "ω²=g/(Lcosθ) ⟹ T=2π√(Lcosθ/g)", annotation: ""),
        ], keyInsight: "圆锥摆：竖直平衡 + 水平向心，两方程拿下。",
           commonMistakes: ["半径用 L 而非 Lsinθ"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "正交分解列两个方程", formula: "Tcosθ=mg；Tsinθ=mω²Lsinθ", annotation: "两式相除消 T，再换算周期"),
            ], keyInsight: "正交分解联立求解。", commonMistakes: ["半径误用 L"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "画力的矢量三角形：重力、张力、合力（向心力）构成直角三角形", formula: "F向 = mg·tanθ", annotation: "一眼读出，免联立"),
                SolutionStep(order: 2, description: "向心力定周期", formula: "mg·tanθ = m(2π/T)²·Lsinθ ⟹ T = 2π√(Lcosθ/g)", annotation: "一步"),
            ], keyInsight: "三力平衡/定合力的问题，画矢量三角形比正交分解快一倍。", commonMistakes: []),
            weaponUsed: .vectorTriangle, timeRatio: 3.0,
            detailedExplanation: "矢量三角形通杀「一力恒定（重力）+ 一力方向已知」的合成问题：圆锥摆、斜面光滑球、绳杆夹角全适用。",
            plainTalk: "小球只受两个力：绳的拉力和重力，它俩合出来的力负责拉着球转圈。把三个矢量首尾相接拼成直角三角形：重力竖直、合力水平、夹角就是绳的倾角 θ——tanθ 一出，向心力 mg·tanθ 白送，方程组直接失业。"),
        tags: ["圆周运动", "圆锥摆", "降维"])

    static let b2_centripetalSource = PhysicsProblem(
        id: "b2_cent_source", type: .multipleChoice, stage: .senior, topic: .circular,
        content: "关于向心力，下列说法正确的是？",
        options: ["向心力是物体受到的一种特殊的力", "向心力由其它实际的力（或其分力）提供",
                  "做匀速圆周运动的物体不受力", "向心力对物体做正功"],
        answer: "向心力由其它实际的力（或其分力）提供",
        difficulty: 0.4, averageTime: 50, hints: ["向心力是按效果命名的"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "本质", formula: "向心力 = 指向圆心的合力", annotation: "由重力/张力/摩擦等提供"),
            SolutionStep(order: 2, description: "做功", formula: "永远垂直速度 → 不做功", annotation: ""),
        ], keyInsight: "向心力是效果命名，不是新的力，且不做功。",
           commonMistakes: ["在受力图里额外画向心力"]),
        misconceptions: [
            Misconception(option: "向心力是物体受到的一种特殊的力",
                youThought: "你大概把「向心力」当成了和重力、拉力并列的一种力。",
                pitfall: "向心力是按效果起的名字，由实际的力提供，受力图里不能再单独画一个。",
                fix: "先分析实际受力，它们指向圆心的合力就是向心力。")
        ], tags: ["圆周运动", "向心力", "错因诊断"])

    static let b2_verticalTop = PhysicsProblem(
        id: "b2_vertical_top", type: .calculation, stage: .senior, topic: .circular,
        content: "小球在竖直平面内做圆周运动，半径 r。要使小球能通过最高点，求在最高点的最小速度。(g 已知)",
        answer: "v_min = √(gr)", difficulty: 0.55, averageTime: 130,
        hints: ["最高点临界：绳/轨道力为零", "此时重力提供向心力"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "临界条件", formula: "N=0，仅重力提供向心力", annotation: ""),
            SolutionStep(order: 2, description: "求最小速度", formula: "mg = mv²/r ⟹ v=√(gr)", annotation: ""),
        ], keyInsight: "最高点恰好通过 = 重力恰好提供向心力。",
           commonMistakes: ["以为最高点速度可以为零"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对最高点做一般受力分析", formula: "mg + N = mv²/r，再讨论 N 的取值范围", annotation: "容易在 N 能不能为负上纠结"),
            ], keyInsight: "一般化受力分析再讨论。", commonMistakes: ["误以为 v=0 也能通过"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "直奔临界态：「恰好通过」=绳拉力/轨道压力为零", formula: "N=0 ⟹ mg = mv²/r", annotation: "临界条件即方程"),
                SolutionStep(order: 2, description: "解出", formula: "v_min = √(gr)", annotation: "一步"),
            ], keyInsight: "「恰好」「最大」「至少」出现时，先翻译成临界条件，方程自动列好。", commonMistakes: []),
            weaponUsed: .criticalAnalysis, timeRatio: 3.0,
            detailedExplanation: "临界分析的关键是把「恰好」翻译成物理量取零或最值。注意 v_min=√(gr) 只适用绳/内轨模型，杆模型最高点 v 可为零。",
            plainTalk: "「恰好通过最高点」翻译成人话：绳子已经完全不出力了（一出力就不叫恰好），全靠重力一个人拉着球拐弯。所以 mg=mv²/r，最小速度 √(gr) 当场出炉。记住公式不如记住翻译：恰好＝某个力恰好变成零。"),
        tags: ["圆周运动", "竖直圆周", "临界分析", "降维"])

    static let b2_turntable = PhysicsProblem(
        id: "b2_turntable", type: .calculation, stage: .senior, topic: .circular,
        content: "物块放在水平转盘上、距轴 r=0.5 m 处，与盘面间最大静摩擦因数 μ=0.4。求物块不被甩出的最大角速度。(g=10 m/s²)",
        answer: "ω_max = √(μg/r) = 4√0.5 ≈ 2.83 rad/s", difficulty: 0.6, averageTime: 150,
        hints: ["摩擦提供向心力", "临界：最大静摩擦=所需向心力"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "临界", formula: "μmg = mω²r", annotation: "摩擦力用到最大"),
            SolutionStep(order: 2, description: "解出", formula: "ω=√(μg/r)=√(0.4×10/0.5)=√8≈2.83 rad/s", annotation: ""),
        ], keyInsight: "转盘问题：静摩擦提供向心力，达到最大即临界。",
           commonMistakes: ["把 μ 当动摩擦用错"]),
        tags: ["圆周运动", "临界分析"])

    static let b2_orbitCompare = PhysicsProblem(
        id: "b2_orbit_compare", type: .multipleChoice, stage: .senior, topic: .circular,
        content: "关于绕地球做匀速圆周运动的人造卫星，轨道半径越大，则？",
        options: ["线速度越大", "周期越小", "线速度越小、周期越大", "角速度越大"],
        answer: "线速度越小、周期越大",
        difficulty: 0.5, averageTime: 60, hints: ["v=√(GM/r)，T=2π√(r³/GM)"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "速度", formula: "v=√(GM/r)，r↑ → v↓", annotation: ""),
            SolutionStep(order: 2, description: "周期", formula: "T=2π√(r³/GM)，r↑ → T↑", annotation: ""),
        ], keyInsight: "高轨卫星「又慢又久」——越高越慢、周期越长。",
           commonMistakes: ["以为越高越快"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "逐项推导 v、T、ω 的表达式再比较", formula: "v=√(GM/r)；T=2π√(r³/GM)；ω=√(GM/r³)", annotation: "三个公式逐一推"),
            ], keyInsight: "完整推导每个量。", commonMistakes: ["公式记混"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "引力提供向心力，只看比例", formula: "GMm/r²=mv²/r ⟹ v∝r^(−1/2)，T∝r^(3/2)", annotation: "指数定一切"),
                SolutionStep(order: 2, description: "口诀裁决", formula: "「高轨低速大周期」", annotation: "秒选"),
            ], keyInsight: "天体圆轨道问题只问「怎么变」时，比例法免去全部数值计算。", commonMistakes: []),
            weaponUsed: .proportion, timeRatio: 3.0,
            detailedExplanation: "比例法通杀卫星比较类选择题：抓住 GM 不变，v、T、ω、a 全部化成 r 的幂次，看指数正负即得结论。",
            plainTalk: "卫星飞得越高越「懒」：那里引力弱，不需要跑那么快也掉不下来。记住口诀「高轨低速大周期」——轨道高的，速度小、周期长。一个数都不用算，结论早写在公式的指数里了。"),
        misconceptions: [
            Misconception(option: "线速度越大",
                youThought: "你大概觉得轨道大、跑得快。",
                pitfall: "v=√(GM/r)，r 越大 v 越小。高轨卫星其实更慢。",
                fix: "记住「高轨道又慢又久」：v↓、T↑、ω↓。")
        ], tags: ["万有引力", "卫星", "错因诊断", "降维"])

    static let b2_centralMass = PhysicsProblem(
        id: "b2_central_mass", type: .calculation, stage: .senior, topic: .circular,
        content: "一颗卫星绕某行星做匀速圆周运动，轨道半径 r、周期 T。求该行星的质量 M。(引力常量 G 已知)",
        answer: "M = 4π²r³/(GT²)", difficulty: 0.6, averageTime: 150,
        hints: ["万有引力提供向心力", "向心力用周期表达 mω²r=m(2π/T)²r"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "引力=向心力", formula: "GMm/r² = m(2π/T)²r", annotation: ""),
            SolutionStep(order: 2, description: "解出", formula: "M = 4π²r³/(GT²)", annotation: "测天体质量的方法"),
        ], keyInsight: "测中心天体质量：用环绕星体的 r 和 T。",
           commonMistakes: ["向心力用线速度但题目没给 v"]),
        tags: ["万有引力", "天体质量"])

    static let b2_gVsHeight = PhysicsProblem(
        id: "b2_g_height", type: .multipleChoice, stage: .senior, topic: .circular,
        content: "关于物体在地球表面和高空的重力加速度 g，下列正确的是？",
        options: ["g 是常数，处处相同", "高空 g 比地面小", "高空 g 比地面大", "g 与地球质量无关"],
        answer: "高空 g 比地面小",
        difficulty: 0.45, averageTime: 55, hints: ["g=GM/r²，r 是到地心距离"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "公式", formula: "g = GM/r²", annotation: "r 为到地心距离"),
            SolutionStep(order: 2, description: "高空", formula: "r↑ → g↓", annotation: ""),
        ], keyInsight: "g 随离地心距离增大而减小，不是常数。",
           commonMistakes: ["以为 g 处处是 9.8"]),
        misconceptions: [
            Misconception(option: "g 是常数，处处相同",
                youThought: "你大概把地表常用的 g=9.8 当成了宇宙通用常数。",
                pitfall: "g=GM/r²，离地心越远越小；月球、高空、其它星球都不同。",
                fix: "9.8 只是地球表面附近的值，g 随位置变。")
        ], tags: ["万有引力", "重力加速度", "错因诊断"])

    static let b2_recoil = PhysicsProblem(
        id: "b2_recoil", type: .calculation, stage: .senior, topic: .momentum,
        content: "静止的炮车质量 M=1000 kg，水平发射质量 m=10 kg、速度 v=200 m/s 的炮弹。求炮车反冲的速度。",
        answer: "V = 2 m/s（方向与炮弹相反）", difficulty: 0.45, averageTime: 100,
        hints: ["系统初动量为零", "动量守恒"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "动量守恒", formula: "0 = mv − MV", annotation: "反向"),
            SolutionStep(order: 2, description: "解出", formula: "V = mv/M = 10×200/1000 = 2 m/s", annotation: ""),
        ], keyInsight: "反冲：总动量守恒为零，正反向动量等大。", commonMistakes: ["方向忽略"]),
        tags: ["动量守恒", "反冲"])

    static let b2_elasticCollision = PhysicsProblem(
        id: "b2_elastic", type: .calculation, stage: .senior, topic: .momentum,
        content: "质量相等的两小球，A 以速度 v₀ 与静止的 B 发生一维弹性正碰。求碰后两球速度。",
        answer: "A 停下（v=0），B 以 v₀ 前进（交换速度）", difficulty: 0.5, averageTime: 120,
        hints: ["动量守恒 + 动能守恒", "等质量结论"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "两守恒联立", formula: "mv₀=mv_A+mv_B；½mv₀²=…", annotation: ""),
            SolutionStep(order: 2, description: "等质量弹性碰", formula: "v_A=0，v_B=v₀", annotation: "交换速度"),
        ], keyInsight: "等质量弹性正碰 → 交换速度（台球现象）。",
           commonMistakes: ["以为两球一起运动"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "动量守恒 + 动能守恒联立", formula: "mv₀=mv_A+mv_B；½mv₀²=½mv_A²+½mv_B²", annotation: "二元二次方程组，要解还要舍根"),
            ], keyInsight: "两守恒联立硬解。", commonMistakes: ["漏舍「未碰」的解 v_A=v₀"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "换到质心系：弹性碰撞=两球速度各自反向", formula: "质心速度 v_c=v₀/2；质心系中 A、B 速度 ±v₀/2 反向", annotation: "弹性碰撞的对称本质"),
                SolutionStep(order: 2, description: "变换回地面系", formula: "v_A=v_c−v₀/2=0；v_B=v_c+v₀/2=v₀", annotation: "交换速度，秒出"),
            ], keyInsight: "质心系里弹性碰撞只是「反弹」——换个参考系，二次方程组变成加减法。", commonMistakes: []),
            weaponUsed: .referenceFrame, timeRatio: 4.0,
            detailedExplanation: "参考系变换通杀弹性碰撞：质心系中两球速度大小不变、方向反转，变换回去即得结果。「等质量交换速度」只在弹性正碰时成立。",
            plainTalk: "两个一样重的球弹性正碰，就是台球桌上的经典画面：白球「啪」地停住，目标球带着原速度走人——它俩把速度完整交换了。为什么？站到它们的中点（质心）看：碰撞只是各自原速反弹，换回地面视角恰好就是交换。"),
        tags: ["动量守恒", "弹性碰撞", "降维"])

    static let b2_manBoat = PhysicsProblem(
        id: "b2_man_boat", type: .calculation, stage: .senior, topic: .momentum,
        content: "质量 m 的人站在质量 M、长 L 的船一端（水面光滑，整体静止）。人走到船另一端，求船移动的距离。",
        answer: "d = mL/(m+M)", difficulty: 0.65, averageTime: 170,
        hints: ["系统动量守恒且初动量为零", "质心位置不变"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "质心不动", formula: "m·x人 = M·x船", annotation: "人相对地走 (L−d)，船走 d"),
            SolutionStep(order: 2, description: "解出", formula: "m(L−d)=Md ⟹ d=mL/(m+M)", annotation: ""),
        ], keyInsight: "人船模型：系统质心不动，按质量反比分配位移。",
           commonMistakes: ["用人相对船的位移当人对地位移"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对人和船分别积分速度求位移", formula: "∫v dt", annotation: "繁琐"),
            ], keyInsight: "逐时刻分析速度积分。", commonMistakes: ["过程复杂"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "质心不动，位移与质量成反比", formula: "d=mL/(m+M)", annotation: "一步"),
            ], keyInsight: "动量守恒 ⟹ 质心不动，秒得位移关系。", commonMistakes: []),
            weaponUsed: .momentumConservation, timeRatio: 3.0,
            detailedExplanation: "初动量为零的系统质心永远不动——人船模型、爆炸反冲都靠这条秒杀。",
            plainTalk: "人往左走，船必须往右退——系统最初静止，总冲劲必须一直是零。更妙的是：整个系统的重心永远钉在原地。人重船轻，人挪得少、船退得多，按质量反着分配总长 L 就行。"),
        tags: ["动量守恒", "人船模型", "降维"])

    static let b2_momentumCond = PhysicsProblem(
        id: "b2_mom_cond", type: .multipleChoice, stage: .senior, topic: .momentum,
        content: "关于动量守恒的条件，下列说法正确的是？",
        options: ["只要发生碰撞，系统动量就守恒", "系统所受合外力为零时，总动量守恒",
                  "动量守恒就是动能守恒", "只要有摩擦，动量就不守恒"],
        answer: "系统所受合外力为零时，总动量守恒",
        difficulty: 0.45, averageTime: 55, hints: ["守恒条件是合外力为零", "内力不影响总动量"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "条件", formula: "F外合 = 0（或内力远大于外力的瞬间）", annotation: ""),
        ], keyInsight: "动量守恒看合外力，不看是否碰撞、是否有摩擦（内摩擦是内力）。",
           commonMistakes: ["把动量守恒和动能守恒混为一谈"]),
        misconceptions: [
            Misconception(option: "动量守恒就是动能守恒",
                youThought: "你大概觉得这两个守恒是一回事。",
                pitfall: "非弹性碰撞动量守恒但动能减少（变成内能）。两者不等价。",
                fix: "动量守恒看合外力；动能是否守恒看碰撞是否弹性。")
        ], tags: ["动量守恒", "守恒条件", "错因诊断"])

    static let b2_buffer = PhysicsProblem(
        id: "b2_buffer", type: .calculation, stage: .senior, topic: .momentum,
        content: "质量 0.2 kg 的球以 10 m/s 撞墙后以 6 m/s 反弹，接触时间 0.1 s。求墙对球的平均作用力大小。",
        answer: "F = 32 N", difficulty: 0.5, averageTime: 110,
        hints: ["取离墙方向为正", "动量定理 Ft=Δp，注意反弹是反向"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "动量变化", formula: "Δp = m·6 − m·(−10) = 0.2×16 = 3.2 kg·m/s", annotation: "方向反了"),
            SolutionStep(order: 2, description: "平均力", formula: "F = Δp/t = 3.2/0.1 = 32 N", annotation: ""),
        ], keyInsight: "动量定理求冲击力，反弹一定要带方向（正负号）。",
           commonMistakes: ["把 Δp 算成 m(10−6)，漏了反向"]),
        tags: ["动量定理", "冲击力"])
}
