import SwiftUI

// MARK: - 物理巨人

struct GiantsView: View {
    private let giants = GiantsData.all

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                ForEach(giants) { giant in
                    NavigationLink { GiantDetailView(giant: giant) } label: {
                        giantCard(giant)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("物理巨人")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func giantCard(_ g: PhysicsGiant) -> some View {
        VStack(spacing: Spacing.sm) {
            Text(g.portraitEmoji).font(.system(size: 44))
            Text(g.name).font(AppFont.cardTitle).foregroundColor(.primary)
            Text(g.era).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(Color.apexCardSurface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}

struct GiantDetailView: View {
    let giant: PhysicsGiant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // 头部
                VStack(spacing: Spacing.sm) {
                    Text(giant.portraitEmoji).font(.system(size: 72))
                    Text(giant.name).font(.title2).bold()
                    Text("\(giant.nameEN) · \(giant.era)")
                        .font(AppFont.caption).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)

                // 属性雷达（条形）
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "能力", systemImage: "chart.bar.fill", accent: .apexStarBlue)
                    attrBar("洞察力", giant.attributes.insight, .apexStarBlue)
                    attrBar("创造力", giant.attributes.creativity, .apexLava)
                    attrBar("毅力", giant.attributes.perseverance, .apexEmerald)
                    attrBar("影响力", giant.attributes.influence, .apexGold)
                }
                .cardSurface()

                // 金句
                Label(giant.famousQuote, systemImage: "quote.opening")
                    .font(.body.italic()).foregroundColor(.apexMystery)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface()

                // 传奇
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "传奇", systemImage: "book.fill", accent: .apexGold)
                    Text(giant.legendStory).font(.body).foregroundColor(.primary)
                }
                .cardSurface()

                // 招牌技
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "招牌技", systemImage: "wand.and.stars", accent: .apexLava)
                    FlowLayout(spacing: 8) {
                        ForEach(giant.weaponSkills, id: \.self) { s in
                            TagChip(text: s, color: .apexLava)
                        }
                    }
                }
                .cardSurface()
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(giant.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func attrBar(_ label: String, _ value: Int, _ color: Color) -> some View {
        HStack(spacing: Spacing.sm) {
            Text(label).font(AppFont.caption).foregroundColor(.secondary).frame(width: 48, alignment: .leading)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(color.opacity(0.15))
                    Capsule().fill(color).frame(width: geo.size.width * CGFloat(value) / 10)
                }
            }
            .frame(height: 8)
            Text("\(value)").font(AppFont.chip).foregroundColor(color).frame(width: 20)
        }
    }
}
