import SwiftUI

// MARK: - SimKit：模拟沙盘共享组件（给 27 个扩充沙盘减负）

/// 页面骨架：ScrollView + 背景 + 标题。
struct SimPage<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) { content() }
                .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 参数滑块行。
struct SimSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var unit: String = ""
    var accent: Color = .apexLava
    var decimals: Int = 1

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Text(label).font(AppFont.caption).frame(width: 88, alignment: .leading)
            Slider(value: $value, in: range).tint(accent)
            Text("\(String(format: decimals == 0 ? "%.0f" : "%.1f", value)) \(unit)")
                .font(AppFont.chip).foregroundColor(accent)
                .frame(width: 64, alignment: .trailing)
        }
    }
}

/// 读数小方块。
struct SimReadout: View {
    let label: String
    let value: String
    var color: Color = .apexLava
    var body: some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.bigStat(16)).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity).padding(.vertical, Spacing.sm)
        .background(color.opacity(0.08)).cornerRadius(Radius.inner)
    }
}

/// 醍醐灌顶提示条。
struct SimInsight: View {
    let text: String
    var body: some View {
        Label(text, systemImage: "lightbulb.fill")
            .font(AppFont.caption).foregroundColor(.apexGold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface()
    }
}

/// 画布通用镶边（统一高度/背景/圆角）。
struct SimCanvasStyle: ViewModifier {
    var height: CGFloat = 220
    var tint: Color = .apexStarBlue
    func body(content: Content) -> some View {
        content
            .frame(height: height)
            .background(LinearGradient(colors: [tint.opacity(0.12), Color.apexBackground],
                                       startPoint: .top, endPoint: .bottom))
            .cornerRadius(Radius.card)
    }
}

extension View {
    func simCanvas(height: CGFloat = 220, tint: Color = .apexStarBlue) -> some View {
        modifier(SimCanvasStyle(height: height, tint: tint))
    }
}

/// 重置/暂停角标。
struct SimChrome: View {
    @Binding var running: Bool
    var onReset: () -> Void
    var body: some View {
        HStack(spacing: 4) {
            Button(action: onReset) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.title2).foregroundColor(.apexLava)
            }
            Button { running.toggle() } label: {
                Image(systemName: running ? "pause.circle.fill" : "play.circle.fill")
                    .font(.title2).foregroundColor(.apexEmerald)
            }
        }
        .padding(8)
    }
}

// MARK: - Canvas 小工具

enum SimDraw {
    /// 带箭头的矢量。
    static func arrow(_ ctx: inout GraphicsContext, from: CGPoint, to: CGPoint, color: Color, lineWidth: CGFloat = 2) {
        var p = Path(); p.move(to: from); p.addLine(to: to)
        ctx.stroke(p, with: .color(color), lineWidth: lineWidth)
        let ang = atan2(to.y - from.y, to.x - from.x)
        let l: CGFloat = 7
        var head = Path()
        head.move(to: to)
        head.addLine(to: CGPoint(x: to.x - l * cos(ang - 0.45), y: to.y - l * sin(ang - 0.45)))
        head.move(to: to)
        head.addLine(to: CGPoint(x: to.x - l * cos(ang + 0.45), y: to.y - l * sin(ang + 0.45)))
        ctx.stroke(head, with: .color(color), lineWidth: lineWidth)
    }

    /// 实心圆点。
    static func dot(_ ctx: inout GraphicsContext, at p: CGPoint, r: CGFloat, color: Color) {
        ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: 2 * r, height: 2 * r)),
                 with: .color(color))
    }

    /// 函数曲线：把 f 在 [x0,x1] 画到指定区域（y 自动按 yMax 缩放，区域底部为 0 或居中）。
    static func curve(_ ctx: inout GraphicsContext, in rect: CGRect,
                      x0: Double, x1: Double, yMin: Double, yMax: Double,
                      color: Color, lineWidth: CGFloat = 2, steps: Int = 100,
                      f: (Double) -> Double) {
        guard yMax > yMin else { return }
        var path = Path()
        for i in 0...steps {
            let x = x0 + (x1 - x0) * Double(i) / Double(steps)
            let y = f(x)
            let px = rect.minX + rect.width * CGFloat(i) / CGFloat(steps)
            let frac = (y - yMin) / (yMax - yMin)
            let py = rect.maxY - rect.height * CGFloat(min(max(frac, 0), 1))
            if i == 0 { path.move(to: CGPoint(x: px, y: py)) } else { path.addLine(to: CGPoint(x: px, y: py)) }
        }
        ctx.stroke(path, with: .color(color), lineWidth: lineWidth)
    }
}
