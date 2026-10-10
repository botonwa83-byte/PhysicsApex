import SwiftUI

// MARK: - 三级重访（物理专属创新）：同一情境，初中/高中/竞赛三镜头切换

struct RevisitView: View {
    @ObservedObject private var purchase = PurchaseManager.shared
    @State private var showPaywall = false
    private let revisits = RevisitData.all

    private func isLocked(_ index: Int) -> Bool {
        !purchase.isUnlocked && index >= PurchaseManager.freeRevisitCount
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                intro
                ForEach(Array(revisits.enumerated()), id: \.element.id) { idx, r in
                    if isLocked(idx) {
                        Button { showPaywall = true } label: {
                            ZStack {
                                RevisitCard(revisit: r).blur(radius: 5).disabled(true)
                                VStack(spacing: 6) {
                                    Image(systemName: "lock.fill").font(.title2).foregroundColor(.stageOlympiad)
                                    Text("解锁查看").font(AppFont.chip).foregroundColor(.stageOlympiad)
                                }
                                .padding(Spacing.md).background(.ultraThinMaterial).cornerRadius(Radius.inner)
                            }
                        }
                        .buttonStyle(.plain)
                    } else {
                        RevisitCard(revisit: r)
                    }
                }
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("三级重访")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("同一道题，三级重访")
                .font(AppFont.cardTitle).foregroundColor(.primary)
            Text("一个物理情境，用初中 / 高中 / 竞赛三个镜头看——亲眼看着解题工具一级级「升维」。这是物理独有的层次感。")
                .font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.lg)
        .background(
            LinearGradient(colors: [Color.stageJunior.opacity(0.15), Color.stageOlympiad.opacity(0.12)],
                           startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(Radius.hero)
    }
}

private struct RevisitCard: View {
    let revisit: TripleRevisit
    @State private var stage: Stage = .junior

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // 情境
            HStack(spacing: Spacing.sm) {
                Text(revisit.emoji).font(.title)
                Text(revisit.scenario).font(AppFont.cardTitle).foregroundColor(.primary)
            }

            // 段位切换
            Picker("段位", selection: $stage) {
                ForEach(Stage.allCases) { Text("\($0.emoji) \($0.shortTitle)").tag($0) }
            }
            .pickerStyle(.segmented)

            // 当前镜头
            if let lens = revisit.lens(for: stage) {
                lensView(lens)
                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                            removal: .opacity))
                    .id(lens.id)
            }
        }
        .animation(.easeInOut(duration: 0.28), value: stage)
        .cardSurface()
    }

    private func lensView(_ lens: RevisitLens) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            field("问", lens.question, .primary)
            field("解", lens.approach, .secondary)
            field("果", lens.result, .secondary)

            if let w = lens.weapon {
                HStack(spacing: 6) {
                    Image(systemName: w.icon).font(.caption)
                    Text(w.name).font(AppFont.chip)
                }
                .foregroundColor(lens.stage.color)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(lens.stage.color.opacity(0.15))
                .clipShape(Capsule())
            }

            Label(lens.insight, systemImage: "lightbulb.fill")
                .font(AppFont.caption).foregroundColor(.apexGold)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .background(lens.stage.color.opacity(0.08))
        .cornerRadius(Radius.inner)
    }

    private func field(_ tag: String, _ text: String, _ color: Color) -> some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Text(tag)
                .font(AppFont.chip).foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(stage.color).clipShape(Circle())
            Text(text).font(AppFont.body).foregroundColor(color)
        }
    }
}
