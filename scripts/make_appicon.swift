// 程序化生成 PhysApex AppIcon (1024x1024)
// 三色极简设计：淡蓝渐变底（主） + 白色电子轨道/文字 + 橙色原子核（画龙点睛）。
// 只保留「原子 + 名字」两个元素，橙色仅用于核心点睛。
// 运行：swift scripts/make_appicon.swift [输出路径]

import AppKit
import CoreGraphics

let S: CGFloat = 1024
let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1]
    : "PhysicsApex/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"

let cs = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8,
                    bytesPerRow: 0, space: cs,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(colorSpace: cs, components: [r, g, b, a])!
}

let cen = CGPoint(x: 512, y: 530)   // 原子中心（主角）

// MARK: 1. 淡蓝渐变底（上浅天蓝 → 下稍深蓝，主色）

let sky = CGGradient(colorsSpace: cs,
                     colors: [color(0.58, 0.80, 0.97), color(0.27, 0.53, 0.85)] as CFArray,
                     locations: [0, 1])!
ctx.drawLinearGradient(sky, start: CGPoint(x: 512, y: 1024), end: CGPoint(x: 512, y: 0), options: [])

// 主角背后的白色柔光
let halo = CGGradient(colorsSpace: cs,
                      colors: [color(1.0, 1.0, 1.0, 0.45), color(0.85, 0.93, 1.0, 0.0)] as CFArray,
                      locations: [0, 1])!
ctx.drawRadialGradient(halo, startCenter: cen, startRadius: 0, endCenter: cen, endRadius: 400, options: [])

// MARK: 2. 大原子（主角）

// 三条电子轨道（白色发光）
ctx.setShadow(offset: .zero, blur: 18, color: color(1.0, 1.0, 1.0, 0.9))
ctx.setStrokeColor(color(1.0, 1.0, 1.0, 0.98))
ctx.setLineWidth(12)
let rx: CGFloat = 230, ry: CGFloat = 88
for angle in [0.0, 60.0, 120.0] {
    ctx.saveGState()
    ctx.translateBy(x: cen.x, y: cen.y)
    ctx.rotate(by: CGFloat(angle) * .pi / 180)
    ctx.strokeEllipse(in: CGRect(x: -rx, y: -ry, width: rx * 2, height: ry * 2))
    ctx.restoreGState()
}
ctx.setShadow(offset: .zero, blur: 0, color: nil)

// 电子（轨道上的白色亮点）
let electrons: [(Double, Double)] = [(0, 35), (60, 200), (120, 320)]
for (orbitAngle, posAngle) in electrons {
    let oa = orbitAngle * .pi / 180, pa = posAngle * .pi / 180
    let lx = rx * cos(pa), ly = ry * sin(pa)
    let ex = cen.x + lx * cos(oa) - ly * sin(oa)
    let ey = cen.y + lx * sin(oa) + ly * cos(oa)
    ctx.setShadow(offset: .zero, blur: 12, color: color(1.0, 1.0, 1.0, 1.0))
    ctx.setFillColor(color(1.0, 1.0, 1.0))
    ctx.fillEllipse(in: CGRect(x: ex - 18, y: ey - 18, width: 36, height: 36))
}
ctx.setShadow(offset: .zero, blur: 0, color: nil)

// 原子核（橙色 · 画龙点睛）
let core = CGGradient(colorsSpace: cs,
                      colors: [color(1.0, 0.85, 0.55, 1.0), color(1.0, 0.58, 0.18, 0.95), color(1.0, 0.5, 0.15, 0.0)] as CFArray,
                      locations: [0, 0.55, 1])!
ctx.drawRadialGradient(core, startCenter: cen, startRadius: 0, endCenter: cen, endRadius: 110, options: [])
ctx.setShadow(offset: .zero, blur: 24, color: color(1.0, 0.6, 0.2, 0.95))
ctx.setFillColor(color(1.0, 0.66, 0.26))
ctx.fillEllipse(in: CGRect(x: cen.x - 46, y: cen.y - 46, width: 92, height: 92))
ctx.setShadow(offset: .zero, blur: 0, color: nil)

// MARK: 3. App 名（白字）

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
let shadow = NSShadow()
shadow.shadowColor = NSColor(srgbRed: 0.15, green: 0.30, blue: 0.55, alpha: 0.45)
shadow.shadowBlurRadius = 8
shadow.shadowOffset = NSSize(width: 0, height: -2)
let attrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 56, weight: .semibold),
    .foregroundColor: NSColor.white,
    .kern: 3.0,
    .shadow: shadow,
]
let astr = NSAttributedString(string: "PhysApex", attributes: attrs)
let tsz = astr.size()
astr.draw(at: NSPoint(x: (1024 - tsz.width) / 2, y: 110))
NSGraphicsContext.restoreGraphicsState()

// MARK: 输出

let img = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: img)
let png = rep.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: outPath))
print("✅ 已生成 \(outPath) (\(Int(S))x\(Int(S)))")
