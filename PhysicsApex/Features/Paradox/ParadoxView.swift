import SwiftUI

// MARK: - 思维挑战

struct ParadoxView: View {
    private let paradoxes = ParadoxData.all

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.md) {
                ForEach(paradoxes) { p in
                    NavigationLink { ParadoxDetailView(paradox: p) } label: {
                        paradoxCard(p)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.mysteryBackground.ignoresSafeArea())
        .navigationTitle("思维挑战")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func paradoxCard(_ p: Paradox) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: p.category.icon).foregroundColor(p.category.color)
                Text(p.category.displayName).font(AppFont.chip).foregroundColor(p.category.color)
                Spacer()
            }
            Text(p.title).font(AppFont.cardTitle).foregroundColor(.primary)
            Text(p.hook).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.mysteryPaper)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}

struct ParadoxDetailView: View {
    let paradox: Paradox

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                HStack(spacing: 6) {
                    Image(systemName: paradox.category.icon).foregroundColor(paradox.category.color)
                    Text(paradox.category.displayName).font(AppFont.chip).foregroundColor(paradox.category.color)
                }
                Text(paradox.hook).font(.title3).bold().foregroundColor(.primary)

                block("情境", paradox.setup, "theatermasks", .apexStarBlue)
                block("矛盾在哪", paradox.theParadox, "exclamationmark.triangle.fill", .apexDanger)
                block("化解", paradox.resolution, "checkmark.seal.fill", .apexEmerald)
                block("你该记住", paradox.takeaway, "lightbulb.fill", .apexGold)
            }
            .padding(Spacing.lg)
        }
        .background(Color.mysteryBackground.ignoresSafeArea())
        .navigationTitle(paradox.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func block(_ title: String, _ body: String, _ icon: String, _ accent: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: accent)
            Text(body).font(.body).foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(Color.mysteryPaper)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}
