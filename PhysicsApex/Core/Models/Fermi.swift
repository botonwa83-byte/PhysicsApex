import Foundation

// MARK: - 费米估算「先估后算」
// 物理直觉的看家本领：不精算，先估出数量级。先让学生猜，再揭晓拆解，校准直觉。

struct FermiQuestion: Identifiable {
    let id: String
    let emoji: String
    let question: String
    let unit: String            // 答案单位（如 升 / 年）
    let answerExponent: Int     // 答案数量级（10 的指数）
    let answerText: String      // 答案口径（如「约 10 升」）
    let maxExponent: Int        // 猜测滑杆上限
    let steps: [String]         // 拆解步骤（每行一步）
    let funFact: String         // 揭晓后的趣味结论
}

enum FermiData {
    static let all: [FermiQuestion] = [
        FermiQuestion(
            id: "boil_water",
            emoji: "💧",
            question: "一度电（1 kWh）能把多少升 20°C 的水烧开？",
            unit: "升",
            answerExponent: 1,
            answerText: "约 10 升",
            maxExponent: 5,
            steps: [
                "1 度电 = 1 kWh = 3.6×10⁶ J",
                "烧开 1 L 水需 Q = cmΔT = 4200 × 1 × 80 ≈ 3.4×10⁵ J",
                "3.6×10⁶ ÷ 3.4×10⁵ ≈ 10 升",
            ],
            funFact: "一度电只够烧开约 10 升水——电其实比你想的「贵」。"
        ),
        FermiQuestion(
            id: "walk_moon",
            emoji: "🌕",
            question: "不吃不喝，步行到月球（38 万公里）要走多少年？",
            unit: "年",
            answerExponent: 1,
            answerText: "约 9 年",
            maxExponent: 4,
            steps: [
                "月地距离 ≈ 3.8×10⁵ km",
                "步行速度 ≈ 5 km/h，一年 ≈ 8800 小时",
                "3.8×10⁵ ÷ 5 ÷ 8800 ≈ 9 年（不眠不休）",
            ],
            funFact: "宇宙尺度大到「走」过去要近十年——这还是不睡觉的极限。"
        ),
        FermiQuestion(
            id: "battery_energy",
            emoji: "🔋",
            question: "一节 5 号电池储存多少焦耳能量？",
            unit: "焦耳",
            answerExponent: 4,
            answerText: "约 1 万焦耳",
            maxExponent: 8,
            steps: [
                "电量 ≈ 2.5 Ah = 2.5 × 3600 ≈ 9000 C",
                "电压 ≈ 1.5 V，能量 W = qU",
                "9000 × 1.5 ≈ 1.4×10⁴ J",
            ],
            funFact: "一节小电池约 1 万焦耳，只够把 1 L 水烧热约 3°C。"
        ),
        FermiQuestion(
            id: "atmosphere_hand",
            emoji: "✋",
            question: "一个标准大气压压在你手掌上，相当于压了多少千克的重量？",
            unit: "千克",
            answerExponent: 2,
            answerText: "约 100 千克",
            maxExponent: 5,
            steps: [
                "手掌面积 ≈ 0.01 m²",
                "大气压 p ≈ 1.0×10⁵ Pa，F = pS",
                "1.0×10⁵ × 0.01 = 10³ N ≈ 100 kg 的重力",
            ],
            funFact: "你手掌每时每刻都顶着约 100 kg 的大气——因为上下都有压，你才没被压垮。"
        ),
        FermiQuestion(
            id: "classroom_air",
            emoji: "🏫",
            question: "一间普通教室里的空气，大约有多重？",
            unit: "千克",
            answerExponent: 2,
            answerText: "约 250 千克",
            maxExponent: 5,
            steps: [
                "教室约 8m × 8m × 3m ≈ 200 m³",
                "空气密度 ρ ≈ 1.3 kg/m³",
                "m = ρV ≈ 1.3 × 200 ≈ 260 kg",
            ],
            funFact: "空气看不见，却重达两三百公斤——比一头牛还沉。我们整天「泡」在重重的空气里。"
        ),
        FermiQuestion(
            id: "lightning_bulb",
            emoji: "⚡",
            question: "一道闪电释放的能量，够一只 100W 灯泡亮多少天？",
            unit: "天",
            answerExponent: 2,
            answerText: "约 100 天",
            maxExponent: 5,
            steps: [
                "一道闪电能量 ≈ 10⁹ J",
                "100W 灯泡每秒耗 100 J，一天耗 100 × 86400 ≈ 10⁷ J",
                "10⁹ ÷ 10⁷ ≈ 100 天",
            ],
            funFact: "一道闪电的能量惊人，但它在百万分之一秒内放完——功率极大、总量却只够点灯几个月。"
        ),
    ]
}
