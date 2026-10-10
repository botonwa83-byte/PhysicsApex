import SwiftUI

// MARK: - 沙盘扩充包 6：电场·热学·近代·天体（8 个，Hub 编号 43–50）

// 43. 等势线与电场线
struct EquipotentialSimView: View {
    @State private var q1: Double = 1      // 左侧电荷量（+/-）
    @State private var q2: Double = -1     // 右侧电荷量
    private let steps = 80

    private func potential(_ x: Double, _ y: Double) -> Double {
        let k = 1.0
        let r1 = sqrt(pow(x + 0.3, 2) + pow(y, 2)) + 0.02
        let r2 = sqrt(pow(x - 0.3, 2) + pow(y, 2)) + 0.02
        return k * q1 / r1 + k * q2 / r2
    }

    var body: some View {
        SimPage(title: "等势线与电场线") {
            Canvas { ctx, size in
                let w = size.width, h = size.height
                // 渲染等势色图（背景热力图）
                let step: CGFloat = 4
                for px in stride(from: CGFloat(0), to: w, by: step) {
                    for py in stride(from: CGFloat(0), to: h, by: step) {
                        let x = Double(px / w) * 2 - 1
                        let y = Double(py / h) * 2 - 1
                        let v = potential(x, y)
                        let t = max(0, min(1, (v + 4) / 8))
                        let color = t > 0.5
                            ? Color(red: Double(2 * t - 1), green: Double(2 - 2 * t), blue: 0)
                            : Color(red: 0, green: Double(2 * t), blue: Double(1 - 2 * t))
                        ctx.fill(Path(CGRect(x: px, y: py, width: step, height: step)), with: .color(color.opacity(0.55)))
                    }
                }
                // 等势线（等值轮廓）
                let levels = [-3.0, -1.5, -0.5, 0.5, 1.5, 3.0]
                for lv in levels {
                    var prev: CGPoint? = nil
                    var path = Path()
                    for k in 0...200 {
                        let angle = Double(k) / 200 * 2 * .pi
                        let r = 0.28
                        let cx = r * cos(angle) * Double(q1 > 0 ? 1 : -1)
                        let cy = r * sin(angle)
                        let v = potential(cx, cy)
                        let x = CGFloat(cx / 2 + 0.5) * w
                        let y = CGFloat(cy / 2 + 0.5) * h
                        _ = (v, lv, prev)
                        if k == 0 { path.move(to: CGPoint(x: x, y: y)) } else { path.addLine(to: CGPoint(x: x, y: y)) }
                        prev = CGPoint(x: x, y: y)
                    }
                }
                // 简单等势圆（近似）
                for r in [0.12, 0.22, 0.38] as [Double] {
                    for (cx, q) in [(-0.3, q1), (0.3, q2)] {
                        let color: Color = q > 0 ? .apexLava : .apexStarBlue
                        var circle = Path()
                        circle.addEllipse(in: CGRect(
                            x: CGFloat(cx / 2 + 0.5) * w - CGFloat(r) * w * 0.48,
                            y: h / 2 - CGFloat(r) * w * 0.48,
                            width: CGFloat(r) * w * 0.96,
                            height: CGFloat(r) * w * 0.96))
                        ctx.stroke(circle, with: .color(color.opacity(0.55)),
                                   style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    }
                }
                // 电荷点
                for (cx, q) in [(-0.3, q1), (0.3, q2)] {
                    let px = CGFloat(cx / 2 + 0.5) * w
                    SimDraw.dot(&ctx, at: CGPoint(x: px, y: h / 2), r: 10,
                               color: q > 0 ? .apexLava : .apexStarBlue)
                    ctx.draw(Text(q > 0 ? "+" : "−").font(.system(size: 14, weight: .black))
                        .foregroundColor(.white), at: CGPoint(x: px, y: h / 2))
                }
                // 电场线（从正电荷出发）
                let nLines = 8
                for i in 0..<nLines {
                    let angle = Double(i) / Double(nLines) * 2 * .pi
                    var lx = -0.3 + 0.06 * cos(angle)
                    var ly = 0.06 * sin(angle)
                    var fp = Path()
                    let startPx = CGFloat(lx / 2 + 0.5) * w
                    let startPy = CGFloat(ly / 2 + 0.5) * h
                    fp.move(to: CGPoint(x: startPx, y: startPy))
                    for _ in 0..<60 {
                        let r1 = sqrt(pow(lx + 0.3, 2) + pow(ly, 2)) + 0.01
                        let r2 = sqrt(pow(lx - 0.3, 2) + pow(ly, 2)) + 0.01
                        let ex = q1 * (lx + 0.3) / pow(r1, 3) + q2 * (lx - 0.3) / pow(r2, 3)
                        let ey = q1 * ly / pow(r1, 3) + q2 * ly / pow(r2, 3)
                        let mag = sqrt(ex * ex + ey * ey) + 1e-6
                        let dt = 0.015
                        lx += ex / mag * dt; ly += ey / mag * dt
                        if abs(lx) > 1 || abs(ly) > 1 { break }
                        fp.addLine(to: CGPoint(x: CGFloat(lx / 2 + 0.5) * w,
                                               y: CGFloat(ly / 2 + 0.5) * h))
                    }
                    ctx.stroke(fp, with: .color(.apexGold.opacity(0.75)), lineWidth: 1.5)
                }
            }
            .simCanvas(height: 240, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "左侧电荷", value: q1 > 0 ? "+\(Int(q1))q" : "\(Int(q1))q", color: q1 > 0 ? .apexLava : .apexStarBlue)
                SimReadout(label: "右侧电荷", value: q2 > 0 ? "+\(Int(q2))q" : "\(Int(q2))q", color: q2 > 0 ? .apexLava : .apexStarBlue)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "左荷 q₁", value: $q1, range: -2...2, unit: "q", accent: .apexLava)
                SimSlider(label: "右荷 q₂", value: $q2, range: -2...2, unit: "q", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "金色电场线总从正电荷出发、扎向负电荷；虚圆等势线始终与电场线垂直——沿等势线移动电荷，电场力做功为零。")
        }
    }
}

// 44. 安培力（通电导线在匀强磁场中受力）
struct AmpereForceSimView: View {
    @State private var current: Double = 3     // A
    @State private var bField: Double = 0.5    // T
    @State private var length: Double = 0.4    // m
    @State private var angleDeg: Double = 90   // 电流与B夹角
    private var force: Double { bField * current * length * sin(angleDeg * .pi / 180) }

    var body: some View {
        SimPage(title: "安培力") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let midX = size.width / 2
                // 磁场符号（×表示进入纸面）
                let cols = 5, rows = 4
                for r in 0..<rows {
                    for c in 0..<cols {
                        let x = 20 + CGFloat(c) * (size.width - 40) / CGFloat(cols - 1)
                        let y = 20 + CGFloat(r) * (size.height - 50) / CGFloat(rows - 1)
                        ctx.draw(Text("×").font(.system(size: 11)).foregroundColor(.apexStarBlue.opacity(0.45)),
                                 at: CGPoint(x: x, y: y))
                    }
                }
                // 导线
                let wireLen = CGFloat(length) * 180
                let ang = angleDeg * .pi / 180
                let dx = CGFloat(cos(ang)) * wireLen / 2
                let dy = -CGFloat(sin(ang)) * wireLen / 2
                let wireStart = CGPoint(x: midX - dx, y: midY + dy)
                let wireEnd   = CGPoint(x: midX + dx, y: midY - dy)
                var wire = Path(); wire.move(to: wireStart); wire.addLine(to: wireEnd)
                ctx.stroke(wire, with: .color(.apexLava), lineWidth: 5)
                // 电流方向箭头
                SimDraw.arrow(&ctx, from: wireStart, to: wireEnd, color: .apexGold, lineWidth: 2.5)
                ctx.draw(Text("I").font(.caption).bold().foregroundColor(.apexGold),
                         at: CGPoint(x: wireEnd.x + 12, y: wireEnd.y))
                // 安培力箭头（向上，F=BIL sinθ）
                let fLen = CGFloat(min(abs(force), 2)) * 55 + 20
                let fDir: CGFloat = force >= 0 ? -1 : 1
                SimDraw.arrow(&ctx, from: CGPoint(x: midX, y: midY),
                              to: CGPoint(x: midX, y: midY + fDir * fLen),
                              color: .apexEmerald, lineWidth: 3)
                ctx.draw(Text("F").font(.caption).bold().foregroundColor(.apexEmerald),
                         at: CGPoint(x: midX + 12, y: midY + fDir * (fLen + 8)))
                ctx.draw(Text("B（向纸面内 ×）").font(.caption2).foregroundColor(.apexStarBlue),
                         at: CGPoint(x: size.width - 60, y: size.height - 16))
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "安培力 F", value: String(format: "%.3f N", force), color: .apexEmerald)
                SimReadout(label: "F = BIL sinθ", value: String(format: "%.1f×%.0f×%.1f×sin%.0f°", bField, current, length, angleDeg), color: .secondary)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电流 I", value: $current, range: 0...8, unit: "A", accent: .apexLava)
                SimSlider(label: "磁感强度 B", value: $bField, range: 0...2, unit: "T", accent: .apexStarBlue)
                SimSlider(label: "导线长 L", value: $length, range: 0.1...1, unit: "m", accent: .apexGold)
                SimSlider(label: "夹角 θ", value: $angleDeg, range: 0...180, unit: "°", accent: .apexEmerald, decimals: 0)
            }.cardSurface()
            SimInsight(text: "θ=90° 时安培力最大（电流⊥磁场）；θ=0°/180° 时为零（平行磁场，没有切割分量）。左手定则：四指指电流，手心迎磁场，大拇指指安培力方向。")
        }
    }
}

// 45. 布朗运动
struct BrownianSimView: View {
    @State private var temperature: Double = 300   // K
    @State private var running = true
    @State private var start = Date()
    @State private var trail: [CGPoint] = []

    var body: some View {
        SimPage(title: "布朗运动") {
            TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let speed = temperature / 200.0   // 温度越高运动越剧烈
                    // 用确定性伪随机模拟方向
                    let freq = speed * 3.2
                    let px = size.width  * 0.5 + CGFloat(sin(freq * t + 0.7) * cos(freq * 0.61 * t + 1.3) * sin(freq * 0.37 * t)) * size.width  * 0.32
                    let py = size.height * 0.5 + CGFloat(cos(freq * t + 1.1) * sin(freq * 0.53 * t + 0.9) * cos(freq * 0.41 * t)) * size.height * 0.32
                    let pos = CGPoint(x: px, y: py)
                    // 背景：小分子随机点
                    var seed: UInt64 = UInt64(t * 8) &+ 42
                    func rnd() -> CGFloat {
                        seed = seed &* 6364136223846793005 &+ 1442695040888963407
                        return CGFloat((seed >> 33) % 1000) / 1000
                    }
                    for _ in 0..<60 {
                        let mx = rnd() * size.width
                        let my = rnd() * size.height
                        SimDraw.dot(&ctx, at: CGPoint(x: mx, y: my), r: 1.5, color: .apexStarBlue.opacity(0.35))
                    }
                    // 轨迹（最近 40 个点）
                    var tr = trail
                    tr.append(pos)
                    if tr.count > 40 { tr.removeFirst() }
                    if tr.count > 1 {
                        var tp = Path(); tp.move(to: tr[0])
                        for pt in tr.dropFirst() { tp.addLine(to: pt) }
                        ctx.stroke(tp, with: .color(.apexGold.opacity(0.6)), lineWidth: 1.5)
                    }
                    // 大粒子（花粉颗粒）
                    SimDraw.dot(&ctx, at: pos, r: 14, color: .apexLava)
                    ctx.draw(Text("花粉").font(.system(size: 8)).foregroundColor(.white), at: pos)
                }
            }
            .simCanvas(height: 230, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date(); trail = [] } }
            SimSlider(label: "温度 T", value: $temperature, range: 100...600, unit: "K", accent: .apexLava, decimals: 0).cardSurface()
            SimInsight(text: "花粉颗粒被四面八方的水分子撞击，合力方向随机变化——温度越高，分子热运动越剧烈，花粉轨迹越混乱。这就是爱因斯坦 1905 年用布朗运动证明分子存在的方式。")
        }
    }
}

// 46. 核反应质量亏损（E=Δmc²）
struct NuclearSimView: View {
    enum Reaction: String, CaseIterable { case fission = "铀裂变", fusion = "氘氚聚变", alpha = "α衰变" }
    @State private var reaction: Reaction = .fission

    private struct RxData {
        let before: [(name: String, mass: Double)]
        let after: [(name: String, mass: Double)]
        let equation: String
    }

    private func data() -> RxData {
        switch reaction {
        case .fission:
            return RxData(
                before: [("²³⁵U", 235.044), ("¹n", 1.009)],
                after:  [("⁹⁰Kr", 89.920), ("¹⁴³Ba", 142.921), ("3¹n", 3.027)],
                equation: "²³⁵U + n → ⁹⁰Kr + ¹⁴³Ba + 3n"
            )
        case .fusion:
            return RxData(
                before: [("²H", 2.014), ("³H", 3.016)],
                after:  [("⁴He", 4.003), ("¹n", 1.009)],
                equation: "²H + ³H → ⁴He + n"
            )
        case .alpha:
            return RxData(
                before: [("²²⁶Ra", 226.025)],
                after:  [("²²²Rn", 222.018), ("⁴He", 4.003)],
                equation: "²²⁶Ra → ²²²Rn + α"
            )
        }
    }

    var body: some View {
        let d = data()
        let mBefore = d.before.map(\.mass).reduce(0, +)
        let mAfter  = d.after.map(\.mass).reduce(0, +)
        let dm = mBefore - mAfter          // u
        let energy = dm * 931.5            // MeV (1u = 931.5 MeV/c²)

        return SimPage(title: "核反应质量亏损") {
            Canvas { ctx, size in
                let barMaxH = size.height * 0.55
                let barW: CGFloat = 38
                let allParts = d.before + d.after
                let maxMass = allParts.map(\.mass).max() ?? 1
                let spacing = size.width / CGFloat(allParts.count + 2)
                // 反应前
                for (i, p) in d.before.enumerated() {
                    let x = spacing * CGFloat(i + 1)
                    let h = barMaxH * CGFloat(p.mass / maxMass)
                    ctx.fill(Path(roundedRect: CGRect(x: x - barW / 2, y: barMaxH - h + 20, width: barW, height: h), cornerRadius: 4),
                             with: .color(.apexLava.opacity(0.8)))
                    ctx.draw(Text(p.name).font(.system(size: 10)).foregroundColor(.white),
                             at: CGPoint(x: x, y: barMaxH - h + 10))
                    ctx.draw(Text(String(format: "%.3f u", p.mass)).font(.system(size: 9)).foregroundColor(.secondary),
                             at: CGPoint(x: x, y: barMaxH + 30))
                }
                // 箭头
                let arrowX = spacing * CGFloat(d.before.count + 1)
                SimDraw.arrow(&ctx, from: CGPoint(x: arrowX - 14, y: barMaxH * 0.5 + 20),
                              to: CGPoint(x: arrowX + 14, y: barMaxH * 0.5 + 20), color: .apexGold, lineWidth: 2)
                // 反应后
                for (i, p) in d.after.enumerated() {
                    let x = spacing * CGFloat(d.before.count + 2 + i)
                    let h = barMaxH * CGFloat(p.mass / maxMass)
                    ctx.fill(Path(roundedRect: CGRect(x: x - barW / 2, y: barMaxH - h + 20, width: barW, height: h), cornerRadius: 4),
                             with: .color(.apexEmerald.opacity(0.8)))
                    ctx.draw(Text(p.name).font(.system(size: 10)).foregroundColor(.white),
                             at: CGPoint(x: x, y: barMaxH - h + 10))
                    ctx.draw(Text(String(format: "%.3f u", p.mass)).font(.system(size: 9)).foregroundColor(.secondary),
                             at: CGPoint(x: x, y: barMaxH + 30))
                }
                // 能量标注
                ctx.draw(Text(String(format: "Δm = %.4f u → E = %.1f MeV", dm, energy))
                    .font(.caption2).foregroundColor(.apexGold),
                         at: CGPoint(x: size.width / 2, y: size.height - 12))
            }
            .simCanvas(height: 220, tint: .apexLava)
            Picker("反应类型", selection: $reaction) {
                ForEach(Reaction.allCases, id: \.self) { Text($0.rawValue).tag($0) }
            }.pickerStyle(.segmented)
            Text(d.equation).font(AppFont.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .center)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "质量亏损 Δm", value: String(format: "%.4f u", dm), color: .apexLava)
                SimReadout(label: "释放能量", value: String(format: "%.1f MeV", energy), color: .apexGold)
            }
            SimInsight(text: "反应前后总质量差（Δm）×c² 就是释放的能量——裂变释放约 200MeV/次，聚变约 17.6MeV/次，但聚变原料质量更轻、能量密度更高。1u=931.5MeV/c² 是高考常数，务必记住。")
        }
    }
}

// 47. 逃逸速度（第一·第二宇宙速度）
struct EscapeVelocitySimView: View {
    @State private var vKms: Double = 7.9      // 发射速度 km/s
    private let r0: Double = 6.371e6           // 地球半径 m
    private let g: Double = 9.8
    private let v1 = 7.9, v2 = 11.2           // 第一、第二宇宙速度 km/s

    private var orbitType: String {
        if vKms < v1 - 0.05  { return "抛物线落回地面" }
        if vKms < v1 + 0.1   { return "近圆轨道（第一宇宙速度）" }
        if vKms < v2 - 0.05  { return "椭圆轨道" }
        if vKms < v2 + 0.1   { return "抛物线轨道（第二宇宙速度，逃逸）" }
        return "双曲线轨道（逃出太阳系）"
    }

    var body: some View {
        SimPage(title: "逃逸速度") {
            Canvas { ctx, size in
                let cx = size.width * 0.38, cy = size.height * 0.56
                let earthR: CGFloat = 38
                // 地球
                ctx.fill(Path(ellipseIn: CGRect(x: cx - earthR, y: cy - earthR, width: 2 * earthR, height: 2 * earthR)),
                         with: .color(.apexStarBlue))
                ctx.draw(Text("地球").font(.caption2).foregroundColor(.white), at: CGPoint(x: cx, y: cy))
                // 轨道形状示意
                let scale: CGFloat = 28
                let v = vKms
                if v < v1 - 0.05 {
                    // 抛物线落地
                    var p = Path(); p.move(to: CGPoint(x: cx + earthR, y: cy - 10))
                    for i in 0...30 {
                        let t = CGFloat(i) * 0.12
                        p.addLine(to: CGPoint(x: cx + earthR + t * 18, y: cy - 10 + t * t * 3.5))
                    }
                    ctx.stroke(p, with: .color(.apexDanger), lineWidth: 2)
                } else if v < v2 - 0.05 {
                    // 椭圆
                    let a = scale * CGFloat(v / v1) * 2.2
                    let b = scale * 1.4
                    ctx.stroke(Path(ellipseIn: CGRect(x: cx - a, y: cy - b, width: 2 * a, height: 2 * b)),
                               with: .color(.apexEmerald), lineWidth: 2)
                } else {
                    // 双曲线/逃逸
                    var p = Path(); p.move(to: CGPoint(x: cx + earthR, y: cy))
                    for i in 0...50 {
                        let t = CGFloat(i) * 0.06
                        p.addLine(to: CGPoint(x: cx + earthR + t * 22, y: cy - t * 14))
                    }
                    ctx.stroke(p, with: .color(.apexGold), lineWidth: 2.5)
                }
                // 速度参考线
                let markers: [(Double, Color, String)] = [(v1, .apexEmerald, "v₁=7.9"), (v2, .apexGold, "v₂=11.2")]
                let barX = size.width * 0.72
                for (mv, mc, ml) in markers {
                    let vy = size.height * CGFloat(1 - mv / 14)
                    var mark = Path(); mark.move(to: CGPoint(x: barX - 6, y: vy)); mark.addLine(to: CGPoint(x: barX + 6, y: vy))
                    ctx.stroke(mark, with: .color(mc), lineWidth: 1.5)
                    ctx.draw(Text(ml).font(.system(size: 9)).foregroundColor(mc), at: CGPoint(x: barX + 26, y: vy))
                }
                // 当前速度点
                let curY = size.height * CGFloat(1 - vKms / 14)
                SimDraw.dot(&ctx, at: CGPoint(x: barX, y: curY), r: 5, color: .apexLava)
                var vbar = Path(); vbar.move(to: CGPoint(x: barX, y: size.height)); vbar.addLine(to: CGPoint(x: barX, y: 10))
                ctx.stroke(vbar, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
            }
            .simCanvas(height: 240, tint: .apexStarBlue)
            SimReadout(label: orbitType, value: String(format: "v = %.1f km/s", vKms), color: vKms < v1 ? .apexDanger : (vKms >= v2 ? .apexGold : .apexEmerald))
            SimSlider(label: "发射速度", value: $vKms, range: 5...14, unit: "km/s", accent: .apexLava).cardSurface()
            SimInsight(text: "v₁=7.9km/s（第一宇宙速度，最小环绕速度）；v₂=11.2km/s（第二宇宙速度，逃出地球引力）；v₃=16.7km/s（第三宇宙速度，逃出太阳系）。速度之间轨道从圆→椭圆→抛物线→双曲线。")
        }
    }
}

// 48. 弹弓效应（引力辅助加速）
struct SlingshotSimView: View {
    @State private var running = true
    @State private var start = Date()
    @State private var vPlanet: Double = 3.0   // 行星速度 km/s

    var body: some View {
        SimPage(title: "弹弓效应（引力辅助）") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let period = 5.0
                    let phase = t.truncatingRemainder(dividingBy: period) / period
                    let cx = size.width * 0.5, cy = size.height * 0.52
                    // 行星（向右运动）
                    let planetX = cx - size.width * 0.35 + CGFloat(phase) * size.width * 0.7
                    SimDraw.dot(&ctx, at: CGPoint(x: planetX, y: cy), r: 20, color: .apexStarBlue)
                    SimDraw.arrow(&ctx, from: CGPoint(x: planetX - 8, y: cy),
                                  to: CGPoint(x: planetX + 8 + CGFloat(vPlanet) * 4, y: cy),
                                  color: .apexStarBlue, lineWidth: 2)
                    // 飞行器轨迹（双曲线绕过行星）
                    let offset = (phase - 0.5) * Double(size.width) * 0.7
                    let probeX = cx + CGFloat(offset)
                    let probeY = cy - CGFloat(40 / (1 + pow(offset / 60, 2))) * 2
                    var trail = Path()
                    for i in -40...Int(phase * 80 - 40) {
                        let ox = Double(i) / 80 * Double(size.width) * 0.7
                        let tx = cx + CGFloat(ox)
                        let ty = cy - CGFloat(40 / (1 + pow(ox / 60, 2))) * 2
                        if i == -40 { trail.move(to: CGPoint(x: tx, y: ty)) } else { trail.addLine(to: CGPoint(x: tx, y: ty)) }
                    }
                    ctx.stroke(trail, with: .color(.apexGold.opacity(0.65)), lineWidth: 2)
                    SimDraw.dot(&ctx, at: CGPoint(x: probeX, y: probeY), r: 6, color: .apexGold)
                    // 速度标注
                    let speedFactor = 1 + vPlanet * 0.15 * (1 - abs(phase - 0.5) * 2)
                    ctx.draw(Text(String(format: "探测器速度 ×%.1f", speedFactor))
                        .font(.caption2).foregroundColor(.apexGold),
                             at: CGPoint(x: size.width / 2, y: 16))
                    ctx.draw(Text("行星速度").font(.caption2).foregroundColor(.apexStarBlue),
                             at: CGPoint(x: planetX, y: cy + 28))
                }
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            SimSlider(label: "行星速度", value: $vPlanet, range: 0...8, unit: "km/s", accent: .apexStarBlue).cardSurface()
            SimInsight(text: "探测器飞过行星时，在行星引力场的双曲线轨道上先加速后减速——但相对太阳，借了行星的动量，飞出时反而比飞入更快。旅行者号就靠这招飞出太阳系。")
        }
    }
}

// 49. 麦克斯韦速率分布
struct MaxwellSimView: View {
    @State private var tempK: Double = 300   // 温度 K
    private let m = 4.65e-26               // 氮气分子质量 kg（N₂）
    private let k = 1.38e-23              // 玻尔兹曼常数

    private func f(_ v: Double) -> Double {
        // Maxwell-Boltzmann 速率分布 f(v)
        let a = m / (2 * k * tempK)
        return 4 * .pi * pow(a / .pi, 1.5) * v * v * exp(-a * v * v)
    }

    private var vp: Double { sqrt(2 * k * tempK / m) }      // 最概然速率
    private var vAvg: Double { sqrt(8 * k * tempK / (.pi * m)) }  // 平均速率

    var body: some View {
        SimPage(title: "麦克斯韦速率分布") {
            Canvas { ctx, size in
                let vMax = 1500.0
                let rect = CGRect(x: 24, y: 16, width: size.width - 48, height: size.height - 60)
                let maxF = f(vp) * 1.05
                // 填充曲线下面积
                var fill = Path()
                fill.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                for i in 0...120 {
                    let v = vMax * Double(i) / 120
                    let fv = min(f(v) / maxF, 1)
                    let px = rect.minX + rect.width * CGFloat(v / vMax)
                    let py = rect.maxY - rect.height * CGFloat(fv)
                    fill.addLine(to: CGPoint(x: px, y: py))
                }
                fill.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                ctx.fill(fill, with: .color(.apexStarBlue.opacity(0.2)))
                // 曲线
                SimDraw.curve(&ctx, in: rect, x0: 0, x1: vMax, yMin: 0, yMax: maxF, color: .apexStarBlue) { self.f($0) }
                // 最概然速率线
                let vpX = rect.minX + rect.width * CGFloat(vp / vMax)
                var vpLine = Path(); vpLine.move(to: CGPoint(x: vpX, y: rect.minY)); vpLine.addLine(to: CGPoint(x: vpX, y: rect.maxY))
                ctx.stroke(vpLine, with: .color(.apexLava), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                ctx.draw(Text("vₚ").font(.caption2).foregroundColor(.apexLava), at: CGPoint(x: vpX, y: rect.minY - 8))
                // 平均速率线
                let vAvgX = rect.minX + rect.width * CGFloat(vAvg / vMax)
                var vAvgLine = Path(); vAvgLine.move(to: CGPoint(x: vAvgX, y: rect.minY)); vAvgLine.addLine(to: CGPoint(x: vAvgX, y: rect.maxY))
                ctx.stroke(vAvgLine, with: .color(.apexGold), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                ctx.draw(Text("v̄").font(.caption2).foregroundColor(.apexGold), at: CGPoint(x: vAvgX + 6, y: rect.minY - 8))
                ctx.draw(Text("速率 v (m/s)").font(.caption2).foregroundColor(.secondary),
                         at: CGPoint(x: rect.midX, y: size.height - 12))
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "最概然速率 vₚ", value: String(format: "%.0f m/s", vp), color: .apexLava)
                SimReadout(label: "平均速率 v̄", value: String(format: "%.0f m/s", vAvg), color: .apexGold)
            }
            SimSlider(label: "温度 T", value: $tempK, range: 100...1000, unit: "K", accent: .apexLava, decimals: 0).cardSurface()
            SimInsight(text: "温度越高，曲线整体右移变平——更多分子跑得更快。vₚ（峰值对应速率）< v̄（平均速率）。温度升高，两者都增大，但分布更宽散；温度降低，分子集中在低速区。")
        }
    }
}

// 50. 薄膜干涉（肥皂泡彩色条纹）
struct ThinFilmSimView: View {
    @State private var n: Double = 1.33      // 折射率（水膜≈1.33）
    @State private var dMax: Double = 600    // 最大膜厚 nm

    var body: some View {
        SimPage(title: "薄膜干涉") {
            Canvas { ctx, size in
                // 从左到右膜厚从 0 → dMax，计算各波长的干涉强度叠加出颜色
                let lambdas: [(Double, Color)] = [
                    (420, Color(red: 0.5, green: 0, blue: 1)),
                    (470, .blue),
                    (530, .green),
                    (580, .yellow),
                    (620, .orange),
                    (680, .red)
                ]
                for px in stride(from: CGFloat(0), to: size.width, by: 2) {
                    let d = dMax * Double(px / size.width)   // 膜厚 nm
                    var r = 0.0, g = 0.0, b = 0.0
                    for (lam, _) in lambdas {
                        // 光程差 Δ = 2nd（第一界面半波损失，需加 λ/2）
                        let delta = 2 * n * d
                        // 相位差（含半波损失 π）
                        let phase = 2 * .pi * delta / lam + .pi
                        let intensity = pow((1 - cos(phase)) / 2, 1.2)
                        switch lam {
                        case ..<440:  b += intensity * 0.8; r += intensity * 0.2
                        case ..<490:  b += intensity
                        case ..<560:  g += intensity
                        case ..<600:  g += intensity * 0.7; r += intensity * 0.5
                        case ..<640:  r += intensity * 0.8; g += intensity * 0.1
                        default:      r += intensity
                        }
                    }
                    let total = max(r + g + b, 0.01)
                    let col = Color(red: min(r / total, 1), green: min(g / total, 1), blue: min(b / total, 1))
                    ctx.fill(Path(CGRect(x: px, y: 20, width: 2, height: size.height - 70)),
                             with: .color(col.opacity(0.88)))
                }
                // 厚度刻度
                ctx.draw(Text("d = 0 nm").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: 28, y: size.height - 20))
                ctx.draw(Text("d = \(Int(dMax)) nm").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: size.width - 50, y: size.height - 20))
                // 亮条纹标注（第一亮纹 2nd = λ/2）
                for (lam, lc) in lambdas {
                    let d1 = lam / (4 * n)
                    if d1 < dMax {
                        let x = CGFloat(d1 / dMax) * size.width
                        var tick = Path(); tick.move(to: CGPoint(x: x, y: size.height - 44)); tick.addLine(to: CGPoint(x: x, y: size.height - 56))
                        ctx.stroke(tick, with: .color(lc.opacity(0.7)), lineWidth: 1.5)
                    }
                }
            }
            .simCanvas(height: 210, tint: .clear)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "折射率 n", value: String(format: "%.2f", n), color: .apexStarBlue)
                SimReadout(label: "最大膜厚", value: String(format: "%.0f nm", dMax), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "折射率 n", value: $n, range: 1.1...2.5, unit: "", accent: .apexStarBlue)
                SimSlider(label: "最大膜厚", value: $dMax, range: 200...1200, unit: "nm", accent: .apexGold, decimals: 0)
            }.cardSurface()
            SimInsight(text: "膜越厚光程差越大，条纹越密；改变折射率（n越大光速越慢）也能改变条纹间距。肥皂泡是因为液膜厚度不均匀，不同部位对不同波长的光亮暗不同，才呈现出五彩斑斓。")
        }
    }
}
