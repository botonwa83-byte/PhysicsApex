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
    ]
}
