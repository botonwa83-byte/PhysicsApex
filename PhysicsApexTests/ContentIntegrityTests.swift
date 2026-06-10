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
}
