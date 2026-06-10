import SwiftUI

// MARK: - 单位 / 量纲训练

struct DimensionTrainingView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                header

                // 用量纲推公式（招牌）
                VStack(alignment: .leading, spacing: Spacing.md) {
                    SectionHeader(title: "用量纲推公式", systemImage: "wand.and.stars", accent: .apexLava)
                    Text("不推导，靠量纲配平直接「猜」出公式形式——物理学家的偷懒神技。")
                        .font(AppFont.caption).foregroundColor(.secondary)
                    ForEach(DimensionData.derivations) { d in
                        NavigationLink { DeriveDetailView(derivation: d) } label: { deriveCard(d) }
                            .buttonStyle(.plain)
                    }
                }

                // 量纲速查
                VStack(alignment: .leading, spacing: Spacing.md) {
                    SectionHeader(title: "量纲速查", systemImage: "ruler", accent: .apexStarBlue)
                    ForEach(DimensionData.quantities) { q in quantityCard(q) }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("单位 / 量纲")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("量纲——物理的隐藏密码")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text("每个物理量都能拆成质量 M、长度 L、时间 T（和电流 I）。看懂量纲，能查错、能估算、甚至能直接猜出公式。")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexStarBlue, Color.apexEmerald],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }

    private func deriveCard(_ d: DimensionDerivation) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "function").font(.title3).foregroundColor(.apexLava).frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text("求 \(d.target)").font(AppFont.cardTitle).foregroundColor(.primary)
                Text("只靠量纲，推出 \(d.result)").font(AppFont.caption).foregroundColor(.secondary).lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
        .cardSurface()
    }

    private func quantityCard(_ q: PhysicalQuantity) -> some View {
        HStack(spacing: Spacing.md) {
            VStack(spacing: 0) {
                Text(q.symbol).font(.system(.headline, design: .serif).italic()).foregroundColor(.apexStarBlue)
                Text(q.siUnit).font(.caption2).foregroundColor(.secondary)
            }
            .frame(width: 56)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(q.name).font(AppFont.cardTitle).foregroundColor(.primary)
                    Text(q.dimension).font(.system(.caption, design: .monospaced)).foregroundColor(.apexLava)
                }
                Text("\(q.breakdown) · \(q.meaning)").font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer()
        }
        .cardSurface()
    }
}

// MARK: - 量纲推公式详情（先看依赖，再揭晓配平）

struct DeriveDetailView: View {
    let derivation: DimensionDerivation
    @State private var revealed = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // 目标 + 依赖量
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("求：\(derivation.target)").font(.title3).foregroundColor(.primary)
                    Text("它只可能依赖这些量：").font(AppFont.caption).foregroundColor(.secondary)
                    ForEach(derivation.depends, id: \.self) { dep in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "circle.fill").font(.system(size: 5)).foregroundColor(.apexStarBlue).padding(.top, 6)
                            Text(dep).font(.system(.subheadline, design: .monospaced)).foregroundColor(.primary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface()

                if !revealed {
                    Button { withAnimation { revealed = true } } label: {
                        Text("用量纲配平 →").font(AppFont.cardTitle).frame(maxWidth: .infinity).padding()
                            .background(Color.apexLava).foregroundColor(.white).cornerRadius(Radius.inner)
                    }
                } else {
                    balancingCard
                    resultCard
                    Label(derivation.insight, systemImage: "lightbulb.fill")
                        .font(AppFont.caption).foregroundColor(.apexGold)
                        .frame(maxWidth: .infinity, alignment: .leading).cardSurface()
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("量纲推公式")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var balancingCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: "配平过程", systemImage: "equal.square", accent: .apexStarBlue)
            Text(derivation.setup).font(.system(.subheadline, design: .monospaced)).foregroundColor(.apexLava)
            Divider()
            ForEach(Array(derivation.balancing.enumerated()), id: \.offset) { i, line in
                HStack(alignment: .top, spacing: Spacing.sm) {
                    Text("\(i+1)").font(AppFont.chip).foregroundColor(.white)
                        .frame(width: 18, height: 18).background(Color.apexStarBlue).clipShape(Circle())
                    Text(line).font(.system(.subheadline, design: .monospaced)).foregroundColor(.primary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private var resultCard: some View {
        VStack(spacing: Spacing.sm) {
            HStack {
                Text("量纲推出").font(AppFont.caption).foregroundColor(.secondary)
                Spacer()
                Text(derivation.result).font(.system(.title3, design: .monospaced)).foregroundColor(.apexLava)
            }
            Divider()
            HStack {
                Text("真实公式").font(AppFont.caption).foregroundColor(.secondary)
                Spacer()
                Text(derivation.realFormula).font(.system(.title3, design: .monospaced)).foregroundColor(.apexEmerald)
            }
        }
        .padding(Spacing.lg)
        .background(Color.apexLava.opacity(0.08))
        .cornerRadius(Radius.card)
    }
}
