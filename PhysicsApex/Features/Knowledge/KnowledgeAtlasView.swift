import SwiftUI

// MARK: - 知识全景图：一屏纵览整个高考物理，逐点深入

struct KnowledgeAtlasView: View {
    private let modules = KnowledgeAtlas.modules

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                header
                ForEach(modules) { module in
                    ModuleCard(module: module)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("知识全景")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("高考物理 · 一图纵览")
                .font(.system(size: 18, weight: .black, design: .rounded)).foregroundColor(.white)
            Text("\(modules.count) 大模块 · \(KnowledgeAtlas.totalPoints) 个核心知识点，每点一句话本质 + 公式 + 秒杀武器")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexStarBlue, Color.apexMystery],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }
}

private struct ModuleCard: View {
    let module: KnowledgeModule
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } } label: {
                HStack(spacing: Spacing.md) {
                    Image(systemName: module.icon).font(.title3).foregroundColor(module.color)
                        .frame(width: 32)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(module.name).font(AppFont.cardTitle).foregroundColor(.primary)
                        Text("\(module.chapters.count) 章 · \(module.pointCount) 知识点").font(AppFont.caption).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.down" : "chevron.right").foregroundColor(.secondary)
                }
                .padding(Spacing.lg)
            }
            .buttonStyle(.plain)

            if expanded {
                ForEach(module.chapters) { chapter in
                    ChapterSection(chapter: chapter, accent: module.color)
                }
                .padding(.bottom, Spacing.sm)
            }
        }
        .background(Color.apexCardSurface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}

private struct ChapterSection: View {
    let chapter: KnowledgeChapter
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: chapter.icon).font(.caption).foregroundColor(accent)
                Text(chapter.name).font(AppFont.chip).foregroundColor(accent)
            }
            .padding(.horizontal, Spacing.lg)

            ForEach(chapter.points) { point in
                NavigationLink { KnowledgePointDetailView(point: point) } label: {
                    pointRow(point)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, Spacing.sm)
    }

    private func pointRow(_ p: KnowledgePoint) -> some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Circle().fill(p.stage.color).frame(width: 6, height: 6).padding(.top, 6)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(p.name).font(AppFont.body).foregroundColor(.primary)
                    if p.weapon != nil { Image(systemName: "bolt.fill").font(.system(size: 9)).foregroundColor(.apexLava) }
                    if p.lawId != nil { Image(systemName: "eye.fill").font(.system(size: 9)).foregroundColor(.apexStarBlue) }
                }
                Text(p.essence).font(AppFont.caption).foregroundColor(.secondary).lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption2).foregroundColor(.secondary.opacity(0.5))
        }
        .padding(.horizontal, Spacing.lg).padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

// MARK: - 知识点全息卡（精炼节点 + 全网互链）

struct KnowledgePointDetailView: View {
    let point: KnowledgePoint

    private var law: PhysicsLaw? { point.lawId.flatMap { id in LawLibrary.all.first { $0.id == id } } }
    private var problem: PhysicsProblem? { point.problemId.flatMap { id in ProblemBank.all.first { $0.id == id } } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                // 本质
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    TagChip(text: point.stage.shortTitle, color: point.stage.color)
                    Text(point.essence).font(.title3).foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardSurface()

                if let f = point.formula {
                    block("核心公式", "function", .apexLava) {
                        Text(f).font(.system(.title3, design: .monospaced)).foregroundColor(.apexLava)
                    }
                }

                if let pitfall = point.pitfall {
                    block("最容易踩的坑", "exclamationmark.triangle.fill", .apexDanger) {
                        Text(pitfall).font(.body).foregroundColor(.primary)
                    }
                }

                if let w = point.weapon {
                    block("秒杀武器", "bolt.fill", .apexLava) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 6) {
                                Image(systemName: w.icon).foregroundColor(.apexLava)
                                Text(w.name).font(AppFont.cardTitle).foregroundColor(.primary)
                            }
                            Text(w.tagline).font(AppFont.caption).foregroundColor(.secondary)
                        }
                    }
                }

                if let law {
                    NavigationLink { LawDetailView(law: law) } label: {
                        HStack {
                            Image(systemName: "eye.fill").foregroundColor(.apexStarBlue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("看通透卡：\(law.name)").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text("物理图像 + 来龙去脉 + 极限检验").font(AppFont.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                        .cardSurface()
                    }
                    .buttonStyle(.plain)
                }

                if let problem {
                    NavigationLink { ProblemDetailView(problem: problem) } label: {
                        HStack {
                            Image(systemName: "bolt.fill").foregroundColor(.apexLava)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("做这道典型题").font(AppFont.cardTitle).foregroundColor(.primary)
                                Text(problem.dualSolution != nil ? "含降维秒杀双解对决" : "典型例题").font(AppFont.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.secondary)
                        }
                        .cardSurface()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(point.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func block<Content: View>(_ title: String, _ icon: String, _ accent: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            SectionHeader(title: title, systemImage: icon, accent: accent)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }
}
