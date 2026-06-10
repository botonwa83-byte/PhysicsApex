import SwiftUI

// MARK: - 单摆沙盘（T=2π√(L/g)，振幅不影响周期）

struct PendulumSimView: View {
    @State private var length: Double = 1.0
    @State private var ampDeg: Double = 20
    @State private var running = true
    @State private var startDate = Date()

    private let g = 9.8
    private var omega: Double { sqrt(g / length) }
    private var period: Double { 2 * .pi / omega }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("周期 T", String(format: "%.2f s", period), .apexStarBlue)
                    simReadout("频率 f", String(format: "%.2f Hz", 1/period), .apexEmerald)
                }
                VStack(spacing: Spacing.md) {
                    simSlider("摆长 L", $length, 0.4...2.0, "m", .apexLava)
                    simSlider("振幅 θ", $ampDeg, 5...35, "°", .apexStarBlue)
                }.cardSurface()
                Label("改变振幅，周期纹丝不动！周期只由摆长和重力决定：T=2π√(L/g)——伽利略看吊灯发现的等时性。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("单摆").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let t = tl.date.timeIntervalSince(startDate)
                let theta = (ampDeg * .pi / 180) * cos(omega * t)
                let cx = size.width / 2, topY: CGFloat = 24
                let scale = (size.height - 70) / 2.0
                let lpx = CGFloat(length) * scale
                let bob = CGPoint(x: cx + lpx * CGFloat(sin(theta)), y: topY + lpx * CGFloat(cos(theta)))
                // 悬点
                ctx.fill(Path(ellipseIn: CGRect(x: cx-3, y: topY-3, width: 6, height: 6)), with: .color(.secondary))
                // 摆线
                var line = Path(); line.move(to: CGPoint(x: cx, y: topY)); line.addLine(to: bob)
                ctx.stroke(line, with: .color(.secondary.opacity(0.6)), lineWidth: 1.5)
                // 竖直参考线
                var ref = Path(); ref.move(to: CGPoint(x: cx, y: topY)); ref.addLine(to: CGPoint(x: cx, y: topY + lpx))
                ctx.stroke(ref, with: .color(.secondary.opacity(0.25)), style: StrokeStyle(lineWidth: 1, dash: [3,3]))
                // 摆球
                ctx.fill(Path(ellipseIn: CGRect(x: bob.x-12, y: bob.y-12, width: 24, height: 24)), with: .color(.apexLava))
            }
        }
        .frame(height: 240)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.10), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Button { startDate = Date(); running = true } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava) }
                Button { running.toggle() } label: { Image(systemName: running ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald) }
            }.padding(8)
        }
    }
}

// MARK: - 电磁感应沙盘（E=BLv，安培力阻碍运动）

struct InductionSimView: View {
    @State private var B: Double = 0.5
    @State private var L: Double = 0.6
    @State private var v: Double = 3
    @State private var R: Double = 2
    @State private var running = true
    @State private var startDate = Date()

    private var emf: Double { B * L * v }
    private var current: Double { emf / R }
    private var force: Double { B * current * L }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("电动势 E", String(format: "%.2f V", emf), .apexLava)
                    simReadout("电流 I", String(format: "%.2f A", current), .apexStarBlue)
                    simReadout("安培力 F", String(format: "%.2f N", force), .apexDanger)
                }
                VStack(spacing: Spacing.md) {
                    simSlider("磁感应强度 B", $B, 0.2...1.0, "T", .apexLava)
                    simSlider("棒速度 v", $v, 1...6, "m/s", .apexStarBlue)
                    simSlider("回路电阻 R", $R, 1...10, "Ω", .apexEmerald)
                }.cardSurface()
                Label("棒动得越快，电动势 E=BLv 越大；而感应电流产生的安培力（红箭头）总是阻碍棒的运动——能量从动能变成了电能。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("电磁感应").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        TimelineView(.animation(minimumInterval: 1.0/60.0, paused: !running)) { tl in
            Canvas { ctx, size in
                let m: CGFloat = 30
                let topR = m + 20, botR = size.height - m - 20
                let leftX = m, rightX = size.width - m
                // 导轨
                for y in [topR, botR] {
                    var p = Path(); p.move(to: CGPoint(x: leftX, y: y)); p.addLine(to: CGPoint(x: rightX, y: y))
                    ctx.stroke(p, with: .color(.secondary.opacity(0.6)), lineWidth: 2)
                }
                // 左端电阻
                var rp = Path(); rp.move(to: CGPoint(x: leftX, y: topR)); rp.addLine(to: CGPoint(x: leftX, y: botR))
                ctx.stroke(rp, with: .color(.apexEmerald), lineWidth: 3)
                // 磁场（× 表示进入纸面）
                ctx.opacity = 0.35
                let cols = 6, rows = 3
                for i in 0..<cols { for j in 0..<rows {
                    let x = leftX + 40 + CGFloat(i)*((rightX-leftX-60)/CGFloat(cols))
                    let y = topR + 14 + CGFloat(j)*((botR-topR-20)/CGFloat(rows))
                    ctx.draw(Text("×").font(.system(size: 12)).foregroundColor(.apexStarBlue), at: CGPoint(x: x, y: y))
                }}
                ctx.opacity = 1
                // 滑动棒
                let span = Double(rightX - leftX - 80)
                let barX = leftX + 40 + CGFloat((v * tl.date.timeIntervalSince(startDate) * 30).truncatingRemainder(dividingBy: span))
                var bar = Path(); bar.move(to: CGPoint(x: barX, y: topR)); bar.addLine(to: CGPoint(x: barX, y: botR))
                ctx.stroke(bar, with: .color(.apexLava), lineWidth: 4)
                // 速度箭头（向右）
                var vArr = Path(); vArr.move(to: CGPoint(x: barX, y: (topR+botR)/2)); vArr.addLine(to: CGPoint(x: barX+CGFloat(v)*8, y: (topR+botR)/2))
                ctx.stroke(vArr, with: .color(.apexStarBlue), lineWidth: 2)
                // 安培力箭头（向左，阻碍）
                var fArr = Path(); fArr.move(to: CGPoint(x: barX, y: (topR+botR)/2 - 18)); fArr.addLine(to: CGPoint(x: barX-CGFloat(force)*14, y: (topR+botR)/2 - 18))
                ctx.stroke(fArr, with: .color(.apexDanger), lineWidth: 2.5)
            }
        }
        .frame(height: 200)
        .background(LinearGradient(colors: [Color.apexStarBlue.opacity(0.10), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
        .overlay(alignment: .topTrailing) {
            HStack(spacing: 4) {
                Button { startDate = Date(); running = true } label: { Image(systemName: "arrow.counterclockwise.circle.fill").font(.title2).foregroundColor(.apexLava) }
                Button { running.toggle() } label: { Image(systemName: running ? "pause.circle.fill" : "play.circle.fill").font(.title2).foregroundColor(.apexEmerald) }
            }.padding(8)
        }
    }
}

// MARK: - 折射光路沙盘（n=sinθ₁/sinθ₂，超过临界角全反射）

struct RefractionSimView: View {
    @State private var incidenceDeg: Double = 30
    @State private var n: Double = 1.5

    private var criticalDeg: Double { asin(1/n) * 180 / .pi }
    private var isTotal: Bool { n * sin(incidenceDeg * .pi/180) > 1 }
    private var refractDeg: Double { isTotal ? 0 : asin(n * sin(incidenceDeg * .pi/180)) * 180 / .pi }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                canvas
                HStack(spacing: Spacing.md) {
                    simReadout("折射角", isTotal ? "全反射" : String(format: "%.0f°", refractDeg), isTotal ? .apexDanger : .apexEmerald)
                    simReadout("临界角", String(format: "%.0f°", criticalDeg), .apexGold)
                }
                VStack(spacing: Spacing.md) {
                    simSlider("入射角", $incidenceDeg, 0...89, "°", .apexLava)
                    simSlider("折射率 n", $n, 1.1...2.5, "", .apexStarBlue)
                }.cardSurface()
                Label("光从介质射向空气：入射角超过临界角 C（sinC=1/n）时，光全部被反射回来——光纤通信正是靠它锁住光。",
                      systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("折射光路").navigationBarTitleDisplayMode(.inline)
    }

    private var canvas: some View {
        Canvas { ctx, size in
            let cx = size.width/2, cy = size.height/2
            let i = incidenceDeg * .pi/180
            // 介质（下半，淡色）
            ctx.fill(Path(CGRect(x: 0, y: cy, width: size.width, height: cy)), with: .color(.apexStarBlue.opacity(0.10)))
            // 界面线
            var iface = Path(); iface.move(to: CGPoint(x: 0, y: cy)); iface.addLine(to: CGPoint(x: size.width, y: cy))
            ctx.stroke(iface, with: .color(.secondary.opacity(0.6)), lineWidth: 1.5)
            // 法线
            var normal = Path(); normal.move(to: CGPoint(x: cx, y: cy-90)); normal.addLine(to: CGPoint(x: cx, y: cy+90))
            ctx.stroke(normal, with: .color(.secondary.opacity(0.4)), style: StrokeStyle(lineWidth: 1, dash: [4,4]))
            let len: CGFloat = 120
            let o = CGPoint(x: cx, y: cy)
            // 入射光线（从介质里、左下射向界面）
            let inStart = CGPoint(x: cx - len*CGFloat(sin(i)), y: cy + len*CGFloat(cos(i)))
            var inc = Path(); inc.move(to: inStart); inc.addLine(to: o)
            ctx.stroke(inc, with: .color(.apexLava), lineWidth: 2.5)
            if isTotal {
                // 全反射：反射回介质（右下）
                let refl = CGPoint(x: cx + len*CGFloat(sin(i)), y: cy + len*CGFloat(cos(i)))
                var rp = Path(); rp.move(to: o); rp.addLine(to: refl)
                ctx.stroke(rp, with: .color(.apexDanger), lineWidth: 2.5)
                ctx.draw(Text("全反射").font(.caption.bold()).foregroundColor(.apexDanger), at: CGPoint(x: cx + 50, y: cy + 70))
            } else {
                // 折射进空气（右上，偏离法线）
                let r = asin(n * sin(i))
                let refr = CGPoint(x: cx + len*CGFloat(sin(r)), y: cy - len*CGFloat(cos(r)))
                var rp = Path(); rp.move(to: o); rp.addLine(to: refr)
                ctx.stroke(rp, with: .color(.apexEmerald), lineWidth: 2.5)
                // 微弱反射线
                let refl = CGPoint(x: cx + len*0.6*CGFloat(sin(i)), y: cy + len*0.6*CGFloat(cos(i)))
                var rfp = Path(); rfp.move(to: o); rfp.addLine(to: refl)
                ctx.stroke(rfp, with: .color(.apexDanger.opacity(0.4)), lineWidth: 1.5)
            }
            ctx.draw(Text("空气").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: 30, y: cy-12))
            ctx.draw(Text("介质 n").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: 34, y: cy+14))
        }
        .frame(height: 240)
        .background(LinearGradient(colors: [Color.apexEmerald.opacity(0.06), Color.apexBackground], startPoint: .top, endPoint: .bottom))
        .cornerRadius(Radius.card)
    }
}
