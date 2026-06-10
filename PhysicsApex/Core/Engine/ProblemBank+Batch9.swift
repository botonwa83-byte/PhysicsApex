import Foundation

// MARK: - 题库 Batch 9：高考压轴秒杀战例（20 题，全部 .senior + dualSolution）
// 定位：高考压轴高频题型（板块/弹簧/变轨/感应双杆/临界/极值…），每题「常规硬解 vs 武器秒杀」双解对决。
// 诚信：题型源自高考高频压轴（改编），不臆造精确出处；每条结论带适用条件。

extension ProblemBank {

    static let batch9: [PhysicsProblem] = [
        b9_blockBoard, b9_springMomentum, b9_swingField, b9_orbitChange, b9_rodHeat,
        b9_doubleRod, b9_projectileIncline, b9_circularDrop, b9_springSeparate, b9_radialField,
        b9_graphCross, b9_powerStart, b9_velocitySelector, b9_transformerDynamic, b9_roundTrip,
        b9_magnetTube, b9_circuitDynamic, b9_satelliteDensity, b9_elevatorGraph, b9_riverShortest,
    ]

    // 1. 板块模型 · 动量守恒
    static let b9_blockBoard = PhysicsProblem(
        id: "b9_block_board", type: .calculation, stage: .senior, topic: .momentum,
        content: "光滑水平地面上放质量 M=2 kg 的长木板，质量 m=1 kg 的木块以 v₀=6 m/s 滑上板左端（块板间 μ=0.3，板足够长）。求两者共速的速度和全程摩擦生热。(g=10)",
        answer: "v = 2 m/s；Q = 12 J", difficulty: 0.75, averageTime: 240,
        hints: ["地面光滑 ⟹ 块板系统合外力为零", "摩擦生热 = 系统动能的损失"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "系统动量守恒", formula: "mv₀ = (m+M)v ⟹ v = 6/3 = 2 m/s", annotation: "地面光滑，摩擦是内力"),
            SolutionStep(order: 2, description: "能量差即生热", formula: "Q = ½mv₀² − ½(m+M)v² = 18 − 6 = 12 J", annotation: ""),
        ], keyInsight: "板块模型的「最终共速」只由动量守恒决定，与 μ 无关；μ 只影响多久达到。",
           commonMistakes: ["以为 μ 越大共速速度越大"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "分别对块、板用牛顿定律", formula: "a₁ = μg = 3 m/s²（减速）；a₂ = μmg/M = 1.5 m/s²（加速）", annotation: "两张受力图"),
                SolutionStep(order: 2, description: "解共速时间和位移差再算热", formula: "6−3t = 1.5t ⟹ t = 4/3 s；再算 Δs 代 Q = μmg·Δs", annotation: "三段计算，步步可错"),
            ], keyInsight: "牛顿定律+运动学逐段硬算。", commonMistakes: ["位移差算错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "摩擦是内力 ⟹ 动量守恒", formula: "v = mv₀/(m+M) = 2 m/s", annotation: "一步"),
                SolutionStep(order: 2, description: "动能差即生热", formula: "Q = 18 − 6 = 12 J", annotation: "不必算时间和位移"),
            ], keyInsight: "板块共速=完全非弹性碰撞的慢动作版——动量定共速、能量差定热，过程细节全跳过。", commonMistakes: []),
            weaponUsed: .momentumConservation, timeRatio: 4.0,
            detailedExplanation: "动量守恒+能量差通杀板块模型「最终态」问题（地面光滑前提）。只有问「时间/板长」时才需要牛顿定律介入。"),
        tags: ["板块模型", "动量守恒", "压轴", "降维"])

    // 2. 弹簧+动量 · 最大弹性势能
    static let b9_springMomentum = PhysicsProblem(
        id: "b9_spring_momentum", type: .calculation, stage: .senior, topic: .momentum,
        content: "光滑水平面上，A（2 kg，4 m/s）撞向带轻弹簧的静止小车 B（2 kg）。求弹簧的最大弹性势能。",
        answer: "Ep_max = 8 J", difficulty: 0.75, averageTime: 220,
        hints: ["弹簧最短的瞬间，A、B 速度有什么关系？", "动量守恒贯穿全程"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "最大压缩 ⟺ 共速", formula: "2×4 = 4v ⟹ v = 2 m/s", annotation: "还在靠近就继续压缩，已在远离则在恢复"),
            SolutionStep(order: 2, description: "能量差存进弹簧", formula: "Ep = ½×2×16 − ½×4×4 = 16 − 8 = 8 J", annotation: ""),
        ], keyInsight: "弹簧最大形变的标志是「等速」——相对速度为零的瞬间。",
           commonMistakes: ["以为 A 停下时弹簧最短"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想跟踪弹簧压缩全过程的受力", formula: "弹力随形变变化 ⟹ 变加速运动", annotation: "微分方程，高中解不动"),
            ], keyInsight: "过程分析卡壳。", commonMistakes: ["陷在过程细节里"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "翻译临界条件：弹簧最短 ⟺ 两者共速", formula: "相对速度 = 0 的瞬间", annotation: "临界条件即方程"),
                SolutionStep(order: 2, description: "动量守恒+能量差", formula: "v = 2 m/s；Ep = 16 − 8 = 8 J", annotation: "秒出"),
            ], keyInsight: "「最大压缩/最大势能/最近距离」统统翻译成「共速」——临界分析把变力过程压缩成一个瞬间。", commonMistakes: []),
            weaponUsed: .criticalAnalysis, timeRatio: 4.0,
            detailedExplanation: "临界分析通杀弹簧/追碰类极值：相对速度为零 ⟺ 形变最大 ⟺ 势能最大 ⟺ 距离最近，配合动量守恒首末对账。"),
        tags: ["弹簧模型", "动量守恒", "临界分析", "压轴", "降维"])

    // 3. 等效重力 · 电场中的单摆
    static let b9_swingField = PhysicsProblem(
        id: "b9_swing_field", type: .calculation, stage: .senior, topic: .electricField,
        content: "摆长 L 的单摆，摆球质量 m、带正电 q，处于水平匀强电场中，电场力恰好 qE=mg。求摆球小幅摆动的周期和平衡位置偏角。",
        answer: "平衡偏角 45°；T = 2π√(L/(√2 g))", difficulty: 0.8, averageTime: 260,
        hints: ["重力和电场力都是恒力，可以合成一个「斜向重力」", "合成后按普通单摆处理"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "恒力合成", formula: "g' = √(g² + (qE/m)²) = √2 g，方向与竖直成 45°", annotation: "平衡位置沿 g' 方向"),
            SolutionStep(order: 2, description: "等效单摆", formula: "T = 2π√(L/g') = 2π√(L/(√2 g))", annotation: ""),
        ], keyInsight: "恒定的电场力+重力 = 一个更斜更强的「等效重力」，单摆公式照用。",
           commonMistakes: ["仍用 g 代周期公式"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "在偏置平衡点附近逐位置分析回复力", formula: "重力分量+电场力分量随摆角变化", annotation: "三角展开繁琐易错"),
            ], keyInsight: "回复力逐项分析。", commonMistakes: ["平衡位置找错导致全错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "把 mg 和 qE 合成等效重力 g'", formula: "g' = √2 g，偏 45°", annotation: "世界整体「倾斜」了"),
                SolutionStep(order: 2, description: "普通单摆公式直接套", formula: "T = 2π√(L/g')", annotation: "一步"),
            ], keyInsight: "等效重力把「电场+重力」双场世界变回单摆熟悉的单场世界——平衡位置、周期、最低点速度全部照搬。", commonMistakes: []),
            weaponUsed: .equivalentMethod, timeRatio: 4.0,
            detailedExplanation: "等效重力通杀「恒定电场力+重力」组合：带电单摆、带电平抛（沿 g' 的类平抛）都适用。前提是电场力必须恒定（匀强电场）。"),
        tags: ["电场", "单摆", "等效重力", "压轴", "降维"])

    // 4. 卫星变轨 · 能量观点
    static let b9_orbitChange = PhysicsProblem(
        id: "b9_orbit_change", type: .multipleChoice, stage: .senior, topic: .circular,
        content: "卫星从低圆轨道 Ⅰ 经椭圆转移轨道 Ⅱ 升至高圆轨道 Ⅲ，P 为轨道 Ⅰ、Ⅱ 的切点。下列正确的是？",
        options: ["在 P 点由轨道Ⅰ进入轨道Ⅱ需要减速", "卫星在轨道Ⅱ的机械能与轨道Ⅰ相等",
                  "在 P 点由轨道Ⅰ进入轨道Ⅱ需要加速，且轨道Ⅱ的机械能更大", "轨道Ⅲ上的线速度大于轨道Ⅰ上的线速度"],
        answer: "在 P 点由轨道Ⅰ进入轨道Ⅱ需要加速，且轨道Ⅱ的机械能更大",
        difficulty: 0.7, averageTime: 120,
        hints: ["轨道越高，机械能越大", "升轨需要发动机做正功"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "能量比较", formula: "E机(Ⅰ) < E机(Ⅱ) < E机(Ⅲ)", annotation: "升轨靠发动机做正功"),
            SolutionStep(order: 2, description: "P 点对比", formula: "同一点 r 相同、势能相同 ⟹ 轨道Ⅱ在 P 动能更大 ⟹ 需加速", annotation: ""),
        ], keyInsight: "「变高轨先加速、变低轨先减速」的本质：高轨道机械能更大。",
           commonMistakes: ["由「高轨低速」误推出升轨要减速"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想比较各轨道各点的 v、a、T 逐项判断", formula: "圆轨道公式+椭圆两点分析混杂", annotation: "「高轨低速」与「加速升轨」表面矛盾，极易绕晕"),
            ], keyInsight: "逐项公式比较。", commonMistakes: ["把圆轨道结论硬套椭圆"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "只看能量账本：升轨=发动机做正功=机械能增加", formula: "E(Ⅰ)<E(Ⅱ)<E(Ⅲ)", annotation: "一条主线"),
                SolutionStep(order: 2, description: "同一点势能相同 ⟹ 机械能大者动能大", formula: "P 点：vⅡ > vⅠ ⟹ 加速", annotation: "秒选"),
            ], keyInsight: "变轨问题抓机械能这一根主线：同一点比动能、不同轨道比机械能，「高轨低速」的迷雾自动散开。", commonMistakes: []),
            weaponUsed: .energyIntuition, timeRatio: 3.0,
            detailedExplanation: "能量观点通杀变轨：「高轨低速」说的是不同圆轨道的稳态速度，「加速升轨」说的是同一点的瞬间对比——能量账本让两者并行不悖。"),
        tags: ["万有引力", "卫星变轨", "压轴", "降维"])

    // 5. 电磁感应 · 焦耳热分配
    static let b9_rodHeat = PhysicsProblem(
        id: "b9_rod_heat", type: .calculation, stage: .senior, topic: .induction,
        content: "水平光滑导轨上，导体棒（电阻 r=1 Ω）以初动能 6 J 滑行，外接定值电阻 R=2 Ω，最终停下。求定值电阻 R 上产生的热量。",
        answer: "Q_R = 4 J", difficulty: 0.7, averageTime: 180,
        hints: ["动能最终去了哪里？", "串联电路中热量按电阻怎么分配？"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "能量守恒", formula: "Q总 = E_k = 6 J", annotation: "光滑导轨，动能全部变焦耳热"),
            SolutionStep(order: 2, description: "串联按电阻分配", formula: "Q_R = R/(R+r) × 6 = 2/3 × 6 = 4 J", annotation: "同电流 ⟹ Q ∝ R"),
        ], keyInsight: "电流大小在变，但串联中两电阻的电流时刻相同 ⟹ 热量比恒为 R:r。",
           commonMistakes: ["想求电流随时间的函数"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想写出 I(t) 再积分 ∫I²R dt", formula: "v 衰减 ⟹ E=BLv 衰减 ⟹ 指数过程", annotation: "微分方程，高中解不动"),
            ], keyInsight: "过程积分卡壳。", commonMistakes: ["在 I(t) 上耗死"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "总账：动能全变热", formula: "Q总 = 6 J", annotation: "能量守恒一步"),
                SolutionStep(order: 2, description: "分账：串联热量比=电阻比", formula: "Q_R = (2/3)×6 = 4 J", annotation: "比例秒出"),
            ], keyInsight: "「总量守恒定总账，比例关系分细账」——电流再怎么变，串联的热量比恒等于电阻比。", commonMistakes: []),
            weaponUsed: .proportion, timeRatio: 4.0,
            detailedExplanation: "比例分配通杀感应电路热量题：串联 Q∝R、并联 Q∝1/R，配合能量守恒的总账，任何复杂的电流过程都不必积分。"),
        tags: ["电磁感应", "焦耳热", "能量守恒", "压轴", "降维"])

    // 6. 电磁感应双杆 · 类比碰撞
    static let b9_doubleRod = PhysicsProblem(
        id: "b9_double_rod", type: .calculation, stage: .senior, topic: .induction,
        content: "光滑水平导轨（无外接电阻）上，杆 a（1 kg）以 4 m/s 滑向静止的杆 b（1 kg），两杆始终在匀强磁场中。求两杆的最终速度和全程焦耳热。",
        answer: "最终共速 2 m/s；Q = 4 J", difficulty: 0.8, averageTime: 260,
        hints: ["两杆受到的安培力等大反向", "电流为零时不再有相对加速——最终如何？"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "安培力是系统内力", formula: "m_a v₀ = (m_a+m_b)v ⟹ v = 2 m/s", annotation: "共速后磁通不变、电流消失"),
            SolutionStep(order: 2, description: "能量差即焦耳热", formula: "Q = ½×1×16 − ½×2×4 = 8 − 4 = 4 J", annotation: ""),
        ], keyInsight: "双杆终态是共速：相对运动消失 ⟹ 感应电流消失 ⟹ 安培力消失。",
           commonMistakes: ["以为 a 会停下、b 达到 4 m/s"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对两杆分别列含 I(t) 的牛顿方程", formula: "F_a = −BIL；F_b = +BIL；I = BL(v_a−v_b)/R总", annotation: "耦合微分方程，高中解不动"),
            ], keyInsight: "动力学方程组卡壳。", commonMistakes: ["试图解出 v(t)"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "类比：这就是一次「电磁完全非弹性碰撞」", formula: "安培力=内力 ⟺ 碰撞内力；终态共速 ⟺ 完全非弹性", annotation: "模型映射"),
                SolutionStep(order: 2, description: "套碰撞结论", formula: "v = 2 m/s；Q = 4 J（动能损失=焦耳热）", annotation: "秒出"),
            ], keyInsight: "把双杆映射成完全非弹性碰撞：动量守恒、终态共速、能量损失全部照搬——只是「碰撞」被磁场拉成了慢动作。", commonMistakes: []),
            weaponUsed: .analogy, timeRatio: 4.0,
            detailedExplanation: "类比迁移通杀双杆模型（等截面平行光滑导轨、无外力前提）：与子弹打木块共用同一套「动量+能量差」算法，焦耳热替代了摩擦热。"),
        tags: ["电磁感应", "双杆模型", "类比", "压轴", "降维"])

    // 7. 斜面平抛 · 位移三角形
    static let b9_projectileIncline = PhysicsProblem(
        id: "b9_projectile_incline", type: .calculation, stage: .senior, topic: .kinematics,
        content: "从倾角 θ 的斜面顶端，以初速度 v₀ 水平抛出小球，最终落回斜面。求飞行时间，并比较落点处速度方向与位移方向和斜面的关系。",
        answer: "t = 2v₀tanθ/g；位移沿斜面（tanθ），速度更陡（tanβ = 2tanθ）", difficulty: 0.75, averageTime: 220,
        hints: ["落在斜面上 ⟹ 位移方向被斜面锁定", "tan(位移角) = y/x"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "位移方向=斜面方向", formula: "tanθ = y/x = (½gt²)/(v₀t) = gt/(2v₀)", annotation: "几何约束直接给方程"),
            SolutionStep(order: 2, description: "解时间", formula: "t = 2v₀tanθ/g", annotation: ""),
            SolutionStep(order: 3, description: "速度方向", formula: "tanβ = v_y/v_x = gt/v₀ = 2tanθ", annotation: "速度偏角的正切恒为位移偏角的 2 倍"),
        ], keyInsight: "落斜面 ⟹ 位移方向锁死；平抛恒有 tan(速度角) = 2tan(位移角)。",
           commonMistakes: ["把速度方向当成沿斜面"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "设落点坐标联立轨迹与斜面直线", formula: "y = gx²/(2v₀²) 与 y = x·tanθ 联立", annotation: "解析几何联立，式子冗长"),
            ], keyInsight: "轨迹方程联立。", commonMistakes: ["代数化简出错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "画位移三角形：水平 v₀t、竖直 ½gt²，斜边贴着斜面", formula: "tanθ = (½gt²)/(v₀t) ⟹ t = 2v₀tanθ/g", annotation: "一个三角形一步出"),
                SolutionStep(order: 2, description: "速度三角形附赠结论", formula: "tanβ = gt/v₀ = 2tanθ", annotation: "「速度角正切=2×位移角正切」白送"),
            ], keyInsight: "平抛的两个直角三角形（位移、速度）藏着全部几何关系——落斜面问题先画三角形再列式。", commonMistakes: []),
            weaponUsed: .vectorTriangle, timeRatio: 3.0,
            detailedExplanation: "矢量三角形通杀「平抛+斜面/挡板」：位移三角形被几何约束锁定即得时间；tan速度角=2tan位移角 是平抛的通用恒等式。"),
        tags: ["平抛", "斜面", "压轴", "降维"])

    // 8. 圆环+平抛衔接 · 机械能守恒
    static let b9_circularDrop = PhysicsProblem(
        id: "b9_circular_drop", type: .calculation, stage: .senior, topic: .energy,
        content: "小球从高 h 处由静止沿光滑轨道滑下，进入半径 R 的竖直圆环内侧，恰好通过最高点后水平飞出（最高点离地 2R）。求 h 和落地点到最高点的水平距离。",
        answer: "h = 2.5R；水平距离 x = 2R", difficulty: 0.8, averageTime: 280,
        hints: ["「恰好通过」给出最高点速度", "之后是一段平抛"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "临界条件", formula: "mg = mv²/R ⟹ v = √(gR)", annotation: "内轨模型"),
            SolutionStep(order: 2, description: "机械能守恒定 h", formula: "mgh = mg·2R + ½mv² ⟹ h = 2R + R/2 = 2.5R", annotation: "首末态直达"),
            SolutionStep(order: 3, description: "平抛", formula: "2R = ½gt² ⟹ t = 2√(R/g)；x = √(gR)·t = 2R", annotation: ""),
        ], keyInsight: "压轴多过程题=几个单元模型串联：临界定速度、守恒定高度、平抛定落点。",
           commonMistakes: ["最高点速度取 0", "平抛高度用 h"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "逐段算速度：下滑段、圆环各点、抛出后", formula: "每段单独列式，中间量一大堆", annotation: "圆环上各点本不必算"),
            ], keyInsight: "逐段硬算。", commonMistakes: ["中间量传递出错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "临界翻译+守恒首末直达", formula: "v顶 = √(gR)；mgh = mg·2R + ½gR·m ⟹ h = 2.5R", annotation: "跳过整条轨道"),
                SolutionStep(order: 2, description: "平抛干净收尾", formula: "x = √(gR)·2√(R/g) = 2R", annotation: "结果只含 R"),
            ], keyInsight: "光滑轨道上「只问两点」就用机械能守恒直连——中间的弯弯绕绕一律无视。", commonMistakes: []),
            weaponUsed: .mechanicalEnergy, timeRatio: 3.0,
            detailedExplanation: "机械能守恒+临界条件是「轨道+圆环+平抛」串联压轴的标准拆法：守恒负责连接两点，临界负责提供锚定速度。"),
        tags: ["机械能守恒", "竖直圆周", "平抛", "压轴", "降维"])

    // 9. 弹簧分离临界
    static let b9_springSeparate = PhysicsProblem(
        id: "b9_spring_separate", type: .multipleChoice, stage: .senior, topic: .newton,
        content: "物块 A 叠放在 B 上，B 置于竖直轻弹簧顶端。向下压一段后由静止释放，系统向上运动。A 与 B 在什么位置分离？",
        options: ["弹簧最短处", "弹簧原长处（弹力为零的位置）", "系统速度最大处", "弹簧最长处"],
        answer: "弹簧原长处（弹力为零的位置）",
        difficulty: 0.75, averageTime: 130,
        hints: ["分离的瞬间 A、B 间压力 N=0", "N=0 时对 A 用牛顿第二定律，加速度是多少？"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "分离条件", formula: "N = 0 ⟹ A 只受重力 ⟹ a_A = g（向下）", annotation: ""),
            SolutionStep(order: 2, description: "分离瞬间仍共速共加速度", formula: "系统 a = g 向下 ⟹ 合外力=总重力 ⟹ 弹簧力 = 0 ⟹ 原长", annotation: ""),
        ], keyInsight: "叠放体分离 ⟺ N=0 ⟺ 共同加速度恰为只剩重力时的值。",
           commonMistakes: ["以为速度最大处分离（那是合力为零处）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "跟踪全程：各位置弹力、加速度、N 逐点分析", formula: "压缩段、原长、伸长段一一讨论", annotation: "全程跟踪工作量大"),
            ], keyInsight: "全程受力跟踪。", commonMistakes: ["在伸长段还假设 N>0"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "直奔临界：分离 ⟺ N=0 ⟺ a=g 向下", formula: "对系统：弹簧力=0 ⟹ 原长处", annotation: "三步等价变换，秒选"),
            ], keyInsight: "「何处分离」永远从 N=0 反推加速度，再反推位置——不必跟踪过程。", commonMistakes: []),
            weaponUsed: .criticalAnalysis, timeRatio: 3.0,
            detailedExplanation: "临界分析通杀分离问题：N=0 是唯一判据。同法可解「超重失重边界」「绳松弛瞬间」（注：若弹簧连着 B，分离点同样是 a=g 处即原长处；若弹簧只是垫着，结论相同）。"),
        tags: ["牛顿定律", "临界分析", "弹簧", "压轴", "降维"])

    // 10. 圆形磁场区 · 径向对称
    static let b9_radialField = PhysicsProblem(
        id: "b9_radial_field", type: .multipleChoice, stage: .senior, topic: .magnetic,
        content: "带电粒子沿直径方向（指向圆心）射入圆形匀强磁场区域，它将沿什么方向射出？",
        options: ["沿入射方向的延长线射出", "出射速度方向的反向延长线也过圆心（仍沿「径向」）",
                  "贴着边界绕场区转圈", "方向取决于电荷正负，无规律"],
        answer: "出射速度方向的反向延长线也过圆心（仍沿「径向」）",
        difficulty: 0.8, averageTime: 150,
        hints: ["画出圆弧轨迹的弦", "弦的两端点关于「圆心连线」对称"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "轨迹是圆弧，弦连接入射出射点", formula: "场区圆心与轨迹圆心的连线垂直平分这条弦", annotation: "两个圆的对称轴"),
            SolutionStep(order: 2, description: "对称性结论", formula: "入射沿径向 ⟹ 出射也沿径向（反向延长线过圆心）", annotation: "电荷正负只改变偏转左右，不破坏该对称"),
        ], keyInsight: "「沿径向进，必沿径向出」——圆形磁场区的对称美。",
           commonMistakes: ["误以为出射方向平行入射方向"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "设半径、圆心坐标，解轨迹圆与边界圆交点", formula: "两圆方程联立求出射点和切向", annotation: "解析几何计算量大"),
            ], keyInsight: "两圆联立硬解。", commonMistakes: ["几何关系搞错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "找对称轴：场区圆心与轨迹圆心的连线", formula: "入射径向线关于对称轴翻折 ⟹ 出射线也过圆心", annotation: "一条对称轴，秒选"),
            ], keyInsight: "两圆系统天然有对称轴——沿径向的性质在翻折下保持，无须任何坐标计算。", commonMistakes: []),
            weaponUsed: .symmetry, timeRatio: 5.0,
            detailedExplanation: "对称法通杀圆形磁场区：径向进⟹径向出；同理「平行束沿直径方向入射会聚于边界一点」等美妙结论都源自这条对称轴。"),
        tags: ["磁场", "圆形场区", "对称法", "压轴", "降维"])

    // 11. 图像交点的物理含义
    static let b9_graphCross = PhysicsProblem(
        id: "b9_graph_cross", type: .multipleChoice, stage: .senior, topic: .kinematics,
        content: "甲、乙两车沿同一直线同向行驶。关于运动图像的交点，下列正确的是？",
        options: ["x-t 图像的交点表示两车速度相等", "v-t 图像的交点表示两车相遇",
                  "x-t 图像的交点表示相遇；v-t 图像的交点表示速度相等（往往对应距离的极值）", "两种图像的交点含义相同"],
        answer: "x-t 图像的交点表示相遇；v-t 图像的交点表示速度相等（往往对应距离的极值）",
        difficulty: 0.65, averageTime: 90,
        hints: ["交点=纵坐标相等", "x 相等是相遇；v 相等是距离极值点"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "看纵轴是什么", formula: "x-t 交点：位置相同=相遇；v-t 交点：速度相同", annotation: ""),
            SolutionStep(order: 2, description: "速度相等的意义", formula: "同向追及中，v 相等时距离取极值（最大或最小）", annotation: ""),
        ], keyInsight: "图像交点只说明「纵坐标相等」——纵轴是 x 就是相遇，是 v 就是等速。",
           commonMistakes: ["把 v-t 交点当成相遇"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对每个选项写运动方程验证", formula: "设两车 x(t)、v(t) 逐项代数检验", annotation: "为概念题大动干戈"),
            ], keyInsight: "代数逐项验证。", commonMistakes: ["方程设错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "一句口诀裁决：交点=纵坐标相等", formula: "纵轴是 x ⟹ 相遇；纵轴是 v ⟹ 等速（距离极值）", annotation: "秒选"),
            ], keyInsight: "读图先读纵轴——「交点含义=纵轴量相等」一条规则通杀所有图像交点题。", commonMistakes: []),
            weaponUsed: .graphMethod, timeRatio: 2.5,
            detailedExplanation: "图像法的元规则：交点看纵轴、斜率看变化率、面积看累积量。三句话覆盖 x-t、v-t、a-t 的一切读图题。"),
        tags: ["运动学", "图像", "追及相遇", "压轴", "降维"])

    // 12. 机车启动 · 匀加速段的终点
    static let b9_powerStart = PhysicsProblem(
        id: "b9_power_start", type: .calculation, stage: .senior, topic: .energy,
        content: "质量 3 t 的机车额定功率 60 kW，阻力恒为 2000 N。它以 a=1 m/s² 匀加速启动，这一阶段最多能维持多久？",
        answer: "t = 12 s（末速度 12 m/s 时达到额定功率）", difficulty: 0.75, averageTime: 220,
        hints: ["匀加速段牵引力恒定 F = ma + f", "功率 P=Fv 随 v 增大，撞到额定值就结束"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "匀加速的牵引力", formula: "F = ma + f = 3000×1 + 2000 = 5000 N", annotation: "恒定"),
            SolutionStep(order: 2, description: "临界：功率达额定", formula: "v₁ = P额/F = 60000/5000 = 12 m/s", annotation: "不是 v_max=30 m/s！"),
            SolutionStep(order: 3, description: "时间", formula: "t = v₁/a = 12 s", annotation: ""),
        ], keyInsight: "匀加速段的终点是「P 撞上额定值」，远早于达到最大速度。",
           commonMistakes: ["用 v_max = P/f = 30 m/s 算时间"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "不设临界直接乱代公式", formula: "误把 v_max = P/f = 30 m/s 当匀加速末速度 ⟹ t=30 s（错）", annotation: "最常见的全军覆没点"),
            ], keyInsight: "不区分两个阶段就会代错速度。", commonMistakes: ["混淆 v₁ = P/F 与 v_max = P/f"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "先立临界：匀加速终点 ⟺ P=P额", formula: "v₁ = P额/(ma+f) = 12 m/s", annotation: "临界条件先行"),
                SolutionStep(order: 2, description: "时间一步", formula: "t = v₁/a = 12 s", annotation: "秒出"),
            ], keyInsight: "机车启动永远先画两阶段分界：v₁=P/F（匀加速尽头）、v_max=P/f（最终匀速）——临界先立，公式不乱。", commonMistakes: []),
            weaponUsed: .criticalAnalysis, timeRatio: 3.0,
            detailedExplanation: "临界分析通杀机车启动：两个特征速度 v₁ 与 v_max 一旦分清，恒加速段与恒功率段各自归位，再不会张冠李戴。"),
        tags: ["功率", "机车启动", "临界", "压轴", "降维"])

    // 13. 速度选择器 · 与电荷无关
    static let b9_velocitySelector = PhysicsProblem(
        id: "b9_velocity_selector", type: .multipleChoice, stage: .senior, topic: .magnetic,
        content: "速度选择器中 E、B 正交。关于能沿直线通过的粒子，下列正确的是？",
        options: ["只有正电荷能直线通过", "只有某一比荷的粒子能通过",
                  "速率恰为 v=E/B 的粒子都能通过，与电荷正负、电量、质量都无关", "速率越大越容易通过"],
        answer: "速率恰为 v=E/B 的粒子都能通过，与电荷正负、电量、质量都无关",
        difficulty: 0.7, averageTime: 110,
        hints: ["写出平衡条件 qE = qvB", "电荷反号时，两个力会怎样？"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "直线通过=两力平衡", formula: "qE = qvB ⟹ v = E/B", annotation: "q 约掉"),
            SolutionStep(order: 2, description: "反号检验", formula: "q→−q：电场力、洛伦兹力同时反向，平衡依旧", annotation: ""),
        ], keyInsight: "v=E/B 中没有 q 和 m——选择器选的是「速度」，不挑电荷。",
           commonMistakes: ["以为负电荷会被偏走"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对正负电荷分别画受力图判断", formula: "正电荷一张图、负电荷一张图，再比较", annotation: "两轮分析"),
            ], keyInsight: "分类逐画受力图。", commonMistakes: ["某一类的力方向画反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "看两个力的结构：F电=qE、F磁=qv×B 都正比于 q", formula: "q 反号 ⟹ 两力同时反向 ⟹ 平衡不破", annotation: "结构对称，免画第二张图"),
                SolutionStep(order: 2, description: "平衡式约掉 q", formula: "v = E/B，与 q、m 无关", annotation: "秒选"),
            ], keyInsight: "两个力同正比于 q ⟹ 平衡条件必然与 q 无关——看公式结构比画图快一倍。", commonMistakes: []),
            weaponUsed: .crossProduct, timeRatio: 2.5,
            detailedExplanation: "从 qE 与 qv×B 的结构看速度选择器：q 是公因子注定被约去。质谱仪、霍尔效应的「与电荷种类无关/有关」判断同此法。"),
        tags: ["磁场", "速度选择器", "压轴", "降维"])

    // 14. 理想变压器 · 因果方向
    static let b9_transformerDynamic = PhysicsProblem(
        id: "b9_transformer_dynamic", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "理想变压器原线圈接稳定正弦交流电源，副线圈接滑动变阻器。当变阻器阻值减小时，原线圈中的电流如何变化？",
        options: ["减小", "不变（原边由电源决定）", "增大", "先增大后减小"],
        answer: "增大",
        difficulty: 0.7, averageTime: 110,
        hints: ["电压由原边定（匝数比），电流由副边定（负载）", "P原 = P副"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电压链", formula: "U₂ = U₁·n₂/n₁ 不变", annotation: "U₁ 由电源锁定"),
            SolutionStep(order: 2, description: "电流链（从副边倒推）", formula: "R↓ ⟹ I₂ = U₂/R ↑ ⟹ P₂↑ = P₁ ⟹ I₁ = P₁/U₁ ↑", annotation: ""),
        ], keyInsight: "理想变压器：电压「从原到副」定，电流「从副到原」定——因果是倒着的。",
           commonMistakes: ["以为原边电流只由电源决定、恒定不变"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "顺着「电源→原边→副边」的直觉推", formula: "误以为 I₁ 先定 ⟹ 推不动或推错", annotation: "因果方向反了"),
            ], keyInsight: "顺推卡壳。", commonMistakes: ["认定原边电流恒定"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "逆向思维：从负载倒着推回电源", formula: "R↓ ⟹ I₂↑ ⟹ P₂↑ = P₁ ⟹ I₁↑", annotation: "「电压正着定、电流倒着定」秒出"),
            ], keyInsight: "变压器动态分析永远倒着走：负载是因、原边电流是果——逆向思维一步理顺。", commonMistakes: []),
            weaponUsed: .reverseThinking, timeRatio: 3.0,
            detailedExplanation: "逆向思维通杀变压器动态：U 由匝数比正向锁定、I 与 P 由负载反向决定。先写 U₂ 不变，再从 R 的变化一路倒推回 I₁。"),
        tags: ["交变电流", "变压器", "压轴", "降维"])

    // 15. 斜面往返 · 全程能量
    static let b9_roundTrip = PhysicsProblem(
        id: "b9_round_trip", type: .calculation, stage: .senior, topic: .energy,
        content: "物块以速度 v₀ 冲上倾角 45°、动摩擦因数 μ=0.5 的斜面，又滑回底端。求返回底端时速度与 v₀ 之比。",
        answer: "v/v₀ = √3/3 ≈ 0.58", difficulty: 0.8, averageTime: 260,
        hints: ["上滑、下滑的加速度不同", "或者：全程只有摩擦耗能，距离相同"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "上滑段（动能定理）", formula: "½mv₀² = mg(sinθ+μcosθ)s", annotation: "得 s"),
            SolutionStep(order: 2, description: "下滑段（动能定理）", formula: "½mv² = mg(sinθ−μcosθ)s", annotation: ""),
            SolutionStep(order: 3, description: "两式相除", formula: "v²/v₀² = (sinθ−μcosθ)/(sinθ+μcosθ) = (1−0.5)/(1+0.5) = 1/3", annotation: "θ=45° 时 sin=cos"),
        ], keyInsight: "上下行程相同 ⟹ 速度平方比 = 下滑净力/上滑净力。",
           commonMistakes: ["上下滑用同一个加速度"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "分上滑、下滑两段求加速度和速度", formula: "a上 = g(sinθ+μcosθ)；a下 = g(sinθ−μcosθ)；分别用 v²=2as", annotation: "两段四个量"),
            ], keyInsight: "分段运动学硬算。", commonMistakes: ["下滑加速度照抄上滑"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "全程动能定理一次记账", formula: "½mv² − ½mv₀² = −2μmg cosθ·s（重力做功抵消）", annotation: "往返高度差为零"),
                SolutionStep(order: 2, description: "与上滑式联立消 s", formula: "v²/v₀² = 1/3 ⟹ v = v₀√3/3", annotation: "比例直达"),
            ], keyInsight: "往返问题先看「重力净功为零」——全程账本里只剩摩擦一项，式子立刻减半。", commonMistakes: []),
            weaponUsed: .workEnergyTheorem, timeRatio: 2.5,
            detailedExplanation: "全程动能定理通杀往返/多段问题：保守力在闭合路径上净功为零，只剩耗散力项——段数越多优势越大。"),
        tags: ["动能定理", "斜面往返", "压轴", "降维"])

    // 16. 磁铁穿管 · 楞次定律
    static let b9_magnetTube = PhysicsProblem(
        id: "b9_magnet_tube", type: .multipleChoice, stage: .senior, topic: .induction,
        content: "一块强磁铁在竖直铜管（不闭合磁路，仅导电）内下落，与在同样尺寸塑料管中相比，它的下落明显变慢。最恰当的解释是？",
        options: ["铜管对磁铁有静磁吸引", "铜被磁化产生排斥",
                  "磁铁运动使管壁产生涡流，按楞次定律涡流的效果阻碍相对运动，磁铁受向上的磁阻力", "空气阻力在铜管中更大"],
        answer: "磁铁运动使管壁产生涡流，按楞次定律涡流的效果阻碍相对运动，磁铁受向上的磁阻力",
        difficulty: 0.65, averageTime: 100,
        hints: ["铜不是铁磁体，不会被吸住", "想想能量去了哪里"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "磁通变化产生涡流", formula: "磁铁穿过 ⟹ 管壁各环路磁通变化 ⟹ 感应涡流", annotation: ""),
            SolutionStep(order: 2, description: "楞次定律", formula: "涡流效果阻碍相对运动 ⟹ 向上阻力 ⟹ a < g", annotation: "损失的机械能变为管壁焦耳热"),
        ], keyInsight: "楞次定律的宏观表述：感应效果总是「阻碍相对运动」——下落变慢、能量变热。",
           commonMistakes: ["以为铜管吸磁铁（铜非铁磁体）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想算涡流的分布和受力", formula: "管壁每个环的感应电流+安培力叠加", annotation: "分布复杂，高中卡壳"),
            ], keyInsight: "涡流细节硬算。", commonMistakes: ["陷入电流分布细节"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "楞次一句话：阻碍相对运动", formula: "磁铁下落 ⟹ 必受向上磁阻力 ⟹ 变慢", annotation: "效果先行，细节免算"),
                SolutionStep(order: 2, description: "能量印证", formula: "减少的机械能 = 管壁焦耳热", annotation: "秒选"),
            ], keyInsight: "楞次定律给「效果」不给「细节」——只问快慢/方向/能量去向的题，一句「阻碍」全部拿下。", commonMistakes: []),
            weaponUsed: .lenzRule, timeRatio: 4.0,
            detailedExplanation: "楞次定则速判通杀涡流类现象：磁铁穿管、电磁阻尼摆、磁悬浮刹车——「阻碍相对运动+机械能变焦耳热」两句话讲完。"),
        tags: ["电磁感应", "涡流", "楞次定律", "压轴", "降维"])

    // 17. 动态电路 · 极端值
    static let b9_circuitDynamic = PhysicsProblem(
        id: "b9_circuit_dynamic", type: .multipleChoice, stage: .senior, topic: .circuit,
        content: "电路中电源（E、内阻 r）与定值电阻 R₁、滑动变阻器 R₂ 串联，电压表测 R₁ 两端电压。R₂ 的阻值增大时，电压表读数如何变化？",
        options: ["增大", "减小", "不变", "先增后减"],
        answer: "减小",
        difficulty: 0.6, averageTime: 90,
        hints: ["试试 R₂ 取两个极端值", "R₂→∞ 时电路相当于断路"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "电流", formula: "I = E/(R₁+R₂+r)，R₂↑ ⟹ I↓", annotation: ""),
            SolutionStep(order: 2, description: "电压表读数", formula: "U₁ = IR₁ ⟹ 随 I 减小", annotation: "「串反」"),
        ], keyInsight: "与变阻器串联的元件，电压随变阻器增大而减小（串反并同）。",
           commonMistakes: ["以为总电压不变则各处电压不变"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "列闭合电路欧姆定律推单调性", formula: "I = E/(R₁+R₂+r) ⟹ U₁ = ER₁/(R₁+R₂+r)", annotation: "公式推导，链条易反"),
            ], keyInsight: "解析式推单调。", commonMistakes: ["分式增减方向看错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "取极端：R₂→∞（断路）", formula: "I = 0 ⟹ U₁ = 0", annotation: "一个端点见底"),
                SolutionStep(order: 2, description: "单调性收尾", formula: "R₂ 增大的尽头是 U₁=0 ⟹ 一路减小", annotation: "秒选"),
            ], keyInsight: "动态电路选择题先代「断路/短路」两个免费端点——单调结论由端点直接夹出。", commonMistakes: []),
            weaponUsed: .specialCase, timeRatio: 3.0,
            detailedExplanation: "特殊值法是动态电路的快刀，与口诀「串反并同」互为印证；遇到非单调情形（如电源输出功率）端点法还能提示极值的存在。"),
        tags: ["电路", "动态分析", "压轴", "降维"])

    // 18. 近地卫星测密度
    static let b9_satelliteDensity = PhysicsProblem(
        id: "b9_satellite_density", type: .calculation, stage: .senior, topic: .circular,
        content: "测得某行星近地卫星的周期为 T。仅用 T 和引力常量 G，求该行星的平均密度。",
        answer: "ρ = 3π/(GT²)", difficulty: 0.75, averageTime: 200,
        hints: ["近地轨道半径≈行星半径 R", "M = ρ·(4/3)πR³，看看 R 会不会约掉"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "引力提供向心力", formula: "GMm/R² = m(2π/T)²R ⟹ M = 4π²R³/(GT²)", annotation: "近地 r≈R"),
            SolutionStep(order: 2, description: "代入密度定义", formula: "ρ = M/[(4/3)πR³] = 3π/(GT²)", annotation: "R³ 恰好约掉"),
        ], keyInsight: "近地卫星周期只由行星密度决定——R 注定被约去。",
           commonMistakes: ["卡在「不知道 R」"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "以为必须先查出 R 和 M", formula: "缺数据 ⟹ 误以为题目条件不足", annotation: "没发现 R 会约掉"),
            ], keyInsight: "被「缺 R」吓住。", commonMistakes: ["中途放弃"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "量纲预判：G（m³·kg⁻¹·s⁻²）×ρ（kg·m⁻³）= s⁻²", formula: "Gρ ~ 1/T² ⟹ ρ ∝ 1/(GT²)", annotation: "形式已定，R 必然不出场"),
                SolutionStep(order: 2, description: "动力学补系数", formula: "ρ = 3π/(GT²)", annotation: "秒出"),
            ], keyInsight: "Gρ 的量纲恰是 1/时间²——「近地周期只认密度」是量纲注定的，做题前就能预言答案的形状。", commonMistakes: []),
            weaponUsed: .dimensionalAnalysis, timeRatio: 3.5,
            detailedExplanation: "量纲分析预判结果形式：ρ=3π/(GT²) 只含 G、T。这也解释了为何各行星的近地卫星周期都约 90 分钟量级——岩石密度相近。系数 3π 仍须动力学给出。"),
        tags: ["万有引力", "行星密度", "压轴", "降维"])

    // 19. 电梯超重失重 · v-t 图
    static let b9_elevatorGraph = PhysicsProblem(
        id: "b9_elevator_graph", type: .multipleChoice, stage: .senior, topic: .newton,
        content: "电梯先向上加速、再匀速、最后减速停下。站在电梯里体重计上的人，三段读数依次是？",
        options: ["大、正常、大", "大、正常、小", "小、正常、大", "三段都正常"],
        answer: "大、正常、小",
        difficulty: 0.6, averageTime: 80,
        hints: ["读数看加速度方向，不看运动方向", "向上加速与向下减速都是超重"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "三段加速度", formula: "向上加速 a↑；匀速 a=0；向上减速 a↓", annotation: ""),
            SolutionStep(order: 2, description: "牛顿第二定律", formula: "N = m(g+a)：a 向上超重、a=0 正常、a 向下失重", annotation: "大、正常、小"),
        ], keyInsight: "超失重只看加速度方向：a 向上=超重，a 向下=失重，与速度方向无关。",
           commonMistakes: ["按「上升=超重、下降=失重」判断"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "三段分别画受力图列方程", formula: "N₁−mg=ma；N₂=mg；mg−N₃=ma", annotation: "三张图三组式"),
            ], keyInsight: "逐段受力分析。", commonMistakes: ["减速段方向设反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "在 v-t 图上读斜率", formula: "斜率正 ⟹ a 向上 ⟹ 超重；零 ⟹ 正常；负 ⟹ 失重", annotation: "图一画，三段秒判"),
            ], keyInsight: "把超失重判断绑定到 v-t 图斜率——「斜率向上超重、向下失重」一条规则扫平全部分段题。", commonMistakes: []),
            weaponUsed: .graphMethod, timeRatio: 2.5,
            detailedExplanation: "图像法处理超失重：斜率即加速度即视重偏向。多段电梯、蹦极、火箭题都先画 v-t 图再逐段读斜率。"),
        tags: ["牛顿定律", "超重失重", "压轴", "降维"])

    // 20. 渡河最短航程 · 矢量圆
    static let b9_riverShortest = PhysicsProblem(
        id: "b9_river_shortest", type: .calculation, stage: .senior, topic: .kinematics,
        content: "河宽 d，水流速度 5 m/s，船在静水中速度只有 3 m/s。怎样开能使航程最短？最短航程是多少？",
        answer: "船头朝上游、与河岸成 53°（cos53°=3/5）；最短航程 5d/3", difficulty: 0.85, averageTime: 300,
        hints: ["船速小于水速，永远无法垂直过河", "把船速矢量的端点画成一个圆"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "矢量圆", formula: "合速度 = 水速(定) + 船速(大小定方向任意) ⟹ 端点在半径 3 的圆上", annotation: "圆心在水速矢量端点"),
            SolutionStep(order: 2, description: "航程最短 ⟺ 合速度与岸夹角最大 ⟺ 合速度沿圆的切线", formula: "sinθ_max = 3/5", annotation: "从原点向圆作切线"),
            SolutionStep(order: 3, description: "几何收尾", formula: "航程 s = d/sinθ_max = 5d/3；切点几何给出船头与上游成 53°", annotation: "此时合速度大小 4 m/s"),
        ], keyInsight: "船速<水速时航程最短的条件：合速度方向与「船速圆」相切。",
           commonMistakes: ["以为船头垂直对岸航程最短（那只在船速>水速时给最短时间）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "设船头角 α，写出航程函数", formula: "s(α) = d·√(v水²+v船²+2v水v船cosα…)/(v船sinα)", annotation: "表达式冗长"),
                SolutionStep(order: 2, description: "求导找极值", formula: "ds/dα = 0 解三角方程", annotation: "运算量很大"),
            ], keyInsight: "解析法求导硬算。", commonMistakes: ["求导化简出错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "画矢量圆，从原点作切线", formula: "sinθ_max = v船/v水 = 3/5", annotation: "极值=切线，免求导"),
                SolutionStep(order: 2, description: "直角三角形读数", formula: "s = d/(3/5) = 5d/3；船头与上游成 53°", annotation: "3-4-5 直角三角形全给出"),
            ], keyInsight: "「一个矢量定、一个矢量大小定」的极值问题=圆与切线的几何——求导被一根切线取代。", commonMistakes: []),
            weaponUsed: .extremumPrinciple, timeRatio: 5.0,
            detailedExplanation: "极值原理的几何化身「矢量圆+切线」通杀：小船渡河（v船<v水）、最小起跳速度、追击最短距离——凡「方向自由、大小受限」的最值都适用。"),
        tags: ["运动学", "渡河模型", "极值", "压轴", "降维"])
}
