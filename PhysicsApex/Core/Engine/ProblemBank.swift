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
}
