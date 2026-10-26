import XCTest
@testable import PhysApex

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

    /// 付费策略钉死：$5.99 买断对应的免费档配置（改价格策略时有意识地更新此测试）。
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

    // MARK: 训练型文案（国内审核合规守门）
    //
    // 背景：App 曾因被判定「包含或访问书籍或杂志内容」而卡在 Guideline 2.1 的出版许可上。
    // 命中形态就是"成段正文 + 目录式浏览"。这两条测试守的是"上屏文案的形态"，
    // 比事后改文案可靠——文案一旦变长，先在 CI 里报错。
    // 现在中国大陆已从销售地区移除（仅港澳台），但形态守门继续保留：
    // 一是下一次版本更新仍会被重新抽查，二是形态本身也是产品定位。

    /// 全部闪卡正文必须是训练型短句：单段 ≤ answerLimit+1，分点清单逐条 ≤ bulletLimit+3。
    /// 两种形态各走各的上限——用 -1 的总长上限去卡分点清单（或反过来）只会永远误报。
    /// 公式类卡片（kind == .expression）的主答案免疫——公式被截断是正确性事故，不是文案问题。
    func testFlashcardCopyStaysShort() {
        let cards = LawFlashcardFactory.all
        XCTAssertFalse(cards.isEmpty, "闪卡工厂没有产出任何卡片")

        for card in cards {
            let lines = card.answerBody.split(separator: "\n", omittingEmptySubsequences: false)
            if lines.count > 1 {
                for line in lines {
                    XCTAssertLessThanOrEqual(line.count, TrainingCopy.bulletLimit + 3,
                                             "卡片 \(card.id) 分点过长（\(line.count) 字）：\(line)")
                }
            } else {
                XCTAssertLessThanOrEqual(card.answerBody.count, TrainingCopy.answerLimit + 1,
                                         "卡片 \(card.id) 正文过长（\(card.answerBody.count) 字）：\(card.answerBody)")
            }
            if card.kind != .expression {
                XCTAssertLessThanOrEqual(card.answerTitle.count, TrainingCopy.titleLimit + 1,
                                         "卡片 \(card.id) 主答案过长（\(card.answerTitle.count) 字）：\(card.answerTitle)")
            }
        }
    }

    /// 定律模型只允许出现会被训练界面消费的字段。
    ///
    /// 背景：nameEN / derivation / applications / relatedWeapons 四个字段零渲染却各带一整套
    /// 词条级文案，40 条堆起来让数据包像一部工具书——已整体删除。加回静态知识型字段会直接
    /// 走到「苦劳式扫描」的靶心，这条测试先把门堵上。
    func testLawModelHasOnlyTrainingFields() {
        let allowed: Set<String> = ["id", "name", "topic", "stage", "expression", "dimension",
                                    "physicalImage", "meaning", "limitChecks", "conditions",
                                    "commonMisuses", "latex"]
        for law in LawLibrary.all {
            let fields = Set(Mirror(reflecting: law).children.compactMap(\.label))
            let extra = fields.subtracting(allowed)
            XCTAssertTrue(extra.isEmpty, "定律 \(law.id) 出现非训练字段: \(extra)")
        }
    }

    /// 内容数据里不得出现"出版类""军事类"与"大陆考试专属"措辞——靠人眼扫容易漏。
    /// 「高考」在列是因为销售地区已不含中国大陆（仅港澳台），App 内统一用「升学考 / 升学物理」。
    func testContentAvoidsSensitiveWording() {
        let banned = ["图书", "杂志", "电子书", "阅读器", "出版", "资料库", "读物", "教材", "书籍",
                      "纵览", "全景", "路线图", "知识体系", "大全", "词条", "手册", "速查",
                      "铀弹", "氢弹", "核弹", "破坏力", "秒杀", "打击", "高考"]

        var corpus: [String] = []
        for law in LawLibrary.all {
            corpus += [law.name, law.expression, law.dimension,
                       law.physicalImage, law.meaning]
            corpus += law.conditions + law.commonMisuses
            corpus += law.limitChecks.flatMap { [$0.scenario, $0.result, $0.intuition] }
        }
        for module in KnowledgeAtlas.modules {
            for chapter in module.chapters {
                corpus.append(chapter.name)
                for point in chapter.points {
                    corpus.append(point.name)
                    corpus.append(point.essence)
                    if let formula = point.formula { corpus.append(formula) }
                    if let pitfall = point.pitfall { corpus.append(pitfall) }
                }
            }
        }

        for word in banned {
            let hits = corpus.filter { $0.contains(word) }
            XCTAssertTrue(hits.isEmpty, "内容数据出现敏感词「\(word)」共 \(hits.count) 处，例：\(hits.prefix(3))")
        }
    }

    /// 定价口径：销售地区为港澳台，ASC 定价基准为美元，兜底展示价不能再用人民币。
    func testPriceFallbackUsesUSDBaseline() {
        XCTAssertTrue(PurchaseManager.fallbackPriceDisplay.hasPrefix("$"),
                      "兜底价应为美元口径，当前：\(PurchaseManager.fallbackPriceDisplay)")
        XCTAssertFalse(PurchaseManager.fallbackPriceDisplay.contains("¥"),
                       "兜底价不应出现人民币符号：\(PurchaseManager.fallbackPriceDisplay)")
    }

    /// TrainingCopy 的裁剪行为：在标点处断开、补省略号、不越界。
    func testTrainingCopyClipsAtBoundary() {
        XCTAssertEqual(TrainingCopy.concise("动量守恒", limit: 20), "动量守恒")

        let long = "力不是「维持」运动的，而是「改变」运动的——踢一脚球，球变速；不踢，它就匀速跑下去。"
        let clipped = TrainingCopy.concise(long, limit: 20)
        XCTAssertLessThanOrEqual(clipped.count, 21, "裁剪后仍超长：\(clipped)")
        XCTAssertTrue(clipped.hasSuffix("…"), "裁剪后应补省略号：\(clipped)")
        XCTAssertFalse(clipped.contains("匀速跑下去"), "裁剪后仍带着后半段：\(clipped)")

        let bullets = TrainingCopy.bullets(["把「有力」当成「有速度」——其实力对应的是加速度"])
        for line in bullets.split(separator: "\n") {
            XCTAssertLessThanOrEqual(line.count, TrainingCopy.bulletLimit + 3, "分点过长：\(line)")
        }
    }
}
