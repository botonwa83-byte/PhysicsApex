import SwiftUI

// MARK: - 沙盘扩充包 5：临界 · 振荡 · 成像 · 波（9 个，编号 28–36）

// 28. 竖直圆周临界（最高点 v=√(gr)）
struct VerticalCircleSimView: View {
    @State private var vTop: Double = 4     // 最高点速度 m/s
    @State private var r: Double = 1.5      // 半径 m
    private let g = 9.8
    private var vCritical: Double { sqrt(g * r) }
    private var passes: Bool { vTop >= vCritical }
    private var tensionPerMass: Double { vTop * vTop / r - g }   // T/m

    var body: some View {
        SimPage(title: "竖直圆周临界") {
            Canvas { ctx, size in
                let c = CGPoint(x: size.width * 0.42, y: size.height * 0.56)
                let rad = min(size.width, size.height) * 0.34
                var circle = Path(); circle.addEllipse(in: CGRect(x: c.x - rad, y: c.y - rad, width: 2 * rad, height: 2 * rad))
                ctx.stroke(circle, with: .color(.secondary.opacity(0.5)), style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                let top = CGPoint(x: c.x, y: c.y - rad)
                if passes {
                    SimDraw.dot(&ctx, at: top, r: 10, color: .apexEmerald)
                    // 重力（向下）
                    SimDraw.arrow(&ctx, from: top, to: CGPoint(x: top.x, y: top.y + 32), color: .apexGold, lineWidth: 2.5)
                    // 绳/轨道张力（向下指向圆心，仅当 v>v临界 才有富余）
                    if tensionPerMass > 0.05 {
                        let len = CGFloat(min(tensionPerMass, 20)) * 1.6 + 10
                        SimDraw.arrow(&ctx, from: CGPoint(x: top.x + 14, y: top.y), to: CGPoint(x: top.x + 14, y: top.y + len), color: .apexLava, lineWidth: 2.5)
                    }
                    ctx.draw(Text(vTop > vCritical + 0.05 ? "顺利通过最高点" : "恰好通过（绳张力为零）")
                        .font(.caption).foregroundColor(.apexEmerald), at: CGPoint(x: size.width / 2, y: 16))
                } else {
                    SimDraw.dot(&ctx, at: top, r: 10, color: .apexDanger)
                    var fall = Path(); fall.move(to: top)
                    for i in 0...26 {
                        let t = Double(i) * 0.045
                        let x = top.x + CGFloat(vTop * t) * 20
                        let y = top.y + CGFloat(0.5 * g * t * t) * 20
                        fall.addLine(to: CGPoint(x: x, y: y))
                    }
                    ctx.stroke(fall, with: .color(.apexDanger.opacity(0.65)), style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                    ctx.draw(Text("速度不够，没到顶就脱轨抛落！").font(.caption).foregroundColor(.apexDanger),
                             at: CGPoint(x: size.width / 2, y: 16))
                }
            }
            .simCanvas(height: 230, tint: .apexLava)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "最高点 v", value: String(format: "%.1f m/s", vTop), color: passes ? .apexEmerald : .apexDanger)
                SimReadout(label: "临界 √(gr)", value: String(format: "%.2f m/s", vCritical), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "最高点速度", value: $vTop, range: 1...8, unit: "m/s", accent: .apexLava)
                SimSlider(label: "半径 r", value: $r, range: 0.5...3, unit: "m", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "最高点重力恰好当向心力时速度最小：v=√(gr)，此刻绳张力为零。再慢一点，绳还没来得及拉，小球就先掉下来了。")
        }
    }
}

// 29. 滑块木板（双摩擦面，整体还是相对滑动）
struct BoardBlockSimView: View {
    @State private var force: Double = 8    // 拉块的力 F (N)
    @State private var mu1: Double = 0.3    // 块-板 摩擦因数
    @State private var running = true
    @State private var start = Date()
    private let m1 = 1.0, m2 = 2.0, mu2 = 0.2, g = 9.8

    // 是否相对滑动 + 两者加速度
    private var groundMax: Double { mu2 * (m1 + m2) * g }
    private var together: Bool {
        guard force > groundMax else { return true }   // 不动也算"一起"
        let a = (force - groundMax) / (m1 + m2)
        let needed = force - m1 * a                     // 块所需摩擦
        return needed <= mu1 * m1 * g + 1e-6
    }
    private var a1: Double {
        if together { return max((force - groundMax) / (m1 + m2), 0) }
        return (force - mu1 * m1 * g) / m1
    }
    private var a2: Double {
        if together { return max((force - groundMax) / (m1 + m2), 0) }
        return max((mu1 * m1 * g - groundMax) / m2, 0)
    }

    var body: some View {
        SimPage(title: "滑块木板") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    var t = tl.date.timeIntervalSince(start)
                    if t > 1.6 { t = 1.6 }   // 演示窗口，到点定格
                    let baseX: CGFloat = 30
                    let groundY = size.height - 30
                    var ground = Path(); ground.move(to: CGPoint(x: 0, y: groundY)); ground.addLine(to: CGPoint(x: size.width, y: groundY))
                    ctx.stroke(ground, with: .color(.secondary.opacity(0.5)), lineWidth: 2)
                    // 阴影线地面
                    for gx in stride(from: CGFloat(0), to: size.width, by: 12) {
                        var h = Path(); h.move(to: CGPoint(x: gx, y: groundY)); h.addLine(to: CGPoint(x: gx - 7, y: groundY + 7))
                        ctx.stroke(h, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
                    }
                    let x2 = baseX + CGFloat(0.5 * a2 * t * t) * 26   // 木板位移
                    let x1 = baseX + CGFloat(0.5 * a1 * t * t) * 26   // 滑块位移
                    // 木板
                    let boardRect = CGRect(x: x2, y: groundY - 24, width: 150, height: 18)
                    ctx.fill(Path(roundedRect: boardRect, cornerRadius: 4), with: .color(.apexStarBlue.opacity(0.8)))
                    // 滑块（在木板上）
                    let blockRect = CGRect(x: x1 + 16, y: boardRect.minY - 30, width: 44, height: 30)
                    ctx.fill(Path(roundedRect: blockRect, cornerRadius: 5), with: .color(.apexLava))
                    // 拉力箭头
                    SimDraw.arrow(&ctx, from: CGPoint(x: blockRect.maxX, y: blockRect.midY),
                                  to: CGPoint(x: blockRect.maxX + 30, y: blockRect.midY), color: .apexGold, lineWidth: 3)
                    ctx.draw(Text("F").font(.caption).foregroundColor(.apexGold), at: CGPoint(x: blockRect.maxX + 38, y: blockRect.midY))
                    ctx.draw(Text(together ? "整体一起加速（不打滑）" : "相对滑动：块快板慢")
                        .font(.caption).foregroundColor(together ? .apexEmerald : .apexDanger),
                             at: CGPoint(x: size.width / 2, y: 16))
                }
            }
            .simCanvas(height: 200, tint: .apexLava)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "块 a₁", value: String(format: "%.2f m/s²", a1), color: .apexLava)
                SimReadout(label: "板 a₂", value: String(format: "%.2f m/s²", a2), color: .apexStarBlue)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "拉力 F", value: $force, range: 0...16, unit: "N", accent: .apexGold, decimals: 0)
                SimSlider(label: "块板摩擦 μ₁", value: $mu1, range: 0.05...0.6, unit: "", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "块板间摩擦撑得住，就整体一起走；F 太大、μ₁ 太小，块上摩擦「拽不动」木板，两者就分道扬镳——这就是相对滑动的临界。")
        }
    }
}

// 30. 受迫振动与共振
struct ResonanceSimView: View {
    @State private var driveFreq: Double = 1.0   // 驱动频率 Hz
    @State private var damping: Double = 0.15    // 阻尼
    @State private var running = true
    @State private var start = Date()
    private let f0 = 1.0                          // 固有频率 Hz

    private func amplitude(_ f: Double) -> Double {
        let w = 2 * Double.pi * f, w0 = 2 * Double.pi * f0
        return 1.2 / sqrt(pow(w0 * w0 - w * w, 2) + pow(2 * damping * w0 * w, 2)) * (w0 * w0)
    }

    var body: some View {
        SimPage(title: "受迫振动与共振") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    // 左：振子
                    let A = min(amplitude(driveFreq), 6)
                    let cx = size.width * 0.22
                    let topY = size.height * 0.18
                    let y = size.height * 0.5 + CGFloat(A * sin(2 * .pi * driveFreq * t)) * 16
                    var spring = Path(); spring.move(to: CGPoint(x: cx, y: topY))
                    let coils = 10
                    for i in 0...coils {
                        let fy = topY + (y - topY) * CGFloat(i) / CGFloat(coils)
                        let fx = cx + (i % 2 == 0 ? -7 : 7)
                        spring.addLine(to: CGPoint(x: i == coils ? cx : CGFloat(fx), y: fy))
                    }
                    ctx.stroke(spring, with: .color(.apexEmerald), lineWidth: 2)
                    ctx.fill(Path(roundedRect: CGRect(x: cx - 16, y: y, width: 32, height: 28), cornerRadius: 5), with: .color(.apexLava))
                    // 右：共振曲线 A(f)
                    let rect = CGRect(x: size.width * 0.42, y: 24, width: size.width * 0.52, height: size.height - 64)
                    SimDraw.curve(&ctx, in: rect, x0: 0.2, x1: 2.0, yMin: 0, yMax: 6, color: .apexStarBlue) { min(self.amplitude($0), 6) }
                    // 固有频率竖线
                    let f0x = rect.minX + rect.width * CGFloat((f0 - 0.2) / 1.8)
                    var vline = Path(); vline.move(to: CGPoint(x: f0x, y: rect.minY)); vline.addLine(to: CGPoint(x: f0x, y: rect.maxY))
                    ctx.stroke(vline, with: .color(.apexGold.opacity(0.5)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    // 当前驱动点
                    let px = rect.minX + rect.width * CGFloat((driveFreq - 0.2) / 1.8)
                    let py = rect.maxY - rect.height * CGFloat(min(amplitude(driveFreq), 6) / 6)
                    SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 5, color: .apexLava)
                    ctx.draw(Text("固有 f₀").font(.caption2).foregroundColor(.apexGold), at: CGPoint(x: f0x, y: rect.minY - 8))
                }
            }
            .simCanvas(height: 220, tint: .apexEmerald)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "驱动频率", value: String(format: "%.2f Hz", driveFreq), color: .apexLava)
                SimReadout(label: "稳态振幅", value: String(format: "%.2f", amplitude(driveFreq)), color: .apexStarBlue)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "驱动频率 f", value: $driveFreq, range: 0.2...2.0, unit: "Hz", accent: .apexLava, decimals: 2)
                SimSlider(label: "阻尼", value: $damping, range: 0.05...0.6, unit: "", accent: .apexStarBlue, decimals: 2)
            }.cardSurface()
            SimInsight(text: "把驱动频率慢慢调到固有频率 f₀，振幅猛地窜起来——这就是共振。阻尼越小峰越尖越危险（塔科马大桥、行军不齐步过桥）。")
        }
    }
}

// 31. RC 充放电
struct RCCircuitSimView: View {
    @State private var r: Double = 10        // 电阻 kΩ
    @State private var c: Double = 100       // 电容 μF
    @State private var charging = true
    @State private var running = true
    @State private var start = Date()
    private let v0 = 5.0
    private var tau: Double { r * c / 1000 }   // ms·kΩ·μF→ R(kΩ)*C(μF)=ms

    var body: some View {
        SimPage(title: "RC 充放电") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    var t = tl.date.timeIntervalSince(start) * 1000   // ms
                    let window = tau * 5
                    if t > window { t = window }
                    let v = charging ? v0 * (1 - exp(-t / tau)) : v0 * exp(-t / tau)
                    // 电容电压条
                    let barX = size.width * 0.12
                    let barH = size.height - 70
                    let topY: CGFloat = 30
                    ctx.stroke(Path(roundedRect: CGRect(x: barX, y: topY, width: 30, height: barH), cornerRadius: 4), with: .color(.secondary), lineWidth: 2)
                    let fillH = barH * CGFloat(v / v0)
                    ctx.fill(Path(roundedRect: CGRect(x: barX + 2, y: topY + barH - fillH, width: 26, height: fillH), cornerRadius: 3), with: .color(.apexLava))
                    ctx.draw(Text(String(format: "%.2f V", v)).font(.caption).foregroundColor(.apexLava), at: CGPoint(x: barX + 15, y: topY - 10))
                    // V-t 曲线
                    let rect = CGRect(x: size.width * 0.32, y: 30, width: size.width * 0.6, height: barH)
                    SimDraw.curve(&ctx, in: rect, x0: 0, x1: window, yMin: 0, yMax: v0, color: .apexStarBlue) {
                        self.charging ? self.v0 * (1 - exp(-$0 / self.tau)) : self.v0 * exp(-$0 / self.tau)
                    }
                    let px = rect.minX + rect.width * CGFloat(t / window)
                    let py = rect.maxY - rect.height * CGFloat(v / v0)
                    SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 5, color: .apexGold)
                    // τ 标记
                    let tauX = rect.minX + rect.width * CGFloat(tau / window)
                    var tl2 = Path(); tl2.move(to: CGPoint(x: tauX, y: rect.minY)); tl2.addLine(to: CGPoint(x: tauX, y: rect.maxY))
                    ctx.stroke(tl2, with: .color(.apexGold.opacity(0.45)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    ctx.draw(Text("τ").font(.caption2).foregroundColor(.apexGold), at: CGPoint(x: tauX, y: rect.minY - 8))
                }
            }
            .simCanvas(height: 210, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            Picker("模式", selection: $charging) {
                Text("充电").tag(true); Text("放电").tag(false)
            }
            .pickerStyle(.segmented)
            .onChange(of: charging) { _ in start = Date() }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "时间常数 τ=RC", value: String(format: "%.0f ms", tau), color: .apexGold)
                SimReadout(label: "5τ 充满约", value: String(format: "%.0f ms", tau * 5), color: .secondary)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电阻 R", value: $r, range: 1...50, unit: "kΩ", accent: .apexStarBlue, decimals: 0)
                SimSlider(label: "电容 C", value: $c, range: 10...300, unit: "μF", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "τ=RC 决定快慢：R 或 C 越大充得越慢。一个 τ 充到 63%，5 个 τ 才算「满」——相机闪光灯、单片机复位都靠它定时。")
        }
    }
}

// 32. LC 振荡（能量在电场与磁场间来回）
struct LCOscillationSimView: View {
    @State private var l: Double = 10        // 电感 mH
    @State private var cap: Double = 100     // 电容 μF
    @State private var running = true
    @State private var start = Date()
    private var freq: Double { 1 / (2 * .pi * sqrt(l * 1e-3 * cap * 1e-6)) }   // Hz

    var body: some View {
        SimPage(title: "LC 电磁振荡") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let phase = tl.date.timeIntervalSince(start) * 2 * .pi / 1.6   // 演示用固定可视周期 1.6s
                    let q = cos(phase)            // 电荷 ∝ cos
                    let i = -sin(phase)           // 电流 ∝ -sin
                    let eC = q * q                // 电容储能 ∝ q²
                    let eL = i * i                // 电感储能 ∝ i²
                    // 两个能量条
                    let barH = size.height * 0.45
                    let baseY = size.height * 0.62
                    func bar(_ x: CGFloat, _ frac: Double, _ color: Color, _ label: String) {
                        ctx.stroke(Path(roundedRect: CGRect(x: x, y: baseY - barH, width: 34, height: barH), cornerRadius: 4), with: .color(.secondary.opacity(0.5)), lineWidth: 1.5)
                        let h = barH * CGFloat(frac)
                        ctx.fill(Path(roundedRect: CGRect(x: x + 2, y: baseY - h, width: 30, height: h), cornerRadius: 3), with: .color(color))
                        ctx.draw(Text(label).font(.caption2).foregroundColor(.secondary), at: CGPoint(x: x + 17, y: baseY + 12))
                    }
                    bar(size.width * 0.14, eC, .apexLava, "电容 E∝q²")
                    bar(size.width * 0.30, eL, .apexStarBlue, "电感 E∝i²")
                    // q-t 与 i-t 正弦
                    let rect = CGRect(x: size.width * 0.5, y: 24, width: size.width * 0.44, height: size.height - 60)
                    var zero = Path(); zero.move(to: CGPoint(x: rect.minX, y: rect.midY)); zero.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                    ctx.stroke(zero, with: .color(.secondary.opacity(0.35)), lineWidth: 1)
                    func wave(_ ph0: Double, _ color: Color, fn: @escaping (Double) -> Double) {
                        var p = Path()
                        for k in 0...100 {
                            let x = rect.minX + rect.width * CGFloat(k) / 100
                            let val = fn(phase - Double(100 - k) * 0.05)
                            let y = rect.midY - CGFloat(val) * rect.height * 0.4
                            if k == 0 { p.move(to: CGPoint(x: x, y: y)) } else { p.addLine(to: CGPoint(x: x, y: y)) }
                        }
                        ctx.stroke(p, with: .color(color), lineWidth: 2)
                    }
                    wave(0, .apexLava) { cos($0) }
                    wave(0, .apexStarBlue) { -sin($0) }
                    // 当前点
                    SimDraw.dot(&ctx, at: CGPoint(x: rect.maxX, y: rect.midY - CGFloat(q) * rect.height * 0.4), r: 4, color: .apexLava)
                    SimDraw.dot(&ctx, at: CGPoint(x: rect.maxX, y: rect.midY - CGFloat(i) * rect.height * 0.4), r: 4, color: .apexStarBlue)
                    ctx.draw(Text("q（红） / i（蓝）相差 90°").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: rect.midX, y: size.height - 16))
                }
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "振荡频率 f", value: freq > 1000 ? String(format: "%.1f kHz", freq / 1000) : String(format: "%.0f Hz", freq), color: .apexGold)
                SimReadout(label: "周期 T=2π√(LC)", value: String(format: "%.2f ms", 1000 / freq), color: .secondary)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电感 L", value: $l, range: 1...50, unit: "mH", accent: .apexStarBlue, decimals: 0)
                SimSlider(label: "电容 C", value: $cap, range: 10...300, unit: "μF", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "电容放电→电流给电感充磁→磁场反过来又给电容充电……能量在电场和磁场间来回倒，永不停（无电阻时）。q 最大时 i 为零，正好差 90°。（动画已放慢便于观察）")
        }
    }
}

// 33. 凸透镜成像
struct ConvexLensSimView: View {
    @State private var u: Double = 30    // 物距 cm
    @State private var f: Double = 12    // 焦距 cm
    private var isReal: Bool { u > f + 0.3 }
    private var v: Double { f * u / (u - f) }         // 像距（实像为正，虚像为负）
    private var mag: Double { abs(v) / u }

    var body: some View {
        SimPage(title: "凸透镜成像") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let cx = size.width * 0.5
                let scale = (size.width * 0.45) / 60   // 约 ±60cm 视野
                let h: CGFloat = 38                    // 物高（像素）
                // 主光轴
                var axis = Path(); axis.move(to: CGPoint(x: 8, y: midY)); axis.addLine(to: CGPoint(x: size.width - 8, y: midY))
                ctx.stroke(axis, with: .color(.secondary.opacity(0.4)), lineWidth: 1)
                // 透镜
                var lens = Path(); lens.move(to: CGPoint(x: cx, y: midY - h - 26)); lens.addLine(to: CGPoint(x: cx, y: midY + h + 26))
                ctx.stroke(lens, with: .color(.apexStarBlue), lineWidth: 3)
                // 焦点
                for sgn in [-1.0, 1.0] {
                    let fx = cx + CGFloat(sgn * f) * scale
                    SimDraw.dot(&ctx, at: CGPoint(x: fx, y: midY), r: 3, color: .apexGold)
                }
                // 物
                let objX = cx - CGFloat(u) * scale
                let objTop = CGPoint(x: objX, y: midY - h)
                SimDraw.arrow(&ctx, from: CGPoint(x: objX, y: midY), to: objTop, color: .apexEmerald, lineWidth: 2.5)
                // 像
                let imgX = cx + CGFloat(v) * scale
                let imgTopY = midY + CGFloat(h) * CGFloat(v / u)   // 实像倒立(在轴下)，虚像正立(轴上)
                let imgTop = CGPoint(x: imgX, y: imgTopY)
                let lensTop = CGPoint(x: cx, y: midY - h)
                // 光线1：平行入射 → 过(对侧)焦点
                SimDraw.arrow(&ctx, from: objTop, to: lensTop, color: .apexLava.opacity(0.8), lineWidth: 1.5)
                // 光线2：过光心直行
                if isReal {
                    var r1 = Path(); r1.move(to: lensTop); r1.addLine(to: imgTop)
                    ctx.stroke(r1, with: .color(.apexLava.opacity(0.8)), lineWidth: 1.5)
                    var r2 = Path(); r2.move(to: objTop); r2.addLine(to: imgTop)
                    ctx.stroke(r2, with: .color(.apexGold.opacity(0.8)), lineWidth: 1.5)
                    SimDraw.arrow(&ctx, from: CGPoint(x: imgX, y: midY), to: imgTop, color: .apexLava, lineWidth: 2.5)
                } else {
                    // 虚像：折射线发散，反向延长（虚线）交于同侧
                    var r1 = Path(); r1.move(to: lensTop)
                    let dir = CGPoint(x: lensTop.x - imgTop.x, y: lensTop.y - imgTop.y)
                    r1.addLine(to: CGPoint(x: lensTop.x + dir.x * 1.4, y: lensTop.y + dir.y * 1.4))
                    ctx.stroke(r1, with: .color(.apexLava.opacity(0.8)), lineWidth: 1.5)
                    var dash = Path(); dash.move(to: imgTop); dash.addLine(to: lensTop)
                    ctx.stroke(dash, with: .color(.apexLava.opacity(0.5)), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    var r2 = Path(); r2.move(to: objTop); r2.addLine(to: CGPoint(x: imgX + (cx - imgX) * 1.6, y: imgTopY + (midY - imgTopY) * 1.6))
                    ctx.stroke(r2, with: .color(.apexGold.opacity(0.8)), lineWidth: 1.5)
                    SimDraw.arrow(&ctx, from: CGPoint(x: imgX, y: midY), to: imgTop, color: .apexLava.opacity(0.7), lineWidth: 2.5)
                }
                ctx.draw(Text(isReal ? "实像 · 倒立" : "虚像 · 正立 · 放大")
                    .font(.caption).foregroundColor(isReal ? .apexLava : .apexEmerald),
                         at: CGPoint(x: size.width / 2, y: 14))
            }
            .simCanvas(height: 230, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "像距 v", value: isReal ? String(format: "%.1f cm", v) : String(format: "%.1f cm(虚)", -v), color: .apexLava)
                SimReadout(label: "放大率", value: String(format: "%.2f×", mag), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "物距 u", value: $u, range: 4...55, unit: "cm", accent: .apexEmerald, decimals: 0)
                SimSlider(label: "焦距 f", value: $f, range: 6...24, unit: "cm", accent: .apexStarBlue, decimals: 0)
            }.cardSurface()
            SimInsight(text: "u>2f 缩小倒立实像（照相机）；f<u<2f 放大倒立实像（投影仪）；u<f 放大正立虚像（放大镜）。拖物距越过焦点，像「翻」过来。")
        }
    }
}

// 34. 单缝衍射
struct SingleSlitSimView: View {
    @State private var a: Double = 2.0    // 缝宽 μm
    @State private var lambda: Double = 600  // 波长 nm
    // 第一暗纹 sinθ = λ/a
    private var firstMinSin: Double { (lambda * 1e-9) / (a * 1e-6) }

    var body: some View {
        SimPage(title: "单缝衍射") {
            Canvas { ctx, size in
                let color = wavelengthColor(lambda)
                let cx = size.width / 2
                // 中央亮纹半宽 ∝ λ/a，映射到像素
                let halfW = max(CGFloat(firstMinSin) * 520, 12)
                for px in stride(from: CGFloat(0), to: size.width, by: 2) {
                    let s = Double(px - cx) / Double(halfW)        // 归一化到第一暗纹=±1
                    let beta = Double.pi * s
                    let inten = abs(beta) < 1e-6 ? 1.0 : pow(sin(beta) / beta, 2)
                    ctx.fill(Path(CGRect(x: px, y: 24, width: 2, height: size.height - 74)),
                             with: .color(color.opacity(inten * 0.92 + 0.03)))
                }
                // 强度曲线
                let rect = CGRect(x: 0, y: size.height - 46, width: size.width, height: 30)
                var p = Path()
                for k in 0...160 {
                    let px = rect.minX + rect.width * CGFloat(k) / 160
                    let s = Double(px - cx) / Double(halfW)
                    let beta = Double.pi * s
                    let inten = abs(beta) < 1e-6 ? 1.0 : pow(sin(beta) / beta, 2)
                    let py = rect.maxY - rect.height * CGFloat(inten)
                    if k == 0 { p.move(to: CGPoint(x: px, y: py)) } else { p.addLine(to: CGPoint(x: px, y: py)) }
                }
                ctx.stroke(p, with: .color(.apexGold), lineWidth: 1.5)
            }
            .simCanvas(height: 200, tint: .apexMystery)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "缝宽 a", value: String(format: "%.1f μm", a), color: .apexStarBlue)
                SimReadout(label: "中央纹相对宽", value: String(format: "%.2f", firstMinSin * 100), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "缝宽 a", value: $a, range: 0.8...6, unit: "μm", accent: .apexStarBlue)
                SimSlider(label: "波长 λ", value: $lambda, range: 400...700, unit: "nm", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "缝越窄，中央亮纹反而越宽（sinθ=λ/a）——这是衍射的「越挤越散」。和双缝不同，单缝是一大坨亮中间夹着越来越暗的次级条纹。")
        }
    }

    private func wavelengthColor(_ nm: Double) -> Color {
        switch nm {
        case ..<450: return Color(red: 0.5, green: 0.3, blue: 1)
        case ..<500: return .blue
        case ..<570: return .green
        case ..<600: return .yellow
        case ..<650: return .orange
        default: return .red
        }
    }
}

// 35. 驻波（两端固定的弦）
struct StandingWaveSimView: View {
    @State private var harmonic: Double = 2   // 第 n 谐波
    @State private var running = true
    @State private var start = Date()

    var body: some View {
        SimPage(title: "驻波") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let n = max(Int(harmonic.rounded()), 1)
                    let left: CGFloat = 24, right = size.width - 24
                    let midY = size.height / 2
                    let amp = size.height * 0.32
                    let env = cos(2 * .pi * 1.0 * t)   // 时间因子
                    func y(_ x: CGFloat) -> CGFloat {
                        let frac = Double((x - left) / (right - left))
                        return midY - CGFloat(sin(Double(n) * .pi * frac)) * amp * CGFloat(env)
                    }
                    // 包络（上下虚线）
                    for sgn in [-1.0, 1.0] {
                        var e = Path()
                        for k in 0...120 {
                            let x = left + (right - left) * CGFloat(k) / 120
                            let frac = Double((x - left) / (right - left))
                            let yy = midY - CGFloat(sgn) * CGFloat(abs(sin(Double(n) * .pi * frac))) * amp
                            if k == 0 { e.move(to: CGPoint(x: x, y: yy)) } else { e.addLine(to: CGPoint(x: x, y: yy)) }
                        }
                        ctx.stroke(e, with: .color(.apexStarBlue.opacity(0.3)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    }
                    // 当前弦形
                    var wave = Path()
                    for k in 0...120 {
                        let x = left + (right - left) * CGFloat(k) / 120
                        if k == 0 { wave.move(to: CGPoint(x: x, y: y(x))) } else { wave.addLine(to: CGPoint(x: x, y: y(x))) }
                    }
                    ctx.stroke(wave, with: .color(.apexLava), lineWidth: 3)
                    // 节点（n+1 个）
                    for k in 0...n {
                        let x = left + (right - left) * CGFloat(k) / CGFloat(n)
                        SimDraw.dot(&ctx, at: CGPoint(x: x, y: midY), r: 4, color: .apexGold)
                    }
                    // 两端墙
                    for x in [left, right] {
                        var w = Path(); w.move(to: CGPoint(x: x, y: midY - amp - 8)); w.addLine(to: CGPoint(x: x, y: midY + amp + 8))
                        ctx.stroke(w, with: .color(.secondary), lineWidth: 3)
                    }
                    ctx.draw(Text("第 \(n) 谐波 · \(n + 1) 个节点 · \(n) 个波腹").font(.caption).foregroundColor(.secondary),
                             at: CGPoint(x: size.width / 2, y: 14))
                }
            }
            .simCanvas(height: 220, tint: .apexLava)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            SimSlider(label: "谐波 n", value: $harmonic, range: 1...5, unit: "", accent: .apexLava, decimals: 0).cardSurface()
            SimInsight(text: "两列反向波叠加，节点（金点）永远不动、波腹拼命摇。弦长必须是半波长的整数倍 L=n·λ/2，所以吉他弦只能发出特定几个音。")
        }
    }
}

// 36. 多普勒效应
struct DopplerSimView: View {
    @State private var srcSpeed: Double = 0.4   // 声源速度（马赫数 v/c）
    @State private var running = true
    @State private var start = Date()
    private let c = 1.0   // 归一化声速

    var body: some View {
        SimPage(title: "多普勒效应") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let now = tl.date.timeIntervalSince(start)
                    let midY = size.height / 2
                    let pxPerUnit = size.width * 0.18      // 速度/半径的像素映射
                    let period = 0.5                       // 每 0.5s 发一个波前
                    let x0 = size.width * 0.18
                    // 声源当前位置（循环回绕）
                    let travel = srcSpeed * pxPerUnit * now
                    let span = size.width * 0.64
                    let srcX = x0 + CGFloat(travel.truncatingRemainder(dividingBy: Double(span)))
                    // 画出最近若干波前
                    let kNow = Int(now / period)
                    for k in max(0, kNow - 7)...kNow {
                        let tEmit = Double(k) * period
                        let age = now - tEmit
                        let radius = CGFloat(c * pxPerUnit * age)
                        if radius < 4 || radius > size.width { continue }
                        let emitTravel = srcSpeed * pxPerUnit * tEmit
                        let ex = x0 + CGFloat(emitTravel.truncatingRemainder(dividingBy: Double(span)))
                        var circle = Path(); circle.addEllipse(in: CGRect(x: ex - radius, y: midY - radius, width: 2 * radius, height: 2 * radius))
                        ctx.stroke(circle, with: .color(.apexStarBlue.opacity(0.55)), lineWidth: 1.5)
                    }
                    // 声源
                    SimDraw.dot(&ctx, at: CGPoint(x: srcX, y: midY), r: 7, color: .apexLava)
                    SimDraw.arrow(&ctx, from: CGPoint(x: srcX, y: midY), to: CGPoint(x: srcX + 22, y: midY), color: .apexLava, lineWidth: 2)
                    // 前后观察者
                    ctx.draw(Text("👂").font(.title3), at: CGPoint(x: size.width - 20, y: midY))
                    ctx.draw(Text("👂").font(.title3), at: CGPoint(x: 16, y: midY))
                    ctx.draw(Text("前方：波被压密 → 音调变高").font(.caption2).foregroundColor(.apexDanger), at: CGPoint(x: size.width * 0.72, y: 16))
                    ctx.draw(Text("后方：波被拉疏 → 音调变低").font(.caption2).foregroundColor(.apexStarBlue), at: CGPoint(x: size.width * 0.28, y: size.height - 14))
                }
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "前方 f′/f", value: srcSpeed < 0.99 ? String(format: "%.2f", 1 / (1 - srcSpeed)) : "∞", color: .apexDanger)
                SimReadout(label: "后方 f′/f", value: String(format: "%.2f", 1 / (1 + srcSpeed)), color: .apexStarBlue)
            }
            SimSlider(label: "声源速度", value: $srcSpeed, range: 0...0.9, unit: "c", accent: .apexLava, decimals: 2).cardSurface()
            SimInsight(text: "声源追着自己发出的波跑，前方波前被挤密（频率升高）、后方被拉疏（频率降低）——救护车迎面来时尖、驶过去后闷，就是这个道理。")
        }
    }
}
