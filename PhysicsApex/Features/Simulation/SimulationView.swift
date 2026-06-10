import SwiftUI

// MARK: - 互动模拟沙盘（物理最大差异化）：可拖参数、实时演化、看见物理

struct SimulationHubView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                NavigationLink { ProjectileSimView() } label: {
                    simCard("抛体运动", "拖动初速、角度、重力，看轨迹实时变化", "scope", .apexLava, ready: true)
                }
                .buttonStyle(.plain)
                simCard("弹性碰撞", "调质量与速度，看碰撞前后动量如何守恒", "arrow.left.arrow.right", .apexStarBlue, ready: false)
                simCard("简谐振动", "改变振幅与劲度，看回复力与周期", "waveform.path", .apexEmerald, ready: false)
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
