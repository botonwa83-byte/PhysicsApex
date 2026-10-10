import SwiftUI

// MARK: - 每日一题（习惯钩子）：每天确定性推一道题，做完即记连击

enum DailyChallenge {
    /// 当天的题（按一年中的第几天确定，全天不变）。从免费档选，保证人人能做。
    static var today: PhysicsProblem {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let pool = ProblemBank.freeProblems.isEmpty ? ProblemBank.all : ProblemBank.freeProblems
        return pool[day % max(pool.count, 1)]
    }

    /// 今天是否已完成（复用练习记录，不新增持久化）。
    static func isDoneToday(_ problemId: String) -> Bool {
        PracticeManager.shared.records.contains {
            $0.problemId == problemId && Calendar.current.isDateInToday($0.timestamp)
        }
    }
}

struct DailyChallengeView: View {
    @ObservedObject private var practice = PracticeManager.shared

    private var problem: PhysicsProblem { DailyChallenge.today }
    private var done: Bool { DailyChallenge.isDoneToday(problem.id) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                hero
                previewCard
                NavigationLink { ProblemDetailView(problem: problem) } label: {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: done ? "arrow.counterclockwise" : "play.fill")
                        Text(done ? "再做一次" : "开始挑战").fontWeight(.bold)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline).foregroundColor(.white)
                    .padding(.vertical, 14).padding(.horizontal, Spacing.lg)
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(colors: [.apexLava, .apexGold], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(Radius.card)
                }
                .buttonStyle(.plain)
            }
            .padding(Spacing.lg)
        }
        .background(Color.apexBackground.ignoresSafeArea())
        .navigationTitle("每日一题")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("今日一题").font(.system(size: 20, weight: .black, design: .rounded)).foregroundColor(.white)
                Spacer()
                if done {
                    Label("已完成", systemImage: "checkmark.seal.fill")
                        .font(AppFont.chip).foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.white.opacity(0.2)).clipShape(Capsule())
                }
            }
            Text(dateText).font(AppFont.caption).foregroundColor(.white.opacity(0.9))
            Text(done ? "今天的挑战已完成，明天再来 👍" : "每天一道精选秒杀题，校准手感、攒连击。")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.xl)
        .background(LinearGradient(colors: [Color.apexLava, Color.apexGold],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(Radius.hero)
    }

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack(spacing: 6) {
                TagChip(text: problem.stage.shortTitle, color: problem.stage.color)
                TagChip(text: problem.topic.name, color: .apexStarBlue)
                if problem.dualSolution != nil { TagChip(text: "可秒杀", color: .apexLava) }
                Spacer()
                Text("难度 \(Int(problem.difficulty * 100))").font(AppFont.chip).foregroundColor(.secondary)
            }
            Text(problem.content).font(.body).foregroundColor(.primary).lineLimit(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardSurface()
    }

    private var dateText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M 月 d 日 EEEE"
        return f.string(from: Date())
    }
}
