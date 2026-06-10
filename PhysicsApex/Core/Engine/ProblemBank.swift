import Foundation

// MARK: - 示例题库（一期：力学为主，含降维双解战例）
// ⚠️ 诚信原则：题型源自高考高频题型（部分改编），不臆造「某年某卷某题」精确出处。

enum ProblemBank {

    static let all: [PhysicsProblem] = [
        inclineRevisitJunior,
        inclineRevisitSenior,
        collisionDescent,
        riverCrossingDescent,
        projectileRangeJunior,
        magneticPeriodChoice,
        railTerminalVelocity,
        workEnergyMultiStage,
        nearEarthSatellite,
    ]

    /// 降维秒杀战例 = 带 dualSolution 的题。
    static var descentCases: [PhysicsProblem] { all.filter { $0.dualSolution != nil } }

    static func problems(for topic: PhysicsTopic) -> [PhysicsProblem] {
        all.filter { $0.topic == topic }
    }

    static func problems(for stage: Stage) -> [PhysicsProblem] {
        all.filter { $0.stage == stage }
    }

    // MARK: - 「同一题三级重访」示范：斜面滑块

    /// 初中视角：滑不滑得动？（直觉）
    static let inclineRevisitJunior = PhysicsProblem(
        id: "incline_junior",
        type: .multipleChoice,
        stage: .junior,
        topic: .newton,
        content: "一个木块放在倾角逐渐增大的斜面上。下列说法正确的是？",
        options: [
            "倾角越大，木块越不容易下滑",
            "只要有摩擦，木块永远不会下滑",
            "当重力沿斜面的分量超过最大静摩擦力时，木块开始下滑",
            "木块下滑与否只取决于木块的重量"
        ],
        answer: "当重力沿斜面的分量超过最大静摩擦力时，木块开始下滑",
        difficulty: 0.25,
        averageTime: 40,
        hints: ["把重力分成'沿斜面'和'垂直斜面'两个方向", "比较下滑力和摩擦力谁大"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "重力沿斜面分量（下滑力）", formula: "F下 = mg·sinθ", annotation: "θ 越大，sinθ 越大，下滑力越大"),
                SolutionStep(order: 2, description: "最大静摩擦力", formula: "f = μ·mg·cosθ", annotation: "θ 越大，cosθ 越小，摩擦力越小"),
                SolutionStep(order: 3, description: "临界：下滑力 = 摩擦力", formula: "tanθ = μ", annotation: "超过这个角就滑动"),
            ],
            keyInsight: "下滑力随角增大、摩擦力随角减小，必有一个临界角。",
            commonMistakes: ["以为重的物体更容易下滑（mg 两边约掉了）"]
        ),
        misconceptions: [
            Misconception(
                option: "倾角越大，木块越不容易下滑",
                youThought: "你大概觉得角度越陡，木块「贴」得越紧、越稳。",
                pitfall: "恰恰相反：角越大，沿斜面的下滑力 mg·sinθ 越大，而压紧斜面的力、摩擦力 μmg·cosθ 反而越小。",
                fix: "角越大越容易滑。临界角满足 tanθ = μ，超过就下滑。"
            ),
            Misconception(
                option: "只要有摩擦，木块永远不会下滑",
                youThought: "你大概把摩擦力当成了「无限大的保险」。",
                pitfall: "最大静摩擦是有上限的（≈μN）。下滑力一旦超过它，木块就动。",
                fix: "比较下滑力与最大静摩擦：mg·sinθ 超过 μmg·cosθ 就滑。"
            ),
            Misconception(
                option: "木块下滑与否只取决于木块的重量",
                youThought: "你大概觉得越重越容易压不住、越会滑。",
                pitfall: "下滑力和摩擦力里都含 mg，比较时两边约掉了——和质量无关。",
                fix: "是否下滑只由倾角 θ 和摩擦因数 μ 决定（tanθ 与 μ 比大小）。"
            ),
        ],
        tags: ["斜面", "受力直觉"]
    )

    /// 高中视角：求加速度（标准解）
    static let inclineRevisitSenior = PhysicsProblem(
        id: "incline_senior",
        type: .calculation,
        stage: .senior,
        topic: .newton,
        content: "质量 m=2kg 的木块从倾角 θ=37° 的斜面顶端由静止下滑，动摩擦因数 μ=0.25，斜面长 L=5m。求滑到底端的速度。(g=10, sin37°=0.6, cos37°=0.8)",
        answer: "约 6.3 m/s",
        difficulty: 0.5,
        averageTime: 180,
        hints: ["先用牛顿第二定律求加速度", "再用匀加速公式 v²=2aL"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "沿斜面合力", formula: "F = mg·sinθ − μmg·cosθ", annotation: "下滑力减摩擦力"),
                SolutionStep(order: 2, description: "加速度", formula: "a = g(sinθ − μcosθ) = 10×(0.6−0.25×0.8) = 4 m/s²", annotation: "代入数值"),
                SolutionStep(order: 3, description: "末速度", formula: "v = √(2aL) = √(2×4×5) ≈ 6.3 m/s", annotation: "匀加速直线运动"),
            ],
            keyInsight: "牛顿第二定律 → 加速度 → 运动学公式，标准两步走。",
            commonMistakes: ["忘记摩擦力方向沿斜面向上", "用了 sin/cos 混淆"]
        ),
        tags: ["斜面", "牛顿定律"]
    )

    // MARK: - 降维战例：完全非弹性碰撞

    static let collisionDescent = PhysicsProblem(
        id: "collision_descent",
        type: .calculation,
        stage: .senior,
        topic: .momentum,
        content: "质量 m 的子弹以速度 v₀ 水平射入静止在光滑地面上、质量 M 的木块并嵌入其中。求子弹+木块共同速度，以及系统损失的动能。",
        answer: "共同速度 v = mv₀/(m+M)；损失动能 ΔE = ½·mM·v₀²/(m+M)",
        difficulty: 0.55,
        averageTime: 150,
        hints: ["碰撞过程时间极短，可用动量守恒", "动能不守恒，差额变成内能"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "动量守恒", formula: "mv₀ = (m+M)v", annotation: "系统水平方向不受外力"),
                SolutionStep(order: 2, description: "共同速度", formula: "v = mv₀/(m+M)", annotation: ""),
            ],
            keyInsight: "嵌入 = 完全非弹性碰撞，动量守恒但动能有损失。",
            commonMistakes: ["误用机械能守恒去解共同速度"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "对子弹用动量定理求阻力冲量，再对木块求加速过程……", formula: "∫F dt = Δp（分别对两物体）", annotation: "需要假设阻力、求作用时间，非常繁琐"),
                    SolutionStep(order: 2, description: "逐段计算两物体位移、相对滑动距离", formula: "牛顿定律 + 运动学联立", annotation: "方程一大堆"),
                ],
                keyInsight: "硬算两个物体各自的受力与运动，方程多、易错。",
                commonMistakes: ["相对位移算错导致内能错"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "只看首末态，动量守恒", formula: "mv₀ = (m+M)v ⟹ v = mv₀/(m+M)", annotation: "无视碰撞内部任何细节"),
                    SolutionStep(order: 2, description: "动能差额即损失", formula: "ΔE = ½mv₀² − ½(m+M)v² = ½·mM·v₀²/(m+M)", annotation: "一步出答案"),
                ],
                keyInsight: "守恒律是上帝视角：不关心过程多复杂，只看首末态。",
                commonMistakes: []
            ),
            weaponUsed: .momentumConservation,
            timeRatio: 4.0,
            detailedExplanation: "复杂的碰撞内部过程（变力、形变、生热）全部被动量守恒'跳过'——这正是降维打击的精髓。"
        ),
        tags: ["碰撞", "动量守恒", "降维"]
    )

    // MARK: - 降维战例：小船过河最短时间/位移

    static let riverCrossingDescent = PhysicsProblem(
        id: "river_descent",
        type: .calculation,
        stage: .senior,
        topic: .kinematics,
        content: "河宽 d，水流速度 u，船在静水中速度 v（v<u）。船头如何朝向才能使航程（位移）最短？最短位移是多少？",
        answer: "船头偏向上游，使合速度垂直分量……最短位移 = d·u/v",
        difficulty: 0.6,
        averageTime: 200,
        hints: ["v<u 时无法垂直渡河", "用速度矢量图，让合速度尽量偏向对岸"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "合速度 = 水流 u + 船速 v 的矢量和", formula: "v合 = u + v（矢量）", annotation: "u 固定，v 大小固定方向可调"),
                SolutionStep(order: 2, description: "v 矢量末端在以 u 末端为圆心、半径 v 的圆上", formula: "求 v合 与河岸夹角最大", annotation: ""),
            ],
            keyInsight: "位移最短 ⟺ 合速度方向与对岸法线夹角最小。",
            commonMistakes: ["以为船头垂直河岸位移最短（那是 v>u 的情况）"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "设船头与河岸夹角 α，写出合速度分量", formula: "vx = u − v·cosα, vy = v·sinα", annotation: "建立函数"),
                    SolutionStep(order: 2, description: "位移 = d / sin(漂角)，对 α 求导找极值", formula: "d(位移)/dα = 0", annotation: "求导、解三角方程，繁琐"),
                ],
                keyInsight: "用三角函数+求导硬找极值。",
                commonMistakes: ["求导算错", "漂移角与船头角混淆"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "画速度矢量圆：u 是定矢量，v 末端在圆上", formula: "几何：合速度与法线夹角最小 ⟺ v合 与小圆相切", annotation: "相切即极值，无需求导"),
                    SolutionStep(order: 2, description: "相切时直角三角形给出", formula: "cosθmin = v/u ⟹ 最短位移 = d·u/v", annotation: "几何一眼定"),
                ],
                keyInsight: "对称/几何意义把'求导找极值'变成'看出相切'。",
                commonMistakes: []
            ),
            weaponUsed: .extremumPrinciple,
            timeRatio: 3.0,
            detailedExplanation: "数形结合：把极值问题翻译成'圆的切线'，几何直觉直接秒杀，免去求导。"
        ),
        tags: ["运动合成", "最值", "数形结合", "降维"]
    )

    // MARK: - 初中：平抛直觉

    static let projectileRangeJunior = PhysicsProblem(
        id: "projectile_junior",
        type: .multipleChoice,
        stage: .junior,
        topic: .kinematics,
        content: "从同一高度，分别以不同水平速度抛出两个小球（忽略空气阻力）。关于它们落地，下列正确的是？",
        options: [
            "速度大的先落地",
            "两球同时落地，速度大的落得远",
            "速度大的后落地",
            "无法判断"
        ],
        answer: "两球同时落地，速度大的落得远",
        difficulty: 0.3,
        averageTime: 45,
        hints: ["竖直方向都是自由落体", "水平方向不影响下落时间"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "竖直方向：自由落体", formula: "t = √(2h/g)", annotation: "只和高度有关，与水平速度无关"),
                SolutionStep(order: 2, description: "水平方向：匀速", formula: "x = v·t", annotation: "速度大射程远"),
            ],
            keyInsight: "平抛 = 水平匀速 + 竖直自由落体，两方向独立。",
            commonMistakes: ["以为水平速度影响下落快慢"]
        ),
        misconceptions: [
            Misconception(
                option: "速度大的先落地",
                youThought: "你大概觉得抛得越快、越「冲」，越早到地面。",
                pitfall: "水平速度只管水平方向，管不到竖直下落。下落时间只由高度决定。",
                fix: "竖直方向都是自由落体 t=√(2h/g)，两球同时落地，快的只是落得更远。"
            ),
            Misconception(
                option: "速度大的后落地",
                youThought: "你大概觉得速度大就「飘」得久、落得晚。",
                pitfall: "同样混淆了水平与竖直：水平快慢不改变竖直下落的快慢。",
                fix: "下落时间与水平速度无关，两球同时落地。"
            ),
            Misconception(
                option: "无法判断",
                youThought: "你大概觉得条件不够、两个方向纠缠不清。",
                pitfall: "其实平抛的精髓正是「两方向独立」，一拆就清楚了。",
                fix: "竖直定时间、水平定射程——同时落地，快的落得远。"
            ),
        ],
        tags: ["平抛", "运动独立性"]
    )

    // MARK: - 降维战例：带电粒子在磁场中的周期

    static let magneticPeriodChoice = PhysicsProblem(
        id: "magnetic_period",
        type: .multipleChoice,
        stage: .senior,
        topic: .magnetic,
        content: "带正电粒子垂直射入匀强磁场，做匀速圆周运动。若只把入射速率增大为原来的 2 倍（磁场不变），下列正确的是？",
        options: [
            "周期变为原来的 2 倍",
            "周期变为原来的一半",
            "周期不变，半径变为 2 倍",
            "周期和半径都不变"
        ],
        answer: "周期不变，半径变为 2 倍",
        difficulty: 0.5,
        averageTime: 60,
        hints: ["写出半径 r = mv/(qB)", "写出周期 T = 2πm/(qB)，看含不含 v"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "半径", formula: "r = mv/(qB) ∝ v", annotation: "速率翻倍，半径翻倍"),
                SolutionStep(order: 2, description: "周期", formula: "T = 2πm/(qB)", annotation: "不含 v——与速率无关"),
            ],
            keyInsight: "半径随 v 变，但周期与 v 无关。",
            commonMistakes: ["以为转得快周期就短"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "由 qvB = mv²/r 解出半径", formula: "r = mv/(qB)", annotation: "向心力 = 洛伦兹力"),
                    SolutionStep(order: 2, description: "再用 T = 2πr/v 代入求周期", formula: "T = 2πr/v = 2πm/(qB)", annotation: "把 r 代回、约掉 v，才发现与 v 无关"),
                ],
                keyInsight: "一步步算到最后才看出周期与 v 无关。",
                commonMistakes: ["代入时漏约 v"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "记住回旋周期公式", formula: "T = 2πm/(qB)", annotation: "压根不含 v"),
                    SolutionStep(order: 2, description: "直接判定", formula: "v↑ ⟹ r↑、T 不变", annotation: "秒选"),
                ],
                keyInsight: "回旋周期只由 m、q、B 决定——这是回旋加速器能工作的根本原因。",
                commonMistakes: []
            ),
            weaponUsed: .symmetry,
            timeRatio: 3.0,
            detailedExplanation: "速率大→半径大→路程长，但快慢恰好抵消，转一圈时间不变。记住 T=2πm/(qB) 就能秒杀一切「周期是否变」的选择题。"
        ),
        misconceptions: [
            Misconception(
                option: "周期变为原来的 2 倍",
                youThought: "你大概觉得跑得快，转一圈反而更费时间。",
                pitfall: "速率快确实路程长，但半径也同步变大，两者恰好抵消。",
                fix: "T = 2πm/(qB) 不含 v，周期与速率无关。"
            ),
            Misconception(
                option: "周期变为原来的一半",
                youThought: "你大概觉得速率翻倍，周期就减半。",
                pitfall: "把直线运动「快=用时短」的直觉错搬到圆周——半径同时变了。",
                fix: "半径 r∝v 一起变大，周期 T=2πm/(qB) 保持不变。"
            ),
            Misconception(
                option: "周期和半径都不变",
                youThought: "你大概觉得磁场没变，一切都不变。",
                pitfall: "半径 r=mv/(qB) 明显随 v 变大，只有周期不变。",
                fix: "半径翻倍、周期不变。"
            ),
        ],
        tags: ["磁场", "洛伦兹力", "回旋周期", "降维"]
    )

    // MARK: - 降维战例：导轨上金属棒的最大速度

    static let railTerminalVelocity = PhysicsProblem(
        id: "rail_terminal",
        type: .calculation,
        stage: .senior,
        topic: .induction,
        content: "倾角 θ 的光滑导轨间距 L，竖直磁场 B 垂直导轨平面，质量 m 的金属棒由静止下滑，回路总电阻 R。求金属棒能达到的最大速度。",
        answer: "v_max = mgR·sinθ / (B²L²)",
        difficulty: 0.7,
        averageTime: 220,
        hints: ["最大速度时加速度为零", "此时安培力沿斜面分量 = 重力沿斜面分量"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "感应电动势与电流", formula: "ε = BLv，I = BLv/R", annotation: "切割磁感线"),
                SolutionStep(order: 2, description: "最大速度时平衡", formula: "BIL = mg·sinθ", annotation: "a=0"),
                SolutionStep(order: 3, description: "解出", formula: "v_max = mgR·sinθ/(B²L²)", annotation: "代入 I"),
            ],
            keyInsight: "达到最大速度的标志是合力为零、加速度为零。",
            commonMistakes: ["误以为「最大速度」要解出整个 v(t)"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "列牛顿第二定律（含速度相关的安培力）", formula: "ma = mg·sinθ − B²L²v/R", annotation: "这是一个微分方程"),
                    SolutionStep(order: 2, description: "解微分方程得 v(t)，再令 t→∞", formula: "v(t) = v_max(1 − e^(−t/τ))", annotation: "求极限才得 v_max，超纲又繁琐"),
                ],
                keyInsight: "硬解含阻尼的微分方程，对高中生几乎不可行。",
                commonMistakes: ["微分方程解错"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "抓住「最大速度 ⟺ 加速度为零」", formula: "合力 = 0 ⟹ BIL = mg·sinθ", annotation: "无需关心如何到达"),
                    SolutionStep(order: 2, description: "一步解出", formula: "v_max = mgR·sinθ/(B²L²)", annotation: "代 I=BLv/R"),
                ],
                keyInsight: "终态平衡法：只问「最终稳定在哪」，跳过整个动态过程。",
                commonMistakes: []
            ),
            weaponUsed: .equivalentMethod,
            timeRatio: 6.0,
            detailedExplanation: "「最大速度 / 收尾速度」类问题的通杀套路——加速度为零即受力平衡，一个方程拿下，彻底绕开微分方程。"
        ),
        tags: ["电磁感应", "终速度", "平衡", "降维"]
    )

    // MARK: - 降维战例：多过程的动能定理

    static let workEnergyMultiStage = PhysicsProblem(
        id: "work_energy_multi",
        type: .calculation,
        stage: .senior,
        topic: .energy,
        content: "物块从高 h 的光滑曲面顶端由静止滑下，进入动摩擦因数为 μ 的粗糙水平面，恰好滑行距离 s 后停下。求 μ（曲面形状未知）。",
        answer: "μ = h / s",
        difficulty: 0.6,
        averageTime: 150,
        hints: ["对全程用动能定理", "始末动能都为零"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "全程动能定理（始末动能均为 0）", formula: "mgh − μmg·s = 0", annotation: "重力做正功、摩擦做负功"),
                SolutionStep(order: 2, description: "解出", formula: "μ = h/s", annotation: "m、g 全约掉"),
            ],
            keyInsight: "始末都静止，合外力做的总功为零。",
            commonMistakes: ["纠结曲面形状去算每一段"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "先对曲面段用机械能守恒求底端速度", formula: "v = √(2gh)", annotation: "假设曲面光滑"),
                    SolutionStep(order: 2, description: "再对水平段用动能定理", formula: "μmg·s = ½mv²", annotation: "分两段、引入中间量 v"),
                ],
                keyInsight: "分段计算，需要中间速度 v 当桥梁。",
                commonMistakes: ["分段处速度衔接错"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "对「下滑+滑行」整个过程一次性用动能定理", formula: "mgh − μmg·s = 0", annotation: "无视中间、无视曲面形状"),
                    SolutionStep(order: 2, description: "直接得", formula: "μ = h/s", annotation: "一个方程搞定"),
                ],
                keyInsight: "动能定理对全过程成立——曲面长什么样根本无所谓。",
                commonMistakes: []
            ),
            weaponUsed: .workEnergyTheorem,
            timeRatio: 2.5,
            detailedExplanation: "动能定理跨过程的威力：只认始末动能与总功，中间的曲面、速度全是浮云。μ=h/s 简洁得惊人。"
        ),
        tags: ["动能定理", "多过程", "降维"]
    )

    // MARK: - 降维战例：近地卫星速度（黄金代换）

    static let nearEarthSatellite = PhysicsProblem(
        id: "near_earth_sat",
        type: .calculation,
        stage: .senior,
        topic: .circular,
        content: "已知地球表面重力加速度 g 和地球半径 R，求近地卫星的环绕速度（不告诉你引力常量 G 和地球质量 M）。",
        answer: "v = √(gR)",
        difficulty: 0.55,
        averageTime: 120,
        hints: ["近地卫星轨道半径≈R", "地表附近重力≈万有引力"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "重力提供向心力", formula: "mg = mv²/R", annotation: "近地，轨道半径≈R"),
                SolutionStep(order: 2, description: "解出", formula: "v = √(gR) ≈ 7.9 km/s", annotation: "第一宇宙速度"),
            ],
            keyInsight: "地表附近，重力就是万有引力，直接提供向心力。",
            commonMistakes: ["非要去找 G 和 M"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "用万有引力提供向心力", formula: "GMm/R² = mv²/R", annotation: "需要 G 和 M"),
                    SolutionStep(order: 2, description: "但题目没给 G、M，被卡住", formula: "v = √(GM/R)", annotation: "还得想办法求 GM"),
                ],
                keyInsight: "从 G、M 入手，会发现题目根本没给这两个量。",
                commonMistakes: ["卡在不知道 GM 的数值"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "黄金代换：地表 mg = GMm/R² ⟹ GM = gR²", formula: "GM = gR²", annotation: "用 g、R 表示 GM"),
                    SolutionStep(order: 2, description: "等效为重力提供向心力", formula: "mg = mv²/R ⟹ v = √(gR)", annotation: "G、M 都不用"),
                ],
                keyInsight: "「黄金代换」GM=gR² 把看不见的 G、M 换成看得见的 g、R。",
                commonMistakes: []
            ),
            weaponUsed: .equivalentMethod,
            timeRatio: 3.0,
            detailedExplanation: "天体问题神器——黄金代换 GM=gR²。凡是给了 g 和 R 的题，都能绕开万有引力常量直接算。"
        ),
        tags: ["万有引力", "黄金代换", "第一宇宙速度", "降维"]
    )
}
