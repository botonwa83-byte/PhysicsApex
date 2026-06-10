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
        electricDeflection,
        photoEffectChoice,
        internalEnergyChoice,
        totalReflectionChoice,
        doubleSlitDescent,
        waterJetForce,
        triangleCharge,
        relativeMotionJunior,
        buoyancyJunior,
    ] + batch1 + batch2 + batch3

    /// 降维秒杀战例 = 带 dualSolution 的题。
    static var descentCases: [PhysicsProblem] { all.filter { $0.dualSolution != nil } }

    /// 该题是否在免费档（全题库前 freeProblemCount 道）。
    static func isFree(_ id: String) -> Bool {
        (all.firstIndex { $0.id == id } ?? 0) < PurchaseManager.freeProblemCount
    }
    static var freeProblems: [PhysicsProblem] { Array(all.prefix(PurchaseManager.freeProblemCount)) }

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

    // MARK: - 降维战例：偏转电场中的类平抛

    static let electricDeflection = PhysicsProblem(
        id: "electric_deflection",
        type: .calculation,
        stage: .senior,
        topic: .electricField,
        content: "质量 m、电荷量 q 的带电粒子以水平速度 v₀ 射入两平行板间的匀强电场，板长 L、板间电压 U、板间距 d。求粒子射出电场时的竖直偏转距离 y。",
        answer: "y = qUL² / (2mdv₀²)",
        difficulty: 0.6,
        averageTime: 180,
        hints: ["水平方向匀速，竖直方向匀加速", "和平抛是同一个模型"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "竖直方向加速度", formula: "a = qE/m = qU/(md)", annotation: "E = U/d"),
                SolutionStep(order: 2, description: "在场中飞行时间", formula: "t = L/v₀", annotation: "水平匀速"),
                SolutionStep(order: 3, description: "竖直偏转", formula: "y = ½at² = qUL²/(2mdv₀²)", annotation: "匀加速"),
            ],
            keyInsight: "偏转电场里的运动 = 平抛的孪生兄弟。",
            commonMistakes: ["把 E 写成 U（漏掉除以 d）"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "重新分析受力、建系、列水平与竖直运动方程", formula: "x = v₀t；y = ½at²", annotation: "从零推导整套运动学"),
                    SolutionStep(order: 2, description: "联立消去时间求 y", formula: "代入 t=L/v₀", annotation: "步骤多"),
                ],
                keyInsight: "当成全新问题，从受力到运动学一步步推。",
                commonMistakes: ["建系混乱"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "认出它就是「平抛」：水平匀速 + 竖直匀加速", formula: "把 g 换成 a=qU/(md)", annotation: "模型同构，直接套"),
                    SolutionStep(order: 2, description: "套平抛结论", formula: "y = qUL²/(2mdv₀²)", annotation: "一步到位"),
                ],
                keyInsight: "等效迁移：偏转电场 ↔ 平抛，把熟悉模型搬过来，秒解。",
                commonMistakes: []
            ),
            weaponUsed: .equivalentMethod,
            timeRatio: 2.5,
            detailedExplanation: "重力场里的平抛、电场里的偏转、磁场里的某些运动，本质都是「一个方向匀速 + 垂直方向匀变速」。认出同构，一类题全解。"
        ),
        tags: ["电场", "类平抛", "等效迁移", "降维"]
    )

    // MARK: - 概念秒杀：光电效应（错因诊断）

    static let photoEffectChoice = PhysicsProblem(
        id: "photo_effect",
        type: .multipleChoice,
        stage: .senior,
        topic: .modern,
        content: "用某频率的光照射某金属，没有发生光电效应。下列措施中，可能使它发生光电效应的是？",
        options: [
            "增大光照强度",
            "延长照射时间",
            "增大入射光的频率",
            "增大照射面积"
        ],
        answer: "增大入射光的频率",
        difficulty: 0.45,
        averageTime: 50,
        hints: ["单个光子的能量由谁决定？", "光强、时间、面积改变的是什么？"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "单个光子能量", formula: "E = hν", annotation: "只由频率决定"),
                SolutionStep(order: 2, description: "发生条件", formula: "hν > W₀（逸出功）", annotation: "和光强、时间、面积都无关"),
            ],
            keyInsight: "能否打出电子只看「单个光子」的能量，即频率。",
            commonMistakes: ["以为光越强、照越久就能打出电子"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "逐条回忆光电效应方程与四条规律去判断", formula: "Ek = hν − W₀", annotation: "一个个选项验证"),
                ],
                keyInsight: "把四个选项逐一对照规律。",
                commonMistakes: ["规律记混"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "一刀切：光强/时间/面积只改变「光子数量」，频率才改变「单光子能量」", formula: "光子数 ↑ ≠ 单光子能量 ↑", annotation: "只有第三项动了能量"),
                    SolutionStep(order: 2, description: "秒排除其余三项", formula: "选 增大频率", annotation: "一句话定胜负"),
                ],
                keyInsight: "抓住「数量 vs 能量」这把刀，一刀切开所有迷惑选项。",
                commonMistakes: []
            ),
            weaponUsed: .energyIntuition,
            timeRatio: 3.0,
            detailedExplanation: "光电效应是单光子单电子的「一对一」过程，不累积。爱因斯坦凭光量子假说解释它，拿了诺贝尔奖。"
        ),
        misconceptions: [
            Misconception(
                option: "增大光照强度",
                youThought: "你大概觉得光更强、能量更大，就能把电子打出来。",
                pitfall: "光强大只是光子「数量」多，每个光子的能量 hν 一点没变。",
                fix: "频率不够，再多光子也是一群「打不动」的小锤子——必须提高频率。"
            ),
            Misconception(
                option: "延长照射时间",
                youThought: "你大概觉得照得久，能量慢慢累积就够了。",
                pitfall: "光电效应是瞬时的、单光子单电子，能量不会在金属里「攒着」。",
                fix: "频率不到，照一万年也打不出电子。"
            ),
            Misconception(
                option: "增大照射面积",
                youThought: "你大概觉得面积大、接收的光多，总能量就大。",
                pitfall: "同样只是增加了光子总数，单个光子能量不变。",
                fix: "决定成败的永远是单光子能量 = 频率。"
            ),
        ],
        tags: ["光电效应", "光子", "概念秒杀", "错因诊断"]
    )

    // MARK: - 概念秒杀：温度与内能（错因诊断）

    static let internalEnergyChoice = PhysicsProblem(
        id: "internal_energy",
        type: .multipleChoice,
        stage: .senior,
        topic: .thermal,
        content: "关于温度和内能，下列说法正确的是？",
        options: [
            "温度高的物体，内能一定大",
            "温度是分子平均动能的标志，温度升高分子平均动能一定增大",
            "0°C 的物体没有内能",
            "物体吸收热量，温度一定升高"
        ],
        answer: "温度是分子平均动能的标志，温度升高分子平均动能一定增大",
        difficulty: 0.5,
        averageTime: 60,
        hints: ["内能 = 所有分子动能 + 分子势能之和", "吸热不等于升温（想想冰熔化）"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "温度的微观意义", formula: "T ∝ 分子平均动能", annotation: "温度是平均动能的标志"),
                SolutionStep(order: 2, description: "内能的构成", formula: "U = 分子动能之和 + 分子势能之和", annotation: "还和质量、种类、状态有关"),
            ],
            keyInsight: "温度只标志「平均动能」，不等于总内能。",
            commonMistakes: ["把温度和内能划等号"]
        ),
        misconceptions: [
            Misconception(
                option: "温度高的物体，内能一定大",
                youThought: "你大概觉得温度高 = 内能大，两者一回事。",
                pitfall: "内能是「所有」分子的动能加势能之和，还看质量、种类、状态。一滴 100°C 的开水，内能远小于一桶 50°C 的温水。",
                fix: "温度只标志分子「平均」动能，决定不了总内能。"
            ),
            Misconception(
                option: "0°C 的物体没有内能",
                youThought: "你大概把 0°C 当成了「没有热量、分子不动」。",
                pitfall: "0°C ≈ 273 K，分子照样在剧烈运动，内能远大于零。",
                fix: "只有绝对零度（−273°C）分子动能才趋于零，而且内能里还有分子势能。"
            ),
            Misconception(
                option: "物体吸收热量，温度一定升高",
                youThought: "你大概觉得吸了热，温度必然往上走。",
                pitfall: "吸的热可能拿去对外做功（气体膨胀），或用于相变（冰熔化时温度不变）。",
                fix: "ΔU = W + Q：吸热只是 Q>0，温度升不升要看内能怎么变。"
            ),
        ],
        tags: ["热学", "内能", "温度", "错因诊断"]
    )

    // MARK: - 概念秒杀：全反射（错因诊断）

    static let totalReflectionChoice = PhysicsProblem(
        id: "total_reflection",
        type: .multipleChoice,
        stage: .senior,
        topic: .optics,
        content: "关于光的全反射，下列说法正确的是？",
        options: [
            "光从光疏介质射入光密介质时，也可能发生全反射",
            "只要入射角足够大，任何界面都能发生全反射",
            "光从光密介质射入光疏介质，且入射角大于临界角时，发生全反射",
            "发生全反射时，仍有一部分光折射出去"
        ],
        answer: "光从光密介质射入光疏介质，且入射角大于临界角时，发生全反射",
        difficulty: 0.5,
        averageTime: 55,
        hints: ["全反射需要两个条件，缺一不可", "临界角满足 sinC = 1/n"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "条件一：方向", formula: "光密 → 光疏", annotation: "如玻璃→空气、水→空气"),
                SolutionStep(order: 2, description: "条件二：角度", formula: "入射角 > 临界角 C，sinC = 1/n", annotation: "两条件同时满足"),
                SolutionStep(order: 3, description: "结果", formula: "折射光消失，能量 100% 反射", annotation: "光纤、内窥镜的原理"),
            ],
            keyInsight: "全反射 = 光密→光疏 且 入射角>临界角，两条件缺一不可。",
            commonMistakes: ["只记角度、忘了方向前提"]
        ),
        misconceptions: [
            Misconception(
                option: "光从光疏介质射入光密介质时，也可能发生全反射",
                youThought: "你大概觉得全反射只跟入射角大小有关。",
                pitfall: "光疏→光密时折射角更小，光永远能射进去，压根没有临界角。",
                fix: "必须是光密→光疏（如玻璃→空气）才可能全反射。"
            ),
            Misconception(
                option: "只要入射角足够大，任何界面都能发生全反射",
                youThought: "你大概以为角度够大就一定全反射。",
                pitfall: "忽略了方向前提：光疏→光密无论角多大都有折射光。",
                fix: "两个条件缺一不可——光密→光疏 且 入射角>临界角。"
            ),
            Misconception(
                option: "发生全反射时，仍有一部分光折射出去",
                youThought: "你大概觉得反射和折射总是同时存在。",
                pitfall: "「全」就是全部——超过临界角后折射光彻底消失。",
                fix: "全反射时能量 100% 反射，正因如此光纤几乎无损耗传光。"
            ),
        ],
        tags: ["光学", "全反射", "概念秒杀", "错因诊断"]
    )

    // MARK: - 降维战例：双缝干涉条纹间距

    static let doubleSlitDescent = PhysicsProblem(
        id: "double_slit",
        type: .calculation,
        stage: .senior,
        topic: .optics,
        content: "双缝间距为 d，缝到屏的距离为 L，用单色光照射。先后改用紫光和红光做实验，哪种光的相邻亮纹间距更大？相邻亮纹间距的表达式是什么？",
        answer: "Δx = Lλ/d；红光波长更长，条纹间距更大",
        difficulty: 0.5,
        averageTime: 120,
        hints: ["条纹间距与波长什么关系？", "红光和紫光谁波长长？"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "相邻亮纹间距", formula: "Δx = Lλ/d", annotation: "正比于波长 λ"),
                SolutionStep(order: 2, description: "比较", formula: "λ红 > λ紫 ⟹ Δx红 > Δx紫", annotation: "红光条纹更宽"),
            ],
            keyInsight: "条纹间距正比于波长，红光波长最长所以条纹最宽。",
            commonMistakes: ["把 d 与 L 的位置写反"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "分别代入红光、紫光波长算出两个 Δx", formula: "Δx = Lλ/d 各算一次", annotation: "两次计算再比较"),
                ],
                keyInsight: "把两种光的条纹间距分别算出来再比大小。",
                commonMistakes: ["代入数值算错"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "抓住正比关系 Δx ∝ λ", formula: "Δx = Lλ/d，其余量都相同", annotation: "只剩 λ 在变"),
                    SolutionStep(order: 2, description: "直接比波长", formula: "红光波长最长 ⟹ 条纹最宽", annotation: "不用算数值，一眼定胜负"),
                ],
                keyInsight: "正比思维：其它量都一样时，只盯着唯一变化的量比大小。",
                commonMistakes: []
            ),
            weaponUsed: .graphMethod,
            timeRatio: 2.0,
            detailedExplanation: "「控制变量 + 正比关系」是比较类题目的通杀套路——别急着代数值，先看哪个量在变、成什么比例。"
        ),
        tags: ["光学", "双缝干涉", "正比思维", "降维"]
    )

    // MARK: - 竞赛降维：水柱冲力（微元法）

    static let waterJetForce = PhysicsProblem(
        id: "water_jet",
        type: .calculation,
        stage: .olympiad,
        topic: .momentum,
        content: "水平水管以速度 v 喷出水柱冲击竖直墙壁，水柱横截面积为 S，水的密度为 ρ，水打到墙后不反弹（沿墙面流下）。求水对墙的平均冲力。",
        answer: "F = ρSv²",
        difficulty: 0.75,
        averageTime: 200,
        hints: ["取一小段时间 Δt 内打到墙的水", "对这段水用动量定理"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "微元：Δt 内打到墙的水", formula: "Δm = ρ·S·v·Δt", annotation: "这段水长 vΔt"),
                SolutionStep(order: 2, description: "对这段水用动量定理", formula: "F·Δt = Δm·v", annotation: "速度由 v 变 0"),
                SolutionStep(order: 3, description: "解出", formula: "F = ρSv²", annotation: "Δt 约掉"),
            ],
            keyInsight: "连续的水流，用「微元」切成一小段，就能套动量定理。",
            commonMistakes: ["把流量和质量搞混", "误以为水反弹（动量变化要翻倍）"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "试图对「整根连续水柱」直接分析受力", formula: "连续介质，受力随时间分布", annotation: "无从下手"),
                    SolutionStep(order: 2, description: "纠结于水流是连续的、没有明确的「一个物体」", formula: "——", annotation: "卡住"),
                ],
                keyInsight: "把连续水流当整体，找不到下手点。",
                commonMistakes: ["无从建立方程"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "微元法：只盯 Δt 内的那一小段水", formula: "Δm = ρSv·Δt，Δp = Δm·v", annotation: "化连续为离散"),
                    SolutionStep(order: 2, description: "动量定理一步出", formula: "F = Δp/Δt = ρSv²", annotation: "干净利落"),
                ],
                keyInsight: "微元法是处理连续 / 变化问题的万能钥匙——切一小片，化无限为有限。",
                commonMistakes: []
            ),
            weaponUsed: .infinitesimal,
            timeRatio: 5.0,
            detailedExplanation: "凡是「连续水流 / 链条 / 变质量」的冲力问题，都用微元法：取 Δt 微元 → 算 Δm 与 Δp → F=Δp/Δt。这是竞赛与大学物理的通用思路。"
        ),
        tags: ["微元法", "动量", "流体冲力", "竞赛"]
    )

    // MARK: - 竞赛降维：等边三角形三电荷（对称法）

    static let triangleCharge = PhysicsProblem(
        id: "tri_charge",
        type: .calculation,
        stage: .olympiad,
        topic: .electricField,
        content: "边长为 a 的等边三角形，三个顶点各放一个电荷量为 +q 的点电荷。求其中任意一个电荷所受的合力大小。",
        answer: "F = √3·kq²/a²",
        difficulty: 0.7,
        averageTime: 180,
        hints: ["该电荷受另两个电荷的斥力，大小都是 kq²/a²", "两力夹角 60°，用对称性找合力方向"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "两个分力", formula: "F₀ = kq²/a²，夹角 60°", annotation: "大小相等"),
                SolutionStep(order: 2, description: "对称 → 合力沿中线", formula: "F = 2F₀·cos30° = √3·kq²/a²", annotation: "对称性定方向、平行四边形定大小"),
            ],
            keyInsight: "两个等大的力，合力沿它们夹角的平分线。",
            commonMistakes: ["把夹角当成 120°", "忘了矢量合成"]
        ),
        dualSolution: DualSolution(
            standardMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "建坐标系，把两个力都分解到 x、y", formula: "Fx、Fy 分别求和", annotation: "三角函数一堆"),
                    SolutionStep(order: 2, description: "再合成", formula: "F = √(Fx²+Fy²)", annotation: "计算量大、易错"),
                ],
                keyInsight: "正交分解硬算，步骤多。",
                commonMistakes: ["分量正负搞错"]
            ),
            descentMethod: SolutionPath(
                steps: [
                    SolutionStep(order: 1, description: "看出对称：合力必沿中线方向", formula: "无需分解，方向已知", annotation: "对称性送的"),
                    SolutionStep(order: 2, description: "两等大力夹角 60°", formula: "F = 2F₀cos30° = √3·kq²/a²", annotation: "一步合成"),
                ],
                keyInsight: "对称性先把方向白送给你，剩下只需算大小。",
                commonMistakes: []
            ),
            weaponUsed: .symmetry,
            timeRatio: 3.0,
            detailedExplanation: "对称性是物理里最省力的武器：先用对称看出合力方向，再只算大小，绕开繁琐的正交分解。"
        ),
        tags: ["对称法", "库仑力", "矢量合成", "竞赛"]
    )

    // MARK: - 初中：相对运动（错因诊断）

    static let relativeMotionJunior = PhysicsProblem(
        id: "relative_motion",
        type: .multipleChoice,
        stage: .junior,
        topic: .kinematics,
        content: "坐在行驶的列车里，看到窗外的树木「向后退」。关于这个现象，下列说法正确的是？",
        options: [
            "树木真的在向后运动",
            "以列车为参照物，树木在向后运动",
            "以地面为参照物，树木在向后运动",
            "树木既在运动又静止，自相矛盾"
        ],
        answer: "以列车为参照物，树木在向后运动",
        difficulty: 0.25,
        averageTime: 40,
        hints: ["运动和静止都是相对于「参照物」说的", "换个参照物，结论可能就变了"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "选参照物", formula: "以列车为参照物", annotation: "树相对列车向后"),
                SolutionStep(order: 2, description: "换参照物", formula: "以地面为参照物，树静止", annotation: "同一棵树，结论不同"),
            ],
            keyInsight: "运动是相对的——说运动前必须先说清「相对谁」。",
            commonMistakes: ["以为运动是绝对的"]
        ),
        misconceptions: [
            Misconception(
                option: "树木真的在向后运动",
                youThought: "你大概觉得「看到它动」就是它真的在动。",
                pitfall: "动不动取决于参照物。相对地面，树是静止的。",
                fix: "说运动前先问「相对谁」——相对列车向后，相对地面静止。"
            ),
            Misconception(
                option: "以地面为参照物，树木在向后运动",
                youThought: "你大概把车里看到的现象直接安到了地面参照系上。",
                pitfall: "相对地面树是不动的，是你（和列车）在前进。",
                fix: "换参照物结论就变：地面看树静止，列车看树后退。"
            ),
            Misconception(
                option: "树木既在运动又静止，自相矛盾",
                youThought: "你大概觉得同一棵树不能既动又不动。",
                pitfall: "这不矛盾——只是参照物不同。运动的相对性正是如此。",
                fix: "相对列车在动、相对地面静止，两者都对，不冲突。"
            ),
        ],
        tags: ["相对运动", "参照物", "受力直觉", "错因诊断"]
    )

    // MARK: - 初中：浮力沉浮（错因诊断）

    static let buoyancyJunior = PhysicsProblem(
        id: "buoyancy_float",
        type: .multipleChoice,
        stage: .junior,
        topic: .newton,
        content: "一块木头漂浮在水面上，静止不动。关于它受到的浮力，下列说法正确的是？",
        options: [
            "浮力大于重力，所以它浮着",
            "浮力等于重力",
            "浸入越深，浮力一定越大",
            "木头越大，浮力一定越大"
        ],
        answer: "浮力等于重力",
        difficulty: 0.3,
        averageTime: 45,
        hints: ["静止 → 受力平衡", "漂浮时浮力和重力什么关系？"],
        solution: SolutionPath(
            steps: [
                SolutionStep(order: 1, description: "静止 → 二力平衡", formula: "F浮 = G", annotation: "上下两个力相等"),
                SolutionStep(order: 2, description: "若浮力更大", formula: "会加速上浮，不会静止", annotation: "所以必相等"),
            ],
            keyInsight: "漂浮静止 = 浮力恰好等于重力（二力平衡）。",
            commonMistakes: ["以为浮着就是浮力更大"]
        ),
        misconceptions: [
            Misconception(
                option: "浮力大于重力，所以它浮着",
                youThought: "你大概觉得「浮着」就说明浮力赢了重力。",
                pitfall: "浮力若真的更大，木头会加速往上冲出水面，不会静止。",
                fix: "静止 = 受力平衡，浮力恰好等于重力。"
            ),
            Misconception(
                option: "浸入越深，浮力一定越大",
                youThought: "你大概觉得越深水压越大、浮力越大。",
                pitfall: "完全浸没后再往深处，排开水的体积不变，浮力就不变了。",
                fix: "浮力 = ρ水·g·V排，只看排开水的体积，与深度无关（未全没时才随深度变）。"
            ),
            Misconception(
                option: "木头越大，浮力一定越大",
                youThought: "你大概觉得物体越大浮力越大。",
                pitfall: "漂浮时浮力只等于自身重力；大木头重力大、浮力才大，但「漂浮」这一条下浮力=重力恒成立。",
                fix: "漂浮物体的浮力由它的重力决定，不是由体积直接决定。"
            ),
        ],
        tags: ["浮力", "二力平衡", "受力直觉", "错因诊断"]
    )
}
