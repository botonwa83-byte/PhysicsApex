import SwiftUI

// MARK: - 题目 → 沙盘 关联：让「关键题目」一键跳到对应互动沙盘动手验证

/// 一条沙盘入口（含 hub 索引以复用付费门槛）。
struct SimLink: Identifiable {
    let id = UUID()
    let title: String
    let blurb: String
    let index: Int                  // 对应 SimulationHubView 的索引（决定免费/付费）
    let destination: () -> AnyView
}

/// 已注册沙盘的统一引用，避免在映射表里重复写 title/index/destination。
enum SimRef: CaseIterable {
    case projectile, conveyor, chase, freefall, incline, boardBlock, connected, elevator
    case verticalCircle, circular, kepler, boat, collision, pendulum, shm, resonance
    case coulomb, eFieldDeflect, capacitor, rc, closedCircuit, ohm, cyclotron, velocitySelector
    case lenz, railGen, transformer, lc, gasIsotherm, molecular, refraction, lens
    case doubleSlit, singleSlit, standingWave, doppler, photoelectric, bohr, decay, wave
    // Pack 6
    case equipotential, ampereForce, brownian, nuclear, escapeVelocity, slingshot, maxwell, thinFilm

    var link: SimLink {
        switch self {
        case .projectile:      return SimLink(title: "抛体运动", blurb: "调初速与角度，亲手画出这道题的轨迹与射程。", index: 0) { AnyView(ProjectileSimView()) }
        case .conveyor:        return SimLink(title: "传送带", blurb: "看相对滑动如何决定摩擦方向，共速后一起走。", index: 5) { AnyView(ConveyorSimView()) }
        case .chase:           return SimLink(title: "追及相遇", blurb: "v-t 图面积之差就是距离，看谁先追上谁。", index: 4) { AnyView(ChaseSimView()) }
        case .freefall:        return SimLink(title: "自由落体与上抛", blurb: "上抛下落对称，全程加速度都是 g。", index: 3) { AnyView(FreeFallSimView()) }
        case .incline:         return SimLink(title: "斜面受力", blurb: "拖动倾角与摩擦，看临界 tanθ=μ 到底滑不滑。", index: 2) { AnyView(InclineSimView()) }
        case .boardBlock:      return SimLink(title: "滑块木板", blurb: "双摩擦面，整体一起走还是相对滑动一目了然。", index: 35) { AnyView(BoardBlockSimView()) }
        case .connected:       return SimLink(title: "连接体", blurb: "整体法求加速度，隔离法求绳张力。", index: 7) { AnyView(ConnectedSimView()) }
        case .elevator:        return SimLink(title: "电梯超重失重", blurb: "加速向上超重、向下失重，看体重计读数变化。", index: 8) { AnyView(ElevatorSimView()) }
        case .verticalCircle:  return SimLink(title: "竖直圆周临界", blurb: "最高点 v=√(gr)，太慢就脱轨抛落。", index: 34) { AnyView(VerticalCircleSimView()) }
        case .circular:        return SimLink(title: "圆周运动", blurb: "向心力 F=mv²/r，速度翻倍力变四倍。", index: 1) { AnyView(CircularMotionSimView()) }
        case .kepler:          return SimLink(title: "开普勒椭圆轨道", blurb: "近日点快、远日点慢，面积速度守恒。", index: 9) { AnyView(KeplerSimView()) }
        case .boat:            return SimLink(title: "人船模型", blurb: "动量守恒，人走船退，质心纹丝不动。", index: 10) { AnyView(BoatSimView()) }
        case .collision:       return SimLink(title: "弹性碰撞", blurb: "调质量与速度，看动量与动能如何守恒。", index: 14) { AnyView(CollisionSimView()) }
        case .pendulum:        return SimLink(title: "单摆", blurb: "T=2π√(L/g)，改振幅周期纹丝不动。", index: 12) { AnyView(PendulumSimView()) }
        case .shm:             return SimLink(title: "简谐振动", blurb: "弹簧滑块 + 回复力 + 实时 x-t 曲线。", index: 11) { AnyView(SHMSimView()) }
        case .resonance:       return SimLink(title: "受迫振动与共振", blurb: "驱动频率逼近固有频率，振幅猛窜。", index: 36) { AnyView(ResonanceSimView()) }
        case .coulomb:         return SimLink(title: "库仑力", blurb: "F=kq₁q₂/r²，距离翻倍力变四分之一。", index: 16) { AnyView(CoulombSimView()) }
        case .eFieldDeflect:   return SimLink(title: "电场偏转", blurb: "类平抛：横向匀速 + 纵向匀加速。", index: 17) { AnyView(EFieldDeflectSimView()) }
        case .capacitor:       return SimLink(title: "电容器动态", blurb: "改 U/d/S，看电荷与场强如何变。", index: 19) { AnyView(CapacitorSimView()) }
        case .rc:              return SimLink(title: "RC 充放电", blurb: "τ=RC 定快慢，一个 τ 充到 63%。", index: 37) { AnyView(RCCircuitSimView()) }
        case .closedCircuit:   return SimLink(title: "闭合电路", blurb: "路端电压随电流下降 U=ε−Ir。", index: 18) { AnyView(ClosedCircuitSimView()) }
        case .ohm:             return SimLink(title: "欧姆定律", blurb: "I=U/R，电阻翻倍电流减半。", index: 15) { AnyView(OhmSimView()) }
        case .cyclotron:       return SimLink(title: "磁场中的圆周", blurb: "洛伦兹力当向心力，r=mv/qB。", index: 20) { AnyView(CyclotronSimView()) }
        case .velocitySelector:return SimLink(title: "速度选择器", blurb: "电场力与磁场力平衡，只放行 v=E/B。", index: 21) { AnyView(VelocitySelectorSimView()) }
        case .lenz:            return SimLink(title: "楞次定律", blurb: "感应电流总是反抗磁通量的变化。", index: 22) { AnyView(LenzSimView()) }
        case .railGen:         return SimLink(title: "单杆切割发电", blurb: "E=BLv，安培力阻碍运动趋于匀速。", index: 23) { AnyView(RailGenSimView()) }
        case .transformer:     return SimLink(title: "理想变压器", blurb: "电压比 = 匝数比，功率守恒。", index: 24) { AnyView(TransformerSimView()) }
        case .lc:              return SimLink(title: "LC 电磁振荡", blurb: "能量在电场磁场间来回，f=1/2π√(LC)。", index: 38) { AnyView(LCOscillationSimView()) }
        case .gasIsotherm:     return SimLink(title: "等温压缩", blurb: "玻意耳定律 p×V 不变，体积减半压强翻倍。", index: 25) { AnyView(GasIsothermSimView()) }
        case .molecular:       return SimLink(title: "分子间作用力", blurb: "近斥远引，平衡距离 r₀ 处合力为零。", index: 26) { AnyView(MolecularForceSimView()) }
        case .refraction:      return SimLink(title: "折射与全反射", blurb: "超过临界角光被关在介质里。", index: 27) { AnyView(RefractionSimView()) }
        case .lens:            return SimLink(title: "凸透镜成像", blurb: "物距越过焦点，像在实/虚之间翻转。", index: 39) { AnyView(ConvexLensSimView()) }
        case .doubleSlit:      return SimLink(title: "双缝干涉", blurb: "Δy=Lλ/d，拖旋钮看条纹变宽变窄。", index: 28) { AnyView(DoubleSlitSimView()) }
        case .singleSlit:      return SimLink(title: "单缝衍射", blurb: "缝越窄中央亮纹越宽 sinθ=λ/a。", index: 40) { AnyView(SingleSlitSimView()) }
        case .standingWave:    return SimLink(title: "驻波", blurb: "两端固定的弦，节点不动波腹猛摇。", index: 41) { AnyView(StandingWaveSimView()) }
        case .doppler:         return SimLink(title: "多普勒效应", blurb: "声源迎面音调高、驶离音调低。", index: 42) { AnyView(DopplerSimView()) }
        case .photoelectric:   return SimLink(title: "光电效应", blurb: "频率不够光强再大也没用，hν 决定逸出。", index: 29) { AnyView(PhotoelectricSimView()) }
        case .bohr:            return SimLink(title: "玻尔能级跃迁", blurb: "电子只能整级跳，光谱是一根根线。", index: 30) { AnyView(BohrSimView()) }
        case .decay:           return SimLink(title: "半衰期", blurb: "每过 T½ 剩一半，单核衰变完全随机。", index: 31) { AnyView(DecaySimView()) }
        case .wave:            return SimLink(title: "横波传播", blurb: "v=λf，质点只上下振动不随波前进。", index: 32) { AnyView(WaveSimView()) }
        // Pack 6
        case .equipotential:   return SimLink(title: "等势线与电场线", blurb: "电场线⊥等势线，沿等势线移动做功为零。", index: 43) { AnyView(EquipotentialSimView()) }
        case .ampereForce:     return SimLink(title: "安培力", blurb: "F=BIL sinθ，左手定则，θ=90° 力最大。", index: 44) { AnyView(AmpereForceSimView()) }
        case .brownian:        return SimLink(title: "布朗运动", blurb: "花粉被分子撞击无规运动，温度越高越乱。", index: 45) { AnyView(BrownianSimView()) }
        case .nuclear:         return SimLink(title: "核反应质量亏损", blurb: "E=Δmc²，裂变/聚变/α衰变能量对比。", index: 46) { AnyView(NuclearSimView()) }
        case .escapeVelocity:  return SimLink(title: "逃逸速度", blurb: "v₁=7.9km/s 圆轨，v₂=11.2km/s 逃离地球。", index: 48) { AnyView(EscapeVelocitySimView()) }
        case .slingshot:       return SimLink(title: "弹弓效应", blurb: "引力辅助借行星动量，探测器加速飞出。", index: 47) { AnyView(SlingshotSimView()) }
        case .maxwell:         return SimLink(title: "麦克斯韦速率分布", blurb: "温度升高曲线右移，vₚ 和 v̄ 都增大。", index: 50) { AnyView(MaxwellSimView()) }
        case .thinFilm:        return SimLink(title: "薄膜干涉", blurb: "膜厚不均匀→光程差不同→彩色条纹。", index: 49) { AnyView(ThinFilmSimView()) }
        }
    }
}

enum SimLibrary {
    /// 关键词优先（精准命中），命中不到再按章节兜底——保证每道题都有一个可动手的沙盘。
    private static let keywordTable: [(words: [String], ref: SimRef)] = [
        (["平抛", "斜抛", "抛体", "抛出", "抛射"], .projectile),
        (["传送带"], .conveyor),
        (["追及", "相遇", "追上"], .chase),
        (["自由落体", "竖直上抛", "竖直下抛"], .freefall),
        (["长木板", "木板", "叠放", "叠加块"], .boardBlock),
        (["斜面", "斜坡", "倾角", "斜劈"], .incline),
        (["滑轮", "连接体", "轻绳连", "用绳"], .connected),
        (["电梯", "超重", "失重"], .elevator),
        (["最高点", "竖直平面内", "竖直圆", "圆轨道最高", "过山车"], .verticalCircle),
        (["卫星", "开普勒", "行星", "万有引力", "天体", "同步轨道"], .kepler),
        (["人船", "反冲", "人在船"], .boat),
        (["向心", "圆周运动", "转弯", "圆周"], .circular),
        (["碰撞", "对心碰", "撞击后"], .collision),
        (["单摆", "摆球", "摆长"], .pendulum),
        (["共振", "受迫振动", "驱动频率"], .resonance),
        (["弹簧振子", "简谐", "弹簧振动"], .shm),
        (["库仑"], .coulomb),
        (["偏转电场", "示波管", "电场偏转", "加速后偏转"], .eFieldDeflect),
        (["时间常数", "RC", "充电过程", "放电过程"], .rc),
        (["平行板电容", "电容器"], .capacitor),
        (["电动势", "内阻", "路端电压", "闭合电路"], .closedCircuit),
        (["串联", "并联", "欧姆", "总电阻"], .ohm),
        (["洛伦兹", "质谱", "回旋加速", "磁场中圆"], .cyclotron),
        (["速度选择"], .velocitySelector),
        (["切割磁感线", "导体棒", "导轨", "单杆"], .railGen),
        (["楞次", "感应电流方向", "磁通量变化"], .lenz),
        (["变压器", "原副线圈", "匝数比"], .transformer),
        (["LC", "振荡电路", "电磁振荡"], .lc),
        (["玻意耳", "等温", "气缸", "活塞", "理想气体", "封闭气体"], .gasIsotherm),
        (["分子力", "分子间", "分子势能"], .molecular),
        (["全反射", "折射率", "临界角", "光的折射"], .refraction),
        (["凸透镜", "成像", "焦距", "放大镜", "照相机"], .lens),
        (["双缝", "干涉条纹", "杨氏"], .doubleSlit),
        (["单缝", "衍射"], .singleSlit),
        (["驻波", "波腹", "波节", "弦振动"], .standingWave),
        (["多普勒"], .doppler),
        (["光电效应", "逸出功", "遏止电压"], .photoelectric),
        (["能级", "玻尔", "跃迁", "氢原子", "光谱线"], .bohr),
        (["半衰期", "衰变", "放射性", "α衰变", "β衰变"], .decay),
        (["横波", "波速", "波长", "波形图"], .wave),
        // Pack 6
        (["等势线", "等势面", "电场线分布"], .equipotential),
        (["安培力", "通电导线", "BIL", "左手定则"], .ampereForce),
        (["布朗运动", "花粉", "无规则运动"], .brownian),
        (["质量亏损", "质能方程", "核反应", "裂变", "聚变", "α衰变", "β衰变", "结合能"], .nuclear),
        (["逃逸速度", "第一宇宙速度", "第二宇宙速度", "环绕速度"], .escapeVelocity),
        (["引力辅助", "弹弓效应", "旅行者"], .slingshot),
        (["速率分布", "麦克斯韦", "最概然速率"], .maxwell),
        (["薄膜干涉", "肥皂膜", "光程差", "光程"], .thinFilm),
    ]

    private static let topicFallback: [PhysicsTopic: SimRef] = [
        .kinematics: .projectile, .newton: .incline, .momentum: .collision,
        .energy: .shm, .circular: .escapeVelocity, .wave: .wave,
        .electricField: .equipotential, .circuit: .closedCircuit, .magnetic: .ampereForce,
        .induction: .railGen, .thermal: .maxwell, .optics: .thinFilm, .modern: .nuclear,
    ]

    static func link(for problem: PhysicsProblem) -> SimLink? {
        let haystack = (problem.content + " " + problem.tags.joined(separator: " "))
        for entry in keywordTable where entry.words.contains(where: { haystack.contains($0) }) {
            return entry.ref.link
        }
        return topicFallback[problem.topic]?.link
    }
}

// MARK: - 题目详情里的「动手验证」卡片（沿用沙盘付费门槛）

struct ProblemSimLinkCard: View {
    let link: SimLink
    var dark: Bool = false
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false

    private var unlocked: Bool { purchase.isUnlocked || link.index < PurchaseManager.freeSandboxCount }

    var body: some View {
        Group {
            if unlocked {
                NavigationLink { link.destination() } label: { card(locked: false) }
                    .buttonStyle(.plain)
            } else {
                Button { showPaywall = true } label: { card(locked: true) }
                    .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private func card(locked: Bool) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: locked ? "lock.fill" : "slider.horizontal.below.rectangle")
                .font(.title2).foregroundColor(.apexEmerald).frame(width: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text("动手验证 · \(link.title)")
                    .font(AppFont.cardTitle)
                    .foregroundColor(dark ? .white : .primary)
                Text(locked ? "解锁后拖动参数，看见这道题背后的物理。" : link.blurb)
                    .font(AppFont.caption)
                    .foregroundColor(dark ? .white.opacity(0.7) : .secondary)
                    .lineLimit(2)
            }
            Spacer()
            Text(locked ? "解锁" : "")
                .font(AppFont.chip).foregroundColor(.apexLava)
            Image(systemName: "chevron.right")
                .foregroundColor(dark ? .white.opacity(0.4) : .secondary)
        }
        .padding(Spacing.md)
        .background(dark ? Color.white.opacity(0.08) : Color.apexCardSurface)
        .cornerRadius(Radius.card)
        .overlay(RoundedRectangle(cornerRadius: Radius.card)
            .stroke(Color.apexEmerald.opacity(dark ? 0.5 : 0.25), lineWidth: 1))
    }
}
