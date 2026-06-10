import Foundation

// MARK: - 题目模型（移植自 MathApex Problem / DualSolution，适配物理）

enum ProblemType: String, Codable {
    case multipleChoice = "multiple_choice"
    case fillInBlank = "fill_in_blank"
    case calculation = "calculation"
}

enum PhysicsTopic: String, Codable, CaseIterable, Identifiable {
    case kinematics      // 运动学
    case newton          // 牛顿运动定律
    case momentum        // 动量
    case energy          // 功和能
    case circular        // 圆周运动 / 万有引力
    case wave            // 机械振动与波
    case electricField   // 电场
    case circuit         // 电路
    case magnetic        // 磁场
    case induction       // 电磁感应
    case thermal         // 热学
    case optics          // 光学
    case modern          // 近代物理

    var id: String { rawValue }
    var name: String {
        switch self {
        case .kinematics:    return "运动学"
        case .newton:        return "牛顿定律"
        case .momentum:      return "动量"
        case .energy:        return "功和能"
        case .circular:      return "圆周·万有引力"
        case .wave:          return "振动与波"
        case .electricField: return "电场"
        case .circuit:       return "电路"
        case .magnetic:      return "磁场"
        case .induction:     return "电磁感应"
        case .thermal:       return "热学"
        case .optics:        return "光学"
        case .modern:        return "近代物理"
        }
    }
    var icon: String {
        switch self {
        case .kinematics:    return "figure.run"
        case .newton:        return "arrow.down.to.line"
        case .momentum:      return "arrow.left.arrow.right"
        case .energy:        return "bolt.fill"
        case .circular:      return "globe"
        case .wave:          return "waveform.path"
        case .electricField: return "e.circle"
        case .circuit:       return "bolt.horizontal.circle"
        case .magnetic:      return "magnet"
        case .induction:     return "wave.3.right"
        case .thermal:       return "thermometer.medium"
        case .optics:        return "rays"
        case .modern:        return "atom"
        }
    }
}

struct SolutionStep: Codable, Identifiable {
    var id: String { "\(order)" }
    let order: Int
    let description: String   // 文字说明
    let formula: String       // 公式（MVP 用 Unicode 文本，二期接 KaTeX）
    let annotation: String    // 旁注 / 物理意义
}

struct SolutionPath: Codable {
    let steps: [SolutionStep]
    let keyInsight: String          // 核心洞察
    let commonMistakes: [String]    // 常见错误
}

/// 迷思点破：针对某个错误选项，诊断学生的错误直觉。
struct Misconception: Codable {
    let option: String      // 触发的错误选项原文
    let youThought: String  // 你大概是这么想的
    let pitfall: String     // 为什么这是个坑
    let fix: String         // 正确该怎么想
}

/// 双解对决：常规解 vs 降维秒杀。
struct DualSolution: Codable {
    let standardMethod: SolutionPath   // 常规解（繁琐但稳）
    let descentMethod: SolutionPath    // 降维秒杀（几步拿下）
    let weaponUsed: PhysicsWeapon      // 用了哪把武器
    let timeRatio: Double              // 耗时比（常规 / 秒杀），越大越爽
    let detailedExplanation: String?
}

struct PhysicsProblem: Identifiable, Codable {
    let id: String
    let type: ProblemType
    let stage: Stage
    let topic: PhysicsTopic
    let content: String
    let options: [String]?
    let answer: String
    let difficulty: Double        // 0...1
    let averageTime: TimeInterval // 秒
    let hints: [String]
    let solution: SolutionPath
    let dualSolution: DualSolution?
    let misconceptions: [Misconception]
    let tags: [String]

    /// 取某个选项对应的迷思诊断（学生选错时点破）。
    func misconception(for option: String) -> Misconception? {
        misconceptions.first { $0.option == option }
    }

    init(id: String, type: ProblemType, stage: Stage, topic: PhysicsTopic,
         content: String, options: [String]? = nil, answer: String,
         difficulty: Double, averageTime: TimeInterval, hints: [String] = [],
         solution: SolutionPath, dualSolution: DualSolution? = nil,
         misconceptions: [Misconception] = [], tags: [String] = []) {
        self.id = id
        self.type = type
        self.stage = stage
        self.topic = topic
        self.content = content
        self.options = options
        self.answer = answer
        self.difficulty = difficulty
        self.averageTime = averageTime
        self.hints = hints
        self.solution = solution
        self.dualSolution = dualSolution
        self.misconceptions = misconceptions
        self.tags = tags
    }
}
