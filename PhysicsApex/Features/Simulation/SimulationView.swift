import SwiftUI

// MARK: - 互动模拟沙盘（物理最大差异化）：可拖参数、实时演化、看见物理

struct SimulationHubView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                groupLabel("力学")
                NavigationLink { ProjectileSimView() } label: {
                    simCard("抛体运动", "调初速、角度、重力，看轨迹与射程", "scope", .apexLava, ready: true)
                }.buttonStyle(.plain)
                NavigationLink { CircularMotionSimView() } label: {
                    simCard("圆周运动", "向心力 F=mv²/r，速度翻倍力变四倍", "arrow.clockwise.circle", .apexLava, ready: true)
                }.buttonStyle(.plain)
                NavigationLink { InclineSimView() } label: {
                    simCard("斜面受力", "受力分解 + 临界角 tanθ=μ，到底滑不滑", "triangle", .apexLava, ready: true)
                }.buttonStyle(.plain)
                NavigationLink { CollisionSimView() } label: {
                    simCard("弹性碰撞", "调质量与速度，看动量如何守恒", "arrow.left.arrow.right", .apexStarBlue, ready: true)
                }.buttonStyle(.plain)
                NavigationLink { SHMSimView() } label: {
                    simCard("简谐振动", "弹簧滑块 + 回复力 + 实时 x-t 曲线", "waveform.path", .apexEmerald, ready: true)
                }.buttonStyle(.plain)

                groupLabel("电学")
                NavigationLink { OhmSimView() } label: {
                    simCard("欧姆定律", "I=U/R，电子流动可视化，电阻翻倍电流减半", "bolt.horizontal.circle", .apexStarBlue, ready: true)
                }.buttonStyle(.plain)

                groupLabel("波动")
                NavigationLink { WaveSimView() } label: {
                    simCard("横波传播", "v=λf，红点只上下振动不随波前进", "waveform.path.ecg", .apexEmerald, ready: true)
                }.buttonStyle(.plain)
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("模拟沙盘")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("看得见的物理")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text("公式是抽象的，运动是直观的。拖一拖参数，物理自己演给你看。")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexEmerald, Color.apexStarBlue],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }

    private func groupLabel(_ text: String) -> some View {
        Text(text).font(AppFont.chip).foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, Spacing.sm)
    }

    private func simCard(_ title: String, _ desc: String, _ icon: String, _ color: Color, ready: Bool) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon).font(.title2).foregroundColor(color).frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(AppFont.cardTitle).foregroundColor(.primary)
                Text(desc).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer()
            if ready { Image(systemName: "chevron.right").foregroundColor(.secondary) }
            else { TagChip(text: "即将上线", color: .secondary) }
        }
        .cardSurface()
        .opacity(ready ? 1 : 0.6)
    }
}

// MARK: - 抛体运动沙盘

struct ProjectileSimView: View {
    @State private var v0: Double = 20      // 初速 m/s
    @State private var angleDeg: Double = 45 // 抛射角
    @State private var g: Double = 9.8       // 重力加速度
    @State private var running = true
    @State private var startDate = Date()

    private var angle: Double { angleDeg * .pi / 180 }
    private var flightTime: Double { g > 0 ? 2 * v0 * sin(angle) / g : 0 }
    private var range: Double { g > 0 ? v0 * v0 * sin(2 * angle) / g : 0 }
    private var maxHeight: Double { g > 0 ? pow(v0 * sin(angle), 2) / (2 * g) : 0 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvasCard
                readouts
                controls
                insight
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("抛体运动")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canvasCard: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: !running)) { timeline in
            Canvas { ctx, size in
                drawScene(ctx: &ctx, size: size, now: timeline.date)
            }
        }
        .frame(height: 240)
        .background(
            LinearGradient(colors: [Color.apexStarBlue.opacity(0.18), Color.apexBackground],
                           startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            Button { startDate = Date(); running = true } label: {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.title2).foregroundColor(.apexLava).padding(8)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button { running.toggle() } label: {
                Image(systemName: running ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2).foregroundColor(.apexEmerald).padding(8)
            }
        }
    }

    private func drawScene(ctx: inout GraphicsContext, size: CGSize, now: Date) {
        let margin: CGFloat = 16
        let worldW = max(range, 1) * 1.1
        let worldH = max(maxHeight, 1) * 1.25
        let scale = min((size.width - 2 * margin) / worldW, (size.height - 2 * margin) / worldH)
        let originX = margin
        let originY = size.height - margin
        func pt(_ x: Double, _ y: Double) -> CGPoint {
            CGPoint(x: originX + CGFloat(x) * scale, y: originY - CGFloat(y) * scale)
        }

        // 地面
        var ground = Path()
        ground.move(to: CGPoint(x: 0, y: originY))
        ground.addLine(to: CGPoint(x: size.width, y: originY))
        ctx.stroke(ground, with: .color(.secondary.opacity(0.5)), lineWidth: 1)

        // 轨迹曲线
        var path = Path()
        let steps = 80
        for i in 0...steps {
            let t = flightTime * Double(i) / Double(steps)
            let x = v0 * cos(angle) * t
            let y = v0 * sin(angle) * t - 0.5 * g * t * t
            let p = pt(x, max(0, y))
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        ctx.stroke(path, with: .color(.apexLava.opacity(0.5)),
                   style: StrokeStyle(lineWidth: 2, dash: [4, 3]))

        // 最高点标记
        let apex = pt(range / 2, maxHeight)
        ctx.fill(Path(ellipseIn: CGRect(x: apex.x - 2, y: apex.y - 2, width: 4, height: 4)),
                 with: .color(.apexGold))

        // 运动小球（按时间循环）
        let elapsed = now.timeIntervalSince(startDate)
        let t = flightTime > 0 ? elapsed.truncatingRemainder(dividingBy: flightTime) : 0
        let bx = v0 * cos(angle) * t
        let by = v0 * sin(angle) * t - 0.5 * g * t * t
        let ball = pt(bx, max(0, by))
        ctx.fill(Path(ellipseIn: CGRect(x: ball.x - 6, y: ball.y - 6, width: 12, height: 12)),
                 with: .color(.apexLava))

        // 速度矢量
        let vx = v0 * cos(angle)
        let vy = v0 * sin(angle) - g * t
        var vArrow = Path()
        vArrow.move(to: ball)
        vArrow.addLine(to: CGPoint(x: ball.x + CGFloat(vx) * scale * 0.25,
                                   y: ball.y - CGFloat(vy) * scale * 0.25))
        ctx.stroke(vArrow, with: .color(.apexEmerald), lineWidth: 2)
    }

    private var readouts: some View {
        HStack(spacing: Spacing.md) {
            readout("射程", String(format: "%.1f m", range), .apexLava)
            readout("最大高度", String(format: "%.1f m", maxHeight), .apexGold)
            readout("飞行时间", String(format: "%.1f s", flightTime), .apexStarBlue)
        }
    }

    private func readout(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.bigStat(18)).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.sm)
        .background(color.opacity(0.08))
        .cornerRadius(Radius.inner)
    }

    private var controls: some View {
        VStack(spacing: Spacing.md) {
            sliderRow("初速度 v₀", value: $v0, range: 5...35, unit: "m/s", accent: .apexLava)
            sliderRow("抛射角 θ", value: $angleDeg, range: 10...80, unit: "°", accent: .apexStarBlue)
            HStack {
                Text("重力 g").font(AppFont.body).frame(width: 70, alignment: .leading)
                Picker("g", selection: $g) {
                    Text("地球 9.8").tag(9.8)
                    Text("月球 1.6").tag(1.6)
                    Text("木星 24.8").tag(24.8)
                }
                .pickerStyle(.segmented)
            }
        }
        .cardSurface()
    }

    private func sliderRow(_ label: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String, accent: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(label).font(AppFont.body).frame(width: 70, alignment: .leading)
            Slider(value: value, in: range).tint(accent)
            Text("\(Int(value.wrappedValue)) \(unit)").font(AppFont.chip).foregroundColor(accent).frame(width: 52, alignment: .trailing)
        }
    }

    private var insight: some View {
        Label("试试把角度调到 45°——同样的初速，射程最大。这是抛体运动的经典对称结论。",
              systemImage: "lightbulb.fill")
            .font(AppFont.caption).foregroundColor(.apexGold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface()
    }
}

// MARK: - 弹性碰撞沙盘（看动量守恒）

struct CollisionSimView: View {
    @State private var m1: Double = 2
    @State private var m2: Double = 1
    @State private var v1: Double = 3
    @State private var v2: Double = -2
    @State private var x1: Double = 2.5
    @State private var x2: Double = 7.5
    @State private var running = true

    private let trackLen: Double = 10
    private let timer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()

    private func radius(_ m: Double) -> Double { 0.25 + 0.12 * sqrt(m) }
    private var totalP: Double { m1 * v1 + m2 * v2 }
    private var totalKE: Double { 0.5 * m1 * v1 * v1 + 0.5 * m2 * v2 * v2 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvasCard
                readouts
                controls
                insight
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("弹性碰撞")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { _ in if running { step() } }
    }

    private func step() {
        let dt = 1.0 / 60.0
        x1 += v1 * dt
        x2 += v2 * dt
        let r1 = radius(m1), r2 = radius(m2)
        // 墙反弹
        if x1 < r1 { x1 = r1; v1 = abs(v1) }
        if x1 > trackLen - r1 { x1 = trackLen - r1; v1 = -abs(v1) }
        if x2 < r2 { x2 = r2; v2 = abs(v2) }
        if x2 > trackLen - r2 { x2 = trackLen - r2; v2 = -abs(v2) }
        // 小球弹性碰撞
        if x2 - x1 < r1 + r2 && v1 > v2 {
            let nv1 = ((m1 - m2) * v1 + 2 * m2 * v2) / (m1 + m2)
            let nv2 = ((m2 - m1) * v2 + 2 * m1 * v1) / (m1 + m2)
            v1 = nv1; v2 = nv2
            let overlap = (r1 + r2) - (x2 - x1)
            x1 -= overlap / 2; x2 += overlap / 2
        }
    }

    private var canvasCard: some View {
        Canvas { ctx, size in
            let margin: CGFloat = 16
            let scale = (size.width - 2 * margin) / CGFloat(trackLen)
            let midY = size.height / 2
            func sx(_ x: Double) -> CGFloat { margin + CGFloat(x) * scale }
            // 轨道
            var track = Path()
            track.move(to: CGPoint(x: margin, y: midY))
            track.addLine(to: CGPoint(x: size.width - margin, y: midY))
            ctx.stroke(track, with: .color(.secondary.opacity(0.4)), lineWidth: 1)
            // 两球
            func drawBall(_ x: Double, _ m: Double, _ color: Color) {
                let rpx = CGFloat(radius(m)) * scale
                let c = CGRect(x: sx(x) - rpx, y: midY - rpx, width: 2 * rpx, height: 2 * rpx)
                ctx.fill(Path(ellipseIn: c), with: .color(color))
            }
            drawBall(x1, m1, .apexLava)
            drawBall(x2, m2, .apexStarBlue)
        }
        .frame(height: 160)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.12), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .bottomTrailing) {
            HStack(spacing: 4) {
                Button { reset() } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava) }
                Button { running.toggle() } label: { Image(systemName: running ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald) }
            }
            .padding(8)
        }
    }

    private func reset() { x1 = 2.5; x2 = 7.5; v1 = 3; v2 = -2; running = true }

    private var readouts: some View {
        HStack(spacing: Spacing.md) {
            readoutBox("总动量 p", String(format: "%.1f", totalP), .apexEmerald, hint: "始终不变")
            readoutBox("总动能", String(format: "%.1f J", totalKE), .apexGold, hint: "弹性守恒")
        }
    }

    private var controls: some View {
        VStack(spacing: Spacing.md) {
            sRow("红球质量 m₁", $m1, 1...5, "kg", .apexLava)
            sRow("蓝球质量 m₂", $m2, 1...5, "kg", .apexStarBlue)
            sRow("红球速度 v₁", $v1, -5...5, "m/s", .apexLava)
            sRow("蓝球速度 v₂", $v2, -5...5, "m/s", .apexStarBlue)
        }
        .cardSurface()
    }

    private var insight: some View {
        Label("让两球质量相等试试——碰撞后它们会交换速度。无论怎么碰，总动量纹丝不动。",
              systemImage: "lightbulb.fill")
            .font(AppFont.caption).foregroundColor(.apexGold)
            .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
    }

    private func sRow(_ label: String, _ value: Binding<Double>, _ range: ClosedRange<Double>, _ unit: String, _ accent: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(label).font(AppFont.caption).frame(width: 86, alignment: .leading)
            Slider(value: value, in: range, step: range.lowerBound < 0 ? 0.5 : 1).tint(accent)
            Text("\(value.wrappedValue, specifier: "%.1f") \(unit)").font(AppFont.chip).foregroundColor(accent).frame(width: 60, alignment: .trailing)
        }
    }

    private func readoutBox(_ label: String, _ value: String, _ color: Color, hint: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.bigStat(18)).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
            Text(hint).font(.system(size: 9)).foregroundColor(color)
        }
        .frame(maxWidth: .infinity).padding(.vertical, Spacing.sm)
        .background(color.opacity(0.08)).cornerRadius(Radius.inner)
    }
}

// MARK: - 简谐振动沙盘（看回复力与周期）

struct SHMSimView: View {
    @State private var amplitude: Double = 1.5  // 振幅 m
    @State private var k: Double = 20           // 劲度 N/m
    @State private var mass: Double = 1         // 质量 kg
    @State private var running = true
    @State private var startDate = Date()

    private var omega: Double { sqrt(k / mass) }
    private var period: Double { 2 * .pi / omega }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvasCard
                readouts
                controls
                insight
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("简谐振动")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var canvasCard: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: !running)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSince(startDate)
                let x = amplitude * cos(omega * t)               // 位移
                let v = -amplitude * omega * sin(omega * t)       // 速度
                let margin: CGFloat = 24
                let midY = size.height * 0.42
                let centerX = size.width / 2
                let scale = (size.width / 2 - margin - 40) / CGFloat(max(amplitude, 0.1))
                let blockX = centerX + CGFloat(x) * scale

                // 平衡位置虚线
                var eq = Path(); eq.move(to: CGPoint(x: centerX, y: midY - 40)); eq.addLine(to: CGPoint(x: centerX, y: midY + 40))
                ctx.stroke(eq, with: .color(.secondary.opacity(0.4)), style: StrokeStyle(lineWidth: 1, dash: [3, 3]))

                // 弹簧（折线）
                var spring = Path()
                let wallX: CGFloat = margin
                spring.move(to: CGPoint(x: wallX, y: midY))
                let coils = 12
                for i in 0...coils {
                    let fx = wallX + (blockX - wallX) * CGFloat(i) / CGFloat(coils)
                    let fy = midY + (i % 2 == 0 ? -8 : 8)
                    spring.addLine(to: CGPoint(x: fx, y: i == coils ? midY : CGFloat(fy)))
                }
                ctx.stroke(spring, with: .color(.apexEmerald), lineWidth: 2)
                // 墙
                var wall = Path(); wall.move(to: CGPoint(x: wallX, y: midY - 30)); wall.addLine(to: CGPoint(x: wallX, y: midY + 30))
                ctx.stroke(wall, with: .color(.secondary), lineWidth: 3)
                // 滑块
                let bs: CGFloat = 34
                ctx.fill(Path(roundedRect: CGRect(x: blockX - bs/2, y: midY - bs/2, width: bs, height: bs), cornerRadius: 6), with: .color(.apexLava))

                // 回复力矢量（指向平衡位置）
                var force = Path()
                force.move(to: CGPoint(x: blockX, y: midY + 30))
                force.addLine(to: CGPoint(x: blockX - CGFloat(k * x) * scale * 0.012, y: midY + 30))
                ctx.stroke(force, with: .color(.apexDanger), lineWidth: 3)

                // x-t 曲线
                let graphTop = size.height * 0.72
                let graphH: CGFloat = size.height * 0.22
                var axis = Path(); axis.move(to: CGPoint(x: margin, y: graphTop)); axis.addLine(to: CGPoint(x: size.width - margin, y: graphTop))
                ctx.stroke(axis, with: .color(.secondary.opacity(0.3)), lineWidth: 1)
                var curve = Path()
                let span = max(period * 1.6, 0.1)
                for i in 0...120 {
                    let tt = t - span + span * Double(i) / 120.0
                    let xx = amplitude * cos(omega * tt)
                    let px = margin + (size.width - 2 * margin) * CGFloat(i) / 120.0
                    let py = graphTop - CGFloat(xx / max(amplitude, 0.1)) * graphH
                    if i == 0 { curve.move(to: CGPoint(x: px, y: py)) } else { curve.addLine(to: CGPoint(x: px, y: py)) }
                }
                ctx.stroke(curve, with: .color(.apexStarBlue), lineWidth: 2)
                _ = v
            }
        }
        .frame(height: 260)
        .background(LinearGradient(colors: [Color.apexEmerald.opacity(0.10), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Button { startDate = Date(); running = true } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava) }
                Button { running.toggle() } label: { Image(systemName: running ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald) }
            }
            .padding(8)
        }
    }

    private var readouts: some View {
        HStack(spacing: Spacing.md) {
            box("周期 T", String(format: "%.2f s", period), .apexStarBlue)
            box("频率 f", String(format: "%.2f Hz", 1 / period), .apexEmerald)
            box("角频率 ω", String(format: "%.2f", omega), .apexGold)
        }
    }

    private var controls: some View {
        VStack(spacing: Spacing.md) {
            sRow("振幅 A", $amplitude, 0.5...2.5, "m", .apexLava)
            sRow("劲度 k", $k, 5...60, "N/m", .apexEmerald)
            sRow("质量 m", $mass, 0.5...4, "kg", .apexStarBlue)
        }
        .cardSurface()
    }

    private var insight: some View {
        Label("改变振幅，周期竟然不变！周期只由 k 和 m 决定：T = 2π√(m/k)——这是简谐运动最反直觉的性质。",
              systemImage: "lightbulb.fill")
            .font(AppFont.caption).foregroundColor(.apexGold)
            .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
    }

    private func sRow(_ label: String, _ value: Binding<Double>, _ range: ClosedRange<Double>, _ unit: String, _ accent: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(label).font(AppFont.caption).frame(width: 64, alignment: .leading)
            Slider(value: value, in: range).tint(accent)
            Text("\(value.wrappedValue, specifier: "%.1f") \(unit)").font(AppFont.chip).foregroundColor(accent).frame(width: 60, alignment: .trailing)
        }
    }

    private func box(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.bigStat(16)).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, Spacing.sm)
        .background(color.opacity(0.08)).cornerRadius(Radius.inner)
    }
}
