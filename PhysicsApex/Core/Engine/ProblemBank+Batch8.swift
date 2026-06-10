import Foundation

// MARK: - 题库 Batch 8：竞赛段（15 题，全部 .olympiad）
// 定位：高考压轴题的「竞赛视角」——守恒·对称·微元·量纲·极值，难度封顶在"够用应付高考"。
// 每题配降维双解；本批为 approximation/angularMomentum/virtualWork/imageCharge/potentialCurve/scaling/equivalentCircuit 七把武器建立首战例。

extension ProblemBank {

    static let batch8: [PhysicsProblem] = [
        g8_ellipseSpeed, g8_skaterSpin, g8_minForceAngle, g8_chainPull, g8_pulleyVirtual,
        g8_potentialWell, g8_scalingJump, g8_gravityHeight, g8_centripetalDerive, g8_firstCosmic,
        g8_rainFrame, g8_imageCharge, g8_infiniteLadder, g8_cubeResistor, g8_fermatReflect,
    ]

    // 1. 角动量守恒 · 椭圆轨道
    static let g8_ellipseSpeed = PhysicsProblem(
        id: "g8_ellipse_speed", type: .calculation, stage: .olympiad, topic: .circular,
        content: "卫星沿椭圆轨道绕地球运行，近地点到地心距离 r₁，远地点到地心距离 r₂。求近地点与远地点速度之比 v₁:v₂。",
        answer: "v₁:v₂ = r₂:r₁（近地点快、远地点慢）", difficulty: 0.75, averageTime: 180,
        hints: ["引力指向地心，对地心力矩为零", "开普勒第二定律的本质就是角动量守恒"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "引力始终指向地心 ⟹ 对地心无力矩", formula: "L = mvr = 常量", annotation: "近远地点速度恰好垂直矢径"),
            SolutionStep(order: 2, description: "两点对比", formula: "mv₁r₁ = mv₂r₂ ⟹ v₁/v₂ = r₂/r₁", annotation: ""),
        ], keyInsight: "有心力对力心无力矩，角动量守恒——开普勒第二定律（等面积）由此而来。",
           commonMistakes: ["误用 v=√(GM/r)（那是圆轨道公式，椭圆不适用）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想用机械能守恒求两点速度", formula: "½mv₁²−GMm/r₁ = ½mv₂²−GMm/r₂", annotation: "一个方程两个未知数，单独解不出"),
            ], keyInsight: "能量守恒单独不够，还缺一个方程。", commonMistakes: ["对椭圆轨道误用圆轨道公式"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "引力是有心力，对地心力矩为零 ⟹ 角动量守恒", formula: "mv₁r₁ = mv₂r₂", annotation: "近远地点 v⊥r，表达式最简"),
                SolutionStep(order: 2, description: "一步出比值", formula: "v₁/v₂ = r₂/r₁", annotation: "秒出"),
            ], keyInsight: "只问「近远地点速度之比」，角动量守恒一个式子封顶——能量方程根本不用列。", commonMistakes: []),
            weaponUsed: .angularMomentum, timeRatio: 4.0,
            detailedExplanation: "角动量守恒通杀椭圆轨道两端点问题：mvr 守恒只在速度垂直矢径的近/远地点取最简形式，这正是高考天体压轴最爱考的两个点。",
            plainTalk: "地球拉卫星的引力永远指向地心，像一根拴着链球的绳——这种「指向一点」的力没法改变卫星绕这一点的「转动冲劲」mvr。近地点 r 小，v 就得大；远地点 r 大，v 就小。mv₁r₁=mv₂r₂，比例一翻就完。"),
        tags: ["万有引力", "椭圆轨道", "角动量守恒", "降维", "竞赛"])

    // 2. 角动量守恒 · 转动直觉
    static let g8_skaterSpin = PhysicsProblem(
        id: "g8_skater_spin", type: .multipleChoice, stage: .olympiad, topic: .momentum,
        content: "花样滑冰运动员旋转中收拢双臂，转速明显变快。最恰当的解释是？",
        options: ["收臂时肌肉做功直接增大了转速，与守恒律无关",
                  "冰面摩擦力矩使她加速",
                  "无外力矩时角动量 L=Iω 守恒，收臂使转动惯量 I 减小，故 ω 增大",
                  "收臂减小了空气阻力"],
        answer: "无外力矩时角动量 L=Iω 守恒，收臂使转动惯量 I 减小，故 ω 增大",
        difficulty: 0.65, averageTime: 70,
        hints: ["冰面近似无摩擦力矩", "质量分布离轴越近，转动惯量越小"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "外力矩近似为零", formula: "L = Iω = 常量", annotation: ""),
            SolutionStep(order: 2, description: "收臂", formula: "I↓ ⟹ ω↑", annotation: "肌肉做的功变成转动动能的增量"),
        ], keyInsight: "角动量守恒：质量收向转轴，转速自动上升——和跳水抱膝翻腾同理。",
           commonMistakes: ["以为转速变化必须有外力矩"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想逐块分析手臂受力和力矩", formula: "每块肌肉的内力分析", annotation: "内力错综复杂，高中工具解不动"),
            ], keyInsight: "内力分析无从下手。", commonMistakes: ["在内力细节里打转"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "跳出细节看守恒量", formula: "无外力矩 ⟹ L=Iω 守恒；I↓ 则 ω↑", annotation: "内力再复杂也改变不了 L"),
            ], keyInsight: "守恒律的威力：不管内部过程多复杂，守恒量一锤定音。", commonMistakes: []),
            weaponUsed: .angularMomentum, timeRatio: 3.0,
            detailedExplanation: "角动量守恒通杀「收缩/伸展改变转速」类问题：冰人收臂、跳水抱膝、星云坍缩成快转中子星，全是同一条定律。",
            plainTalk: "转着圈把手臂收回来，质量更贴近转轴，「转动惯量」变小——可转动的总冲劲 L=Iω 没人动得了它（冰面几乎没有力矩），所以转速 ω 必须变大来补。跳水运动员空中抱膝、星云缩成飞转的中子星，全是同一招。"),
        tags: ["角动量守恒", "转动", "降维", "竞赛"])

    // 3. 矢量三角形（摩擦角） · 最省力方向
    static let g8_minForceAngle = PhysicsProblem(
        id: "g8_min_force_angle", type: .calculation, stage: .olympiad, topic: .newton,
        content: "在水平地面上拖动质量 m 的木箱（动摩擦因数 μ），拉力与水平方向成角 θ。求最省力的 θ 和最小拉力。",
        answer: "tanθ = μ 时最省力，F_min = μmg/√(1+μ²)", difficulty: 0.8, averageTime: 280,
        hints: ["把支持力与摩擦力合成一个「全反力」", "全反力与竖直方向的夹角是固定的摩擦角 φ=arctanμ"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "匀速拖动时列平衡式", formula: "Fcosθ = μN；N = mg − Fsinθ", annotation: ""),
            SolutionStep(order: 2, description: "解出 F(θ)", formula: "F = μmg/(cosθ + μsinθ)", annotation: ""),
            SolutionStep(order: 3, description: "分母辅助角公式取最大", formula: "cosθ+μsinθ = √(1+μ²)·cos(θ−φ)，θ=φ=arctanμ 时最大", annotation: "F_min = μmg/√(1+μ²)"),
        ], keyInsight: "把地面的支持力和摩擦力打包成「全反力」，它与竖直方向恒成摩擦角 φ。",
           commonMistakes: ["以为水平拉（θ=0）最省力，忽略了抬升减压的收益"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "列平衡方程化出 F(θ)", formula: "F = μmg/(cosθ + μsinθ)", annotation: "两条方程消 N"),
                SolutionStep(order: 2, description: "求导或辅助角求最值", formula: "d F/dθ = 0 ⟹ tanθ = μ", annotation: "三角运算量大"),
            ], keyInsight: "函数求极值硬算。", commonMistakes: ["求导出错或辅助角公式记错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "支持力+摩擦力合成「全反力」，方向固定（与竖直成摩擦角 φ，tanφ=μ）", formula: "三力平衡：mg（定）、全反力（方向定）、F（待定）", annotation: "矢量三角形两边已锁定"),
                SolutionStep(order: 2, description: "F 最短=垂直于全反力", formula: "θ = φ = arctanμ；F_min = mg·sinφ = μmg/√(1+μ²)", annotation: "几何一眼定"),
            ], keyInsight: "「一力恒定、一力方向已知、求第三力最小」⟹ 第三力垂直于方向已知的力——矢量三角形的最短边定理。", commonMistakes: []),
            weaponUsed: .vectorTriangle, timeRatio: 4.0,
            detailedExplanation: "矢量三角形+摩擦角是竞赛处理「最省力」问题的标准武器：把求导题变成几何题，画一个三角形就看到答案。",
            plainTalk: "地面给箱子的支持力和摩擦力其实是「一伙的」，可以打包成一个方向固定的「全反力」。于是问题变成：重力定死、全反力方向定死，拉力怎么拉最短？三角形里最短的边是垂线——拉力垂直于全反力时最省力，那个角度恰好就是摩擦角。"),
        tags: ["牛顿定律", "摩擦角", "最值", "降维", "竞赛"])

    // 4. 等效法（质心） · 链条做功
    static let g8_chainPull = PhysicsProblem(
        id: "g8_chain_pull", type: .calculation, stage: .olympiad, topic: .energy,
        content: "长 L、质量 m 的均匀链条放在光滑桌面上，一半垂在桌边外。求把垂下部分缓慢拉回桌面需做的功。",
        answer: "W = mgL/8", difficulty: 0.7, averageTime: 200,
        hints: ["垂下部分质量 m/2", "它的质心在桌面下方 L/4 处"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "垂下段的质量与质心", formula: "m' = m/2，质心深度 h = L/4", annotation: "均匀链，质心在中点"),
            SolutionStep(order: 2, description: "做功=抬升质心", formula: "W = m'gh = (m/2)g(L/4) = mgL/8", annotation: ""),
        ], keyInsight: "变力做功不用积分：整段链条的重力势能变化只看质心升降。",
           commonMistakes: ["把垂下段质心深度当成 L/2"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "取深度 x 处微元 dx，逐段算提升功再求和", formula: "dW = (m/L)g·x·dx，对 x 从 0 到 L/2 累加", annotation: "需要积分思想，求和易错"),
            ], keyInsight: "微元累加硬算。", commonMistakes: ["上下限或线密度代错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "把垂下段等效成全部质量集中在质心的质点", formula: "W = (m/2)g·(L/4) = mgL/8", annotation: "一步"),
            ], keyInsight: "重力势能只认质心——把连续体「捏成」质心上的质点，积分瞬间消失。", commonMistakes: []),
            weaponUsed: .equivalentMethod, timeRatio: 4.0,
            detailedExplanation: "质心等效通杀链条/绳/液柱类势能问题：连续分布的重力势能=总质量×质心高度，不必逐段积分。",
            plainTalk: "拉链条不用积分：垂下来那半截（质量 m/2）的「平均位置」在桌面下 L/4 处。把整截链条想象成捏在质心处的一个小球——把这个小球提回桌面要做多少功？(m/2)g×(L/4)=mgL/8，完事。"),
        tags: ["功和能", "质心", "链条模型", "降维", "竞赛"])

    // 5. 虚功原理 · 滑轮组
    static let g8_pulleyVirtual = PhysicsProblem(
        id: "g8_pulley_virtual", type: .calculation, stage: .olympiad, topic: .energy,
        content: "用一个动滑轮和一个定滑轮组成滑轮组吊起重物 G，承重绳共 3 段（滑轮、绳均轻且光滑）。用虚功原理求平衡时绳端的拉力 F。",
        answer: "F = G/3", difficulty: 0.65, averageTime: 150,
        hints: ["设重物上升虚位移 d，绳端要拉过 3d", "平衡 ⟹ 总虚功为零"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "几何约束", formula: "重物升 d ⟹ 绳端移 3d", annotation: "3 段绳同时缩短"),
            SolutionStep(order: 2, description: "虚功为零", formula: "F·3d − G·d = 0 ⟹ F = G/3", annotation: ""),
        ], keyInsight: "平衡系统给个「假想的小位移」，各力做的总功为零——约束力（轴、绳内力）自动不出场。",
           commonMistakes: ["数错承重绳段数"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对每个滑轮逐一受力分析", formula: "动滑轮：3 段绳张力支撑 G；定滑轮只改向", annotation: "要画两张受力图，分析轴力"),
            ], keyInsight: "逐体受力分析。", commonMistakes: ["定滑轮当省力滑轮"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "虚位移对账：重物升 d、绳端拉 3d", formula: "F·3d = G·d ⟹ F = G/3", annotation: "一步，滑轮受力全程不出场"),
            ], keyInsight: "虚功原理只看「位移传动比」，机构内部的约束力一概免分析——机构越复杂越显威力。", commonMistakes: []),
            weaponUsed: .virtualWork, timeRatio: 3.0,
            detailedExplanation: "虚功原理通杀滑轮组/杠杆/连杆平衡：给一个虚位移，令总功为零，传动比就是力之比的倒数。",
            plainTalk: "不想一个个滑轮画受力图？让系统「假装」动一小步：重物升 1 厘米，三段绳每段都要缩 1 厘米，你的手就得拉走 3 厘米。力气×距离两头相等：F×3=G×1，所以 F=G/3。机构再复杂，数绳子就行。"),
        tags: ["平衡", "滑轮组", "虚功原理", "降维", "竞赛"])

    // 6. 势能曲线法 · 平衡稳定性
    static let g8_potentialWell = PhysicsProblem(
        id: "g8_potential_well", type: .multipleChoice, stage: .olympiad, topic: .energy,
        content: "粒子沿 x 轴运动，势能曲线 Ep(x) 在 x₁ 处是谷底、在 x₂ 处是峰顶。关于这两个位置，下列正确的是？",
        options: ["x₁、x₂ 都是稳定平衡", "x₁ 是稳定平衡，x₂ 是不稳定平衡",
                  "x₁ 是不稳定平衡，x₂ 是稳定平衡", "x₁、x₂ 处粒子所受合力不为零"],
        answer: "x₁ 是稳定平衡，x₂ 是不稳定平衡",
        difficulty: 0.7, averageTime: 90,
        hints: ["F = −dEp/dx：力指向势能下降的方向", "把曲线想成地形，小球往低处滚"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "极值点处斜率为零", formula: "F = −dEp/dx = 0 ⟹ 都是平衡位置", annotation: ""),
            SolutionStep(order: 2, description: "偏离后看回复还是逃逸", formula: "谷底：偏离后力指回谷底（稳定）；峰顶：偏离后力背离峰顶（不稳定）", annotation: ""),
        ], keyInsight: "势能曲线即「地形图」：谷底稳定、峰顶不稳定。",
           commonMistakes: ["只判断平衡、不判断稳定性"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "对 Ep(x) 求导分析力的方向再讨论稳定性", formula: "F=−dEp/dx，分区间讨论符号", annotation: "导数+分类讨论，繁琐"),
            ], keyInsight: "解析法逐段分析。", commonMistakes: ["F 与 Ep 斜率的符号关系记反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "把势能曲线当真实地形，放一颗小球", formula: "谷底=碗里的球（推一下会回来）；峰顶=山尖的球（推一下就跑）", annotation: "直觉即答案，秒选"),
            ], keyInsight: "势能曲线法：曲线即地形、小球即粒子——稳定性一眼看穿，不动一笔导数。", commonMistakes: []),
            weaponUsed: .potentialCurve, timeRatio: 3.0,
            detailedExplanation: "势能曲线法通杀平衡与运动趋势问题：地形直觉与 F=−dEp/dx 严格等价（一维保守场），分子势能、电势能曲线全适用。",
            plainTalk: "把势能曲线想成滑梯的形状，粒子就是放上去的小球：放在谷底，推一下会滚回来——稳定；放在峰顶，碰一下就滚没影——不稳定。求导？不需要，看地形就够了，而且这个直觉和数学严格等价。"),
        tags: ["功和能", "势能曲线", "平衡稳定性", "降维", "竞赛"])

    // 7. 标度分析 · 尺寸与跳高
    static let g8_scalingJump = PhysicsProblem(
        id: "g8_scaling_jump", type: .multipleChoice, stage: .olympiad, topic: .newton,
        content: "若把一只动物按比例整体放大 n 倍（几何相似、材料不变），它原地起跳的高度大约会？",
        options: ["变为 n 倍", "变为 n² 倍", "基本不变", "变为 1/n"],
        answer: "基本不变",
        difficulty: 0.8, averageTime: 150,
        hints: ["肌肉力 ∝ 横截面积 ∝ L²，质量 ∝ 体积 ∝ L³", "起跳高度看「单位质量获得的能量」"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "各量的标度", formula: "力 F∝L²；做功距离（蹬伸长度）∝L；质量 m∝L³", annotation: ""),
            SolutionStep(order: 2, description: "跳高的标度", formula: "h = F·L/(mg) ∝ L²·L/L³ = L⁰", annotation: "与尺寸无关"),
        ], keyInsight: "跳蚤和人跳起的绝对高度同量级——力²、质量³的标度差让「巨兽」占不到便宜。",
           commonMistakes: ["以为放大 n 倍力气大 n³ 倍"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想代入具体生物数据计算", formula: "肌肉应力、腿长、质量逐个查数据估算", annotation: "数据繁多，迷失在细节里"),
            ], keyInsight: "具体数值堆砌。", commonMistakes: ["被「大象腿粗」的直觉带偏"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "只看幂次：F∝L²、m∝L³、蹬伸∝L", formula: "h ∝ F·L/m ∝ L²·L/L³ = 1", annotation: "指数相消，一步出「不变」"),
            ], keyInsight: "标度分析不要数值只要幂次——指数一加减，趋势自动浮出。", commonMistakes: []),
            weaponUsed: .scaling, timeRatio: 4.0,
            detailedExplanation: "标度分析通杀「放大缩小会怎样」：面积²/体积³的错位解释了为何蚂蚁举重若轻、巨兽步履沉重，也是估算题的暗器。",
            plainTalk: "把动物整体放大 n 倍：力气跟肌肉横截面走，长 n² 倍；体重跟体积走，长 n³ 倍——力气永远涨不过体重！好在腿也长了 n 倍、蹬地距离变长。算总账：跳高 ∝ n²·n/n³ = 1，恰好不变。跳蚤和人跳的绝对高度差不多——不是巧合，是几何定律。"),
        tags: ["标度分析", "尺寸效应", "降维", "竞赛"])

    // 8. 近似展开 · 高度与重力
    static let g8_gravityHeight = PhysicsProblem(
        id: "g8_gravity_height", type: .calculation, stage: .olympiad, topic: .circular,
        content: "海拔 h 处的重力加速度比地面小多少？设 h ≪ 地球半径 R，用近似展开给出 Δg/g，并以 h=10 km、R=6400 km 估算数值。",
        answer: "Δg/g ≈ 2h/R ≈ 0.3%", difficulty: 0.75, averageTime: 220,
        hints: ["g(h) = GM/(R+h)²", "(1+x)ⁿ ≈ 1+nx（|x|≪1）"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "写成无量纲形式", formula: "g(h) = GM/(R+h)² = g·(1+h/R)⁻²", annotation: "x = h/R ≪ 1"),
            SolutionStep(order: 2, description: "一阶展开", formula: "(1+x)⁻² ≈ 1−2x ⟹ Δg/g ≈ 2h/R", annotation: ""),
            SolutionStep(order: 3, description: "代数", formula: "2×10/6400 ≈ 0.31%", annotation: ""),
        ], keyInsight: "小量 h/R 出现时，(1+x)ⁿ≈1+nx 把平方反比变成线性减小。",
           commonMistakes: ["直接精确计算 (6400/6410)²，算得费力且看不出规律"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "硬算精确比值", formula: "g(h)/g = (6400/6410)² = 0.99688…", annotation: "多位小数除法平方，费时且无一般规律"),
            ], keyInsight: "精确数值计算。", commonMistakes: ["保留位数不够，差值被舍掉"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "认出小量 x=h/R，一阶展开", formula: "(1+x)⁻² ≈ 1−2x ⟹ Δg/g ≈ 2h/R", annotation: "公式形式直接到手"),
                SolutionStep(order: 2, description: "心算数值", formula: "2×10/6400 ≈ 0.3%", annotation: "秒出"),
            ], keyInsight: "看到「≪」就启动一阶展开：复杂表达式塌缩成线性主项，规律和数值同时到手。", commonMistakes: []),
            weaponUsed: .approximation, timeRatio: 4.0,
            detailedExplanation: "近似展开通杀小量问题：(1+x)ⁿ≈1+nx 适用于 |x|≪1，高度修正、单摆小角、干涉光程差都是它的猎物。",
            plainTalk: "10 公里高空重力弱多少？精确算要做 (6400/6410)² 这种恶心的除法。注意 h 比 R 小太多——小量登场：(1+x)⁻²≈1−2x，所以减弱约 2h/R=2×10/6400≈0.3%。两秒心算，还顺手看清了规律：每升高 1% 的地球半径，重力少 2%。"),
        tags: ["万有引力", "近似展开", "降维", "竞赛"])

    // 9. 微元法 · 向心加速度的来历
    static let g8_centripetalDerive = PhysicsProblem(
        id: "g8_centripetal_derive", type: .multipleChoice, stage: .olympiad, topic: .circular,
        content: "匀速圆周运动速率 v 不变，为什么仍有加速度 a=v²/r？最能说明其来历的是？",
        options: ["速度大小在周期性变化", "公式规定如此，记住即可",
                  "速度矢量端点也在画圆：Δt 内方向转过 Δθ，|Δv|=v·Δθ，故 a=vω=v²/r", "向心力凭空产生了加速度"],
        answer: "速度矢量端点也在画圆：Δt 内方向转过 Δθ，|Δv|=v·Δθ，故 a=vω=v²/r",
        difficulty: 0.75, averageTime: 120,
        hints: ["把各时刻的速度矢量平移到同一起点", "微小时间内 Δv 的大小≈弧长 v·Δθ"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "速度矢量平移到同一起点", formula: "矢量端点轨迹是半径为 v 的圆", annotation: "方向转 ⟹ 端点转"),
            SolutionStep(order: 2, description: "取微元", formula: "|Δv| ≈ v·Δθ ⟹ a = vΔθ/Δt = vω = v²/r", annotation: "Δθ→0 时严格成立"),
        ], keyInsight: "加速度是「速度矢量的变化率」——大小不变、方向变，照样有 Δv。",
           commonMistakes: ["以为速率不变就没有加速度"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "背公式 a=v²/r 然后逐选项排除", formula: "知其然不知其所以然", annotation: "遇到变形题（如椭圆某点）就失灵"),
            ], keyInsight: "纯记忆。", commonMistakes: ["公式背混 v²/r 与 ω²r"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "微元视角：速度矢量自身画圆，端点速率就是加速度", formula: "「速度圆」半径 v、角速度 ω ⟹ a = vω = v²/r", annotation: "推导即记忆"),
            ], keyInsight: "微元法把公式变成图像：速度端点画圆——一旦看见，永远不会忘也不会混。", commonMistakes: []),
            weaponUsed: .infinitesimal, timeRatio: 3.0,
            detailedExplanation: "微元法的入门战例：用 Δθ→0 的极限思想推出 a=v²/r，同样的「端点画圆」手法可推简谐运动的加速度。",
            plainTalk: "速度大小不变怎么还有加速度？把每一刻的速度箭头都平移到同一个起点——箭头的「尖」也在画圆，半径是 v、转速跟粒子一样是 ω。箭头尖移动的速率就是加速度：a=vω=v²/r。这幅图看懂一次，公式一辈子忘不掉、也不会和 ω²r 搞混。"),
        tags: ["圆周运动", "向心加速度", "微元法", "降维", "竞赛"])

    // 10. 量纲分析 · 第一宇宙速度
    static let g8_firstCosmic = PhysicsProblem(
        id: "g8_first_cosmic", type: .calculation, stage: .olympiad, topic: .circular,
        content: "不查任何天文数据，只用地面重力加速度 g≈9.8 m/s² 和地球半径 R≈6.4×10⁶ m，构造出第一宇宙速度并估算数值。",
        answer: "v = √(gR) ≈ 7.9 km/s", difficulty: 0.7, averageTime: 180,
        hints: ["速度的量纲是 m/s，用 g 和 R 怎么凑？", "严格推导：近地圆轨道 mg = mv²/R"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "量纲拼装", formula: "[g][R] = (m/s²)(m) = m²/s² ⟹ √(gR) 是速度", annotation: "唯一的速度组合"),
            SolutionStep(order: 2, description: "动力学验证（系数恰为 1）", formula: "近地轨道 mg = mv²/R ⟹ v = √(gR)", annotation: ""),
            SolutionStep(order: 3, description: "估算", formula: "√(9.8×6.4×10⁶) ≈ 7.9×10³ m/s", annotation: ""),
        ], keyInsight: "g 和 R 只能凑出一个速度 √(gR)，动力学证明系数恰好是 1。",
           commonMistakes: ["以为必须知道 GM 才能算"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "从引力定律出发", formula: "GMm/R² = mv²/R ⟹ v = √(GM/R)", annotation: "还得用黄金代换 GM=gR² 换掉查不到的 GM"),
            ], keyInsight: "完整推导链。", commonMistakes: ["卡在不知道 GM 的数值"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "量纲直接拼出形式", formula: "√(gR) 是 g、R 唯一的速度组合", annotation: "公式忘光也能重建"),
                SolutionStep(order: 2, description: "心算", formula: "√(9.8×6.4×10⁶) ≈ √(64×10⁶)=8×10³ 量级 ⟹ ≈7.9 km/s", annotation: "秒出"),
            ], keyInsight: "量纲分析在「只有两个相关量」时几乎白送答案——形式唯一，只剩系数要靠动力学背书。", commonMistakes: []),
            weaponUsed: .dimensionalAnalysis, timeRatio: 3.0,
            detailedExplanation: "量纲分析的进阶战例：√(gR) 与单摆 √(L/g) 同源。注意量纲只定形式，系数 1 是动力学（mg=mv²/R）给的，不可省略验证。",
            plainTalk: "不查任何天文资料，用 g 和 R 现场拼出第一宇宙速度：速度的单位是 m/s，而 g×R 的单位恰好是 m²/s²，开个根号正好！√(9.8×6.4×10⁶)≈7.9 km/s。量纲就像乐高接口——能拼上的形状只有一种。"),
        tags: ["万有引力", "第一宇宙速度", "量纲分析", "降维", "竞赛"])

    // 11. 参考系变换 · 雨中撑伞
    static let g8_rainFrame = PhysicsProblem(
        id: "g8_rain_frame", type: .calculation, stage: .olympiad, topic: .kinematics,
        content: "雨滴以速率 u 竖直下落。人以速率 v 水平前行，伞柄应向前倾斜与竖直方向成多大角度，才能正对雨来的方向？",
        answer: "tanθ = v/u（向前倾）", difficulty: 0.65, averageTime: 140,
        hints: ["到人的参考系里看雨", "人参考系中雨多了一个水平分速度 −v"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "变换到人的参考系", formula: "v雨' = v雨 − v人：竖直 u + 水平 −v", annotation: "雨「迎面斜着来」"),
            SolutionStep(order: 2, description: "几何", formula: "tanθ = v/u", annotation: "伞正对雨的相对速度方向"),
        ], keyInsight: "相对速度 = 矢量差：换到运动者的参考系，问题就是一个直角三角形。",
           commonMistakes: ["角度的对边邻边搞反（tanθ=u/v）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "在地面系里追踪雨滴与人的相对位置变化", formula: "逐时刻几何作图分析", annotation: "脑中要同时跟踪两个运动"),
            ], keyInsight: "地面系硬分析。", commonMistakes: ["相对方向想反"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "跳进人的参考系：自己不动，雨获得水平速度 −v", formula: "雨速 = (−v, −u) ⟹ tanθ = v/u", annotation: "一个三角形，秒出"),
            ], keyInsight: "谁在问问题就站到谁的参考系上——相对运动瞬间退化成单体运动。", commonMistakes: []),
            weaponUsed: .referenceFrame, timeRatio: 3.0,
            detailedExplanation: "参考系变换通杀相对运动：雨中撑伞、侧风行船、空中加油，换系后全是简单的矢量三角形。",
            plainTalk: "坐到走路的人身上看雨：人自己「不动」了，雨却多出一个迎面扑来的水平速度 v。竖直 u、水平 v，两支箭头一拼成直角三角形，雨从 tanθ=v/u 的斜方向来——伞向前倾这个角度就刚好。换个视角，难题自动躺平。"),
        tags: ["运动学", "相对运动", "参考系", "降维", "竞赛"])

    // 12. 镜像法 · 点电荷与导体板
    static let g8_imageCharge = PhysicsProblem(
        id: "g8_image_charge", type: .calculation, stage: .olympiad, topic: .electricField,
        content: "点电荷 +q 放在接地无限大导体平面前方，距平面 d。求导体板对它的吸引力大小。",
        answer: "F = kq²/(4d²)，方向指向平面", difficulty: 0.8, averageTime: 240,
        hints: ["板上感应电荷的分布很复杂，别硬算", "试试在对称位置放一个假想的 −q"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "镜像替换", formula: "接地平面 ⟺ 对称位置的镜像电荷 −q", annotation: "两者在右半空间产生完全相同的场"),
            SolutionStep(order: 2, description: "库仑定律", formula: "F = kq·q/(2d)² = kq²/(4d²)", annotation: "两电荷相距 2d"),
        ], keyInsight: "接地导体平面的全部感应效果，等价于一个镜像电荷——边界条件（板上电势为零）自动满足。",
           commonMistakes: ["距离用 d 而不是 2d"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "想求出板上感应电荷的分布再积分受力", formula: "σ(r) 的分布 + 对全平面积分", annotation: "高中乃至大学低年级都解不动"),
            ], keyInsight: "感应电荷分布积分，无从下手。", commonMistakes: ["卡死在第一步"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "用镜像电荷 −q 替换整块导体板", formula: "对称位置放 −q，板上电势自动为零", annotation: "无限复杂 → 两个点电荷"),
                SolutionStep(order: 2, description: "库仑定律一步出", formula: "F = kq²/(2d)² = kq²/(4d²)", annotation: "秒出"),
            ], keyInsight: "镜像法是「换一个等价世界」：边界条件相同则场唯一——导体板从此消失，只剩两个点电荷。", commonMistakes: []),
            weaponUsed: .imageCharge, timeRatio: 6.0,
            detailedExplanation: "镜像法通杀「点电荷+接地导体平面」：唯一性定理保证替换合法。注意镜像电荷只在导体外侧的半空间等效，且平面必须接地（或视作零电势）。",
            plainTalk: "板上的感应电荷分布根本算不动？那就不算——在「镜子里」造一个假电荷：对称位置放个 −q，它在板外产生的电场跟整块板一模一样（物理定理保证独此一家）。于是问题塌缩成两个相距 2d 的点电荷，库仑定律一行搞定。"),
        tags: ["电场", "镜像法", "感应电荷", "降维", "竞赛"])

    // 13. 等效电路 · 无穷梯网络
    static let g8_infiniteLadder = PhysicsProblem(
        id: "g8_infinite_ladder", type: .calculation, stage: .olympiad, topic: .circuit,
        content: "无穷多节相同的「串 R 再并 R」梯形电阻网络，求从入口看进去的等效电阻 R_eq。",
        answer: "R_eq = (1+√5)R/2 ≈ 1.618R（黄金比！）", difficulty: 0.8, averageTime: 260,
        hints: ["无穷网络去掉第一节后，剩下的还是原网络", "设 R_eq，让它出现在自己的表达式里"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "自相似：剥掉一节不改变整体", formula: "R_eq = R + R∥R_eq = R + R·R_eq/(R+R_eq)", annotation: "无穷的妙处"),
            SolutionStep(order: 2, description: "解二次方程", formula: "R_eq² − R·R_eq − R² = 0 ⟹ R_eq = (1+√5)R/2", annotation: "取正根"),
        ], keyInsight: "无穷自相似结构：整体=一节+整体自身，方程自己咬住自己的尾巴。",
           commonMistakes: ["负根没舍去"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "从第 1 节开始逐节化简", formula: "算 1 节、2 节、3 节…的等效电阻找规律", annotation: "永远算不到无穷，只能看出极限趋势"),
            ], keyInsight: "逐节迭代逼近。", commonMistakes: ["迭代几步就放弃，得不到精确值"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "等效观点：剥掉一节，剩下的仍是 R_eq", formula: "R_eq = R + R∥R_eq", annotation: "无穷变成一个方程"),
                SolutionStep(order: 2, description: "解出", formula: "R_eq = (1+√5)R/2", annotation: "黄金比，秒出精确值"),
            ], keyInsight: "对无穷重复结构，「自己等效自己」一招致命——无穷不再可怕，反而成了解题工具。", commonMistakes: []),
            weaponUsed: .equivalentCircuit, timeRatio: 5.0,
            detailedExplanation: "等效电路的竞赛形态：自相似等效。同一招还能算无穷电容链、无穷弹簧链——凡「剥一层还是自己」的结构都适用。",
            plainTalk: "无穷多个电阻怎么算？抓住「无穷」的小辫子：剥掉第一节，剩下的还是同一个无穷网络，电阻还是 R_eq！于是 R_eq = R + (R 并 R_eq)，方程咬住自己的尾巴，一解——居然是黄金比例 1.618R。无穷不可怕，自相似就是它的命门。"),
        tags: ["电路", "无穷网络", "自相似", "降维", "竞赛"])

    // 14. 对称法 · 立方体电阻网络
    static let g8_cubeResistor = PhysicsProblem(
        id: "g8_cube_resistor", type: .calculation, stage: .olympiad, topic: .circuit,
        content: "12 条棱均为电阻 R 的立方体框架，求体对角线两顶点间的等效电阻。",
        answer: "R_eq = 5R/6", difficulty: 0.85, averageTime: 300,
        hints: ["从入口顶点出发的 3 条棱完全等价", "对称的节点电位相同，可以合并成一点"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "对称性找等电位点", formula: "离入口 1 步的 3 个顶点等电位；离出口 1 步的 3 个顶点等电位", annotation: "体对角线方向的三重旋转对称"),
            SolutionStep(order: 2, description: "合并等电位点", formula: "网络化为三级串联：3 条并联 + 6 条并联 + 3 条并联", annotation: ""),
            SolutionStep(order: 3, description: "求和", formula: "R/3 + R/6 + R/3 = 5R/6", annotation: ""),
        ], keyInsight: "等电位的节点之间没有电流，可以随意合并/断开——对称性直接重画电路。",
           commonMistakes: ["漏掉中间层 6 条棱的并联"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "设 8 个节点电位，列基尔霍夫方程组", formula: "8 个未知数的线性方程组", annotation: "高中阶段几乎不可解"),
            ], keyInsight: "基尔霍夫方程组硬解。", commonMistakes: ["方程列错或解不动"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "三重对称 ⟹ 两组「等电位三顶点」各自合并", formula: "电路塌缩成 3∥ + 6∥ + 3∥ 三段串联", annotation: "图一画就化简"),
                SolutionStep(order: 2, description: "心算", formula: "R/3 + R/6 + R/3 = 5R/6", annotation: "秒出"),
            ], keyInsight: "看出对称，方程组消失——等电位合并是电路版的「一半计算蒸发」。", commonMistakes: []),
            weaponUsed: .symmetry, timeRatio: 6.0,
            detailedExplanation: "对称法在电路里的极致演出：等电位点合并把 8 节点网络压成 3 段串联。面对角线、棱对角线情形同法可解（对称轴不同）。",
            plainTalk: "12 个电阻的立方体不用列方程组：从对角线看进去，离入口一步的 3 个角「地位完全相同」——电位必然相等！等电位的点之间没有电流，可以直接焊成一个点。电路瞬间塌成三段：R/3+R/6+R/3=5R/6。对称性把八元方程组干成了心算。"),
        tags: ["电路", "对称法", "立方体网络", "降维", "竞赛"])

    // 15. 极值原理 · 反射定律的来历
    static let g8_fermatReflect = PhysicsProblem(
        id: "g8_fermat_reflect", type: .multipleChoice, stage: .olympiad, topic: .optics,
        content: "光从 A 点经平面镜反射到 B 点，为什么走「入射角=反射角」的那条路径？最深刻的解释是？",
        options: ["光被镜面弹开，像小球碰墙", "这是实验规律，没有更深的原因",
                  "费马原理：光走耗时最短的路径——把 B 关于镜面映射成 B′，直线 AB′ 即最短路径，对应等角反射", "镜面的微观结构恰好让角度相等"],
        answer: "费马原理：光走耗时最短的路径——把 B 关于镜面映射成 B′，直线 AB′ 即最短路径，对应等角反射",
        difficulty: 0.75, averageTime: 130,
        hints: ["同一介质中光速相同，耗时最短=路程最短", "镜像点把折线拉成直线"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "费马原理", formula: "实际光路是耗时极值（此处为最短）的路径", annotation: ""),
            SolutionStep(order: 2, description: "镜像拉直", formula: "B 映射为 B′，折线 A→镜→B 等长于 A→镜→B′；直线 AB′ 最短", annotation: "交点处自动满足等角"),
        ], keyInsight: "反射定律不是「规定」，是「光选了最快的路」——镜像点一画，最值问题变直线问题。",
           commonMistakes: ["把光的反射类比成完全弹性碰撞（碰撞类比解释不了折射）"]),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "设反射点位置 x，写出路程函数求导", formula: "L(x)=√(a²+x²)+√(b²+(c−x)²)，令 dL/dx=0", annotation: "求导+化简，运算量不小"),
            ], keyInsight: "解析法求最值。", commonMistakes: ["求导化简出错"]),
            descentMethod: SolutionPath(steps: [
                SolutionStep(order: 1, description: "把 B 关于镜面翻折成 B′", formula: "min(A→镜→B) = min(A→镜→B′) = 直线 AB′", annotation: "两点之间线段最短，免求导"),
                SolutionStep(order: 2, description: "几何读出等角", formula: "直线与镜面的交角关系 ⟹ 入射角=反射角", annotation: "秒出"),
            ], keyInsight: "极值原理+镜像翻折：把「找最短折线」变成「连一条直线」——这招也是平面几何最值题的通杀器。", commonMistakes: []),
            weaponUsed: .extremumPrinciple, timeRatio: 4.0,
            detailedExplanation: "费马原理是物理学「变分原理」家族的入门款：反射对应路程最短；折射对应时间最短（光速不同），同样的镜像/折直手法贯穿光学与力学最值题。",
            plainTalk: "为什么入射角等于反射角？因为光是个「赶时间的通勤族」，永远挑最快的路走。把终点 B 关于镜面翻折成 B′，「经过镜面的折线」就被拉直成 A 到 B′ 的一条直线——两点之间线段最短，而这条直线恰好对应等角反射。大自然一直在帮光做最优化。"),
        tags: ["光学", "费马原理", "反射定律", "降维", "竞赛"])
}
