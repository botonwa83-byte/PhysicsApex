import SwiftUI

// MARK: - 公式速记闪卡（answer-first：先回忆 → 再揭晓 → 自评，纯训练交互）
//
// 合规约定（改动前先读）：卡片正反面都必须是"训练型短句"，不得出现成段正文。
// 定律数据里的长句（physicalImage / intuition 等）一律先过 TrainingCopy 裁剪再上屏——
// 这样屏幕上永远是一张卡，而不是一段资料。ContentIntegrityTests 里有对应的守门测试。

struct LawFlashcard: Identifiable {
    enum Kind: String, CaseIterable {
        case expression   // 表达式
        case meaning      // 物理意义
        case conditions   // 适用条件
        case misuses      // 常见迷思
        case limitCheck   // 极限检验

        var label: String {
            switch self {
            case .expression: return "表达式"
            case .meaning: return "物理意义"
            case .conditions: return "适用条件"
            case .misuses: return "常见迷思"
            case .limitCheck: return "极限检验"
            }
        }

        var icon: String {
            switch self {
            case .expression: return "function"
            case .meaning: return "brain.head.profile"
            case .conditions: return "checkmark.seal.fill"
            case .misuses: return "xmark.octagon.fill"
            case .limitCheck: return "slider.horizontal.below.square.filled.and.square"
            }
        }

        var accent: Color {
            switch self {
            case .expression: return .apexLava
            case .meaning: return .apexStarBlue
            case .conditions: return .apexEmerald
            case .misuses: return .apexDanger
            case .limitCheck: return .apexMystery
            }
        }
    }

    let id: String            // "\(lawId)#\(kind)#\(index)"
    let lawId: String
    let lawName: String
    let kind: Kind
    let prompt: String        // 正面：先回忆
    let answerTitle: String   // 背面主答案（短）
    let answerBody: String    // 背面补充（可多行）
    let latex: String?        // 有则用 FormulaView 渲染
}

// MARK: - 卡片工厂：从现有 PhysicsLaw 字段机械生成，不改定律数据

enum LawFlashcardFactory {
    static var all: [LawFlashcard] {
        LawLibrary.all.flatMap { cards(for: $0) }
    }

    static func cards(for topic: PhysicsTopic) -> [LawFlashcard] {
        LawLibrary.laws(for: topic).flatMap { cards(for: $0) }
    }

    static func cards(for law: PhysicsLaw) -> [LawFlashcard] {
        var cards: [LawFlashcard] = []

        // ① 表达式
        cards.append(LawFlashcard(
            id: "\(law.id)#expression#0",
            lawId: law.id,
            lawName: law.name,
            kind: .expression,
            prompt: "「\(law.name)」的表达式是？",
            answerTitle: law.expression,
            answerBody: "量纲 / 单位：\(law.dimension)",
            latex: law.latex
        ))

        // ② 物理意义
        cards.append(LawFlashcard(
            id: "\(law.id)#meaning#0",
            lawId: law.id,
            lawName: law.name,
            kind: .meaning,
            prompt: "「\(law.name)」（\(law.expression)）的物理意义是？",
            answerTitle: TrainingCopy.concise(law.meaning, limit: TrainingCopy.titleLimit),
            answerBody: TrainingCopy.concise(law.physicalImage),
            latex: nil
        ))

        // ③ 适用条件
        if !law.conditions.isEmpty {
            cards.append(LawFlashcard(
                id: "\(law.id)#conditions#0",
                lawId: law.id,
                lawName: law.name,
                kind: .conditions,
                prompt: "使用「\(law.name)」的前提条件有哪些？",
                answerTitle: "适用条件",
                answerBody: TrainingCopy.bullets(law.conditions),
                latex: nil
            ))
        }

        // ④ 常见迷思
        if !law.commonMisuses.isEmpty {
            cards.append(LawFlashcard(
                id: "\(law.id)#misuses#0",
                lawId: law.id,
                lawName: law.name,
                kind: .misuses,
                prompt: "用「\(law.name)」最容易犯什么错？",
                answerTitle: "常见迷思",
                answerBody: TrainingCopy.bullets(law.commonMisuses),
                latex: nil
            ))
        }

        // ⑤ 极限检验：每条一张（把变量推到极端，先猜再看）
        for (i, check) in law.limitChecks.enumerated() {
            cards.append(LawFlashcard(
                id: "\(law.id)#limitCheck#\(i)",
                lawId: law.id,
                lawName: law.name,
                kind: .limitCheck,
                prompt: "极端检验：\(check.scenario)，「\(law.expression)」会怎样？",
                answerTitle: TrainingCopy.concise(check.result, limit: TrainingCopy.titleLimit),
                answerBody: TrainingCopy.concise(check.intuition),
                latex: nil
            ))
        }

        return cards
    }
}
