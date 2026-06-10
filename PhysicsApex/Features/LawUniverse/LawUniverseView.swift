import SwiftUI

// MARK: - 定律宇宙：定律含 物理意义 + 适用条件 + 量纲 + 常见误用

struct LawUniverseView: View {
    private var topics: [PhysicsTopic] {
        PhysicsTopic.allCases.filter { !LawLibrary.laws(for: $0).isEmpty }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(topics) { topic in
                    Section(topic.name) {
                        ForEach(LawLibrary.laws(for: topic)) { law in
                            NavigationLink { LawDetailView(law: law) } label: {
                                lawRow(law)
                            }
                        }
                    }
                }
            }
            .navigationTitle("定律宇宙")
        }
    }

    private func lawRow(_ law: PhysicsLaw) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(law.name).font(AppFont.cardTitle).foregroundColor(.primary)
                Spacer()
                TagChip(text: law.stage.shortTitle, color: law.stage.color)
            }
            Text(law.expression).font(.system(.subheadline, design: .monospaced)).foregroundColor(.apexLava)
        }
        .padding(.vertical, 2)
    }
}

struct LawDetailView: View {
    let law: PhysicsLaw

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                // 表达式 + 量纲
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text(law.expression)
                        .font(.system(.title3, design: .monospaced))
                        .foregroundColor(.apexLava)
                    HStack(spacing: 6) {
                        Image(systemName: "ruler").foregroundColor(.secondary)
                        Text("量纲 / 单位：\(law.dimension)")
                            .font(AppFont.caption).foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface()

                block(title: "物理意义", icon: "brain.head.profile", accent: .apexStarBlue) {
                    Text(law.meaning).font(.body).foregroundColor(.primary)
                }

                listBlock(title: "适用条件", icon: "checkmark.seal.fill", accent: .apexEmerald, items: law.conditions)
                listBlock(title: "常见误用", icon: "xmark.octagon.fill", accent: .apexDanger, items: law.commonMisuses)
                listBlock(title: "高考应用", icon: "graduationcap.fill", accent: .apexGold, items: law.applications)

                if !law.relatedWeapons.isEmpty {
                    block(title: "关联武器", icon: "wand.and.stars", accent: .apexMystery) {
                        FlowLayout(spacing: 8) {
                            ForEach(law.relatedWeapons) { w in
                                TagChip(text: w.name, color: .apexMystery)
                            }
                        }
                    }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(law.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func block<Content: View>(title: String, icon: String, accent: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: accent)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private func listBlock(title: String, icon: String, accent: Color, items: [String]) -> some View {
        block(title: title, icon: icon, accent: accent) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 6) {
                        Image(systemName: "circle.fill").font(.system(size: 5)).foregroundColor(accent).padding(.top, 6)
                        Text(item).font(AppFont.body).foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
