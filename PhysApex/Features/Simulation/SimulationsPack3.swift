import SwiftUI

// MARK: - 沙盘扩充包 3：电磁进阶（9 个）

// 10. 库仑力
struct CoulombSimView: View {
    @State private var q1: Double = 2
    @State private var q2: Double = 3
    @State private var r: Double = 0.3
    private var force: Double { 9e9 * q1 * 1e-6 * q2 * 1e-6 / (r * r) }

    var body: some View {
        SimPage(title: "库仑力") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let scale = (size.width - 120) / 1.0
                let x1 = size.width / 2 - CGFloat(r / 2) * scale
                let x2 = size.width / 2 + CGFloat(r / 2) * scale
                SimDraw.dot(&ctx, at: CGPoint(x: x1, y: midY), r: 10 + CGFloat(q1), color: .apexLava)
                SimDraw.dot(&ctx, at: CGPoint(x: x2, y: midY), r: 10 + CGFloat(q2), color: .apexStarBlue)
                let fLen = CGFloat(min(force * 8, 70)) + 14
                SimDraw.arrow(&ctx, from: CGPoint(x: x1, y: midY), to: CGPoint(x: x1 - fLen, y: midY), color: .apexGold, lineWidth: 3)
                SimDraw.arrow(&ctx, from: CGPoint(x: x2, y: midY), to: CGPoint(x: x2 + fLen, y: midY), color: .apexGold, lineWidth: 3)
                ctx.draw(Text("+q₁").font(.caption2).foregroundColor(.white), at: CGPoint(x: x1, y: midY))
                ctx.draw(Text("+q₂").font(.caption2).foregroundColor(.white), at: CGPoint(x: x2, y: midY))
            }
            .simCanvas(height: 150, tint: .apexLava)
            SimReadout(label: "库仑力 F = kq₁q₂/r²", value: String(format: "%.2f N", force), color: .apexGold)
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电荷 q₁", value: $q1, range: 1...6, unit: "μC", accent: .apexLava)
                SimSlider(label: "电荷 q₂", value: $q2, range: 1...6, unit: "μC", accent: .apexStarBlue)
                SimSlider(label: "距离 r", value: $r, range: 0.1...0.9, unit: "m", accent: .apexEmerald)
            }.cardSurface()
            SimInsight(text: "把距离缩一半，力变四倍——平方反比的厉害之处。两个箭头永远等长：作用力与反作用力。")
        }
    }
}

// 11. 电场偏转（类平抛）
struct EFieldDeflectSimView: View {
    @State private var u: Double = 200
    @State private var v0: Double = 4e6
    private let plateLen = 0.1, plateGap = 0.02, q = 1.6e-19, m = 9.1e-31
    private var aField: Double { q * u / plateGap / m }
    private var tIn: Double { plateLen / v0 }
    private var deflect: Double { 0.5 * aField * tIn * tIn }

    var body: some View {
        SimPage(title: "电场偏转") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let px0: CGFloat = 40, px1 = size.width - 70
                // 两块极板
                for dy in [-40.0, 40.0] {
                    var plate = Path(); plate.move(to: CGPoint(x: px0, y: midY + dy)); plate.addLine(to: CGPoint(x: px0 + (px1 - px0) * 0.55, y: midY + dy))
                    ctx.stroke(plate, with: .color(.secondary), lineWidth: 4)
                }
                // 轨迹：板内抛物线 + 板外直线
                let yScale = 36 / CGFloat(max(deflect, 1e-4))
                var traj = Path(); traj.move(to: CGPoint(x: 10, y: midY))
                traj.addLine(to: CGPoint(x: px0, y: midY))
                let inEnd = px0 + (px1 - px0) * 0.55
                for i in 0...30 {
                    let frac = Double(i) / 30
                    let x = px0 + (inEnd - px0) * CGFloat(frac)
                    let y = midY - CGFloat(deflect * frac * frac) * yScale
                    traj.addLine(to: CGPoint(x: x, y: y))
                }
                let exitSlope = 2 * deflect
                traj.addLine(to: CGPoint(x: px1 + 50, y: midY - CGFloat(deflect) * yScale - CGFloat(exitSlope) * yScale * (px1 + 50 - inEnd) / (inEnd - px0)))
                ctx.stroke(traj, with: .color(.apexLava), lineWidth: 2)
                ctx.draw(Text("U=\(Int(u)) V").font(.caption2).foregroundColor(.apexStarBlue), at: CGPoint(x: px0 + 50, y: midY + 56))
            }
            .simCanvas(height: 190, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "板内偏移", value: String(format: "%.2f mm", deflect * 1000), color: .apexLava)
                SimReadout(label: "出板速度角", value: String(format: "%.1f°", atan(aField * tIn / v0) * 180 / .pi), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "偏转电压 U", value: $u, range: 50...500, unit: "V", accent: .apexStarBlue, decimals: 0)
                SimSlider(label: "入射速度", value: $v0, range: 2e6...8e6, unit: "m/s", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "板内是「横过来的平抛」：水平匀速 + 竖直匀加速。出板后沿直线飞——反向延长恰好过板内位移的中点。")
        }
    }
}

// 12. 磁场圆周运动
struct CyclotronSimView: View {
    @State private var b: Double = 0.5
    @State private var v: Double = 3
    @State private var running = true
    @State private var start = Date()
    private let qm = 1.0   // q/m 归一化
    private var radius: Double { v / (qm * b) }
    private var period: Double { 2 * .pi / (qm * b) }

    var body: some View {
        SimPage(title: "磁场中的圆周") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let rpx = CGFloat(radius) * 16
                    // 磁场区（×符号）
                    for gx in stride(from: 24.0, to: size.width - 12, by: 36) {
                        for gy in stride(from: 24.0, to: size.height - 12, by: 36) {
                            ctx.draw(Text("×").font(.caption).foregroundColor(.secondary.opacity(0.45)), at: CGPoint(x: gx, y: gy))
                        }
                    }
                    var orbit = Path()
                    orbit.addEllipse(in: CGRect(x: center.x - rpx, y: center.y - rpx, width: 2 * rpx, height: 2 * rpx))
                    ctx.stroke(orbit, with: .color(.apexStarBlue.opacity(0.5)), style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                    let ang = 2 * .pi * t / period
                    let p = CGPoint(x: center.x + rpx * CGFloat(cos(ang)), y: center.y + rpx * CGFloat(sin(ang)))
                    SimDraw.dot(&ctx, at: p, r: 7, color: .apexLava)
                    SimDraw.arrow(&ctx, from: p, to: CGPoint(x: p.x - rpx * 0.5 * CGFloat(sin(ang)), y: p.y + rpx * 0.5 * CGFloat(cos(ang))), color: .apexEmerald)
                }
            }
            .simCanvas(height: 220, tint: .apexMystery)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            HStack(spacing: Spacing.md) {
                SimReadout(label: "半径 r=mv/qB", value: String(format: "%.1f", radius), color: .apexStarBlue)
                SimReadout(label: "周期 T=2πm/qB", value: String(format: "%.2f s", period), color: .apexGold)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "磁感应强度 B", value: $b, range: 0.2...1.5, unit: "T", accent: .apexMystery)
                SimSlider(label: "速度 v", value: $v, range: 1...6, unit: "", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "调大速度：圆变大，但转一圈的时间不变！周期只认 m、q、B——这就是回旋加速器能工作的根基。")
        }
    }
}

// 13. 速度选择器
struct VelocitySelectorSimView: View {
    @State private var e: Double = 200
    @State private var b: Double = 0.5
    @State private var v: Double = 400
    private var vSelect: Double { e / b }
    private var balanced: Bool { abs(v - vSelect) < 12 }

    var body: some View {
        SimPage(title: "速度选择器") {
            Canvas { ctx, size in
                let midY = size.height / 2
                for dy in [-44.0, 44.0] {
                    var plate = Path(); plate.move(to: CGPoint(x: 36, y: midY + dy)); plate.addLine(to: CGPoint(x: size.width - 36, y: midY + dy))
                    ctx.stroke(plate, with: .color(.secondary), lineWidth: 4)
                }
                for gx in stride(from: 56.0, to: size.width - 50, by: 42) {
                    ctx.draw(Text("×").font(.caption).foregroundColor(.secondary.opacity(0.5)), at: CGPoint(x: gx, y: midY - 18))
                    ctx.draw(Text("×").font(.caption).foregroundColor(.secondary.opacity(0.5)), at: CGPoint(x: gx, y: midY + 18))
                }
                // 轨迹
                var traj = Path(); traj.move(to: CGPoint(x: 10, y: midY))
                if balanced {
                    traj.addLine(to: CGPoint(x: size.width - 10, y: midY))
                } else {
                    let bend: CGFloat = v > vSelect ? -1 : 1   // 磁场力占优向上/电场力占优向下（示意）
                    for i in 0...30 {
                        let frac = CGFloat(i) / 30
                        let x = 10 + (size.width - 20) * frac
                        traj.addLine(to: CGPoint(x: x, y: midY + bend * 40 * frac * frac))
                    }
                }
                ctx.stroke(traj, with: .color(balanced ? .apexEmerald : .apexLava), lineWidth: 2.5)
            }
            .simCanvas(height: 180, tint: .apexEmerald)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "选择速度 E/B", value: String(format: "%.0f m/s", vSelect), color: .apexGold)
                SimReadout(label: "当前粒子", value: balanced ? "直线通过 ✓" : "被偏走 ✗", color: balanced ? .apexEmerald : .apexDanger)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电场 E", value: $e, range: 100...400, unit: "V/m", accent: .apexStarBlue, decimals: 0)
                SimSlider(label: "磁场 B", value: $b, range: 0.2...1, unit: "T", accent: .apexMystery)
                SimSlider(label: "粒子速度 v", value: $v, range: 100...900, unit: "m/s", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "只有 v=E/B 的粒子能走直线——与电荷正负、电量、质量统统无关。试试调 v 偏离一点，立刻被甩出去。")
        }
    }
}

// 14. 闭合电路
struct ClosedCircuitSimView: View {
    @State private var emf: Double = 6
    @State private var rInt: Double = 0.5
    @State private var rExt: Double = 2.5
    private var current: Double { emf / (rExt + rInt) }
    private var uOut: Double { current * rExt }

    var body: some View {
        SimPage(title: "闭合电路") {
            Canvas { ctx, size in
                let rect = CGRect(x: 36, y: 20, width: size.width - 72, height: size.height - 56)
                SimDraw.curve(&ctx, in: rect, x0: 0.1, x1: 10, yMin: 0, yMax: emf * 1.05, color: .apexStarBlue) { emf * $0 / ($0 + rInt) }
                let px = rect.minX + rect.width * CGFloat((rExt - 0.1) / 9.9)
                let py = rect.maxY - rect.height * CGFloat(uOut / (emf * 1.05))
                SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 6, color: .apexLava)
                var top = Path(); top.move(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 1.05)); top.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - rect.height / 1.05))
                ctx.stroke(top, with: .color(.apexGold.opacity(0.6)), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                ctx.draw(Text("电动势 E（上限）").font(.caption2).foregroundColor(.apexGold), at: CGPoint(x: rect.midX, y: rect.maxY - rect.height / 1.05 - 10))
                ctx.draw(Text("路端电压 U—外阻 R 曲线").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: rect.midX, y: size.height - 14))
            }
            .simCanvas(height: 200, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "电流 I", value: String(format: "%.2f A", current), color: .apexLava)
                SimReadout(label: "路端电压 U", value: String(format: "%.2f V", uOut), color: .apexStarBlue)
                SimReadout(label: "内压 Ir", value: String(format: "%.2f V", current * rInt), color: .apexDanger)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "电动势 E", value: $emf, range: 3...12, unit: "V", accent: .apexGold)
                SimSlider(label: "内阻 r", value: $rInt, range: 0.1...2, unit: "Ω", accent: .apexDanger)
                SimSlider(label: "外阻 R", value: $rExt, range: 0.1...10, unit: "Ω", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "外阻越大，路端电压越贴近电动势；短路（R→0）时电压全被内阻吃光。E 永远是 U 的天花板。")
        }
    }
}

// 15. 电容器动态
struct CapacitorSimView: View {
    @State private var d: Double = 2          // 板距 mm
    @State private var connected = true       // 接电源 or 断开
    private let u0 = 100.0, c0 = 4.0          // d=2mm 时 C=4 单位
    private var cap: Double { c0 * 2 / d }
    private var q: Double { connected ? cap * u0 : c0 * u0 }   // 断开时按 d=2 的电荷锁定
    private var u: Double { connected ? u0 : q / cap }
    private var field: Double { u / d }

    var body: some View {
        SimPage(title: "电容器动态") {
            Canvas { ctx, size in
                let midX = size.width / 2
                let gap = CGFloat(d) * 14
                for sx in [midX - gap / 2, midX + gap / 2] {
                    var plate = Path(); plate.move(to: CGPoint(x: sx, y: 26)); plate.addLine(to: CGPoint(x: sx, y: size.height - 26))
                    ctx.stroke(plate, with: .color(.secondary), lineWidth: 6)
                }
                let lines = max(2, Int(field / 12))
                for i in 0..<lines {
                    let y = 36 + (size.height - 72) * CGFloat(i) / CGFloat(max(lines - 1, 1))
                    SimDraw.arrow(&ctx, from: CGPoint(x: midX - gap / 2 + 5, y: y), to: CGPoint(x: midX + gap / 2 - 5, y: y), color: .apexStarBlue.opacity(0.7), lineWidth: 1.5)
                }
                ctx.draw(Text(connected ? "已接电源（U 锁定）" : "已断开（Q 锁定）").font(.caption2).foregroundColor(.apexGold),
                         at: CGPoint(x: midX, y: 12))
            }
            .simCanvas(height: 190, tint: .apexStarBlue)
            Picker("状态", selection: $connected) {
                Text("接着电源").tag(true); Text("断开电源").tag(false)
            }.pickerStyle(.segmented)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "电压 U", value: String(format: "%.0f V", u), color: .apexStarBlue)
                SimReadout(label: "电荷 Q", value: String(format: "%.0f", q), color: .apexLava)
                SimReadout(label: "场强 E=U/d", value: String(format: "%.0f", field), color: .apexEmerald)
            }
            SimSlider(label: "板距 d", value: $d, range: 1...5, unit: "mm", accent: .apexMystery).cardSurface()
            SimInsight(text: "同样拉大板距：接电源时 Q 变小（U 锁定）；断电源时 U 变大、场强 E=Q/(εS) 竟然不变！「接 U 断 Q」亲手拖一次就懂。")
        }
    }
}

// 16. 楞次定律
struct LenzSimView: View {
    @State private var inserting = true
    @State private var running = true
    @State private var start = Date()

    var body: some View {
        SimPage(title: "楞次定律") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let cycle = 2.2
                    let frac = (t.truncatingRemainder(dividingBy: cycle)) / cycle
                    let midY = size.height / 2
                    // 线圈
                    let coilX = size.width * 0.66
                    for i in 0..<5 {
                        var ring = Path()
                        ring.addEllipse(in: CGRect(x: coilX + CGFloat(i) * 10 - 7, y: midY - 34, width: 14, height: 68))
                        ctx.stroke(ring, with: .color(.apexStarBlue), lineWidth: 2)
                    }
                    // 磁铁运动
                    let travel = size.width * 0.34
                    let magX = inserting ? 20 + travel * CGFloat(frac) : 20 + travel * CGFloat(1 - frac)
                    ctx.fill(Path(roundedRect: CGRect(x: magX, y: midY - 14, width: 64, height: 28), cornerRadius: 4), with: .color(.apexLava))
                    ctx.draw(Text("S    N").font(.system(size: 12, weight: .black)).foregroundColor(.white), at: CGPoint(x: magX + 32, y: midY))
                    // 感应电流方向提示（线圈端面）
                    let dirText = inserting ? "感应电流：使左端呈 N 极（拒）" : "感应电流：使左端呈 S 极（留）"
                    ctx.draw(Text(dirText).font(.caption2).foregroundColor(.apexEmerald), at: CGPoint(x: size.width / 2, y: size.height - 16))
                    // 斥/吸力箭头
                    let fDir: CGFloat = inserting ? -1 : 1
                    SimDraw.arrow(&ctx, from: CGPoint(x: magX + 32, y: midY - 26), to: CGPoint(x: magX + 32 + fDir * 30, y: midY - 26), color: .apexGold, lineWidth: 2.5)
                }
            }
            .simCanvas(height: 180, tint: .apexMystery)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            Picker("动作", selection: $inserting) {
                Text("N 极插入").tag(true); Text("N 极拔出").tag(false)
            }.pickerStyle(.segmented)
            SimInsight(text: "来拒去留：插入时线圈把磁铁往外推，拔出时又挽留它。金色箭头是磁铁受到的力——永远跟你对着干。")
        }
    }
}

// 17. 单杆切割发电
struct RailGenSimView: View {
    @State private var v: Double = 4
    @State private var b: Double = 0.4
    @State private var l: Double = 0.5
    @State private var r: Double = 2
    private var emf: Double { b * l * v }
    private var current: Double { emf / r }
    private var fAmp: Double { b * current * l }

    var body: some View {
        SimPage(title: "单杆切割发电") {
            Canvas { ctx, size in
                let railY1 = size.height * 0.3, railY2 = size.height * 0.7
                for y in [railY1, railY2] {
                    var rail = Path(); rail.move(to: CGPoint(x: 20, y: y)); rail.addLine(to: CGPoint(x: size.width - 20, y: y))
                    ctx.stroke(rail, with: .color(.secondary), lineWidth: 3)
                }
                for gx in stride(from: 36.0, to: size.width - 24, by: 40) {
                    ctx.draw(Text("×").font(.caption).foregroundColor(.secondary.opacity(0.5)), at: CGPoint(x: gx, y: (railY1 + railY2) / 2))
                }
                let barX = size.width * 0.55
                var bar = Path(); bar.move(to: CGPoint(x: barX, y: railY1)); bar.addLine(to: CGPoint(x: barX, y: railY2))
                ctx.stroke(bar, with: .color(.apexLava), lineWidth: 5)
                SimDraw.arrow(&ctx, from: CGPoint(x: barX, y: (railY1 + railY2) / 2), to: CGPoint(x: barX + CGFloat(v) * 12, y: (railY1 + railY2) / 2), color: .apexEmerald, lineWidth: 2.5)
                // 左端电阻
                ctx.fill(Path(roundedRect: CGRect(x: 14, y: (railY1 + railY2) / 2 - 16, width: 12, height: 32), cornerRadius: 3), with: .color(.apexStarBlue))
            }
            .simCanvas(height: 170, tint: .apexEmerald)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "电动势 BLv", value: String(format: "%.2f V", emf), color: .apexGold)
                SimReadout(label: "电流 I", value: String(format: "%.2f A", current), color: .apexStarBlue)
                SimReadout(label: "安培阻力", value: String(format: "%.3f N", fAmp), color: .apexDanger)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "杆速 v", value: $v, range: 1...8, unit: "m/s", accent: .apexEmerald)
                SimSlider(label: "磁场 B", value: $b, range: 0.1...1, unit: "T", accent: .apexMystery)
                SimSlider(label: "杆长 L", value: $l, range: 0.2...1, unit: "m", accent: .apexLava)
                SimSlider(label: "电阻 R", value: $r, range: 0.5...5, unit: "Ω", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "杆越快电动势越大，但电流一大，安培力这个「电磁刹车」也越狠——发电永远伴随阻力，能量不会白来。")
        }
    }
}

// 18. 理想变压器
struct TransformerSimView: View {
    @State private var ratio: Double = 2     // n1/n2
    @State private var rLoad: Double = 11
    private let u1 = 220.0
    private var u2: Double { u1 / ratio }
    private var i2: Double { u2 / rLoad }
    private var i1: Double { i2 / ratio }

    var body: some View {
        SimPage(title: "理想变压器") {
            Canvas { ctx, size in
                let midY = size.height / 2
                let coreX = size.width / 2
                // 铁芯
                ctx.stroke(Path(roundedRect: CGRect(x: coreX - 36, y: midY - 56, width: 72, height: 112), cornerRadius: 8), with: .color(.secondary), lineWidth: 8)
                // 原副线圈匝数示意
                let n1 = Int(4 * ratio), n2 = 4
                for i in 0..<n1 {
                    var loop = Path()
                    loop.addEllipse(in: CGRect(x: coreX - 52, y: midY - 44 + CGFloat(i) * CGFloat(88 / max(n1, 1)), width: 18, height: 10))
                    ctx.stroke(loop, with: .color(.apexLava), lineWidth: 2)
                }
                for i in 0..<n2 {
                    var loop = Path()
                    loop.addEllipse(in: CGRect(x: coreX + 34, y: midY - 36 + CGFloat(i) * 20, width: 18, height: 10))
                    ctx.stroke(loop, with: .color(.apexStarBlue), lineWidth: 2)
                }
                ctx.draw(Text("原边 220 V").font(.caption2).foregroundColor(.apexLava), at: CGPoint(x: coreX - 70, y: midY - 66))
                ctx.draw(Text(String(format: "副边 %.0f V", u2)).font(.caption2).foregroundColor(.apexStarBlue), at: CGPoint(x: coreX + 70, y: midY - 66))
            }
            .simCanvas(height: 180, tint: .apexGold)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "副边电压", value: String(format: "%.0f V", u2), color: .apexStarBlue)
                SimReadout(label: "副边电流", value: String(format: "%.1f A", i2), color: .apexEmerald)
                SimReadout(label: "原边电流", value: String(format: "%.1f A", i1), color: .apexLava)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "匝数比 n₁:n₂", value: $ratio, range: 0.5...5, unit: ": 1", accent: .apexGold)
                SimSlider(label: "负载电阻", value: $rLoad, range: 2...50, unit: "Ω", accent: .apexStarBlue, decimals: 0)
            }.cardSurface()
            SimInsight(text: "调小负载电阻：副边电流变大，原边电流跟着变大——电压由匝数比定，电流由负载「倒着」定，功率两边永远相等。")
        }
    }
}
