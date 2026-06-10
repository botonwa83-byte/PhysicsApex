import SwiftUI

// MARK: - 降维武器：按「工具」组织（而非按章节），按段位解锁
// 产品灵魂：用「上帝视角」工具几步秒杀，跳过繁琐受力分析 / 硬算。

enum PhysicsWeapon: String, Codable, CaseIterable, Identifiable {
    // 初中
    case forceDiagram       // 受力图三步法
    case energyIntuition    // 能量守恒思想
    case graphMethod        // 图像法 v-t / s-t
    case controlVariable    // 控制变量
    case equivalentCircuit  // 等效电路
    // 高中（主战场）
    case momentumConservation   // 动量守恒
    case mechanicalEnergy       // 机械能守恒
    case workEnergyTheorem      // 动能定理
    case equivalentMethod       // 等效法（等效重力 / 等效电源）
    case referenceFrame         // 参考系变换
    case lenzRule               // 楞次定则速判
    case symmetry               // 对称法
    // 竞赛（点缀 · 真·降维）
    case infinitesimal          // 微元法
    case dimensionalAnalysis    // 量纲分析
    case extremumPrinciple      // 极值 / 变分原理
    case crossProduct           // 矢量叉乘
    case approximation          // 近似展开
    // ── 扩展武器（v2）：高中技巧型 + 竞赛进阶 ──
    case wholeIsolation         // 整体隔离法
    case criticalAnalysis       // 临界分析
    case assumption             // 假设法
    case proportion             // 比例法
    case reverseThinking        // 逆向思维
    case analogy                // 类比迁移
    case specialCase            // 特殊值法
    case vectorTriangle         // 矢量三角形
    case angularMomentum        // 角动量守恒
    case virtualWork            // 虚功原理
    case imageCharge            // 镜像法
    case potentialCurve         // 势能曲线法
    case scaling                // 标度分析

    var id: String { rawValue }

    var name: String {
        switch self {
        case .forceDiagram:        return "受力图三步法"
        case .energyIntuition:     return "能量守恒思想"
        case .graphMethod:         return "图像法"
        case .controlVariable:     return "控制变量"
        case .equivalentCircuit:   return "等效电路"
        case .momentumConservation:return "动量守恒"
        case .mechanicalEnergy:    return "机械能守恒"
        case .workEnergyTheorem:   return "动能定理"
        case .equivalentMethod:    return "等效法"
        case .referenceFrame:      return "参考系变换"
        case .lenzRule:            return "楞次定则速判"
        case .symmetry:            return "对称法"
        case .infinitesimal:       return "微元法"
        case .dimensionalAnalysis: return "量纲分析"
        case .extremumPrinciple:   return "极值原理"
        case .crossProduct:        return "矢量叉乘"
        case .approximation:       return "近似展开"
        case .wholeIsolation:      return "整体隔离法"
        case .criticalAnalysis:    return "临界分析"
        case .assumption:          return "假设法"
        case .proportion:          return "比例法"
        case .reverseThinking:     return "逆向思维"
        case .analogy:             return "类比迁移"
        case .specialCase:         return "特殊值法"
        case .vectorTriangle:      return "矢量三角形"
        case .angularMomentum:     return "角动量守恒"
        case .virtualWork:         return "虚功原理"
        case .imageCharge:         return "镜像法"
        case .potentialCurve:      return "势能曲线法"
        case .scaling:             return "标度分析"
        }
    }

    var icon: String {
        switch self {
        case .forceDiagram:        return "arrow.up.and.down.and.arrow.left.and.right"
        case .energyIntuition:     return "bolt.heart"
        case .graphMethod:         return "chart.xyaxis.line"
        case .controlVariable:     return "slider.horizontal.3"
        case .equivalentCircuit:   return "bolt.horizontal.circle"
        case .momentumConservation:return "arrow.left.arrow.right"
        case .mechanicalEnergy:    return "arrow.triangle.2.circlepath"
        case .workEnergyTheorem:   return "bolt.fill"
        case .equivalentMethod:    return "equal.circle"
        case .referenceFrame:      return "scope"
        case .lenzRule:            return "minus.plus.batteryblock"
        case .symmetry:            return "circle.lefthalf.filled"
        case .infinitesimal:       return "function"
        case .dimensionalAnalysis: return "ruler"
        case .extremumPrinciple:   return "arrow.up.right.circle"
        case .crossProduct:        return "multiply.circle"
        case .approximation:       return "waveform.path.ecg"
        case .wholeIsolation:      return "square.on.square"
        case .criticalAnalysis:    return "smallcircle.filled.circle"
        case .assumption:          return "questionmark.circle"
        case .proportion:          return "arrow.up.arrow.down"
        case .reverseThinking:     return "arrow.uturn.backward"
        case .analogy:             return "arrow.triangle.swap"
        case .specialCase:         return "star.circle"
        case .vectorTriangle:      return "triangle"
        case .angularMomentum:     return "tornado"
        case .virtualWork:         return "arrow.left.and.right"
        case .imageCharge:         return "circle.righthalf.filled"
        case .potentialCurve:      return "chart.line.downtrend.xyaxis"
        case .scaling:             return "arrow.up.left.and.arrow.down.right"
        }
    }

    /// 武器所属段位（决定解锁门槛）。
    var stage: Stage {
        switch self {
        case .forceDiagram, .energyIntuition, .graphMethod, .controlVariable, .equivalentCircuit:
            return .junior
        case .momentumConservation, .mechanicalEnergy, .workEnergyTheorem,
             .equivalentMethod, .referenceFrame, .lenzRule, .symmetry:
            return .senior
        case .infinitesimal, .dimensionalAnalysis, .extremumPrinciple, .crossProduct, .approximation:
            return .olympiad
        case .wholeIsolation, .criticalAnalysis, .assumption, .proportion,
             .reverseThinking, .analogy, .specialCase, .vectorTriangle:
            return .senior
        case .angularMomentum, .virtualWork, .imageCharge, .potentialCurve, .scaling:
            return .olympiad
        }
    }

    /// 一句话心法。
    var tagline: String {
        switch self {
        case .forceDiagram:        return "隔离 → 画力 → 正交分解，三步不漏力"
        case .energyIntuition:     return "不看过程，只看能量从哪来到哪去"
        case .graphMethod:         return "斜率是变化率，面积是累积量"
        case .controlVariable:     return "只变一个量，因果立刻显形"
        case .equivalentCircuit:   return "化繁为简，串并联等效成一个电阻"
        case .momentumConservation:return "系统不受外力，碰前碰后动量不变"
        case .mechanicalEnergy:    return "只有重力/弹力做功，机械能守恒"
        case .workEnergyTheorem:   return "合外力做的功，等于动能的改变"
        case .equivalentMethod:    return "把复合场等效成一个'斜重力'，问题瞬间退化"
        case .referenceFrame:      return "换个参考系，相对运动题直接崩塌"
        case .lenzRule:            return "阻碍变化——感应电流的唯一信仰"
        case .symmetry:            return "看出对称，一半的计算消失"
        case .infinitesimal:       return "切成微元，累加求和→积分"
        case .dimensionalAnalysis: return "量纲对上，公式形式直接估出来"
        case .extremumPrinciple:   return "最值不必求导，用对称/几何一眼定"
        case .crossProduct:        return "右手定则，方向与大小一次搞定"
        case .approximation:       return "小量略去，复杂表达式塌缩成主项"
        case .wholeIsolation:      return "连接体：先整体求加速度，再隔离求内力"
        case .criticalAnalysis:    return "抓住「恰好 / 最大 / 最小」的临界条件"
        case .assumption:          return "先假设一种情形，自洽就对、矛盾就反"
        case .proportion:          return "盯住正比反比，不算数值直接比大小"
        case .reverseThinking:     return "从末态倒推，或把整个过程反过来看"
        case .analogy:             return "把陌生题映射到熟悉模型（类平抛 / 类弹簧）"
        case .specialCase:         return "取特殊或极端值，验证结论、秒选选项"
        case .vectorTriangle:      return "三力平衡，首尾相接画成一个三角形"
        case .angularMomentum:     return "无外力矩时 mvr 守恒（开普勒第二定律）"
        case .virtualWork:         return "给一个虚位移，令总功为零求平衡"
        case .imageCharge:         return "用虚拟「镜像电荷」替代导体平面"
        case .potentialCurve:      return "看势能曲线，判断平衡位置与运动趋势"
        case .scaling:             return "用尺度缩放，估出量随参数的变化趋势"
        }
    }
}
