import SwiftUI

// MARK: - 知识全景图模型
// 「全面」体现在地图（一个不漏的高考物理骨架），「精」体现在节点（一句话本质 + 核心公式 + 秒杀武器 + 迷思）。

struct KnowledgePoint: Identifiable {
    let id: String
    let name: String
    let essence: String        // 一句话本质
    let formula: String?       // 核心公式（Unicode）
    let weapon: PhysicsWeapon? // 该用哪把秒杀武器
    let pitfall: String?       // 最容易踩的坑
    let lawId: String?         // 链接「通透卡」
    let stage: Stage           // 难度段位

    init(_ id: String, _ name: String, essence: String, formula: String? = nil,
         weapon: PhysicsWeapon? = nil, pitfall: String? = nil, lawId: String? = nil, stage: Stage = .senior) {
        self.id = id; self.name = name; self.essence = essence; self.formula = formula
        self.weapon = weapon; self.pitfall = pitfall; self.lawId = lawId; self.stage = stage
    }
}

struct KnowledgeChapter: Identifiable {
    let id: String
    let name: String
    let icon: String
    let points: [KnowledgePoint]
}

struct KnowledgeModule: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let chapters: [KnowledgeChapter]

    var pointCount: Int { chapters.reduce(0) { $0 + $1.points.count } }
}
