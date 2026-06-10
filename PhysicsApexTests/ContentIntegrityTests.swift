import XCTest
@testable import PhysicsApex

/// 题库与内容数据的一致性守护：以前靠手工 grep 的检查全部固化在这里。
final class ContentIntegrityTests: XCTestCase {

    // MARK: 题库基础

    /// 题目 id 全库唯一。
    func testProblemIdsUnique() {
        let ids = ProblemBank.all.map(\.id)
        let dup = Dictionary(grouping: ids, by: { $0 }).filter { $1.count > 1 }.keys
        XCTAssertTrue(dup.isEmpty, "重复的题目 id: \(dup)")
    }

    /// 题库规模底线（防止批次漏注册）。
    func testBankSizeFloor() {
        XCTAssertGreaterThanOrEqual(ProblemBank.all.count, 138, "题库少于 138 题——是否有批次没注册进 all？")
        XCTAssertGreaterThanOrEqual(ProblemBank.descentCases.count, 68, "降维战例少于 68 道")
    }

    /// 每个段位、每个 topic 都有题。
    func testStageAndTopicCoverage() {
        for stage in Stage.allCases {
            XCTAssertFalse(ProblemBank.problems(for: stage).isEmpty, "段位 \(stage) 没有任何题")
        }
        for topic in PhysicsTopic.allCases {
            XCTAssertFalse(ProblemBank.problems(for: topic).isEmpty, "分类 \(topic) 没有任何题")
        }
    }

    /// 选择题的答案必须出现在选项中。
    func testMultipleChoiceAnswerInOptions() {
        for p in ProblemBank.all where p.type == .multipleChoice {
            guard let options = p.options, !options.isEmpty else {
                XCTFail("选择题 \(p.id) 没有选项"); continue
            }
            XCTAssertTrue(options.contains(p.answer), "题 \(p.id) 的答案不在选项中: \(p.answer)")
        }
    }

    // MARK: 降维双解约定

    /// timeRatio 约定范围 [2.0, 6.0]；descentMethod 的 commonMistakes 恒为空；detailedExplanation 非空。
    func testDualSolutionConventions() {
        for p in ProblemBank.descentCases {
            guard let dual = p.dualSolution else { continue }
            XCTAssertTrue((2.0...6.0).contains(dual.timeRatio), "题 \(p.id) timeRatio=\(dual.timeRatio) 越界")
            XCTAssertTrue(dual.descentMethod.commonMistakes.isEmpty, "题 \(p.id) 的 descentMethod 不应有 commonMistakes")
            XCTAssertFalse((dual.detailedExplanation ?? "").isEmpty, "题 \(p.id) 缺 detailedExplanation")
            XCTAssertFalse(dual.standardMethod.steps.isEmpty, "题 \(p.id) standardMethod 无步骤")
            XCTAssertFalse(dual.descentMethod.steps.isEmpty, "题 \(p.id) descentMethod 无步骤")
        }
    }

    // MARK: 知识全景链接

    /// 全部 50 节点的 problemId 都能在题库找到；lawId 都能在定律库找到。
    func testKnowledgeAtlasLinksResolve() {
        let problemIds = Set(ProblemBank.all.map(\.id))
        let lawIds = Set(LawLibrary.all.map(\.id))
        var linked = 0, total = 0
        for module in KnowledgeAtlas.modules {
            for chapter in module.chapters {
                for point in chapter.points {
                    total += 1
                    if let pid = point.problemId {
                        linked += 1
                        XCTAssertTrue(problemIds.contains(pid), "节点 \(point.id) 链接的题 \(pid) 不存在")
                    }
                    if let lid = point.lawId {
                        XCTAssertTrue(lawIds.contains(lid), "节点 \(point.id) 链接的定律 \(lid) 不存在")
                    }
                }
            }
        }
        XCTAssertEqual(linked, total, "知识全景应保持全链题（\(linked)/\(total)）")
    }

    // MARK: 免费档与门禁

    /// 免费档参数不越界。
    func testFreeTierValid() {
        XCTAssertGreaterThan(PurchaseManager.freeProblemCount, 0)
        XCTAssertLessThan(PurchaseManager.freeProblemCount, ProblemBank.all.count)
        XCTAssertGreaterThan(PurchaseManager.freeDescentCount, 0)
        XCTAssertLessThan(PurchaseManager.freeDescentCount, ProblemBank.descentCases.count)
        XCTAssertEqual(ProblemBank.freeProblems.count, PurchaseManager.freeProblemCount)
    }

    /// 付费策略钉死：¥22 买断对应的免费档配置（改价格策略时有意识地更新此测试）。
    func testFreeTierPolicy() {
        XCTAssertEqual(PurchaseManager.freeProblemCount, 10, "题库免费档应为前 10 题")
        XCTAssertEqual(PurchaseManager.freeDescentCount, 10, "降维战例免费档应为前 10 道")
        XCTAssertEqual(PurchaseManager.freeRevisitCount, 1)
        XCTAssertEqual(PurchaseManager.freeSandboxCount, 3)
        XCTAssertEqual(PurchaseManager.freeWeaponCount, 10)
        // 免费战例应覆盖多把不同武器（试吃的多样性）
        let freeWeapons = Set(ProblemBank.descentCases.prefix(PurchaseManager.freeDescentCount)
            .compactMap { $0.dualSolution?.weaponUsed })
        XCTAssertGreaterThanOrEqual(freeWeapons.count, 5, "前 10 道免费战例应至少覆盖 5 把武器")
    }

    // MARK: 武器库

    /// 武器战例覆盖底线：30 把武器至少 29 把有战例（forceDiagram 为有意留白）。
    func testWeaponCoverage() {
        let used = Set(ProblemBank.descentCases.compactMap { $0.dualSolution?.weaponUsed })
        let uncovered = Set(PhysicsWeapon.allCases).subtracting(used)
        XCTAssertTrue(uncovered.isSubset(of: [PhysicsWeapon.forceDiagram]),
                      "除 forceDiagram 外不应有武器零战例，当前缺: \(uncovered.map(\.rawValue))")
    }

    /// 竞赛段题量底线（付费钩子不空心）。
    func testOlympiadContentFloor() {
        XCTAssertGreaterThanOrEqual(ProblemBank.problems(for: .olympiad).count, 15, "竞赛段题目过少")
    }

    // MARK: 亲民层（说人话）

    /// 30 把武器都要有生活类比和触发信号；免费档战例必须配 plainTalk（学生第一眼看到的内容必须看得懂）。
    func testPlainTalkLayer() {
        for w in PhysicsWeapon.allCases {
            XCTAssertFalse(w.analogy.isEmpty, "武器 \(w.rawValue) 缺生活类比")
            XCTAssertGreaterThanOrEqual(w.signals.count, 2, "武器 \(w.rawValue) 触发信号少于 2 条")
        }
        for p in ProblemBank.descentCases {
            XCTAssertFalse((p.dualSolution?.plainTalk ?? "").isEmpty, "战例 \(p.id) 缺 plainTalk（说人话层须全量覆盖）")
        }
    }

    // MARK: KaTeX

    /// 全部定律应配 latex；katex 离线资源必须打进包（FormulaView 依赖）。
    func testLawLatexAndKatexBundle() {
        for law in LawLibrary.all {
            XCTAssertFalse((law.latex ?? "").isEmpty, "定律 \(law.id) 缺 latex")
        }
        XCTAssertNotNil(Bundle.main.url(forResource: "katex.min", withExtension: "css", subdirectory: "katex"),
                        "katex.min.css 未打进 App Bundle 的 katex 目录")
        XCTAssertNotNil(Bundle.main.url(forResource: "katex.min", withExtension: "js", subdirectory: "katex"),
                        "katex.min.js 未打进 App Bundle 的 katex 目录")
    }
}
