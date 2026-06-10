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

    /// 🗣 生活类比：用一个生活画面讲清这把武器的本质（亲民层）。
    var analogy: String {
        switch self {
        case .forceDiagram:        return "像侦探列嫌疑人名单：把每个力挨个点名（重力、接触力、场力），一个不冤枉、一个不放过。"
        case .energyIntuition:     return "把能量当零花钱记账：收入多少、花掉多少、还剩多少——钱不会凭空消失，能量也一样。"
        case .graphMethod:         return "把运动画成心电图：线的斜率是变化快慢，线下面积是攒下的量——一眼看穿，不用列式。"
        case .controlVariable:     return "像做菜只调一味盐：其它调料全锁死，只动一个量，是咸是淡立刻知道是谁的功劳。"
        case .equivalentCircuit:   return "把缠成毛线团的电路梳成一根直线：能合并的合并，剩下的就是清爽的串并联。"
        case .momentumConservation:return "两团橡皮泥相撞粘一起：里面挤来挤去多复杂都行，外面没人推，总冲劲就锁死不变。"
        case .mechanicalEnergy:    return "过山车拿高度换速度：只要没有摩擦来偷钱，高度账户和速度账户的总额永远不变。"
        case .workEnergyTheorem:   return "只看总账不看流水：力做的功全部记进动能账户，路上多绕几个弯都不用管。"
        case .equivalentMethod:    return "把陌生世界翻译成熟悉世界：电场加重力＝一个斜着的重力；一根链条＝质心处的一个点。"
        case .referenceFrame:      return "坐到对方车里看问题：你不动、世界在动——刚才乱成一团的相对运动瞬间变成一条直线。"
        case .lenzRule:            return "电磁感应界的'杠精'：你来它拒、你走它留，永远跟变化对着干——记住这个脾气就够了。"
        case .symmetry:            return "照镜子做题：图形左右本来就一样，算一半就够，另一半镜子里白送。"
        case .infinitesimal:       return "把香肠切成薄片：每一片都简单得不像话，全部加起来就是整根——这就是微积分的灵魂。"
        case .dimensionalAnalysis: return "看单位猜公式：答案的单位是'秒'，就只能由凑得出'秒'的量组合——单位对不上的公式必错。"
        case .extremumPrinciple:   return "最值问题先画圆：方向随便挑、大小定死的量，端点就在一个圆上——切线一引，极值白送。"
        case .crossProduct:        return "右手一摆方向自动弹出：叉乘的结果天生垂直于两个乘数，所以磁场力永远不做功。"
        case .approximation:       return "买单抹零头：100.3 元就当 100 元——小量的平方更是小到可以直接扔掉。"
        case .wholeIsolation:      return "先看全家福再看单人照：全家一起算出加速度，再单独拎一个人出来揪内力。"
        case .criticalAnalysis:    return "抓住'恰好'两个字：恰好通过＝拉力为零、恰好分离＝压力为零——题眼直接翻译成方程。"
        case .assumption:          return "先猜后验：假设地面是光滑的，看脚往哪滑——打滑方向一出来，摩擦力方向反着写就行。"
        case .proportion:          return "不算钱只比倍数：工资翻一倍、物价翻四倍，日子过得怎样不用算账本也知道。"
        case .reverseThinking:     return "倒着放电影：刹车的最后一秒，倒放就是起步的第一秒——末态简单就从末态下手。"
        case .analogy:             return "给新题认亲戚：电压像高度差、电流像水流——认出老亲戚，老办法原封不动搬过来。"
        case .specialCase:         return "拿极端情况当试金石：把电阻调到零和无穷大各试一次，选项的真假立刻现原形。"
        case .vectorTriangle:      return "三个力手拉手围成三角形：两条边定了形状，第三条边最短是哪条垂线，画出来一眼便知。"
        case .angularMomentum:     return "花滑选手一收手臂转得飞快：转动的冲劲 mvr 守恒，半径变小，速度自动变大。"
        case .virtualWork:         return "假装动一下：让滑轮组虚走一小步，数数绳子收了几段——力的比例就是步数的反比。"
        case .imageCharge:         return "在镜子里造一个假电荷：整块导体板的影响，等于镜像位置放一个反号电荷——板子从此消失。"
        case .potentialCurve:      return "把势能曲线当滑梯地形：小球放上去往低处滚——谷底坐得稳，峰顶站不住。"
        case .scaling:             return "蚂蚁和大象的数学：力气随面积平方长、体重随体积立方长——放大以后谁吃亏，指数一减便知。"
        }
    }

    /// 📡 触发信号：题面出现什么特征，就该抽这把武器（武器雷达的训练点）。
    var signals: [String] {
        switch self {
        case .forceDiagram:        return ["受力情况说不清", "怀疑漏力或多画力", "平衡与加速度问题"]
        case .energyIntuition:     return ["出现摩擦生热或能量转化", "问能量去哪了", "不关心过程细节"]
        case .graphMethod:         return ["追及相遇", "传送带相对滑动", "要比较或找极值"]
        case .controlVariable:     return ["电容器接/断电源", "多个量互相牵扯", "问谁变谁不变"]
        case .equivalentCircuit:   return ["电路图看着乱", "节点对称", "无穷重复结构"]
        case .momentumConservation:return ["碰撞、爆炸、反冲", "地面或冰面光滑", "只问首末速度"]
        case .mechanicalEnergy:    return ["光滑轨道或摆", "只有重力弹力做功", "只问两点的速度或高度"]
        case .workEnergyTheorem:   return ["题目不问时间", "变力或曲线路径", "已知位移求速度"]
        case .equivalentMethod:    return ["重力+电场力组合", "链条绳子液柱", "似曾相识但多了一个力"]
        case .referenceFrame:      return ["雨中走路、逆水行船", "两物体互相追赶", "弹性碰撞"]
        case .lenzRule:            return ["磁铁靠近或远离", "只问方向或快慢", "涡流现象"]
        case .symmetry:            return ["图形有对称轴", "等价位置或节点", "平面镜成像"]
        case .infinitesimal:       return ["连续的水流链条", "力随位置连续变化", "问公式从哪来"]
        case .dimensionalAnalysis: return ["公式忘了", "要检验答案", "估数量级"]
        case .extremumPrinciple:   return ["问最大最小", "方向可调大小固定", "光走哪条路"]
        case .crossProduct:        return ["判洛伦兹力安培力方向", "磁场力做不做功", "三维方向关系"]
        case .approximation:       return ["出现 h≪R 之类小量", "精确计算太脏", "问变化了多少"]
        case .wholeIsolation:      return ["连接体或叠放体", "问绳张力接触力", "多物体同加速度"]
        case .criticalAnalysis:    return ["恰好、最多、至少", "分离脱离打滑边缘", "功率达到额定"]
        case .assumption:          return ["静摩擦方向难判", "状态不确定", "要分情况讨论"]
        case .proportion:          return ["只问比值倍数", "卫星轨道比较", "导线拉长对折"]
        case .reverseThinking:     return ["末态比初态简单", "刹车或上抛末段", "正着想卡住了"]
        case .analogy:             return ["陌生情景熟悉结构", "类平抛类碰撞", "电场和重力互相迁移"]
        case .specialCase:         return ["选择题判趋势", "对公式没把握", "动态电路"]
        case .vectorTriangle:      return ["三力平衡", "一力恒定一力方向已知", "求最小力"]
        case .angularMomentum:     return ["椭圆轨道近远点", "旋转中收缩伸展", "受力始终指向一点"]
        case .virtualWork:         return ["滑轮杠杆连杆机构", "平衡但内力复杂", "传动比明显"]
        case .imageCharge:         return ["点电荷+导体平面", "感应电荷无从下手", "接地边界"]
        case .potentialCurve:      return ["给出 Ep-x 图像", "问平衡稳不稳", "判断运动范围"]
        case .scaling:             return ["按比例放大缩小", "生物或工程的尺寸问题", "只要趋势不要数值"]
        }
    }
}
