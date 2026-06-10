import SwiftUI

// MARK: - 段位系统：PhysicsApex 的脊梁
// 三段递进闯关：初中建直觉 → 高中练硬功(主战场) → 竞赛降维打击。

enum Stage: String, Codable, CaseIterable, Identifiable {
    case junior    // 初中
    case senior    // 高中（主战场）
    case olympiad  // 竞赛（天花板）

    var id: String { rawValue }

    var title: String {
        switch self {
        case .junior:   return "初中 · 建直觉"
        case .senior:   return "高中 · 练硬功"
        case .olympiad: return "竞赛 · 降维打击"
        }
    }

    var shortTitle: String {
        switch self {
        case .junior:   return "初中"
        case .senior:   return "高中"
        case .olympiad: return "竞赛"
        }
    }

    var emoji: String {
        switch self {
        case .junior:   return "🌱"
        case .senior:   return "⚔️"
        case .olympiad: return "👁"
        }
    }

    var subtitle: String {
        switch self {
        case .junior:   return "现象 · 图像 · 基础直觉"
        case .senior:   return "受力分析 · 标准解 · 高考主线"
        case .olympiad: return "守恒 · 对称 · 微元 · 量纲"
        }
    }

    var color: Color {
        switch self {
        case .junior:   return .stageJunior
        case .senior:   return .stageSenior
        case .olympiad: return .stageOlympiad
        }
    }

    /// 段位顺序（用于解锁判断）。
    var rank: Int {
        switch self {
        case .junior:   return 0
        case .senior:   return 1
        case .olympiad: return 2
        }
    }

    /// 当前段位是否已解锁 `other` 段位的内容。
    func unlocks(_ other: Stage) -> Bool { other.rank <= rank }
}
