import SwiftUI

// MARK: - 闪卡训练会话（先回忆 → 揭晓 → 自评，逐张推进）

struct LawTrainingSessionView: View {
    let cards: [LawFlashcard]
    let title: String

    @ObservedObject private var store = LawTrainingStore.shared
    @Environment(\.dismiss) private var dismiss
    @State private var queue: [LawFlashcard] = []
    @State private var revealed = false
    @State private var done = false
    @State private var rememberedCount = 0
    @State private var fuzzyCount = 0
    @State private var forgotCount = 0

    init(cards: [LawFlashcard], title: String = "公式速记") {
        self.cards = cards
        self.title = title
    }

    var body: some View {
        Group {
            if done {
                summary
            } else if let card = queue.first {
                cardFace(card)
            } else {
                ContentUnavailableViewCompat(
                    title: "没有待训练的卡片",
                    systemImage: "checkmark.seal",
                    description: "全部卡片都在复习排期中，明天再来。"
                )
            }
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { if queue.isEmpty { queue = cards } }
    }

    // MARK: 卡片

    private func cardFace(_ card: LawFlashcard) -> some View {
        VStack(spacing: Spacing.xl) {
            // 进度
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("第 \(cards.count - queue.count + 1) / \(cards.count) 张")
                        .font(AppFont.chip).foregroundColor(.secondary)
                    Spacer()
                    TagChip(text: card.kind.label, color: card.kind.accent)
                }
                ProgressView(value: Double(cards.count - queue.count), total: Double(cards.count))
                    .tint(card.kind.accent)
            }

            // 卡面
            VStack(alignment: .leading, spacing: Spacing.lg) {
                Text(card.lawName)
                    .font(AppFont.chip).foregroundColor(.secondary)
                if revealed {
                    // 背面：答案
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        if let latex = card.latex {
                            FormulaView(latex: latex, fontSize: 22)
                        } else {
                            Text(card.answerTitle)
                                .font(.title3.bold()).foregroundColor(.primary)
                        }
                        if !card.answerBody.isEmpty {
                            Text(card.answerBody)
                                .font(AppFont.body).foregroundColor(.primary)
                                .lineSpacing(4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    // 正面：先回忆
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text(card.prompt)
                            .font(.title2.bold()).foregroundColor(.primary)
                            .lineSpacing(4)
                        Label("先在脑中回忆，再翻面核对", systemImage: "brain")
                            .font(AppFont.caption).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardSurface()
            .animation(.easeInOut(duration: 0.25), value: revealed)

            Spacer(minLength: 0)

            // 操作区
            if revealed {
                VStack(spacing: Spacing.sm) {
                    Text("这道卡你掌握得如何？").font(AppFont.caption).foregroundColor(.secondary)
                    HStack(spacing: Spacing.sm) {
                        gradeButton("忘了", icon: "arrow.counterclockwise", color: .apexDanger) {
                            store.grade(card); advance(.forgot)
                        }
                        gradeButton("模糊", icon: "questionmark.circle", color: .apexGold) {
                            store.grade(card, fuzzy: true); advance(.fuzzy)
                        }
                        gradeButton("记牢了", icon: "checkmark.circle.fill", color: .apexEmerald) {
                            store.grade(card, remembered: true); advance(.remembered)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) { revealed = true }
                } label: {
                    Label("显示答案", systemImage: "eye.fill")
                        .font(.headline).foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.md)
                        .background(Color.apexLava)
                        .cornerRadius(Radius.inner)
                }
            }
        }
        .padding(Spacing.lg)
    }

    private func gradeButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title3)
                Text(title).font(AppFont.chip)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.sm)
            .background(color.opacity(0.12))
            .cornerRadius(Radius.inner)
        }
        .buttonStyle(.plain)
    }

    private enum GradeResult { case remembered, fuzzy, forgot }

    private func advance(_ grade: GradeResult) {
        switch grade {
        case .remembered: rememberedCount += 1
        case .fuzzy: fuzzyCount += 1
        case .forgot: forgotCount += 1
        }
        queue.removeFirst()
        withAnimation(.easeInOut(duration: 0.25)) { revealed = false }
        if queue.isEmpty { done = true }
    }

    // MARK: 结算页

    private var summary: some View {
        VStack(spacing: Spacing.xl) {
            Image(systemName: "rectangle.stack.fill")
                .font(.system(size: 48)).foregroundColor(.apexLava)
            Text("本轮训练完成").font(.title2.bold()).foregroundColor(.primary)

            HStack(spacing: Spacing.lg) {
                summaryBlock(value: "\(rememberedCount)", label: "记牢", color: .apexEmerald)
                summaryBlock(value: "\(fuzzyCount)", label: "模糊", color: .apexGold)
                summaryBlock(value: "\(forgotCount)", label: "忘了", color: .apexDanger)
            }

            Text("记牢的卡片将按 1 / 3 / 7 / 14 天间隔自动排期复习")
                .font(AppFont.caption).foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Spacer(minLength: 0)

            Button {
                dismiss()
            } label: {
                Text("完成")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Spacing.md)
                    .background(Color.apexLava)
                    .cornerRadius(Radius.inner)
            }
        }
        .padding(Spacing.lg)
    }

    private func summaryBlock(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value).font(AppFont.bigStat(28)).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.md)
        .cardSurface()
    }
}
