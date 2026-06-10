import Foundation

// MARK: - 物理巨人 数据

enum GiantsData {
    static let all: [PhysicsGiant] = [
        PhysicsGiant(
            id: "newton",
            name: "牛顿",
            nameEN: "Isaac Newton",
            era: "1643–1727",
            attributes: GiantAttributes(insight: 10, creativity: 10, perseverance: 9, influence: 10),
            weaponSkills: ["牛顿第二定律", "万有引力", "微积分"],
            legendStory: "瘟疫避居乡下的「奇迹之年」里，他发明微积分、提出万有引力、分解白光。用三条定律统一了天上地下的运动。",
            famousQuote: "如果说我看得更远，那是因为我站在巨人的肩膀上。",
            relatedParadoxes: ["galileo_tower"],
            portraitEmoji: "🍎"
        ),
        PhysicsGiant(
            id: "einstein",
            name: "爱因斯坦",
            nameEN: "Albert Einstein",
            era: "1879–1955",
            attributes: GiantAttributes(insight: 10, creativity: 10, perseverance: 9, influence: 10),
            weaponSkills: ["相对论", "光电效应", "质能方程"],
            legendStory: "26 岁的「奇迹年」一口气发表狭义相对论、光电效应、布朗运动。一个思想实验——追着光跑会看到什么——掀翻了牛顿的绝对时空。",
            famousQuote: "想象力比知识更重要。",
            relatedParadoxes: ["twin_paradox"],
            portraitEmoji: "🧠"
        ),
        PhysicsGiant(
            id: "faraday",
            name: "法拉第",
            nameEN: "Michael Faraday",
            era: "1791–1867",
            attributes: GiantAttributes(insight: 10, creativity: 9, perseverance: 10, influence: 9),
            weaponSkills: ["电磁感应", "电场线", "电解定律"],
            legendStory: "装订工出身、几乎没受过数学训练，却凭惊人的实验直觉发现电磁感应，用「力线」图像看见了看不见的场。",
            famousQuote: "没有什么比一个能解释大量事实的理论更实用。",
            relatedParadoxes: [],
            portraitEmoji: "🧲"
        ),
        PhysicsGiant(
            id: "maxwell",
            name: "麦克斯韦",
            nameEN: "James Clerk Maxwell",
            era: "1831–1879",
            attributes: GiantAttributes(insight: 10, creativity: 10, perseverance: 8, influence: 10),
            weaponSkills: ["麦克斯韦方程组", "电磁波", "统计力学"],
            legendStory: "用四个方程统一了电、磁、光，预言了电磁波的存在。还提出了著名的「麦克斯韦妖」思想实验挑战热力学第二定律。",
            famousQuote: "光是电磁场中的扰动。",
            relatedParadoxes: ["maxwell_demon"],
            portraitEmoji: "📐"
        ),
        PhysicsGiant(
            id: "galileo",
            name: "伽利略",
            nameEN: "Galileo Galilei",
            era: "1564–1642",
            attributes: GiantAttributes(insight: 10, creativity: 9, perseverance: 9, influence: 10),
            weaponSkills: ["惯性思想", "自由落体", "相对性原理"],
            legendStory: "用一个纯粹的思想实验就推翻了「重物先落地」：把轻重两球绑一起会更快还是更慢？矛盾本身证明了亚里士多德错了。",
            famousQuote: "自然之书是用数学语言写成的。",
            relatedParadoxes: ["galileo_tower"],
            portraitEmoji: "🔭"
        ),
        PhysicsGiant(
            id: "feynman",
            name: "费曼",
            nameEN: "Richard Feynman",
            era: "1918–1988",
            attributes: GiantAttributes(insight: 10, creativity: 10, perseverance: 8, influence: 9),
            weaponSkills: ["路径积分", "费曼图", "量子电动力学"],
            legendStory: "顽童式的物理学家，用一杯冰水和一个 O 形圈在听证会上揭示了挑战者号失事原因。坚信「如果你不能简单解释，说明你没真懂」。",
            famousQuote: "我无法创造的，我就不理解。",
            relatedParadoxes: ["schrodinger_cat"],
            portraitEmoji: "🥁"
        ),
        PhysicsGiant(
            id: "bohr",
            name: "玻尔",
            nameEN: "Niels Bohr",
            era: "1885–1962",
            attributes: GiantAttributes(insight: 10, creativity: 9, perseverance: 9, influence: 10),
            weaponSkills: ["玻尔原子模型", "互补原理", "对应原理"],
            legendStory: "把量子引入原子，解释了氢光谱。与爱因斯坦进行了物理学史上最著名的世纪辩论——爱因斯坦说「上帝不掷骰子」，玻尔回敬「别教上帝该怎么做」。",
            famousQuote: "如果谁不为量子论感到困惑，那他就是没真懂它。",
            relatedParadoxes: ["schrodinger_cat", "epr"],
            portraitEmoji: "⚛️"
        ),
        PhysicsGiant(
            id: "curie",
            name: "居里夫人",
            nameEN: "Marie Curie",
            era: "1867–1934",
            attributes: GiantAttributes(insight: 9, creativity: 9, perseverance: 10, influence: 9),
            weaponSkills: ["放射性研究", "发现钋与镭", "提纯技术"],
            legendStory: "从数吨沥青铀矿中提炼出 0.1 克镭。史上唯一在两个不同学科（物理、化学）都拿到诺奖的人，最终因长期接触辐射献出生命。",
            famousQuote: "生活中没有什么可怕的东西，只有需要理解的东西。",
            relatedParadoxes: [],
            portraitEmoji: "☢️"
        ),
        PhysicsGiant(
            id: "kepler",
            name: "开普勒",
            nameEN: "Johannes Kepler",
            era: "1571–1630",
            attributes: GiantAttributes(insight: 10, creativity: 9, perseverance: 10, influence: 9),
            weaponSkills: ["开普勒三定律", "椭圆轨道", "行星运动"],
            legendStory: "用第谷·布拉赫留下的海量观测数据，固执地算了无数遍，终于发现行星走的是椭圆而非完美的圆，为牛顿的万有引力铺平了道路。",
            famousQuote: "我只是在思考上帝的思想。",
            relatedParadoxes: [],
            portraitEmoji: "🪐"
        ),
        PhysicsGiant(
            id: "ampere",
            name: "安培",
            nameEN: "André-Marie Ampère",
            era: "1775–1836",
            attributes: GiantAttributes(insight: 9, creativity: 9, perseverance: 8, influence: 9),
            weaponSkills: ["安培定律", "电动力学", "电流相互作用"],
            legendStory: "被称为「电学中的牛顿」。在奥斯特发现电流的磁效应后仅一周，他就揭示了两根通电导线之间的相互作用力。电流的单位「安培」就是为纪念他。",
            famousQuote: "把现象上升为定律，才是科学的目标。",
            relatedParadoxes: [],
            portraitEmoji: "🔌"
        ),
    ]
}
