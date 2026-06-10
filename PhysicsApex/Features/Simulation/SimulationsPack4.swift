import SwiftUI

// MARK: - 沙盘扩充包 4：热 · 光 · 近代 · 波（9 个）

// 19. 等温压缩（玻意耳定律）
struct GasIsothermSimView: View {
    @State private var volume: Double = 5     // L
    private let pv = 10.0                      // p·V = 常数
    private var pressure: Double { pv / volume }

    var body: some View {
        SimPage(title: "等温压缩") {
            Canvas { ctx, size in
                // 气缸 + 活塞
                let cylX: CGFloat = 24, cylW = size.width * 0.42
                let cylRect = CGRect(x: cylX, y: 30, width: cylW, height: size.height - 70)
                ctx.stroke(Path(roundedRect: cylRect, cornerRadius: 6), with: .color(.secondary), lineWidth: 3)
                let pistonY = cylRect.minY + cylRect.height * CGFloat(1 - volume / 10)
                ctx.fill(Path(roundedRect: CGRect(x: cylX + 3, y: pistonY, width: cylW - 6, height: 10), cornerRadius: 3), with: .color(.apexLava))
                // 分子点（数量不变，越压越密）
                var seed: UInt64 = 7
                func rnd() -> CGFloat { seed = seed &* 6364136223846793005 &+ 1442695040888963407; return CGFloat((seed >> 33) % 1000) / 1000 }
                for _ in 0..<24 {
                    let x = cylX + 8 + (cylW - 16) * rnd()
                    let y = pistonY + 14 + (cylRect.maxY - pistonY - 20) * rnd()
                    SimDraw.dot(&ctx, at: CGPoint(x: x, y: y), r: 2.5, color: .apexStarBlue)
                }
                // p-V 等温线
                let rect = CGRect(x: size.width * 0.55, y: 30, width: size.width * 0.4, height: size.height - 70)
                SimDraw.curve(&ctx, in: rect, x0: 1, x1: 10, yMin: 0, yMax: pv, color: .apexEmerald) { pv / $0 }
                let px = rect.minX + rect.width * CGFloat((volume - 1) / 9)
                let py = rect.maxY - rect.height * CGFloat(pressure / pv)
                SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 5, color: .apexGold)
                ctx.draw(Text("p-V 等温线").font(.caption2).foregroundColor(.secondary), at: CGPoint(x: rect.midX, y: size.height - 18))
            }
            .simCanvas(height: 210, tint: .apexEmerald)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "体积 V", value: String(format: "%.1f L", volume), color: .apexStarBlue)
                SimReadout(label: "压强 p", value: String(format: "%.2f atm", pressure), color: .apexLava)
                SimReadout(label: "p×V", value: String(format: "%.1f（不变）", pressure * volume), color: .apexGold)
            }
            SimSlider(label: "压缩活塞", value: $volume, range: 1...10, unit: "L", accent: .apexLava).cardSurface()
            SimInsight(text: "体积压到一半，压强翻一倍，p×V 雷打不动——分子没变多，只是同样的「撞击」挤进了更小的房间。")
        }
    }
}

// 20. 分子力曲线
struct MolecularForceSimView: View {
    @State private var r: Double = 1.12   // r/r0
    private func ljForce(_ x: Double) -> Double {   // 简化 Lennard-Jones 形状
        24 * (2 * pow(x, -13) - pow(x, -7))
    }

    var body: some View {
        SimPage(title: "分子间作用力") {
            Canvas { ctx, size in
                let rect = CGRect(x: 30, y: 20, width: size.width - 60, height: size.height - 80)
                // 零线
                var zero = Path(); zero.move(to: CGPoint(x: rect.minX, y: rect.midY)); zero.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                ctx.stroke(zero, with: .color(.secondary.opacity(0.4)), lineWidth: 1)
                SimDraw.curve(&ctx, in: rect, x0: 0.95, x1: 2.5, yMin: -6, yMax: 6, color: .apexStarBlue) { min(max(self.ljForce($0), -6), 6) }
                let px = rect.minX + rect.width * CGFloat((r - 0.95) / 1.55)
                let fy = min(max(ljForce(r), -6), 6)
                let py = rect.maxY - rect.height * CGFloat((fy + 6) / 12)
                SimDraw.dot(&ctx, at: CGPoint(x: px, y: py), r: 6, color: .apexLava)
                // 两个分子示意
                let molY = size.height - 28
                let gap = CGFloat(r) * 56
                SimDraw.dot(&ctx, at: CGPoint(x: size.width / 2 - gap / 2, y: molY), r: 9, color: .apexEmerald)
                SimDraw.dot(&ctx, at: CGPoint(x: size.width / 2 + gap / 2, y: molY), r: 9, color: .apexEmerald)
            }
            .simCanvas(height: 210, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "间距 r/r₀", value: String(format: "%.2f", r), color: .apexEmerald)
                SimReadout(label: "合力", value: ljForce(r) > 0.2 ? "斥力" : (ljForce(r) < -0.2 ? "引力" : "≈0 平衡"), color: ljForce(r) > 0.2 ? .apexDanger : .apexStarBlue)
            }
            SimSlider(label: "分子间距", value: $r, range: 0.95...2.5, unit: "r₀", accent: .apexEmerald).cardSurface()
            SimInsight(text: "靠太近被狠狠推开（斥力陡增），拉远了又被轻轻拽回（引力）——分子像一对「若即若离」的伙伴，平衡距离就是 r₀。")
        }
    }
}

// 21. 折射与全反射
struct RefractionSimView: View {
    @State private var angleDeg: Double = 30
    @State private var n: Double = 1.5
    private var critical: Double { asin(1 / n) * 180 / .pi }
    private var totalReflect: Bool { angleDeg > critical }
    private var refractDeg: Double { totalReflect ? 90 : asin(n * sin(angleDeg * .pi / 180)) * 180 / .pi }

    var body: some View {
        SimPage(title: "折射与全反射") {
            Canvas { ctx, size in
                let o = CGPoint(x: size.width / 2, y: size.height / 2)
                // 介质分界面（下半为介质）
                ctx.fill(Path(CGRect(x: 0, y: o.y, width: size.width, height: size.height - o.y)), with: .color(.apexStarBlue.opacity(0.12)))
                var surf = Path(); surf.move(to: CGPoint(x: 0, y: o.y)); surf.addLine(to: CGPoint(x: size.width, y: o.y))
                ctx.stroke(surf, with: .color(.secondary), lineWidth: 2)
                var norm = Path(); norm.move(to: CGPoint(x: o.x, y: 16)); norm.addLine(to: CGPoint(x: o.x, y: size.height - 16))
                ctx.stroke(norm, with: .color(.secondary.opacity(0.4)), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                let ai = angleDeg * .pi / 180
                let len: CGFloat = 90
                // 入射光（从介质内向上打到界面）
                let from = CGPoint(x: o.x - len * CGFloat(sin(ai)), y: o.y + len * CGFloat(cos(ai)))
                SimDraw.arrow(&ctx, from: from, to: o, color: .apexGold, lineWidth: 2.5)
                // 反射光
                let refl = CGPoint(x: o.x + len * CGFloat(sin(ai)), y: o.y + len * CGFloat(cos(ai)))
                SimDraw.arrow(&ctx, from: o, to: refl, color: totalReflect ? .apexLava : .apexLava.opacity(0.45), lineWidth: totalReflect ? 3 : 1.5)
                // 折射光
                if !totalReflect {
                    let ar = refractDeg * .pi / 180
                    let refr = CGPoint(x: o.x + len * CGFloat(sin(ar)), y: o.y - len * CGFloat(cos(ar)))
                    SimDraw.arrow(&ctx, from: o, to: refr, color: .apexEmerald, lineWidth: 2.5)
                }
                ctx.draw(Text(totalReflect ? "全反射！光出不去了" : String(format: "折射角 %.0f°", refractDeg))
                    .font(.caption2).foregroundColor(totalReflect ? .apexLava : .apexEmerald), at: CGPoint(x: size.width / 2, y: 14))
            }
            .simCanvas(height: 210, tint: .apexStarBlue)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "入射角", value: String(format: "%.0f°", angleDeg), color: .apexGold)
                SimReadout(label: "临界角 C", value: String(format: "%.1f°", critical), color: .apexLava)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "入射角", value: $angleDeg, range: 5...85, unit: "°", accent: .apexGold, decimals: 0)
                SimSlider(label: "折射率 n", value: $n, range: 1.2...2.4, unit: "", accent: .apexStarBlue)
            }.cardSurface()
            SimInsight(text: "光从水/玻璃往空气跑，角度一超过临界角就被「关在里面」全反射——光纤通信就是把光这样囚禁起来传到千里之外。")
        }
    }
}

// 22. 双缝干涉
struct DoubleSlitSimView: View {
    @State private var lambda: Double = 600   // nm
    @State private var d: Double = 0.2        // mm
    @State private var l: Double = 1.0        // m
    private var spacing: Double { l * lambda * 1e-9 / (d * 1e-3) * 1000 }   // mm

    var body: some View {
        SimPage(title: "双缝干涉") {
            Canvas { ctx, size in
                // 条纹屏：亮度 cos² 分布
                let stripeW = max(CGFloat(spacing) * 14, 4)
                let waveColor = wavelengthColor(lambda)
                for px in stride(from: CGFloat(0), to: size.width, by: 2) {
                    let phase = (px - size.width / 2) / stripeW * .pi
                    let bright = pow(cos(phase), 2)
                    ctx.fill(Path(CGRect(x: px, y: 24, width: 2, height: size.height - 70)),
                             with: .color(waveColor.opacity(Double(bright) * 0.9 + 0.04)))
                }
                ctx.draw(Text(String(format: "条纹间距 Δy = %.2f mm", spacing)).font(.caption2).foregroundColor(.secondary),
                         at: CGPoint(x: size.width / 2, y: size.height - 22))
            }
            .simCanvas(height: 190, tint: .apexMystery)
            VStack(spacing: Spacing.md) {
                SimSlider(label: "波长 λ", value: $lambda, range: 400...700, unit: "nm", accent: .apexLava, decimals: 0)
                SimSlider(label: "缝距 d", value: $d, range: 0.1...0.5, unit: "mm", accent: .apexStarBlue)
                SimSlider(label: "屏距 L", value: $l, range: 0.5...2, unit: "m", accent: .apexEmerald)
            }.cardSurface()
            SimInsight(text: "Δy=Lλ/d：红光条纹比紫光宽、屏拉远条纹变宽、缝靠近条纹也变宽。亲手拖三个旋钮，公式就长在手上了。")
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

// 23. 光电效应
struct PhotoelectricSimView: View {
    @State private var freq: Double = 6       // ×10¹⁴ Hz
    @State private var intensity: Double = 5
    private let w0 = 3.0                       // 逸出功对应 ×10¹⁴ Hz 阈值≈4.5（取 hν₀=3 单位）
    private let hUnit = 0.66                   // h×10¹⁴ ≈ 0.66 eV
    private var photonE: Double { hUnit * freq }
    private var ekMax: Double { photonE - w0 }
    private var emits: Bool { ekMax > 0 }

    var body: some View {
        SimPage(title: "光电效应") {
            Canvas { ctx, size in
                let metalY = size.height * 0.7
                ctx.fill(Path(roundedRect: CGRect(x: 20, y: metalY, width: size.width - 40, height: 26), cornerRadius: 6), with: .color(.secondary.opacity(0.6)))
                // 入射光子
                let photons = Int(intensity)
                for i in 0..<photons {
                    let x = 40 + (size.width - 80) * CGFloat(i) / CGFloat(max(photons - 1, 1))
                    var ray = Path(); ray.move(to: CGPoint(x: x - 16, y: 20)); ray.addLine(to: CGPoint(x: x, y: metalY - 2))
                    ctx.stroke(ray, with: .color(freq > 7 ? .purple : (freq > 5.5 ? .blue : .red)), style: StrokeStyle(lineWidth: 1.5, dash: [5, 3]))
                    // 逸出电子
                    if emits {
                        SimDraw.arrow(&ctx, from: CGPoint(x: x, y: metalY - 4), to: CGPoint(x: x + 12, y: metalY - 4 - CGFloat(ekMax) * 16), color: .apexEmerald, lineWidth: 2)
                    }
                }
                ctx.draw(Text(emits ? "电子逸出！" : "光子能量不够，一个电子也出不来").font(.caption).foregroundColor(emits ? .apexEmerald : .apexDanger),
                         at: CGPoint(x: size.width / 2, y: size.height - 14))
            }
            .simCanvas(height: 190, tint: .apexGold)
            HStack(spacing: Spacing.md) {
                SimReadout(label: "光子能量 hν", value: String(format: "%.2f eV", photonE), color: .apexGold)
                SimReadout(label: "逸出功 W₀", value: String(format: "%.1f eV", w0), color: .secondary)
                SimReadout(label: "最大动能", value: emits ? String(format: "%.2f eV", ekMax) : "—", color: .apexEmerald)
            }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "频率 ν", value: $freq, range: 3...9, unit: "×10¹⁴", accent: .apexMystery)
                SimSlider(label: "光强（光子数）", value: $intensity, range: 1...9, unit: "", accent: .apexLava, decimals: 0)
            }.cardSurface()
            SimInsight(text: "把光强拉满也没用——单个光子钱不够（hν<W₀），谁也赎不出电子。把频率调高一点，立刻就有电子飞出。")
        }
    }
}

// 24. 玻尔能级跃迁
struct BohrSimView: View {
    @State private var fromLevel: Int = 3
    @State private var toLevel: Int = 2
    private func energy(_ n: Int) -> Double { -13.6 / Double(n * n) }
    private var photon: Double { abs(energy(fromLevel) - energy(toLevel)) }

    var body: some View {
        SimPage(title: "玻尔能级跃迁") {
            Canvas { ctx, size in
                let levels = [1, 2, 3, 4, 5]
                func y(_ n: Int) -> CGFloat {
                    // E ∝ −1/n²，映射到画布
                    let frac = (energy(n) + 13.6) / 13.6
                    return size.height - 36 - CGFloat(frac) * (size.height - 70)
                }
                for n in levels {
                    var line = Path(); line.move(to: CGPoint(x: 36, y: y(n))); line.addLine(to: CGPoint(x: size.width - 36, y: y(n)))
                    ctx.stroke(line, with: .color(n == fromLevel || n == toLevel ? .apexLava : .secondary.opacity(0.45)), lineWidth: n == 1 ? 3 : 1.5)
                    ctx.draw(Text("n=\(n)  \(String(format: "%.1f eV", energy(n)))").font(.caption2).foregroundColor(.secondary),
                             at: CGPoint(x: size.width - 70, y: y(n) - 9))
                }
                // 跃迁箭头
                SimDraw.arrow(&ctx, from: CGPoint(x: size.width * 0.32, y: y(fromLevel)),
                              to: CGPoint(x: size.width * 0.32, y: y(toLevel)), color: .apexEmerald, lineWidth: 3)
                // 光子波浪
                if fromLevel > toLevel {
                    var wave = Path()
                    let wy = (y(fromLevel) + y(toLevel)) / 2
                    wave.move(to: CGPoint(x: size.width * 0.4, y: wy))
                    for i in 0...30 {
                        let x = size.width * 0.4 + CGFloat(i) * 3
                        wave.addLine(to: CGPoint(x: x, y: wy + 6 * sin(CGFloat(i) * 0.8)))
                    }
                    ctx.stroke(wave, with: .color(.apexGold), lineWidth: 2)
                }
            }
            .simCanvas(height: 220, tint: .apexMystery)
            HStack {
                Picker("从", selection: $fromLevel) { ForEach(2...5, id: \.self) { Text("n=\($0)").tag($0) } }
                Image(systemName: "arrow.right")
                Picker("到", selection: $toLevel) { ForEach(1...4, id: \.self) { Text("n=\($0)").tag($0) } }
            }
            .pickerStyle(.segmented)
            SimReadout(label: fromLevel > toLevel ? "辐射光子能量 hν = Em − En" : "需吸收能量",
                       value: String(format: "%.2f eV", photon), color: .apexGold)
            SimInsight(text: "能级像台阶不像斜坡——电子只能整级跳，吐出的光子能量只能取特定值。这就是原子光谱是一根根「线」的原因。")
        }
    }
}

// 25. 半衰期
struct DecaySimView: View {
    @State private var halfLife: Double = 2
    @State private var running = true
    @State private var start = Date()
    private let n0 = 64

    var body: some View {
        SimPage(title: "半衰期") {
            TimelineView(.animation(minimumInterval: 0.2, paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let remainFrac = pow(0.5, t / halfLife)
                    // 粒子网格：按伪随机顺序「衰变」
                    var seed: UInt64 = 12345
                    func rnd() -> Double { seed = seed &* 6364136223846793005 &+ 1442695040888963407; return Double((seed >> 33) % 1000) / 1000 }
                    var order: [(Int, Double)] = []
                    for i in 0..<n0 { order.append((i, rnd())) }
                    let sorted = order.sorted { $0.1 < $1.1 }
                    let decayedCount = n0 - Int((remainFrac * Double(n0)).rounded())
                    var decayedSet = Set<Int>()
                    for k in 0..<min(decayedCount, n0) { decayedSet.insert(sorted[k].0) }
                    let cols = 8
                    for i in 0..<n0 {
                        let cx = 30 + (size.width * 0.5 - 40) * CGFloat(i % cols) / CGFloat(cols - 1)
                        let cy = 26 + (size.height - 60) * CGFloat(i / cols) / 7
                        SimDraw.dot(&ctx, at: CGPoint(x: cx, y: cy), r: 6, color: decayedSet.contains(i) ? .secondary.opacity(0.25) : .apexLava)
                    }
                    // 衰变曲线
                    let rect = CGRect(x: size.width * 0.58, y: 26, width: size.width * 0.38, height: size.height - 60)
                    SimDraw.curve(&ctx, in: rect, x0: 0, x1: halfLife * 4, yMin: 0, yMax: 1, color: .apexStarBlue) { pow(0.5, $0 / halfLife) }
                    let px = rect.minX + rect.width * CGFloat(min(t / (halfLife * 4), 1))
                    SimDraw.dot(&ctx, at: CGPoint(x: px, y: rect.maxY - rect.height * CGFloat(remainFrac)), r: 5, color: .apexGold)
                    ctx.draw(Text(String(format: "剩 %.0f%%", remainFrac * 100)).font(.caption).foregroundColor(.apexGold),
                             at: CGPoint(x: rect.midX, y: 14))
                }
            }
            .simCanvas(height: 210, tint: .apexLava)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            SimSlider(label: "半衰期 T½", value: $halfLife, range: 1...6, unit: "s", accent: .apexLava).cardSurface()
            SimInsight(text: "每过一个半衰期剩一半：1/2、1/4、1/8……但具体哪颗核先衰变完全随机——半衰期是大量原子核的统计规律。")
        }
    }
}

// 26. 波的叠加
struct SuperpositionSimView: View {
    @State private var a1: Double = 1
    @State private var a2: Double = 1
    @State private var phase: Double = 0   // 相位差（π 的倍数）
    @State private var running = true
    @State private var start = Date()

    var body: some View {
        SimPage(title: "波的叠加") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let rows: [(Double, Double, Color, CGFloat)] = [
                        (a1, 0, .apexStarBlue, size.height * 0.2),
                        (a2, phase * .pi, .apexEmerald, size.height * 0.5),
                    ]
                    func drawWave(_ amp: Double, _ ph: Double, _ color: Color, _ midY: CGFloat, bold: Bool = false) {
                        var path = Path()
                        for i in 0...140 {
                            let x = CGFloat(i) / 140 * size.width
                            let arg = Double(i) / 140 * 4 * .pi - 2 * .pi * t + ph
                            let y = midY - CGFloat(amp * sin(arg)) * 20
                            if i == 0 { path.move(to: CGPoint(x: x, y: y)) } else { path.addLine(to: CGPoint(x: x, y: y)) }
                        }
                        ctx.stroke(path, with: .color(color), lineWidth: bold ? 3 : 1.5)
                    }
                    for r in rows { drawWave(r.0, r.1, r.2, r.3) }
                    // 合成波
                    var sum = Path()
                    let midY = size.height * 0.82
                    for i in 0...140 {
                        let x = CGFloat(i) / 140 * size.width
                        let arg = Double(i) / 140 * 4 * .pi - 2 * .pi * t
                        let y = midY - CGFloat(a1 * sin(arg) + a2 * sin(arg + phase * .pi)) * 20
                        if i == 0 { sum.move(to: CGPoint(x: x, y: y)) } else { sum.addLine(to: CGPoint(x: x, y: y)) }
                    }
                    ctx.stroke(sum, with: .color(.apexLava), lineWidth: 3)
                }
            }
            .simCanvas(height: 230, tint: .apexEmerald)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            VStack(spacing: Spacing.md) {
                SimSlider(label: "波 1 振幅", value: $a1, range: 0...2, unit: "", accent: .apexStarBlue)
                SimSlider(label: "波 2 振幅", value: $a2, range: 0...2, unit: "", accent: .apexEmerald)
                SimSlider(label: "相位差", value: $phase, range: 0...2, unit: "π", accent: .apexLava)
            }.cardSurface()
            SimInsight(text: "相位差 0：红色合成波最强（相长干涉）；拖到 1π：两列波互相抵消（相消干涉）。声学降噪耳机就是这么干的。")
        }
    }
}

// 27. 参考圆与简谐运动
struct ReferenceCircleSimView: View {
    @State private var omega: Double = 2
    @State private var running = true
    @State private var start = Date()

    var body: some View {
        SimPage(title: "参考圆与简谐") {
            TimelineView(.animation(paused: !running)) { tl in
                Canvas { ctx, size in
                    let t = tl.date.timeIntervalSince(start)
                    let r: CGFloat = min(size.width, size.height) * 0.3
                    let cc = CGPoint(x: size.width * 0.28, y: size.height / 2)
                    var circle = Path(); circle.addEllipse(in: CGRect(x: cc.x - r, y: cc.y - r, width: 2 * r, height: 2 * r))
                    ctx.stroke(circle, with: .color(.secondary.opacity(0.4)), lineWidth: 1.5)
                    let ang = omega * t
                    let p = CGPoint(x: cc.x + r * CGFloat(cos(ang)), y: cc.y - r * CGFloat(sin(ang)))
                    SimDraw.dot(&ctx, at: p, r: 7, color: .apexStarBlue)
                    // 投影线
                    let axisX = size.width * 0.62
                    var proj = Path(); proj.move(to: p); proj.addLine(to: CGPoint(x: axisX, y: p.y))
                    ctx.stroke(proj, with: .color(.apexGold.opacity(0.6)), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    // 投影点（简谐振子）
                    var axis = Path(); axis.move(to: CGPoint(x: axisX, y: cc.y - r - 10)); axis.addLine(to: CGPoint(x: axisX, y: cc.y + r + 10))
                    ctx.stroke(axis, with: .color(.secondary.opacity(0.4)), lineWidth: 1)
                    SimDraw.dot(&ctx, at: CGPoint(x: axisX, y: p.y), r: 8, color: .apexLava)
                    // x-t 曲线（向右延展）
                    var curve = Path()
                    for i in 0...80 {
                        let tt = t - Double(i) * 0.02 * (6.28 / omega)
                        let y = cc.y - r * CGFloat(sin(omega * tt))
                        let x = axisX + 8 + CGFloat(i) * (size.width - axisX - 20) / 80
                        if i == 0 { curve.move(to: CGPoint(x: x, y: y)) } else { curve.addLine(to: CGPoint(x: x, y: y)) }
                    }
                    ctx.stroke(curve, with: .color(.apexLava.opacity(0.7)), lineWidth: 2)
                }
            }
            .simCanvas(height: 220, tint: .apexStarBlue)
            .overlay(alignment: .bottomTrailing) { SimChrome(running: $running) { start = Date() } }
            SimSlider(label: "角速度 ω", value: $omega, range: 0.5...5, unit: "rad/s", accent: .apexStarBlue).cardSurface()
            SimInsight(text: "匀速圆周运动的「影子」就是简谐运动——红点是蓝点的投影。简谐公式里的 ω、相位、振幅全都来自这个圆。")
        }
    }
}
