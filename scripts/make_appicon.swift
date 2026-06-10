// 程序化生成 PhysicsApex AppIcon (1024x1024)
// 设计：深空渐变 + 登顶山峰(lava) + 原子轨道环(starBlue) + 顶点星(gold)
// 运行：swift scripts/make_appicon.swift <输出路径>

import AppKit
import CoreGraphics

let size: CGFloat = 1024
let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1]
    : "PhysicsApex/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"

func rgb(_ hex: UInt32, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: CGFloat((hex >> 16) & 0xFF)/255, green: CGFloat((hex >> 8) & 0xFF)/255,
            blue: CGFloat(hex & 0xFF)/255, alpha: a)
}

let cs = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8,
                    bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

// 1. 深空渐变背景（上深紫蓝 → 下夜蓝）
let bgGrad = CGGradient(colorsSpace: cs, colors: [rgb(0x141A3C), rgb(0x0A0F26)] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(bgGrad, start: CGPoint(x: size/2, y: size), end: CGPoint(x: size/2, y: 0), options: [])

// 2. 顶部辉光（顶点星的氛围）
let glow = CGGradient(colorsSpace: cs,
                      colors: [rgb(0xFFA726, 0.32), rgb(0xFFA726, 0.0)] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(glow, startCenter: CGPoint(x: size/2, y: 700), startRadius: 0,
                       endCenter: CGPoint(x: size/2, y: 700), endRadius: 360, options: [])

// 3. 星空（伪随机小星点）
var seed: UInt64 = 42
func rand01() -> CGFloat { seed = seed &* 6364136223846793005 &+ 1442695040888963407
    return CGFloat((seed >> 33) % 10000) / 10000 }
for _ in 0..<70 {
    let x = rand01() * size, y = 380 + rand01() * (size - 420)
    let r = 1.5 + rand01() * 3.5
    ctx.setFillColor(rgb(0xFFFFFF, 0.25 + rand01() * 0.5))
    ctx.fillEllipse(in: CGRect(x: x - r, y: y - r, width: 2*r, height: 2*r))
}

// 4. 远山（mystery 紫，层次感）
ctx.setFillColor(rgb(0x2A2F5C))
ctx.beginPath()
ctx.move(to: CGPoint(x: 0, y: 0)); ctx.addLine(to: CGPoint(x: 0, y: 300))
ctx.addLine(to: CGPoint(x: 300, y: 470)); ctx.addLine(to: CGPoint(x: 560, y: 300))
ctx.addLine(to: CGPoint(x: 1024, y: 430)); ctx.addLine(to: CGPoint(x: 1024, y: 0))
ctx.closePath(); ctx.fillPath()

// 5. 主峰（lava 渐变三角，顶点在辉光中心下方）
let peakTop = CGPoint(x: size/2, y: 690)
ctx.saveGState()
ctx.beginPath()
ctx.move(to: peakTop)
ctx.addLine(to: CGPoint(x: 130, y: 0)); ctx.addLine(to: CGPoint(x: 894, y: 0))
ctx.closePath(); ctx.clip()
let peakGrad = CGGradient(colorsSpace: cs, colors: [rgb(0xFF8A65), rgb(0xD84315)] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(peakGrad, start: CGPoint(x: size/2, y: 690), end: CGPoint(x: size/2, y: 0), options: [])
ctx.restoreGState()

// 5b. 主峰雪顶高光
ctx.setFillColor(rgb(0xFFE0B2, 0.9))
ctx.beginPath()
ctx.move(to: peakTop)
ctx.addLine(to: CGPoint(x: 462, y: 600)); ctx.addLine(to: CGPoint(x: 512, y: 620))
ctx.addLine(to: CGPoint(x: 562, y: 600))
ctx.closePath(); ctx.fillPath()

// 6. 原子轨道环（starBlue 椭圆，倾斜，环绕峰腰）
func drawOrbit(tilt: CGFloat, ry: CGFloat, lineW: CGFloat, alpha: CGFloat) {
    ctx.saveGState()
    ctx.translateBy(x: size/2, y: 480)
    ctx.rotate(by: tilt)
    ctx.setStrokeColor(rgb(0x42A5F5, alpha))
    ctx.setLineWidth(lineW)
    ctx.strokeEllipse(in: CGRect(x: -430, y: -ry, width: 860, height: 2*ry))
    ctx.restoreGState()
}
drawOrbit(tilt: -0.20, ry: 150, lineW: 16, alpha: 0.95)
drawOrbit(tilt: 0.32, ry: 120, lineW: 10, alpha: 0.45)

// 6b. 轨道上的电子（starBlue 亮点 + 光晕）
let electron = CGPoint(x: size/2 + 430 * cos(2.4) , y: 480 + 150 * sin(2.4) - 80)
let eGlow = CGGradient(colorsSpace: cs, colors: [rgb(0x90CAF9, 0.9), rgb(0x42A5F5, 0.0)] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(eGlow, startCenter: electron, startRadius: 0, endCenter: electron, endRadius: 60, options: [])
ctx.setFillColor(rgb(0xE3F2FD))
ctx.fillEllipse(in: CGRect(x: electron.x - 22, y: electron.y - 22, width: 44, height: 44))

// 7. 顶点星（gold 四角星）
func drawStar(center c: CGPoint, rOuter: CGFloat, rInner: CGFloat, color: CGColor) {
    ctx.setFillColor(color)
    ctx.beginPath()
    for i in 0..<8 {
        let r = i % 2 == 0 ? rOuter : rInner
        let ang = CGFloat(i) * .pi / 4 + .pi / 2
        let p = CGPoint(x: c.x + r * cos(ang), y: c.y + r * sin(ang))
        i == 0 ? ctx.move(to: p) : ctx.addLine(to: p)
    }
    ctx.closePath(); ctx.fillPath()
}
let starC = CGPoint(x: size/2, y: 760)
let starGlow = CGGradient(colorsSpace: cs, colors: [rgb(0xFFD54F, 0.85), rgb(0xFFA726, 0.0)] as CFArray, locations: [0, 1])!
ctx.drawRadialGradient(starGlow, startCenter: starC, startRadius: 0, endCenter: starC, endRadius: 130, options: [])
drawStar(center: starC, rOuter: 86, rInner: 26, color: rgb(0xFFE082))

// 输出 PNG
let img = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: img)
let data = rep.representation(using: .png, properties: [:])!
try! data.write(to: URL(fileURLWithPath: outPath))
print("✅ 已生成 \(outPath) (\(Int(size))x\(Int(size)))")
