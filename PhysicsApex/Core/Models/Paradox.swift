import SwiftUI

// MARK: - 物理佯谬 / 思维挑战（移植自 MathApex Mystery）

enum ParadoxCategory: String, Codable, CaseIterable {
    case relativity   // 相对论佯谬
    case quantum      // 量子诡异
    case thermo       // 热力学幽灵
    case classic      // 经典思维推演

    var displayName: String {
        switch self {
        case .relativity: return "相对论佯谬"
        case .quantum:    return "量子诡异"
        case .thermo:     return "热力学幽灵"
        case .classic:    return "经典推演"
        }
    }
    var icon: String {
        switch self {
        case .relativity: return "clock.arrow.2.circlepath"
        case .quantum:    return "atom"
        case .thermo:     return "wind"
        case .classic:    return "lightbulb"
        }
    }
    var color: Color {
        switch self {
        case .relativity: return .apexStarBlue
        case .quantum:    return .apexMystery
        case .thermo:     return .apexLava
        case .classic:    return .apexGold
        }
    }
}

struct Paradox: Identifiable, Codable {
    let id: String
    let title: String
    let category: ParadoxCategory
    let hook: String          // 一句话钩子
    let setup: String         // 情境设定
    let theParadox: String    // 矛盾在哪
    let resolution: String    // 物理学如何化解
    let takeaway: String      // 你该记住什么
    let relatedGiants: [String]

    enum CodingKeys: String, CodingKey {
        case id, title, category, hook, setup, theParadox, resolution, takeaway, relatedGiants
    }
}
