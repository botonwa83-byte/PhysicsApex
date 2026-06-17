import Foundation

// MARK: - 练习 Batch 1：运动学 & 力（13 题）
// 放在 extension 里分文件管理；ProblemBank.all 引用这些 static let（非内联，避免编译器超时）。

extension ProblemBank {

    static let batch1: [PhysicsProblem] = [
        b1_accelDirection, b1_uniformAccel, b1_freeFall, b1_braking, b1_vtGraph,
        b1_uniformMotion, b1_chase, b1_balance, b1_inclineVariant, b1_elevator,
        b1_connector, b1_newton3, b1_frictionDir,
    ]

    // 1
    static let b1_accelDirection = PhysicsProblem(
        id: "b1_accel_dir", type: .multipleChoice, stage: .junior, topic: .kinematics,
        content: "关于速度和加速度，下列说法正确的是？",
        options: ["加速度方向一定和速度方向相同", "物体减速时，加速度方向与速度方向相反",
                  "速度为零时加速度一定为零", "速度越大，加速度一定越大"],
        answer: "物体减速时，加速度方向与速度方向相反",
        difficulty: 0.3, averageTime: 40,
        hints: ["加速度是速度的变化率", "减速 = 速度在减小"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "加速度反映速度怎么变", formula: "a = Δv/Δt", annotation: "与速度大小无必然关系"),
            SolutionStep(order: 2, description: "减速时速度减小", formula: "Δv 与 v 反向 ⟹ a 与 v 反向", annotation: ""),
        ], keyInsight: "加速度方向由「速度怎么变」决定，不是由速度方向决定。",
           commonMistakes: ["把加速度方向当成速度方向"]),
        misconceptions: [
            Misconception(option: "速度为零时加速度一定为零",
                youThought: "你大概觉得不动了就没有加速度。",
                pitfall: "竖直上抛到最高点时速度为零，但加速度仍是 g，向下。",
                fix: "速度和加速度是两回事，速度为零加速度可以不为零。")
        ], tags: ["运动学", "加速度", "错因诊断"])

    // 2
    static let b1_uniformAccel = PhysicsProblem(
        id: "b1_uniform_accel", type: .calculation, stage: .senior, topic: .kinematics,
        content: "一物体做初速度 v₀=2 m/s、加速度 a=3 m/s² 的匀加速直线运动。求 4 s 末的速度和这 4 s 内的位移。",
        answer: "v = 14 m/s；x = 32 m", difficulty: 0.4, averageTime: 90,
        hints: ["v=v₀+at", "x=v₀t+½at²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "末速度", formula: "v = 2 + 3×4 = 14 m/s", annotation: ""),
            SolutionStep(order: 2, description: "位移", formula: "x = 2×4 + ½×3×16 = 32 m", annotation: ""),
        ], keyInsight: "匀变速三公式，缺谁选谁。", commonMistakes: ["½at² 漏掉 ½"]),
        tags: ["运动学", "匀变速"])

    // 3
    static let b1_freeFall = PhysicsProblem(
        id: "b1_free_fall", type: .calculation, stage: .senior, topic: .kinematics,
        content: "从塔顶自由释放一个小球，2 s 后落地。求塔高和落地速度。(g=10 m/s²)",
        answer: "h = 20 m；v = 20 m/s", difficulty: 0.35, averageTime: 80,
        hints: ["自由落体初速度为零", "h=½gt²，v=gt"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "塔高", formula: "h = ½×10×2² = 20 m", annotation: ""),
            SolutionStep(order: 2, description: "落地速度", formula: "v = gt = 20 m/s", annotation: ""),
        ], keyInsight: "自由落体 = 初速为零的匀加速。", commonMistakes: ["把 h 算成 vt"]),
        tags: ["运动学", "自由落体"])

    // 4
    static let b1_braking = PhysicsProblem(
        id: "b1_braking", type: .calculation, stage: .senior, topic: .kinematics,
        content: "汽车以 20 m/s 行驶，刹车后做加速度大小为 5 m/s² 的匀减速运动。求刹车后 6 s 内汽车滑行的距离。",
        answer: "40 m（4 s 即停，后 2 s 不动）", difficulty: 0.55, averageTime: 120,
        hints: ["先算刹停需要多久", "停下后不会倒车"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "刹停时间", formula: "t停 = v₀/a = 20/5 = 4 s", annotation: "小于 6 s"),
            SolutionStep(order: 2, description: "只算 4 s 内位移", formula: "x = v₀²/(2a) = 400/10 = 40 m", annotation: "后 2 s 静止"),
        ], keyInsight: "刹车类问题先判断是否已停，停了就别再代 6 s。",
           commonMistakes: ["直接代 t=6 s，得出错误（甚至倒车）的结果"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "先算刹停时间再判断", formula: "t停=v₀/a=4 s < 6 s", annotation: "必须先排掉 t=6 s 的陷阱"),
                SolutionStep(order: 2, description: "代位移公式", formula: "x=v₀t停−½at停²=80−40=40 m", annotation: "两项相减易错"),
            ], keyInsight: "正向硬算，公式两项相减。", commonMistakes: ["漏判刹停时间直接代 6 s"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "时间倒放：刹车的逆过程是初速为零的匀加速", formula: "x=½at停²=½×5×4²=40 m", annotation: "一步，只有一项"),
            ], keyInsight: "末态简单（v=0）就倒过来看——逆向思维把减速题变成自由落体式的简单题。", commonMistakes: []),
            weaponUsed: .reverseThinking, timeRatio: 3.0,
            detailedExplanation: "凡是末速度为零的匀减速（刹车、竖直上抛末段），倒放都是初速为零的匀加速，公式从两项变一项。",
            plainTalk: "汽车刹车到停，倒过来放就是一辆车从静止起步加速——而初速为零的运动最好算。先确认 4 秒就停了（6 秒是出题人挖的坑），再把这段倒着看：x=½at²，一项搞定，比正着算两项相减舒服多了。"),
        misconceptions: [
            Misconception(option: "",
                youThought: "直接把 t=6 s 代进 x=v₀t−½at² 会算出 60 m。",
                pitfall: "车 4 s 就停了，6 s 的公式相当于让它倒车，不符合实际。",
                fix: "先求刹停时间 4 s，只算这段：x=v₀²/2a=40 m。")
        ], tags: ["运动学", "刹车陷阱", "降维"])

    // 5
    static let b1_vtGraph = PhysicsProblem(
        id: "b1_vt_graph", type: .multipleChoice, stage: .senior, topic: .kinematics,
        content: "关于速度—时间（v-t）图象，下列说法正确的是？",
        options: ["图线的斜率表示位移", "图线与时间轴围成的面积表示位移",
                  "图线越高，加速度越大", "水平的图线表示物体静止"],
        answer: "图线与时间轴围成的面积表示位移",
        difficulty: 0.4, averageTime: 50, hints: ["斜率是什么？面积是什么？"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "斜率 = 加速度", formula: "Δv/Δt", annotation: ""),
            SolutionStep(order: 2, description: "面积 = 位移", formula: "v·t 累积", annotation: "水平线表示匀速"),
        ], keyInsight: "v-t 图：斜率是加速度，面积是位移。",
           commonMistakes: ["把斜率当位移", "把水平线当静止（其实是匀速）"]),
        misconceptions: [
            Misconception(option: "水平的图线表示物体静止",
                youThought: "你大概觉得图线不上不下就是不动。",
                pitfall: "v-t 图里水平线表示速度恒定，是匀速运动，不是静止。",
                fix: "静止是 v=0（贴着时间轴）；水平线在高处是匀速。")
        ], tags: ["运动学", "图象法", "错因诊断"])

    // 6
    static let b1_uniformMotion = PhysicsProblem(
        id: "b1_uniform_motion", type: .multipleChoice, stage: .junior, topic: .kinematics,
        content: "下列关于匀速直线运动的说法，正确的是？",
        options: ["速度越来越大", "相等时间内通过的路程相等",
                  "一定受到力的作用才能维持", "加速度恒定且不为零"],
        answer: "相等时间内通过的路程相等",
        difficulty: 0.2, averageTime: 35, hints: ["匀速 = 速度不变"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "匀速特征", formula: "v 恒定，a = 0", annotation: "等时等距"),
        ], keyInsight: "匀速直线运动速度不变、加速度为零，不需要力维持。",
           commonMistakes: ["以为运动需要力维持"]),
        tags: ["运动学", "匀速运动"])

    // 7
    static let b1_chase = PhysicsProblem(
        id: "b1_chase", type: .calculation, stage: .senior, topic: .kinematics,
        content: "汽车以 10 m/s 匀速经过路口，同时一辆摩托车从路口由静止以 2 m/s² 匀加速追赶。求摩托车追上汽车所需时间。",
        answer: "t = 10 s", difficulty: 0.5, averageTime: 120,
        hints: ["追上时两者位移相等", "汽车 x=vt，摩托 x=½at²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "位移相等", formula: "10t = ½×2×t²", annotation: ""),
            SolutionStep(order: 2, description: "解得", formula: "t = 10 s（t=0 舍去）", annotation: "追上"),
        ], keyInsight: "追及问题的核心：追上瞬间位移相等。",
           commonMistakes: ["用速度相等当追上条件（那是距离最大）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "列位移方程并解二次方程", formula: "10t=½×2×t² ⟹ t²−10t=0", annotation: "需解方程并讨论舍根"),
            ], keyInsight: "代数硬解，注意舍去 t=0。", commonMistakes: ["误用速度相等当追上条件"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "画 v-t 图：汽车水平线、摩托过原点斜线", formula: "5 s 两线相交（速度相等，差距最大）", annotation: "图一画陷阱自动现形"),
                SolutionStep(order: 2, description: "追上=两图线下面积相等", formula: "对称性：交点在 5 s ⟹ 面积相等在 t=10 s", annotation: "秒读"),
            ], keyInsight: "v-t 图上面积就是位移——追及相遇问题画图比列式快，还自带「速度相等≠追上」的免疫力。", commonMistakes: []),
            weaponUsed: .graphMethod, timeRatio: 2.5,
            detailedExplanation: "图像法通杀追及相遇：交点定「差距最大」，面积相等定「追上」，二次方程根本不用解。",
            plainTalk: "画 v-t 图：汽车是一条水平线，摩托是从原点爬升的斜线，线下面积就是各自跑的路。两线在 5 秒交叉——那是差距最大的时刻，不是追上！等摩托的三角形面积追平汽车的矩形面积才算追上：10 秒，图上一眼读出。"),
        tags: ["运动学", "追及相遇", "降维"])

    // 8
    static let b1_balance = PhysicsProblem(
        id: "b1_balance", type: .multipleChoice, stage: .junior, topic: .newton,
        content: "一个木块静止放在水平桌面上。关于二力平衡，下列说法正确的是？",
        options: ["木块受的重力和桌面的支持力是一对平衡力", "木块受的重力和木块对桌面的压力是平衡力",
                  "桌面支持力大于木块的重力", "木块不受力"],
        answer: "木块受的重力和桌面的支持力是一对平衡力",
        difficulty: 0.3, averageTime: 45, hints: ["平衡力作用在同一物体上", "压力作用在桌面上，不在木块上"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "二力平衡", formula: "G = N（作用在木块上）", annotation: "等大反向共线同体"),
        ], keyInsight: "平衡力作用在同一物体上；压力作用在桌面，不能和木块的重力平衡。",
           commonMistakes: ["把作用力反作用力当成平衡力"]),
        misconceptions: [
            Misconception(option: "木块受的重力和木块对桌面的压力是平衡力",
                youThought: "你大概觉得重力和压力等大反向就是平衡力。",
                pitfall: "压力作用在桌面上，不作用在木块上——平衡力必须作用在同一物体。",
                fix: "和重力平衡的是桌面对木块的支持力（都作用在木块上）。")
        ], tags: ["力", "二力平衡", "错因诊断"])

    // 9
    static let b1_inclineVariant = PhysicsProblem(
        id: "b1_incline_var", type: .calculation, stage: .senior, topic: .newton,
        content: "质量 2 kg 的物体在水平面上受到 10 N 水平拉力，动摩擦因数 μ=0.2。求物体的加速度。(g=10 m/s²)",
        answer: "a = 3 m/s²", difficulty: 0.45, averageTime: 100,
        hints: ["先求摩擦力 f=μmg", "牛顿第二定律 F−f=ma"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "摩擦力", formula: "f = μmg = 0.2×2×10 = 4 N", annotation: ""),
            SolutionStep(order: 2, description: "加速度", formula: "a = (F−f)/m = (10−4)/2 = 3 m/s²", annotation: ""),
        ], keyInsight: "水平面：合力 = 拉力 − 摩擦力。", commonMistakes: ["摩擦力用错正压力"]),
        tags: ["牛顿定律", "摩擦力"])

    // 10
    static let b1_elevator = PhysicsProblem(
        id: "b1_elevator", type: .calculation, stage: .senior, topic: .newton,
        content: "质量 50 kg 的人站在电梯里，电梯以 2 m/s² 的加速度竖直加速上升。求电梯地板对人的支持力。(g=10 m/s²)",
        answer: "N = 600 N（超重）", difficulty: 0.5, averageTime: 110,
        hints: ["对人用牛顿第二定律", "向上为正：N−mg=ma"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "牛顿第二定律", formula: "N − mg = ma", annotation: "加速度向上"),
            SolutionStep(order: 2, description: "解出", formula: "N = m(g+a) = 50×12 = 600 N", annotation: "大于重力 → 超重"),
        ], keyInsight: "加速上升 → 支持力大于重力（超重）。",
           commonMistakes: ["以为超重是重力变大（其实重力不变，是支持力变大）"]),
        tags: ["牛顿定律", "超重失重"])

    // 11
    static let b1_connector = PhysicsProblem(
        id: "b1_connector", type: .calculation, stage: .senior, topic: .newton,
        content: "光滑水平面上，质量 m₁=1 kg 和 m₂=2 kg 的两物块用轻绳相连，对 m₂ 施加水平拉力 F=6 N。求系统加速度和绳中张力。",
        answer: "a = 2 m/s²；T = 2 N", difficulty: 0.55, averageTime: 140,
        hints: ["整体求加速度", "隔离 m₁ 求张力"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "整体法求加速度", formula: "a = F/(m₁+m₂) = 6/3 = 2 m/s²", annotation: ""),
            SolutionStep(order: 2, description: "隔离 m₁ 求张力", formula: "T = m₁a = 1×2 = 2 N", annotation: ""),
        ], keyInsight: "连接体：整体求 a，隔离求内力。", commonMistakes: ["对整体用内力求 a"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "分别对 m₁、m₂ 列方程联立", formula: "T=m₁a；F−T=m₂a", annotation: "两个未知数两个方程"),
            ], keyInsight: "联立方程组求解。", commonMistakes: ["方程符号错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "整体隔离法：先整体 a=F/(m₁+m₂)", formula: "a=2 m/s²", annotation: "一步"),
                SolutionStep(order: 2, description: "再隔离 m₁", formula: "T=m₁a=2 N", annotation: "一步"),
            ], keyInsight: "整体求加速度、隔离求内力——连接体的固定套路。", commonMistakes: []),
            weaponUsed: .wholeIsolation, timeRatio: 2.0,
            detailedExplanation: "整体隔离法把联立方程拆成两个一步小算：整体定 a、隔离定内力。",
            plainTalk: "把两个木块当一个整体看——绳子是「自家人」，内力不用管，总力除以总质量就是加速度。想知道绳的拉力？再单独拎出前面那个小木块：拉它的只有绳子，m×a 就是绳的力。先全家福、后单人照，两步搞定。"),
        tags: ["牛顿定律", "连接体", "整体隔离法"])

    // 12
    static let b1_newton3 = PhysicsProblem(
        id: "b1_newton3", type: .multipleChoice, stage: .senior, topic: .newton,
        content: "鸡蛋撞在石头上碎了，石头没事。关于鸡蛋对石头的力 F₁ 和石头对鸡蛋的力 F₂，下列正确的是？",
        options: ["F₂ 大于 F₁，所以鸡蛋碎了", "F₁ 大于 F₂", "F₁ 和 F₂ 大小相等", "无法比较"],
        answer: "F₁ 和 F₂ 大小相等",
        difficulty: 0.4, averageTime: 50, hints: ["作用力与反作用力", "碎不碎看能否承受，不看力的大小"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "牛顿第三定律", formula: "F₁ = F₂（等大反向）", annotation: "总是相等"),
            SolutionStep(order: 2, description: "碎不碎", formula: "看材料能否承受", annotation: "鸡蛋脆所以碎"),
        ], keyInsight: "作用力与反作用力总是等大反向；碎不碎取决于材料强度，与力大小无关。",
           commonMistakes: ["以为谁碎了谁受的力就大"]),
        misconceptions: [
            Misconception(option: "F₂ 大于 F₁，所以鸡蛋碎了",
                youThought: "你大概觉得鸡蛋碎了，说明它受的力更大。",
                pitfall: "作用力与反作用力永远等大反向，与谁碎了无关。",
                fix: "F₁=F₂；鸡蛋碎是因为它脆、承受不住，不是因为受力更大。")
        ], tags: ["牛顿定律", "作用反作用", "错因诊断"])

    // 13
    static let b1_frictionDir = PhysicsProblem(
        id: "b1_friction_dir", type: .multipleChoice, stage: .junior, topic: .newton,
        content: "人走路时，脚相对地面有向后蹬的趋势。此时地面对脚的摩擦力方向是？",
        options: ["向后", "向前", "向下", "没有摩擦力"],
        answer: "向前",
        difficulty: 0.35, averageTime: 45, hints: ["摩擦力阻碍相对运动趋势", "脚向后蹬 → 摩擦力向前"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "判断相对趋势", formula: "脚相对地面有向后趋势", annotation: ""),
            SolutionStep(order: 2, description: "摩擦力反趋势", formula: "摩擦力向前 → 推人前进", annotation: ""),
        ], keyInsight: "静摩擦力方向与「相对运动趋势」相反——走路正是靠它向前推。",
           commonMistakes: ["以为摩擦力总是阻碍运动、应向后"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "凭空想象「相对运动趋势」的方向", formula: "脚相对地面趋势向后 ⟹ 摩擦力向前", annotation: "趋势看不见摸不着，容易想反"),
            ], keyInsight: "直接判断趋势方向。", commonMistakes: ["把「人向前走」当成趋势向前"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "假设地面光滑：脚会向哪打滑？", formula: "光滑 ⟹ 脚向后滑（原地蹬空）", annotation: "打滑方向=趋势方向"),
                SolutionStep(order: 2, description: "静摩擦阻碍此趋势", formula: "摩擦力向前", annotation: "秒选"),
            ], keyInsight: "趋势想不出来就假设接触面光滑，看物体往哪滑——滑动方向就是趋势方向。", commonMistakes: []),
            weaponUsed: .assumption, timeRatio: 2.0,
            detailedExplanation: "假设法把看不见的「趋势」变成看得见的「打滑」，静摩擦方向判断一律适用。",
            plainTalk: "搞不清摩擦力朝哪？做个假想推演：假设地面突然变成溜冰场——你蹬地的脚会向后打滑。摩擦力的职责就是阻止打滑，所以它向前推你。没错，是摩擦力推着你走路。"),
        misconceptions: [
            Misconception(option: "向后",
                youThought: "你大概觉得摩擦力总是「拖后腿」，方向向后。",
                pitfall: "脚向后蹬地，相对趋势向后，摩擦力就反过来向前。正是它推着你走。",
                fix: "静摩擦反的是「相对趋势」，不是反「运动方向」——这里向前。")
        ], tags: ["力", "摩擦力方向", "错因诊断", "降维"])
}
