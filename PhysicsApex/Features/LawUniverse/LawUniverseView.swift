import SwiftUI

// MARK: - 定律宇宙：定律含 物理意义 + 适用条件 + 量纲 + 常见误用

struct LawUniverseView: View {
    private var topics: [PhysicsTopic] {
        PhysicsTopic.allCases.filter { !LawLibrary.laws(for: $0).isEmpty }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { KnowledgeAtlasView() } label: {
                        HStack(spacing: Spacing.md) {
                            Image(systemName: "map.fill").font(.title3)
                                .foregroundStyle(LinearGradient(colors: [.apexStarBlue, .apexMystery], startPoint: .top, endPoint: .bottom))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("知识路线图").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text("一图纵览整个高考物理 · \(KnowledgeAtlas.totalPoints) 个知识点").font(AppFont.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

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
                // 表达式 + 量纲（有 latex 用 KaTeX 渲染，否则回退文本）
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    if let latex = law.latex {
                        FormulaView(latex: latex, fontSize: 20)
                    } else {
                        Text(law.expression)
                            .font(.system(.title3, design: .monospaced))
                            .foregroundColor(.apexLava)
                    }
                    HStack(spacing: 6) {
                        Image(systemName: "ruler").foregroundColor(.secondary)
                        Text("量纲 / 单位：\(law.dimension)")
                            .font(AppFont.caption).foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface()

                // 🖼 物理图像（C 位，让你"看见"它）
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "物理图像", systemImage: "eye.fill", accent: .apexLava)
                    Text(law.physicalImage).font(.body).foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.lg)
                .background(LinearGradient(colors: [Color.apexLava.opacity(0.12), Color.apexGold.opacity(0.08)],
                                          startPoint: .leading, endPoint: .trailing))
                .cornerRadius(Radius.card)

                block(title: "来龙去脉", icon: "arrow.triangle.branch", accent: .apexEmerald) {
                    Text(law.derivation).font(.body).foregroundColor(.primary)
                }

                block(title: "物理意义", icon: "brain.head.profile", accent: .apexStarBlue) {
                    Text(law.meaning).font(.body).foregroundColor(.primary)
                }

                // 🎚 极限检验器（交互：点开看"啊哈"）
                if !law.limitChecks.isEmpty {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        SectionHeader(title: "极限检验器", systemImage: "slider.horizontal.below.square.filled.and.square", accent: .apexMystery)
                        Text("把变量推到极端，看公式是否符合直觉——物理学家的验真绝技")
                            .font(AppFont.caption).foregroundColor(.secondary)
                        ForEach(law.limitChecks) { check in
                            LimitCheckCard(check: check)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardSurface()
                }

                listBlock(title: "适用条件", icon: "checkmark.seal.fill", accent: .apexEmerald, items: law.conditions)
                listBlock(title: "常见迷思", icon: "xmark.octagon.fill", accent: .apexDanger, items: law.commonMisuses)
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

// MARK: - 极限检验卡（点开揭示「啊哈」）

private struct LimitCheckCard: View {
    let check: LimitCheck
    @State private var revealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // 极端情形 → 结果
            HStack(spacing: Spacing.sm) {
                Text(check.scenario)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.apexMystery)
                Image(systemName: "arrow.right").font(.caption).foregroundColor(.secondary)
                Text(check.result).font(AppFont.body).foregroundColor(.primary)
                Spacer(minLength: 0)
            }

            if revealed {
                Label(check.intuition, systemImage: "lightbulb.fill")
                    .font(AppFont.caption).foregroundColor(.apexGold)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { revealed = true }
                } label: {
                    Label("这符合直觉吗？点开看", systemImage: "hand.tap.fill")
                        .font(AppFont.caption).foregroundColor(.apexMystery)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(Color.apexMystery.opacity(0.07))
        .cornerRadius(Radius.inner)
    }
}
