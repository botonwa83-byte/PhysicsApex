import SwiftUI

// MARK: - 沙盘扩充包 2：力学进阶（9 个）

// 1. 自由落体与竖直上抛
struct FreeFallSimView: View {
    @State private var v0: Double = 15
    @State private var g: Double = 9.8
    @State private var running = true
    @State private var start = Date()
    private var tUp: Double { v0 / g }
    private var hMax: Double { v0 * v0 / (2 * g) }
    private var tTotal: Double { 2 * tUp }

    var body: some View {
        SimPage(title: "自由落体与上抛") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start).truncatingRemainder(dividingBy: max(tTotal, 0.1))
                    let y = v0 * t - 0.5 * g * t * t
                    let scale = (size.height - 50) / CGFloat(max(hMax, 1))
                    let groundY = size.height - 20
                    var ground = Path(); ground.move(to: CGPoint(x: 0, y: groundY)); ground.addLine(to: CGPoint(x: size.width, y: groundY))
                    ctx.stroke(ground, with: .color(.secondary.opacity(0.5)), lineWidth: 1)
                    let ball = CGPoint(x: size.width * 0.3, y: groundY - CGFloat(max(0, y)) * scale)
                    SimDraw.dot(&ctx, at: ball, r: 8, color: .apexLava)
                    let v = v0 - g * t
                    SimDraw.arrow(&ctx, from: ball, to: CGPoint(x: ball.x, y: ball.y - CGFloat(v) * 3), color: .apexEmerald)
                    // v-t 曲线
                    let rect = CGRect(x: size.width * 0.5, y: 24, width: size.width * 0.45, height: size.height - 60)
                    SimDraw.curve(&ctx, in: rect, x0: 0, x1: tTotal, yMin: -v0, yMax: v0, color: .apexStarBlue) { v0 - g * $0 }
                    let px = rect.minX + rect.width * CGFloat(t / max(tTotal, 0.1))
                    SimDraw.dot(&ctx, at: CGPoint(x: px, y: rect.midY + rect.height * CGFloat(-(v0 - g * t) / (2 * v0))), r: 4, color: .apexGold)
                }
            }
            .simCanvas()
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "上升时间", value: String(format: "%.1f s", tUp), color: .apexStarBlue)
                SimReadout(label: "最大高度", value: String(format: "%.1f m", hMax), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "初速度 v₀", value: $v0, range: 5...30, unit: "m/s", accent: .apexLava)
                SimSlider(label: "重力 g", value: $g, range: 1.6...24.8, unit: "m/s²", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "上升和下落完全对称：升多久、落多久；以多快出发、就以多快回来。v-t 图是一条斜率为 −g 的直线。")
        }
    }
}

// 2. 追及相遇
struct ChaseSimView: View {
    @State private var vCar: Double = 10
    @State private var aMoto: Double = 2
    @State private var running = true
    @State private var start = Date()
    private var tCatch: Double { 2 * vCar / aMoto }
    private var tMaxGap: Double { vCar / aMoto }

    var body: some View {
        SimPage(title: "追及相遇") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start).truncatingRemainder(dividingBy: max(tCatch * 1.15, 0.1))
                    let xCar = vCar * t
                    let xMoto = 0.5 * aMoto * t * t
                    let scale = (size.width - 60) / CGFloat(vCar * tCatch)
                    let y1 = size.height * 0.32, y2 = size.height * 0.62
                    for (x, y, c) in [(xCar, y1, Color.apexStarBlue), (xMoto, y2, Color.apexLava)] {
                        var lane = Path(); lane.move(to: CGPoint(x: 20, y: y + 14)); lane.addLine(to: CGPoint(x: size.width - 20, y: y + 14))
                        ctx.stroke(lane, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
                        ctx.fill(Path(roundedRect: CGRect(x: 20 + CGFloat(x) * scale, y: y - 8, width: 26, height: 16), cornerRadius: 4), with: .color(c))
                    }
                    let gap = xCar - xMoto
                    ctx.draw(Text("差距 \(String(format: "%.1f", max(gap, 0))) m").font(.caption2).foregroundColor(.apexGold),
                             at: CGPoint(x: size.width / 2, y: size.height * 0.12))
                }
            }
            .simCanvas(height: 180)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "差距最大于", value: String(format: "%.1f s（共速）", tMaxGap), color: .apexGold)
                SimReadout(label: "追上时刻", value: String(format: "%.1f s", tCatch), color: .apexLava)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "汽车速度", value: $vCar, range: 5...20, unit: "m/s", accent: .apexStarBlue)
                SimSlider(label: "摩托加速度", value: $aMoto, range: 1...5, unit: "m/s²", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "速度相等时差距最大（不是追上）！追上时刻恰好是共速时刻的 2 倍——v-t 图上面积相等的几何必然。")
        }
    }
}

// 3. 最省力角（摩擦角）
struct FrictionPullSimView: View {
    @State private var mu: Double = 0.5
    @State private var theta: Double = 20
    private let mg = 100.0
    private func force(_ deg: Double) -> Double {
        let r = deg * .pi / 180
        return mu * mg / (cos(r) + mu * sin(r))
    }
    private var bestDeg: Double { atan(mu) * 180 / .pi }

    var body: some View {
        SimPage(title: "最省力的角度") {
            Canvas { ctx, size in
                let rect = CGRect(x: 30, y: 20, width: size.width - 60, height: size.height - 56)
                let fMax = force(0) * 1.15
                SimDraw.curve(&ctx, in: rect, x0: 0, x1: 80, yMin: 0, yMax: fMax, color: .apexStarBlue) { force($0) }
                // 当前角度点
                let px = rect.minX + rect.width * CGFloat(theta / 80)
                let py = rect.maxY - rect.height * CGFloat(force(theta) / fMax)
                SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 6, color: .apexLava)
                // 最省力点
                let bx = rect.minX + rect.width * CGFloat(bestDeg / 80)
                let by = rect.maxY - rect.height * CGFloat(force(bestDeg) / fMax)
                SimDraw.dot(&ctx, at: CGPoint(x: bx, y: by), r: 4, color: .apexGold)
                ctx.draw(Text("F(θ) 拉力曲线").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: size.width / 2, y: size.height - 14))
            }
            .simCanvas(height: 200, tint: .apexLava)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "当前拉力", value: String(format: "%.1f N", force(theta)), color: .apexLava)
                SimReadout(label: "最省力角", value: String(format: "%.0f°", bestDeg), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "拉力角 θ", value: $theta, range: 0...80, unit: "°", accent: .apexLava, decimals: 0)
                SimSlider(label: "摩擦因数 μ", value: $mu, range: 0.1...1, unit: "", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "水平拉（0°）不是最省力！斜向上拉能减小压力从而减小摩擦。最优角恰好满足 tanθ=μ——这就是摩擦角。")
        }
    }
}

// 4. 连接体（整体与隔离）
struct ConnectedSimView: View {
    @State private var f: Double = 6
    @State private var m1: Double = 1
    @State private var m2: Double = 2
    private var a: Double { f / (m1 + m2) }
    private var tension: Double { m1 * a }

    var body: some View {
        SimPage(title: "连接体") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let w1 = 30 + CGFloat(m1) * 8, w2 = 30 + CGFloat(m2) * 8
                let x1 = size.width * 0.25, x2 = size.width * 0.55
                var rope = Path(); rope.move(to: CGPoint(x: x1 + w1 / 2, y: midY)); rope.addLine(to: CGPoint(x: x2 - w2 / 2, y: midY))
                ctx.stroke(rope, with: .color(.secondary), lineWidth: 2)
                ctx.fill(Path(roundedRect: CGRect(x: x1 - w1 / 2, y: midY - 20, width: w1, height: 40), cornerRadius: 6), with: .color(.apexStarBlue))
                ctx.fill(Path(roundedRect: CGRect(x: x2 - w2 / 2, y: midY - 20, width: w2, height: 40), cornerRadius: 6), with: .color(.apexLava))
                SimDraw.arrow(&ctx, from: CGPoint(x: x2 + w2 / 2, y: midY), to: CGPoint(x: x2 + w2 / 2 + CGFloat(f) * 9, y: midY), color: .apexEmerald, lineWidth: 3)
                ctx.draw(Text("m₁").font(.caption).foregroundColor(.white), at: CGPoint(x: x1, y: midY))
                ctx.draw(Text("m₂").font(.caption).foregroundColor(.white), at: CGPoint(x: x2, y: midY))
                ctx.draw(Text("F").font(.caption).foregroundColor(.apexEmerald), at: CGPoint(x: x2 + w2 / 2 + CGFloat(f) * 9, y: midY - 14))
            }
            .simCanvas(height: 150, tint: .apexEmerald)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "加速度 a", value: String(format: "%.2f m/s²", a), color: .apexEmerald)
                SimReadout(label: "绳张力 T", value: String(format: "%.2f N", tension), color: .apexLava)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "拉力 F", value: $f, range: 2...20, unit: "N", accent: .apexEmerald)
                SimSlider(label: "前块 m₁", value: $m1, range: 0.5...5, unit: "kg", accent: .apexStarBlue)
                SimSlider(label: "后块 m₂", value: $m2, range: 0.5...5, unit: "kg", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "张力 T = m₁F/(m₁+m₂)：只跟质量的「比例」有关。试试把 m₁ 调大——前面的货越重，绳子越吃力。")
        }
    }
}

// 5. 电梯超重失重
struct ElevatorSimView: View {
    @State private var a: Double = 2
    @State private var phase: Int = 0   // 0 加速上升 1 匀速 2 减速上升
    private let m = 50.0, g = 9.8
    private var effA: Double { phase == 0 ? a : (phase == 1 ? 0 : -a) }
    private var n: Double { m * (g + effA) }

    var body: some View {
        SimPage(title: "电梯超重失重") {
            Canvas { ctx, size in
                let boxRect = CGRect(x: size.width / 2 - 60, y: 24, width: 120, height: size.height - 60)
                ctx.stroke(Path(roundedRect: boxRect, cornerRadius: 8), with: .color(.secondary), lineWidth: 2)
                // 人
                let py = boxRect.maxY - 40
                SimDraw.dot(&ctx, at: CGPoint(x: boxRect.midX, y: py - 26), r: 10, color: .apexLava)
                ctx.fill(Path(roundedRect: CGRect(x: boxRect.midX - 8, y: py - 18, width: 16, height: 26), cornerRadius: 4), with: .color(.apexLava))
                // 体重计读数
                ctx.fill(Path(roundedRect: CGRect(x: boxRect.midX - 30, y: py + 10, width: 60, height: 14), cornerRadius: 3), with: .color(.apexStarBlue.opacity(0.4)))
                ctx.draw(Text(String(format: "%.0f N", n)).font(.system(size: 13, weight: .black)).foregroundColor(.apexGold),
                         at: CGPoint(x: boxRect.midX, y: py + 17))
                // 加速度箭头
                if effA != 0 {
                    let dir: CGFloat = effA > 0 ? -1 : 1
                    SimDraw.arrow(&ctx, from: CGPoint(x: boxRect.maxX + 24, y: boxRect.midY),
                                  to: CGPoint(x: boxRect.maxX + 24, y: boxRect.midY + dir * 36), color: .apexEmerald, lineWidth: 3)
                    ctx.draw(Text("a").font(.caption).foregroundColor(.apexEmerald), at: CGPoint(x: boxRect.maxX + 36, y: boxRect.midY))
                }
            }
            .simCanvas(height: 210, tint: .apexMystery)
            Picker("阶段", selection: $phase) {
                Text("加速上升").tag(0); Text("匀速").tag(1); Text("减速上升").tag(2)
            }.pickerStyle(.segmented)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "体重计读数", value: String(format: "%.0f N", n), color: .apexGold)
                SimReadout(label: "静止应为", value: String(format: "%.0f N", m * g), color: .apexStarBlue)
            }
            SimSlider(label: "加速度 a", value: $a, range: 0...6, unit: "m/s²", accent: .apexEmerald).cardSurface()
            SimInsight(text: "读数只看加速度方向：a 向上读数变大（超重），a 向下变小（失重）。「减速上升」和「加速下降」是一回事。")
        }
    }
}

// 6. 人船模型
struct BoatSimView: View {
    @State private var mPerson: Double = 60
    @State private var mBoat: Double = 120
    @State private var walk: Double = 0   // 人在船上走的进度 0...1
    private let boatLen = 6.0
    private var boatShift: Double { mPerson * boatLen * walk / (mPerson + mBoat) }

    var body: some View {
        SimPage(title: "人船模型") {
            Canvas { ctx, size in
                let scale = (size.width - 80) / CGFloat(boatLen * 1.8)
                let waterY = size.height * 0.62
                var water = Path(); water.move(to: CGPoint(x: 0, y: waterY + 18)); water.addLine(to: CGPoint(x: size.width, y: waterY + 18))
                ctx.stroke(water, with: .color(.apexStarBlue.opacity(0.5)), lineWidth: 2)
                let boatX0 = 40 + CGFloat(boatLen * 0.4 - boatShift) * scale
                let boatW = CGFloat(boatLen) * scale
                ctx.fill(Path(roundedRect: CGRect(x: boatX0, y: waterY, width: boatW, height: 16), cornerRadius: 6), with: .color(.brown))
                let personX = boatX0 + boatW * CGFloat(walk)
                SimDraw.dot(&ctx, at: CGPoint(x: personX, y: waterY - 22), r: 8, color: .apexLava)
                ctx.fill(Path(roundedRect: CGRect(x: personX - 5, y: waterY - 16, width: 10, height: 16), cornerRadius: 3), with: .color(.apexLava))
                // 质心线（不动）
                let comX = 40 + CGFloat(boatLen * 0.4) * scale + boatW * CGFloat(mPerson / (mPerson + mBoat)) * 0
                    + (boatW * CGFloat(mPerson) * 0) // 视觉提示线固定
                var com = Path(); com.move(to: CGPoint(x: size.width / 2 + comX * 0, y: 24)); com.addLine(to: CGPoint(x: size.width / 2, y: size.height - 16))
                ctx.stroke(com, with: .color(.apexGold.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                ctx.draw(Text("系统质心（不动）").font(.caption2).foregroundColor(.apexGold), at: CGPoint(x: size.width / 2, y: 14))
            }
            .simCanvas(height: 190, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "船退距离", value: String(format: "%.2f m", boatShift), color: .apexLava)
                SimReadout(label: "理论 mL/(m+M)", value: String(format: "%.2f m", mPerson * boatLen / (mPerson + mBoat)), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "走到船另一端", value: $walk, range: 0...1, unit: "", accent: .apexLava)
                SimSlider(label: "人质量", value: $mPerson, range: 40...100, unit: "kg", accent: .apexLava, decimals: 0)
                SimSlider(label: "船质量", value: $mBoat, range: 60...300, unit: "kg", accent: .apexStarBlue, decimals: 0)
            }.cardSurface()
            SimInsight(text: "拖动「走到船另一端」：人往前、船往后，但金色质心线纹丝不动——初动量为零的系统，质心被钉死。")
        }
    }
}

// 7. 单摆
struct PendulumSimView: View {
    @State private var length: Double = 1
    @State private var g: Double = 9.8
    @State private var running = true
    @State private var start = Date()
    private var period: Double { 2 * .pi * sqrt(length / g) }

    var body: some View {
        SimPage(title: "单摆") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let theta = 0.35 * cos(2 * .pi * t / period)
                    let pivot = CGPoint(x: size.width / 2, y: 28)
                    let lpx = CGFloat(length) * (size.height - 90)
                    let bob = CGPoint(x: pivot.x + lpx * CGFloat(sin(theta)), y: pivot.y + lpx * CGFloat(cos(theta)))
                    var rod = Path(); rod.move(to: pivot); rod.addLine(to: bob)
                    ctx.stroke(rod, with: .color(.secondary), lineWidth: 2)
                    SimDraw.dot(&ctx, at: pivot, r: 4, color: .secondary)
                    SimDraw.dot(&ctx, at: bob, r: 12, color: .apexLava)
                    var eq = Path(); eq.move(to: pivot); eq.addLine(to: CGPoint(x: pivot.x, y: pivot.y + lpx + 16))
                    ctx.stroke(eq, with: .color(.secondary.opacity(0.3)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                }
            }
            .simCanvas(height: 230, tint: .apexEmerald)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "周期 T", value: String(format: "%.2f s", period), color: .apexStarBlue)
                SimReadout(label: "T=2π√(L/g)", value: length == 1 && abs(g - 9.8) < 0.2 ? "秒摆!" : "—", color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "摆长 L", value: $length, range: 0.3...1, unit: "m", accent: .apexLava)
                SimSlider(label: "重力 g", value: $g, range: 1.6...24.8, unit: "m/s²", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "周期只认摆长和 g：摆长变 4 倍周期才变 2 倍；换到月球（g=1.6）摆得明显变慢。质量？根本不在公式里。")
        }
    }
}

// 8. 开普勒轨道
struct KeplerSimView: View {
    @State private var ecc: Double = 0.5
    @State private var running = true
    @State private var start = Date()

    var body: some View {
        SimPage(title: "开普勒椭圆轨道") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let a = min(size.width, size.height) * 0.38
                    let b = a * CGFloat(sqrt(1 - ecc * ecc))
                    let c = a * CGFloat(ecc)
                    let center = CGPoint(x: size.width / 2 - c, y: size.height / 2)
                    let focus = CGPoint(x: size.width / 2 - 2 * c + c, y: size.height / 2) // 太阳在焦点
                    var orbit = Path()
                    orbit.addEllipse(in: CGRect(x: center.x - a, y: center.y - b, width: 2 * a, height: 2 * b))
                    ctx.stroke(orbit, with: .color(.secondary.opacity(0.4)), lineWidth: 1)
                    SimDraw.dot(&ctx, at: focus, r: 10, color: .apexGold)
                    // 用面积速度恒定近似推进真近点角
                    let period = 6.0
                    let M = (t.truncatingRemainder(dividingBy: period)) / period * 2 * .pi
                    var E = M
                    for _ in 0..<5 { E = M + ecc * sin(E) }   // 开普勒方程迭代
                    let x = center.x + a * CGFloat(cos(E))
                    let y = center.y + b * CGFloat(sin(E))
                    let planet = CGPoint(x: x, y: y)
                    // 扫过的扇形（最近一段）
                    var sweep = Path()
                    sweep.move(to: focus)
                    for k in 0...12 {
                        let Ek = E - 0.5 + 0.5 * Double(k) / 12
                        sweep.addLine(to: CGPoint(x: center.x + a * CGFloat(cos(Ek)), y: center.y + b * CGFloat(sin(Ek))))
                    }
                    sweep.closeSubpath()
                    ctx.fill(sweep, with: .color(.apexStarBlue.opacity(0.18)))
                    SimDraw.dot(&ctx, at: planet, r: 7, color: .apexStarBlue)
                }
            }
            .simCanvas(height: 230, tint: .apexMystery)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            SimSlider(label: "偏心率 e", value: $ecc, range: 0...0.8, unit: "", accent: .apexMystery).cardSurface()
            SimInsight(text: "看行星在近日点明显加速、远日点变慢——相同时间扫过的扇形面积却始终一样大。这就是开普勒第二定律（角动量守恒）。")
        }
    }
}

// 9. 传送带
struct ConveyorSimView: View {
    @State private var vBelt: Double = 2
    @State private var mu: Double = 0.5
    @State private var running = true
    @State private var start = Date()
    private let g = 10.0
    private var aVal: Double { mu * g }
    private var tShare: Double { vBelt / aVal }
    private var relSlip: Double { vBelt * tShare - 0.5 * aVal * tShare * tShare }
    private var heat: Double { mu * 1 * g * relSlip }

    var body: some View {
        SimPage(title: "传送带") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start).truncatingRemainder(dividingBy: max(tShare * 1.6, 0.1))
                    let beltY = size.height * 0.5
                    // 传送带（滚动条纹）
                    let stripeShift = CGFloat((tl.date.timeIntervalSince(start) * vBelt * 30).truncatingRemainder(dividingBy: 20))
                    var belt = Path(); belt.move(to: CGPoint(x: 16, y: beltY)); belt.addLine(to: CGPoint(x: size.width - 16, y: beltY))
                    ctx.stroke(belt, with: .color(.secondary), lineWidth: 4)
                    var x: CGFloat = 16 + stripeShift
                    while x < size.width - 16 {
                        var tick = Path(); tick.move(to: CGPoint(x: x, y: beltY - 4)); tick.addLine(to: CGPoint(x: x + 6, y: beltY + 4))
                        ctx.stroke(tick, with: .color(.secondary.opacity(0.6)), lineWidth: 1.5)
                        x += 20
                    }
                    // 工件
                    let vNow = min(aVal * t, vBelt)
                    let xObj = min(aVal * t * t / 2, vBelt * t) * 18
                    ctx.fill(Path(roundedRect: CGRect(x: 30 + CGFloat(xObj), y: beltY - 26, width: 30, height: 22), cornerRadius: 4), with: .color(.apexLava))
                    ctx.draw(Text(String(format: "v=%.1f", vNow)).font(.caption2).foregroundColor(.apexLava),
                             at: CGPoint(x: 45 + CGFloat(xObj), y: beltY - 38))
                    ctx.draw(Text(String(format: "带速 %.1f m/s", vBelt)).font(.caption2).foregroundColor(.secondary),
                             at: CGPoint(x: size.width / 2, y: beltY + 22))
                }
            }
            .simCanvas(height: 170, tint: .apexLava)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "共速用时", value: String(format: "%.2f s", tShare), color: .apexStarBlue)
                SimReadout(label: "相对滑动", value: String(format: "%.2f m", relSlip), color: .apexLava)
                SimReadout(label: "摩擦生热", value: String(format: "%.2f J", heat), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "带速", value: $vBelt, range: 1...5, unit: "m/s", accent: .apexStarBlue)
                SimSlider(label: "摩擦因数 μ", value: $mu, range: 0.2...0.8, unit: "", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "工件加速阶段，皮带永远比它多走一段——这段「相对滑动」乘以摩擦力才是生热，别用工件位移去算。")
        }
    }
}
