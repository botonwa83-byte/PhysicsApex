import SwiftUI

// MARK: - 先估后算（费米估算）：先猜数量级，再揭晓拆解，校准物理直觉

struct FermiEstimationView: View {
    private let questions = FermiData.all

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                ForEach(questions) { q in
                    NavigationLink { FermiDetailView(question: q) } label: { card(q) }
                        .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("先估后算")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("不精算，先估数量级")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text("数量级直觉是物理学家的看家本领。先大胆猜，再看拆解——一次次校准你的直觉。")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexGold, Color.apexLava],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }

    private func card(_ q: FermiQuestion) -> some View {
        HStack(spacing: Spacing.md) {
            Text(q.emoji).font(.title)
            Text(q.question).font(AppFont.body).foregroundColor(.primary).lineLimit(3)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
        .cardSurface()
    }
}

struct FermiDetailView: View {
    let question: FermiQuestion
    @State private var guess: Double = 0
    @State private var revealed = false

    private var guessExp: Int { Int(guess.rounded()) }
    private var diff: Int { abs(guessExp - question.answerExponent) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // 题目
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(question.emoji).font(.system(size: 40))
                    Text(question.question).font(.title3).foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface()

                // 猜数量级
                VStack(alignment: .leading, spacing: Spacing.md) {
                    SectionHeader(title: revealed ? "你的猜测" : "先猜一个数量级", systemImage: "dial.medium", accent: .apexGold)
                    Text("≈ 10\(superscript(guessExp)) \(question.unit)")
                        .font(AppFont.bigStat(28)).foregroundColor(.apexLava)
                        .frame(maxWidth: .infinity)
                    Slider(value: $guess, in: 0...Double(question.maxExponent), step: 1).tint(.apexLava)
                        .disabled(revealed)
                    HStack {
                        Text("10⁰").font(.caption2).foregroundColor(.secondary)
                        Spacer()
                        Text("10\(superscript(question.maxExponent))").font(.caption2).foregroundColor(.secondary)
                    }
                }
                .cardSurface()

                if !revealed {
                    Button { withAnimation { revealed = true } } label: {
                        Text("揭晓答案").font(AppFont.cardTitle).frame(maxWidth: .infinity).padding()
                            .background(Color.apexGold).foregroundColor(.white).cornerRadius(Radius.inner)
                    }
                } else {
                    resultCard
                    stepsCard
                    Label(question.funFact, systemImage: "sparkles")
                        .font(AppFont.caption).foregroundColor(.apexGold)
                        .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("先估后算")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { guess = Double(question.maxExponent) / 2 }
    }

    private var resultCard: some View {
        let color: Color = diff == 0 ? .apexEmerald : (diff == 1 ? .apexGold : .apexDanger)
        let verdict = diff == 0 ? "完美命中！" : (diff == 1 ? "很接近，差 1 个数量级" : "差了 \(diff) 个数量级")
        return HStack(spacing: Spacing.md) {
            Image(systemName: diff == 0 ? "checkmark.seal.fill" : "scope").font(.title).foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(question.answerText).font(AppFont.sectionTitle).foregroundColor(.primary)
                Text(verdict).font(AppFont.caption).foregroundColor(color)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(color.opacity(0.10))
        .cornerRadius(Radius.card)
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "怎么估出来的", systemImage: "list.number", accent: .apexStarBlue)
            ForEach(Array(question.steps.enumerated()), id: \.offset) { i, step in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(i+1)").font(AppFont.chip).foregroundColor(.white)
                        .frame(width: 20, height: 20).background(Color.apexStarBlue).clipShape(Circle())
                    Text(step).font(.system(.subheadline, design: .monospaced)).foregroundColor(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private func superscript(_ n: Int) -> String {
        let map: [Character: Character] = ["0":"⁰","1":"¹","2":"²","3":"³","4":"⁴","5":"⁵","6":"⁶","7":"⁷","8":"⁸","9":"⁹"]
        return String(String(n).map { map[$0] ?? $0 })
    }
}
