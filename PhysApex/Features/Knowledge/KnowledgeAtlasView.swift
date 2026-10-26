import SwiftUI

// MARK: - 考点训练：按掌握度顺序推进的关卡队列
//
// 合规约定（改动前先读）：这一页曾经是「模块 → 章节 → 知识点」的三级可展开树，
// 一次能翻完全部几十个考点名 + 本质说明 + 公式 + 易错点——整屏就是一本教材的目录，
// 是判定「含书籍杂志内容」最典型的一屏。
// 现在改成队列：只露出紧邻的若干个待练考点，点进去直接做题；过关的只以进度呈现，
// 不再提供任何"从头翻到尾"的浏览形态。想加回列表前，先想清楚会不会把"查资料"的观感带回来。

struct KnowledgeAtlasView: View {
    @ObservedObject private var mastery = ProblemMasteryManager.shared
    private let modules = KnowledgeAtlas.modules

    private struct QueueItem: Identifiable {
        let id: String
        let moduleName: String
        let index: Int
        let point: KnowledgePoint
    }

    /// 全部考点按模块声明顺序铺平（不再渲染树，只用于排序与计数）。
    private var queue: [QueueItem] {
        var result: [QueueItem] = []
        for module in modules {
            for point in module.chapters.flatMap(\.points) {
                result.append(QueueItem(id: point.id, moduleName: module.name,
                                    index: result.count + 1, point: point))
            }
        }
        return result
    }

    private var pending: [QueueItem] {
        queue.filter { stage in
            guard let pid = stage.point.problemId else { return false }
            return !mastery.isMastered(pid)
        }
    }

    private var passedCount: Int { queue.count - pending.count }

    var body: some View {
        List {
            Section { progressHeader }

            Section {
                ForEach(Array(pending.prefix(batchSize))) { stage in
                    if let problem = ProblemBank.all.first(where: { $0.id == stage.point.problemId }) {
                        NavigationLink { ProblemDetailView(problem: problem) } label: {
                            stageRow(stage)
                        }
                    }
                }
            } header: {
                Text(pending.isEmpty ? "全部过关" : "本批待练 \(min(pending.count, batchSize)) 关")
            } footer: {
                Text("练完本批自动推进到下一批；过关判定以该题的掌握度为准。")
                    .font(AppFont.caption)
            }
        }
        .navigationTitle("考点训练")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let batchSize = 5

    // MARK: 进度

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("升学物理 · 考点训练")
                .font(.system(size: 17, weight: .black, design: .rounded))
                .foregroundColor(.primary)
            Text("已过关 \(passedCount) / \(queue.count) 关")
                .font(AppFont.caption).foregroundColor(.secondary)
            ProgressView(value: Double(passedCount), total: Double(max(queue.count, 1)))
                .tint(.apexLava)
        }
        .padding(.vertical, Spacing.sm)
    }

    // MARK: 关卡行

    private func stageRow(_ stage: QueueItem) -> some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Circle().fill(stage.point.stage.color).frame(width: 6, height: 6).padding(.top, 6)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(stage.moduleName) · 第 \(stage.index) 关")
                    .font(AppFont.chip).foregroundColor(.secondary)
                Text(stage.point.name).font(AppFont.body).foregroundColor(.primary)
                if let pitfall = stage.point.pitfall {
                    Text(pitfall).font(AppFont.caption).foregroundColor(.apexDanger).lineLimit(2)
                }
            }
            Spacer()
            Text("去练习").font(AppFont.chip).foregroundColor(.apexLava)
        }
        .padding(.vertical, 6)
    }
}
