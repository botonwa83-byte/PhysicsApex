import Foundation

// MARK: - 题库 Batch 6：热 & 光 & 近代（14 题）

extension ProblemBank {

    static let batch6: [PhysicsProblem] = [
        b6_gasState, b6_molecularForce, b6_isothermal, b6_firstLaw, b6_secondLaw,
        b6_tempHeat, b6_refractAngle, b6_criticalAngle, b6_lightNature, b6_planeMirror,
        b6_photoEk, b6_bohrJump, b6_waveParticle, b6_nuclearEnergy,
    ]

    static let b6_gasState = PhysicsProblem(
        id: "b6_gas_state", type: .calculation, stage: .senior, topic: .thermal,
        content: "一定质量理想气体，初态压强 1×10⁵ Pa、体积 2 L、温度 300 K。等压加热到 400 K，求末体积。",
        answer: "V₂ = 8/3 L ≈ 2.67 L", difficulty: 0.5, averageTime: 100,
        hints: ["等压：V/T=常量（盖-吕萨克）"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "等压定律", formula: "V₁/T₁ = V₂/T₂", annotation: ""),
            SolutionStep(order: 2, description: "解出", formula: "V₂ = 2×400/300 ≈ 2.67 L", annotation: ""),
        ], keyInsight: "理想气体状态方程，等压时 V∝T。", commonMistakes: ["温度用摄氏度"]),
        tags: ["热学", "气体定律"])

    static let b6_molecularForce = PhysicsProblem(
        id: "b6_molecular_force", type: .multipleChoice, stage: .senior, topic: .thermal,
        content: "关于分子间作用力，下列说法正确的是？",
        options: ["分子间只有引力", "分子间只有斥力",
                  "分子间同时存在引力和斥力，合力随距离变化", "分子间没有作用力"],
        answer: "分子间同时存在引力和斥力，合力随距离变化",
        difficulty: 0.4, averageTime: 50, hints: ["引力斥力都随距离变，斥力变化更快"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "本质", formula: "引力、斥力并存", annotation: "近距斥力为主、远距引力为主"),
        ], keyInsight: "分子力是引力和斥力的合力，存在一个平衡距离。",
           commonMistakes: ["以为只有引力或只有斥力"]),
        tags: ["热学", "分子动理论"])

    static let b6_isothermal = PhysicsProblem(
        id: "b6_isothermal", type: .calculation, stage: .senior, topic: .thermal,
        content: "一定质量气体在温度不变时，压强从 2×10⁵ Pa 变到 5×10⁵ Pa。若初体积为 5 L，求末体积。",
        answer: "V₂ = 2 L", difficulty: 0.45, averageTime: 80, hints: ["等温：pV=常量（玻意耳）"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "玻意耳定律", formula: "p₁V₁ = p₂V₂", annotation: ""),
            SolutionStep(order: 2, description: "解出", formula: "V₂ = 2×5/5 = 2 L", annotation: ""),
        ], keyInsight: "等温：压强与体积成反比。", commonMistakes: ["正反比搞反"]),
        tags: ["热学", "玻意耳定律"])

    static let b6_firstLaw = PhysicsProblem(
        id: "b6_first_law", type: .calculation, stage: .senior, topic: .thermal,
        content: "一定质量气体吸收 200 J 热量，同时对外做功 80 J。求气体内能的变化。",
        answer: "ΔU = +120 J（增大）", difficulty: 0.5, averageTime: 90,
        hints: ["ΔU=W+Q", "对外做功 W为负 −80 J，吸热 Q=+200 J"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "热力学第一定律", formula: "ΔU = W + Q = (−80) + 200 = 120 J", annotation: "对外做功 W 取负"),
        ], keyInsight: "ΔU=W+Q：吸热为正，对外做功为负。",
           commonMistakes: ["对外做功符号取正"]),
        tags: ["热学", "热力学第一定律"])

    static let b6_secondLaw = PhysicsProblem(
        id: "b6_second_law", type: .multipleChoice, stage: .senior, topic: .thermal,
        content: "关于热力学第二定律，下列说法正确的是？",
        options: ["热量可以自发地从低温物体传到高温物体", "热量不能从低温传到高温",
                  "热量可以从低温传到高温，但需要外界做功（如制冷机）", "第二定律否定了能量守恒"],
        answer: "热量可以从低温传到高温，但需要外界做功（如制冷机）",
        difficulty: 0.5, averageTime: 60, hints: ["第二定律讲的是「自发」过程的方向"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "方向性", formula: "热自发地高温→低温", annotation: "反向需外界做功"),
        ], keyInsight: "第二定律约束的是「自发」方向；借助外力（制冷机）可以反向。",
           commonMistakes: ["以为热绝对不能从低温到高温"]),
        misconceptions: [
            Misconception(option: "热量不能从低温传到高温",
                youThought: "你大概觉得热永远只能从热流向冷。",
                pitfall: "冰箱、空调正是把热从低温搬到高温——只是要耗电（外界做功）。",
                fix: "第二定律说的是「不能自发」，借助外力可以反向。")
        ], tags: ["热学", "热力学第二定律", "错因诊断"])

    static let b6_tempHeat = PhysicsProblem(
        id: "b6_temp_heat", type: .multipleChoice, stage: .junior, topic: .thermal,
        content: "关于温度、热量和内能，下列说法正确的是？",
        options: ["温度高的物体含有的热量多", "热量是物体含有的能量",
                  "热传递中，内能从高温物体转移到低温物体", "温度越高，内能一定越大"],
        answer: "热传递中，内能从高温物体转移到低温物体",
        difficulty: 0.4, averageTime: 55, hints: ["热量是过程量，不能说「含有」"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "热量是过程量", formula: "热量是「传递」的能量", annotation: "不能说物体含有热量"),
        ], keyInsight: "热量是过程量（传递的能量），内能才是状态量。",
           commonMistakes: ["说物体「含有」热量"]),
        misconceptions: [
            Misconception(option: "温度高的物体含有的热量多",
                youThought: "你大概觉得温度高就「存」了更多热量。",
                pitfall: "热量是传递过程中的能量，物体只能「含有」内能，不能含有热量。",
                fix: "内能是状态量（物体有多少），热量是过程量（传递了多少）。")
        ], tags: ["热学", "温度内能热量", "错因诊断"])

    static let b6_refractAngle = PhysicsProblem(
        id: "b6_refract_angle", type: .calculation, stage: .senior, topic: .optics,
        content: "光从空气射入某介质，入射角 45°，折射角 30°。求该介质的折射率。(sin45°=√2/2, sin30°=0.5)",
        answer: "n = √2 ≈ 1.41", difficulty: 0.45, averageTime: 90, hints: ["n=sinθ₁/sinθ₂"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "折射定律", formula: "n = sin45°/sin30° = (√2/2)/0.5 = √2", annotation: ""),
        ], keyInsight: "折射率 n=sin入射角/sin折射角。", commonMistakes: ["角度比而非正弦比"]),
        tags: ["光学", "折射"])

    static let b6_criticalAngle = PhysicsProblem(
        id: "b6_critical_angle", type: .calculation, stage: .senior, topic: .optics,
        content: "某介质的折射率为 n=2。求光从该介质射向空气时发生全反射的临界角。(sin30°=0.5)",
        answer: "C = 30°", difficulty: 0.45, averageTime: 80, hints: ["sinC=1/n"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "临界角", formula: "sinC = 1/n = 0.5 ⟹ C = 30°", annotation: ""),
        ], keyInsight: "临界角 sinC=1/n。", commonMistakes: ["sinC=n 记反"]),
        tags: ["光学", "全反射"])

    static let b6_lightNature = PhysicsProblem(
        id: "b6_light_nature", type: .multipleChoice, stage: .senior, topic: .optics,
        content: "光的干涉和衍射现象说明？",
        options: ["光是一种波", "光是一种粒子流", "光没有能量", "光速可以改变"],
        answer: "光是一种波",
        difficulty: 0.4, averageTime: 50, hints: ["干涉衍射是波特有的现象"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "波动性", formula: "干涉、衍射 → 波动性", annotation: "光电效应才显粒子性"),
        ], keyInsight: "干涉衍射证明光的波动性；光电效应证明粒子性——波粒二象性。",
           commonMistakes: ["把干涉当成粒子性证据"]),
        tags: ["光学", "光的本性"])

    static let b6_planeMirror = PhysicsProblem(
        id: "b6_plane_mirror", type: .multipleChoice, stage: .junior, topic: .optics,
        content: "关于平面镜成像，下列说法正确的是？",
        options: ["成的是放大的实像", "像与物到镜面距离相等，是虚像",
                  "像比物体小", "人离镜越远，像越小"],
        answer: "像与物到镜面距离相等，是虚像",
        difficulty: 0.3, averageTime: 45, hints: ["平面镜成等大正立虚像"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "成像特点", formula: "等大、正立、虚像，物像对称", annotation: ""),
        ], keyInsight: "平面镜：等大正立虚像，物像关于镜面对称，距离相等。",
           commonMistakes: ["以为离远像变小"]),
        misconceptions: [
            Misconception(option: "人离镜越远，像越小",
                youThought: "你大概觉得离镜子远了，镜中的像就变小。",
                pitfall: "平面镜成的像永远和物体等大；远了只是看起来视角小，像本身不变。",
                fix: "平面镜像始终等大，物像到镜面距离相等。")
        ], tags: ["光学", "平面镜", "错因诊断"])

    static let b6_photoEk = PhysicsProblem(
        id: "b6_photo_ek", type: .calculation, stage: .senior, topic: .modern,
        content: "某金属逸出功 W₀=2.0 eV，用光子能量为 5.0 eV 的紫外线照射。求逸出光电子的最大初动能。",
        answer: "Ek = 3.0 eV", difficulty: 0.45, averageTime: 80, hints: ["Ek=hν−W₀"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "光电方程", formula: "Ek = hν − W₀ = 5.0 − 2.0 = 3.0 eV", annotation: ""),
        ], keyInsight: "最大初动能 = 光子能量 − 逸出功。", commonMistakes: ["加号写成减"]),
        tags: ["近代物理", "光电效应"])

    static let b6_bohrJump = PhysicsProblem(
        id: "b6_bohr_jump", type: .calculation, stage: .senior, topic: .modern,
        content: "氢原子从能量 E₃=−1.51 eV 的能级跃迁到 E₂=−3.4 eV 的能级。求放出光子的能量。",
        answer: "光子能量 = 1.89 eV", difficulty: 0.5, averageTime: 90,
        hints: ["hν=E_高−E_低", "向低能级跃迁放出光子"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "能级差", formula: "hν = E₃ − E₂ = −1.51 − (−3.4) = 1.89 eV", annotation: ""),
        ], keyInsight: "跃迁放出/吸收光子能量 = 两能级之差。", commonMistakes: ["负号处理错"]),
        tags: ["近代物理", "玻尔模型"])

    static let b6_waveParticle = PhysicsProblem(
        id: "b6_wave_particle", type: .multipleChoice, stage: .senior, topic: .modern,
        content: "关于光的波粒二象性，下列说法正确的是？",
        options: ["光要么是波，要么是粒子，不能两者都是", "光既具有波动性又具有粒子性",
                  "频率越高波动性越强", "光强越大粒子性越弱"],
        answer: "光既具有波动性又具有粒子性",
        difficulty: 0.4, averageTime: 50, hints: ["干涉衍射显波动性，光电效应显粒子性"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "二象性", formula: "波动性 + 粒子性", annotation: "不同实验显不同侧面"),
        ], keyInsight: "光同时具有波动性和粒子性，这就是波粒二象性。",
           commonMistakes: ["认为二者互相排斥"]),
        misconceptions: [
            Misconception(option: "光要么是波，要么是粒子，不能两者都是",
                youThought: "你大概觉得波和粒子是矛盾的、不能共存。",
                pitfall: "光在干涉衍射里像波、在光电效应里像粒子——两种属性都真实存在。",
                fix: "波粒二象性：光既是波又是粒子，这是量子世界的本性。")
        ], tags: ["近代物理", "波粒二象性", "错因诊断"])

    static let b6_nuclearEnergy = PhysicsProblem(
        id: "b6_nuclear_energy", type: .calculation, stage: .senior, topic: .modern,
        content: "某核反应中质量亏损 Δm=3×10⁻²⁹ kg。求释放的能量。(c=3×10⁸ m/s)",
        answer: "E = 2.7×10⁻¹² J", difficulty: 0.5, averageTime: 90, hints: ["E=Δmc²"],
        solution: SolutionPath(steps: [
            SolutionStep(order: 1, description: "质能方程", formula: "E = Δmc² = 3×10⁻²⁹×(3×10⁸)² = 2.7×10⁻¹² J", annotation: ""),
        ], keyInsight: "质量亏损释放能量 E=Δmc²。", commonMistakes: ["c 没平方"]),
        tags: ["近代物理", "质能方程"])
}
