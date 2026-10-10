import SwiftUI

// MARK: - 宇宙特效：可复用的动态星空（闪烁星点 + 流星）
// Canvas + TimelineView，30fps，轻量；用于首页 hero、对决剧场等氛围层。

struct CosmicStarfield: View {
    var starCount: Int = 70
    var meteors: Bool = true
    var intensity: Double = 1   // 整体亮度 0...1

    private struct Star {
        let pos: CGPoint     // 归一化坐标
        let radius: CGFloat
        let phase: Double
        let speed: Double
    }

    private let stars: [Star]

    init(starCount: Int = 70, meteors: Bool = true, intensity: Double = 1) {
        self.starCount = starCount
        self.meteors = meteors
        self.intensity = intensity
        var seed: UInt64 = 0x9E3779B97F4A7C15
        func rnd() -> CGFloat {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            return CGFloat((seed >> 33) % 10000) / 10000
        }
        self.stars = (0..<starCount).map { _ in
            Star(pos: CGPoint(x: rnd(), y: rnd()),
                 radius: 0.6 + rnd() * 1.7,
                 phase: Double(rnd()) * .pi * 2,
                 speed: 0.5 + Double(rnd()) * 1.8)
        }
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate

                // 闪烁星点
                for s in stars {
                    let twinkle = 0.35 + 0.65 * (0.5 + 0.5 * sin(t * s.speed + s.phase))
                    let rect = CGRect(x: s.pos.x * size.width - s.radius,
                                      y: s.pos.y * size.height - s.radius,
                                      width: s.radius * 2, height: s.radius * 2)
                    ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(twinkle * intensity)))
                }

                // 流星：每 ~5 s 划过一颗，持续 1 s
                if meteors {
                    let cycle = 5.0, life = 1.0
                    let local = t.truncatingRemainder(dividingBy: cycle)
                    if local < life {
                        let k = local / life                       // 0...1 生命进度
                        var mseed = UInt64(Int(t / cycle) % 9973) &+ 7
                        func mr() -> CGFloat {
                            mseed = mseed &* 6364136223846793005 &+ 1442695040888963407
                            return CGFloat((mseed >> 33) % 10000) / 10000
                        }
                        let sx = (0.05 + mr() * 0.7) * size.width
                        let sy = (0.05 + mr() * 0.35) * size.height
                        let head = CGPoint(x: sx + 170 * k, y: sy + 95 * k)
                        let tail = CGPoint(x: head.x - 70, y: head.y - 39)
                        let fade = k < 0.25 ? k / 0.25 : (1 - k) / 0.75
                        var path = Path()
                        path.move(to: tail); path.addLine(to: head)
                        ctx.stroke(path,
                                   with: .linearGradient(Gradient(colors: [.white.opacity(0), .white.opacity(0.9 * fade * intensity)]),
                                                         startPoint: tail, endPoint: head),
                                   lineWidth: 2)
                        // 流星头部光点
                        ctx.fill(Path(ellipseIn: CGRect(x: head.x - 2, y: head.y - 2, width: 4, height: 4)),
                                 with: .color(.white.opacity(fade * intensity)))
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}
