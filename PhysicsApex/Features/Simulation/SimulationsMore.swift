import SwiftUI

// MARK: - 圆周运动沙盘（向心力 F = mv²/r）

struct CircularMotionSimView: View {
    @State private var r: Double = 2
    @State private var v: Double = 6
    @State private var mass: Double = 1
    @State private var running = true
    @State private var startDate = Date()

    private var omega: Double { v / r }
    private var accel: Double { v * v / r }
    private var force: Double { mass * accel }
    private var period: Double { 2 * .pi * r / v }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    box("向心加速度", String(format: "%.1f m/s²", accel), .apexStarBlue)
                    box("向心力 F", String(format: "%.1f N", force), .apexLava)
                    box("周期 T", String(format: "%.1f s", period), .apexGold)
                }
                controls
                Label("把速度翻倍试试——向心力会变成 4 倍！因为 F 正比于 v²。这就是高速过弯特别危险的原因。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("圆周运动").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let t = tl.date.timeIntervalSince(startDate)
                let theta = omega * t
                let cx = size.width / 2, cy = size.height / 2
                let scale = min(size.width, size.height) / 2 - 40
                let R = CGFloat(r / 3) * scale
                // 轨道圆
                ctx.stroke(Path(ellipseIn: CGRect(x: cx - R, y: cy - R, width: 2*R, height: 2*R)),
                           with: .color(.secondary.opacity(0.4)), style: StrokeStyle(lineWidth: 1, dash: [4,3]))
                ctx.fill(Path(ellipseIn: CGRect(x: cx-3, y: cy-3, width: 6, height: 6)), with: .color(.secondary))
                // 球
                let px = cx + R * CGFloat(cos(theta)), py = cy + R * CGFloat(sin(theta))
                // 半径线
                var radius = Path(); radius.move(to: CGPoint(x: cx, y: cy)); radius.addLine(to: CGPoint(x: px, y: py))
                ctx.stroke(radius, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
                // 速度矢量（切向）
                let vdir = CGVector(dx: -sin(theta), dy: cos(theta))
                var vArrow = Path(); vArrow.move(to: CGPoint(x: px, y: py))
                vArrow.addLine(to: CGPoint(x: px + vdir.dx * CGFloat(v) * 6, y: py + vdir.dy * CGFloat(v) * 6))
                ctx.stroke(vArrow, with: .color(.apexEmerald), lineWidth: 2)
                // 向心力矢量（指向圆心）
                let fdir = CGVector(dx: (cx - px), dy: (cy - py))
                let flen = sqrt(fdir.dx*fdir.dx + fdir.dy*fdir.dy)
                let fn = CGVector(dx: fdir.dx/flen, dy: fdir.dy/flen)
                var fArrow = Path(); fArrow.move(to: CGPoint(x: px, y: py))
                fArrow.addLine(to: CGPoint(x: px + fn.dx * CGFloat(force) * 3, y: py + fn.dy * CGFloat(force) * 3))
                ctx.stroke(fArrow, with: .color(.apexLava), lineWidth: 2.5)
                // 球体
                ctx.fill(Path(ellipseIn: CGRect(x: px-7, y: py-7, width: 14, height: 14)), with: .color(.apexLava))
            }
        }
        .frame(height: 240)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.12), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) { playReset($running, $startDate) }
    }

    private var controls: some View {
        VStack(spacing: Spacing.md) {
            simSlider("半径 r", $r, 1...3, "m", .apexStarBlue)
            simSlider("速度 v", $v, 2...12, "m/s", .apexEmerald)
            simSlider("质量 m", $mass, 0.5...4, "kg", .apexLava)
        }.cardSurface()
    }

    private func box(_ l: String, _ vv: String, _ c: Color) -> some View { simReadout(l, vv, c) }
    private func playReset(_ running: Binding<Bool>, _ start: Binding<Date>) -> some View {
        HStack(spacing: 4) {
            Button { start.wrappedValue = Date(); running.wrappedValue = true } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava) }
            Button { running.wrappedValue.toggle() } label: { Image(systemName: running.wrappedValue ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald) }
        }.padding(8)
    }
}

// MARK: - 斜面受力沙盘（受力分解 + 临界角）

struct InclineSimView: View {
    @State private var angleDeg: Double = 30
    @State private var mu: Double = 0.3
    @State private var running = true
    @State private var startDate = Date()

    private let g = 9.8, mass = 1.0
    private var angle: Double { angleDeg * .pi / 180 }
    private var slideForce: Double { mass * g * sin(angle) }
    private var maxFriction: Double { mu * mass * g * cos(angle) }
    private var willSlide: Bool { slideForce > maxFriction }
    private var accel: Double { willSlide ? g * (sin(angle) - mu * cos(angle)) : 0 }
    private var criticalAngle: Double { atan(mu) * 180 / .pi }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("下滑力", String(format: "%.1f N", slideForce), .apexLava)
                    simReadout("最大静摩擦", String(format: "%.1f N", maxFriction), .apexStarBlue)
                    simReadout("加速度", String(format: "%.1f m/s²", accel), willSlide ? .apexEmerald : .secondary)
                }
                statusBanner
                VStack(spacing: Spacing.md) {
                    simSlider("倾角 θ", $angleDeg, 5...60, "°", .apexLava)
                    simSlider("摩擦因数 μ", $mu, 0...0.8, "", .apexStarBlue)
                }.cardSurface()
                Label(String(format: "临界角 = arctan(μ) ≈ %.0f°。倾角超过它木块才开始下滑——和质量无关，这是斜面问题的秘密。", criticalAngle),
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("斜面受力").navigationBarTitleDisplayMode(.inline)
    }

    private var statusBanner: some View {
        HStack {
            Image(systemName: willSlide ? "arrow.down.forward" : "lock.fill")
            Text(willSlide ? "下滑力 > 摩擦力：木块加速下滑" : "摩擦力够大：木块保持静止")
                .font(AppFont.cardTitle)
            Spacer()
        }
        .foregroundColor(willSlide ? .apexLava : .apexEmerald)
        .padding(Spacing.md)
        .background((willSlide ? Color.apexLava : Color.apexEmerald).opacity(0.10))
        .cornerRadius(Radius.inner)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let m: CGFloat = 24
                let baseY = size.height - m
                let leftX = m, rightX = size.width - m
                let base = rightX - leftX
                let height = base * CGFloat(tan(angle))
                let apexY = max(m, baseY - height)
                // 斜面三角形：底(left→right) 斜边(right→apex 左上)
                let topPoint = CGPoint(x: leftX, y: apexY)
                let botRight = CGPoint(x: rightX, y: baseY)
                var tri = Path()
                tri.move(to: CGPoint(x: leftX, y: baseY)); tri.addLine(to: botRight)
                tri.addLine(to: topPoint); tri.closeSubpath()
                ctx.fill(tri, with: .color(.secondary.opacity(0.15)))
                ctx.stroke(tri, with: .color(.secondary.opacity(0.5)), lineWidth: 1.5)
                // 斜边单位向量（从顶点指向右下，即下滑方向）
                let dx = botRight.x - topPoint.x, dy = botRight.y - topPoint.y
                let L = sqrt(dx*dx + dy*dy)
                let down = CGVector(dx: dx/L, dy: dy/L)
                // 滑块位置：沿斜边滑动（若 willSlide）
                let t = tl.date.timeIntervalSince(startDate)
                let travel = willSlide ? min(0.5 * accel * t * t * 6, Double(L) - 60) : 0
                let frac = (Double(L) > 0) ? travel / Double(L) : 0
                let bx = topPoint.x + dx * CGFloat(frac) + down.dx * 30
                let by = topPoint.y + dy * CGFloat(frac) + down.dy * 30
                let bs: CGFloat = 26
                ctx.fill(Path(roundedRect: CGRect(x: bx - bs/2, y: by - bs/2, width: bs, height: bs), cornerRadius: 5), with: .color(.apexLava))
                // 力矢量：重力(下) 法向(垂直斜面) 摩擦(沿斜面向上)
                let c = CGPoint(x: bx, y: by)
                func arrow(_ d: CGVector, _ len: CGFloat, _ color: Color) {
                    var p = Path(); p.move(to: c); p.addLine(to: CGPoint(x: c.x + d.dx*len, y: c.y + d.dy*len))
                    ctx.stroke(p, with: .color(color), lineWidth: 2)
                }
                arrow(CGVector(dx: 0, dy: 1), CGFloat(mass*g)*2.2, .apexDanger)              // 重力
                let normal = CGVector(dx: -down.dy, dy: down.dx)                               // 垂直斜面
                arrow(normal, CGFloat(maxFriction)*2.2 + 18, .apexStarBlue)                    // 法向(示意)
                arrow(CGVector(dx: -down.dx, dy: -down.dy), CGFloat(maxFriction)*2.2, .apexEmerald) // 摩擦
            }
        }
        .frame(height: 220)
        .background(LinearGradient(colors: [Color.apexLava.opacity(0.08), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            Button { startDate = Date() } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava).padding(8) }
        }
    }
}

// MARK: - 欧姆定律沙盘（I = U/R，电子流动可视化）

struct OhmSimView: View {
    @State private var voltage: Double = 6
    @State private var resistance: Double = 3
    @State private var running = true
    @State private var startDate = Date()

    private var current: Double { voltage / resistance }
    private var power: Double { voltage * current }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("电流 I", String(format: "%.2f A", current), .apexLava)
                    simReadout("功率 P", String(format: "%.1f W", power), .apexGold)
                }
                VStack(spacing: Spacing.md) {
                    simSlider("电压 U", $voltage, 1...12, "V", .apexLava)
                    simSlider("电阻 R", $resistance, 1...20, "Ω", .apexStarBlue)
                }.cardSurface()
                Label("保持电压不变，把电阻翻倍——电流立刻减半。I 与 R 成反比，这就是欧姆定律。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("欧姆定律").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let m: CGFloat = 30
                let rect = CGRect(x: m, y: m, width: size.width - 2*m, height: size.height - 2*m)
                // 导线回路
                ctx.stroke(Path(rect), with: .color(.secondary.opacity(0.6)), lineWidth: 3)
                // 电池（左边）
                let bx = rect.minX
                var b1 = Path(); b1.move(to: CGPoint(x: bx-7, y: rect.midY-14)); b1.addLine(to: CGPoint(x: bx+7, y: rect.midY-14))
                var b2 = Path(); b2.move(to: CGPoint(x: bx-12, y: rect.midY+6)); b2.addLine(to: CGPoint(x: bx+12, y: rect.midY+6))
                ctx.stroke(b1, with: .color(.primary), lineWidth: 3)
                ctx.stroke(b2, with: .color(.primary), lineWidth: 3)
                // 电阻（右边，发热发光 ∝ P）
                let rx = rect.maxX
                let glow = min(power / 30, 1)
                ctx.fill(Path(roundedRect: CGRect(x: rx-9, y: rect.midY-22, width: 18, height: 44), cornerRadius: 4),
                         with: .color(.apexLava.opacity(0.3 + 0.7*glow)))
                // 电子（沿回路移动，速度 ∝ I）
                let perim = 2*(rect.width + rect.height)
                let n = 14
                let offset = tl.date.timeIntervalSince(startDate) * current * 40
                for i in 0..<n {
                    let d = (Double(i)/Double(n) * Double(perim) + offset).truncatingRemainder(dividingBy: Double(perim))
                    let p = pointOnRect(rect, dist: CGFloat(d))
                    ctx.fill(Path(ellipseIn: CGRect(x: p.x-3, y: p.y-3, width: 6, height: 6)), with: .color(.apexStarBlue))
                }
            }
        }
        .frame(height: 200)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.10), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            Button { running.toggle() } label: { Image(systemName: running ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald).padding(8) }
        }
    }

    /// 顺时针沿矩形周长取点。
    private func pointOnRect(_ r: CGRect, dist: CGFloat) -> CGPoint {
        let w = r.width, h = r.height
        var d = dist
        if d < w { return CGPoint(x: r.minX + d, y: r.minY) }
        d -= w
        if d < h { return CGPoint(x: r.maxX, y: r.minY + d) }
        d -= h
        if d < w { return CGPoint(x: r.maxX - d, y: r.maxY) }
        d -= w
        return CGPoint(x: r.minX, y: r.maxY - d)
    }
}

// MARK: - 横波沙盘（v = λf）

struct WaveSimView: View {
    @State private var amplitude: Double = 1
    @State private var frequency: Double = 1
    @State private var wavelength: Double = 4
    @State private var running = true
    @State private var startDate = Date()

    private var speed: Double { wavelength * frequency }
    private var period: Double { 1 / frequency }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("波速 v", String(format: "%.1f m/s", speed), .apexLava)
                    simReadout("周期 T", String(format: "%.2f s", period), .apexStarBlue)
                }
                VStack(spacing: Spacing.md) {
                    simSlider("振幅 A", $amplitude, 0.3...1.5, "m", .apexLava)
                    simSlider("频率 f", $frequency, 0.3...2.5, "Hz", .apexEmerald)
                    simSlider("波长 λ", $wavelength, 2...8, "m", .apexStarBlue)
                }.cardSurface()
                Label("红点只上下振动，并不随波前进——波传递的是振动和能量，不是介质。波速 v = λf。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("横波").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let t = tl.date.timeIntervalSince(startDate)
                let m: CGFloat = 20
                let midY = size.height / 2
                let worldW = 12.0  // 显示 12 m 宽
                let sx = (size.width - 2*m) / CGFloat(worldW)
                let ampPx = CGFloat(amplitude) * (size.height/2 - m) / 1.5
                let k = 2 * .pi / wavelength
                let w = 2 * .pi * frequency
                // 平衡轴
                var axis = Path(); axis.move(to: CGPoint(x: m, y: midY)); axis.addLine(to: CGPoint(x: size.width-m, y: midY))
                ctx.stroke(axis, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
                // 波形
                var wave = Path()
                let n = 160
                for i in 0...n {
                    let xw = worldW * Double(i)/Double(n)
                    let y = amplitude * sin(k * xw - w * t)
                    let px = m + CGFloat(xw) * sx
                    let py = midY - CGFloat(y) * ampPx / CGFloat(amplitude)
                    if i == 0 { wave.move(to: CGPoint(x: px, y: py)) } else { wave.addLine(to: CGPoint(x: px, y: py)) }
                }
                ctx.stroke(wave, with: .color(.apexStarBlue), lineWidth: 2.5)
                // 标记质点（x = 3 m 处）只上下振动
                let markXw = 3.0
                let my = amplitude * sin(k * markXw - w * t)
                let mpx = m + CGFloat(markXw) * sx
                let mpy = midY - CGFloat(my) * ampPx / CGFloat(amplitude)
                var vline = Path(); vline.move(to: CGPoint(x: mpx, y: midY - ampPx)); vline.addLine(to: CGPoint(x: mpx, y: midY + ampPx))
                ctx.stroke(vline, with: .color(.apexLava.opacity(0.25)), style: StrokeStyle(lineWidth: 1, dash: [2,2]))
                ctx.fill(Path(ellipseIn: CGRect(x: mpx-6, y: mpy-6, width: 12, height: 12)), with: .color(.apexLava))
            }
        }
        .frame(height: 220)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.10), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            Button { startDate = Date(); running = true } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava).padding(8) }
        }
    }
}

// MARK: - 沙盘通用小组件

func simReadout(_ label: String, _ value: String, _ color: Color) -> some View {
    VStack(spacing: 2) {
        Text(value).font(AppFont.bigStat(17)).foregroundColor(color)
        Text(label).font(AppFont.caption).foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity).padding(.vertical, Spacing.sm)
    .background(color.opacity(0.08)).cornerRadius(Radius.inner)
}

func simSlider(_ label: String, _ value: Binding<Double>, _ range: ClosedRange<Double>, _ unit: String, _ accent: Color) -> some View {
    HStack(spacing: Spacing.sm) {
        Text(label).font(AppFont.caption).frame(width: 80, alignment: .leading)
        Slider(value: value, in: range).tint(accent)
        Text(unit.isEmpty ? String(format: "%.2f", value.wrappedValue) : "\(Int(value.wrappedValue)) \(unit)")
            .font(AppFont.chip).foregroundColor(accent).frame(width: 56, alignment: .trailing)
    }
}
