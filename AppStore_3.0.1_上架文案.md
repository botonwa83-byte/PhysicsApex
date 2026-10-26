# PhysApex 3.0.1 上架文案

> **销售地区：中国香港 / 中国澳门 / 中国台湾（已取消中国大陆）**
> 配套：`AppStore_3.0.1_提交操作清单.md`（ASC 操作步骤）、`AppStore_2.1_回复文案.md`（已改为「已移除中国大陆」口径）。

## 版本信息

App 名称：PhysApex
Bundle ID：com.physicsapex.app（沿用现有 App 记录，作为 3.0.1 升级提交）
版本号：3.0.1
构建号：3（`3.0.0 (1)` / `3.0.0 (2)` 已用过，构建号继续顺延，避免 ASC 报"该构建已存在"）
**本次要解决的问题**：3.0.0 已上架，但内购 `com.physicsapex.app.full_unlock` **从未随版本提交审核**——用户打开付费墙时商品查询返回空数组，价格显示不出来、点购买无响应。3.0.0 版本记录已处于"已发售"状态，无法再往里挂内购，因此本次以 3.0.1 升级提交，把内购一并带上审核。

**本次改动**：

- **内购随版本提审**：`com.physicsapex.app.full_unlock` 一次性买断，基准货币美元，基准价 **USD 5.99**。
- **解锁方式统一**：全 App 只有一个付费墙 `PaywallView` 和一个调度器 `PaywallPresenter`（唯一 .sheet 挂载点在 App 根视图）。常驻入口是首页置顶横幅 +「更多」页卡片；此外**任何被锁住的内容卡片 / 题目行 / 沙盘行，点一下就地弹出同一个付费墙**。锁态视觉统一为金色皇冠 +「解锁完整版」角标 + 半透明。
- **修复"满屏锁"**：免费档判定从「全局前 10 题」改为「当前列表前 10 题」。段位页 / 章节页是过滤后的子集，旧口径下那两页一题都不免费，用户满眼都是锁。

**销售地区（本次决策）**：仅保留 **中国香港、中国澳门、中国台湾**，**取消中国大陆**。
原因：Guideline 2.1 的中国大陆出版许可闸门对未持证的开发者是结构性死路（申请主体须为出版单位），与其反复被模板复述卡住整个版本，先把港澳台华语市场跑起来。详见 `AppStore_2.1_出版许可_应对方案.md` 路线 C。

**术语口径（本次决策）**：App 内与商店文案一律用「升学物理 / 升学考」，不再出现「高考」。
题库内容与知识点骨架不动，只改措辞；守门测试已把「高考」纳入禁词表（`ContentIntegrityTests.testContentAvoidsSensitiveWording`）。

**定价口径（本次决策）**：ASC 定价基准货币为**美元**，内购 `com.physicsapex.app.full_unlock` 基准价 **USD 5.99**；代码兜底展示价同步为 `$5.99`（`PurchaseManager.fallbackPriceDisplay`）。价格只有这一处基准，App 内展示一律读商品真实价，取不到才用兜底价。

## 第四轮：针对「含书籍/杂志内容」定性的结构性收敛（本次）

> 背景：2026-10-21 苹果回函升级为 **Guideline 5. Legal + 中国大陆下架通知**，并明示
> **即使未勾选中国大陆，App 仍在中国区不可用、TestFlight 在中国亦失效**。
> 结论：**「取消中国大陆供货」这条路不成立**，不再依赖它；本轮改为从产品形态上把"可翻阅的知识集合"整个拿掉。

本轮已完成的形态收敛：

| 收敛项 | 改前形态 | 改后形态 |
|---|---|---|
| 定律数据包 | 40 条 × (英文名 / 来龙去脉 / 应用场景 / 关联方法)，零界面渲染的静态词条文案 | 四个字段与其全部 160 条数据删除，只留闪卡会消费的字段；守门测试 `testLawModelHasOnlyTrainingFields` |
| 公式速记首页 | 按分类分组罗列 40 条定律名 + 公式的术语索引 | 只有训练入口：今日到期训练 / 薄弱优先 / 随机抽练 / 全部重刷 / 考点训练，无逐条翻阅 |
| 考点闯关 | 模块→章节→考点 三级展开树，一屏翻完几十个考点名、本质、公式、易错点 | 关卡队列：只露当前待练的 5 关，过关只以进度呈现，点开即做题 |
| 解析长正文 | `plainTalk` / `detailedExplanation` 150–250 字整段铺满屏幕 | 新增逐句点开组件 `SentenceReveal`，一次放一句，用户点"再放一句"才继续 |

文案层面同步：修正「说人话 · 为什么能秒」→「为什么更快」（秒杀改制的漏网字）。

## 本次改进点

- 应用更名为 PhysApex，定位全面收敛为「升学物理刷题与公式记忆训练工具」。
- 彻底移除全部叙事型模块，App 内不再存在任何成段阅读型页面，所有知识呈现均为问答式交互。
- 原「定律宇宙」板块改造为「公式速记」：全部改为"先回忆 → 再揭晓 → 自评掌握度"的闪卡训练交互，配合 1/3/7/14 天间隔复习排期。
- 解锁入口统一：仅保留「降维快解」页与「我的」页两处入口，两处共用同一个付费墙（价格 + 购买 + 恢复，一屏完成）；商品未就绪时点击购买会现场重试加载，并显示明确提示。
- 全部界面文案统一为训练型表述，并清除了所有武力、军事色彩用词。
- 界面去掉全部「知识全景」「一图纵览」「知识路线图」式措辞，改为「考点闯关」口径：模块=关卡组、考点=关，每关显示过关状态（掌握度驱动），不再呈现"目录式"的章节树。
- 闪卡正反面正文一律短句化（新增 TrainingCopy 工具）：所有成段解释先裁成训练型短句再上屏，卡面正文硬限 4 行，任一屏都不再出现连续成段正文。
- **销售地区收敛为港澳台，考试定位统一为中性表述「升学物理 / 升学考」，定价基准改为美元。**
- 商店元数据同步重写，明确"互动训练工具，非资料类产品"的定位。

## ASC「新功能」粘贴区（What's New，用户可见，已自检无敏感词）

PhysApex 3.0.1 —— 全面聚焦"练"。

- 全新「公式速记」：先回忆、再揭晓、自己评掌握度，按记忆曲线安排复习。
- 界面全面改版：功能更聚焦，逐题作答、翻卡自测、拖动参数观察运动，每一步都是动手训练。
- 解锁更简单：一次买断，入口直达，购买体验更顺畅。
- 交互与表述全面统一为训练型风格。

本应用为互动训练工具：全部练习与解析均为原创训练素材，逐题交互作答，每一屏都是动手训练。

## 简体中文（默认语言）

### App Store 副标题

升学物理刷题与公式记忆训练

### App Store 简短宣传语

刷题练直觉，闪卡记公式，模拟看物理。

### App Store 描述

PhysApex 是一款面向升学物理备考的互动训练工具。它的每一屏都是"动手做"：逐题作答、翻卡自测、拖动参数观察运动——一台帮你练出题感和公式记忆的随身训练器。

核心功能：

- 分层刷题：按初中直觉、升学主线、竞赛降维组织训练路径，逐题作答即时反馈。
- 降维快解训练：同一道题对比常规法与高效法，训练考场识局能力。
- 公式速记闪卡：先回忆、再揭晓、自己评掌握度，按记忆曲线自动排期复习。
- 互动模拟沙盘：拖动参数，看抛体、碰撞、振动、电路等过程实时变化。
- 错题本与智能复习：答错自动收录，按艾宾浩斯间隔安排复盘。
- 三级重访：同一情境用初中、高中、竞赛三级工具重新分析，逐级升维。

所有练习题、解析与闪卡均为本应用原创训练素材，全部通过交互式作答完成，每一屏都是动手训练。

适合人群：

- 正在系统刷题备考升学物理的学生。
- 想用闪卡快速记住公式和适用条件的学习者。
- 希望通过可视化模拟理解物理过程的用户。

付费说明：

PhysApex 提供一次性完整功能解锁。购买后可使用全部分层练习、全部快解训练、全部闪卡卡组、全部互动模拟和全部三级重访。无订阅，无自动续费。更换设备后可使用同一 Apple ID 恢复购买。

### 关键词

物理,升学物理,刷题,公式记忆,闪卡,错题本,间隔复习,压轴题,物理练习,模拟实验,解题训练,力学,电磁学

## 繁體中文（香港 / 台灣）— 強烈建議提交

> 港澳台店面以繁中為主，只給簡中會明顯吃虧。ASC → App 資訊 → 本地化資訊，新增語言 **繁體中文**。

### App Store 副標題

升學物理刷題與公式記憶訓練

### App Store 描述

PhysApex 是一款面向升學物理備考的互動訓練工具。它的每一屏都是「動手做」：逐題作答、翻卡自測、拖動參數觀察運動——一台幫你練出題感和公式記憶的隨身訓練器。

核心功能：

- 分層刷題：按初中直覺、升學主線、競賽降維組織訓練路徑，逐題作答即時反饋。
- 降維快解訓練：同一道題對比常規法與高效法，訓練考場識局能力。
- 公式速記閃卡：先回憶、再揭曉、自己評掌握度，按記憶曲線自動排期複習。
- 互動模擬沙盤：拖動參數，看拋體、碰撞、振動、電路等過程即時變化。
- 錯題本與智能複習：答錯自動收錄，按艾賓浩斯間隔安排復盤。
- 三級重訪：同一情境用初中、高中、競賽三級工具重新分析，逐級升維。

所有練習題、解析與閃卡均為本應用原創訓練素材，全部通過互動式作答完成，每一屏都是動手訓練。

適合人群：

- 正在系統刷題備考升學物理的學生。
- 想用閃卡快速記住公式和適用條件的學習者。
- 希望通過視覺化模擬理解物理過程的用戶。

付費說明：

PhysApex 提供一次性完整功能解鎖。購買後可使用全部分層練習、全部快解訓練、全部閃卡卡組、全部互動模擬和全部三級重訪。無訂閱，無自動續費。更換設備後可使用同一 Apple ID 恢復購買。

### 關鍵詞

物理,升學物理,刷題,公式記憶,閃卡,錯題本,間隔複習,壓軸題,物理練習,模擬實驗,解題訓練,力學,電磁學

### ASC「新功能」貼上區（What's New，**必填**，漏填會擋住 Add for Review）

PhysApex 3.0.1 —— 全面聚焦「練」。

- 全新「公式速記」：先回憶、再揭曉、自己評掌握度，按記憶曲線安排複習。
- 介面全面改版：功能更聚焦，逐題作答、翻卡自測、拖動參數觀察運動，每一步都是動手訓練。
- 解鎖更簡單：一次買斷，入口直達，購買體驗更順暢。
- 互動與表述全面統一為訓練型風格。

本應用為互動訓練工具：全部練習與解析均為原創訓練素材，逐題互動作答，每一屏都是動手訓練。

## 宣传截图文案

1. 刷题练出手感：分层题库，逐题作答即时反馈
2. 一题双解训练：常规法 vs 快解法，练识局能力
3. 公式速记闪卡：先回忆，再揭晓，自己评掌握度
4. 拖动参数，运动过程实时变化
5. 错题自动收录，间隔复习安排得明明白白
6. 同一情境三级重访，解题工具逐级升维

## 30 秒产品介绍

PhysApex 把升学物理备考做成纯训练工具：刷题练手感，闪卡记公式，模拟看过程。做错的题自动进错题本并按记忆曲线排期复习。它不是资料库，而是一台随身物理训练器。

## 定价（本次必须落到位）

- 内购：`com.physicsapex.app.full_unlock`，一次性买断（non-consumable）
- 基准货币：**美元**，基准价 **USD 5.99**
- 中国大陆不在销售范围内，**不要**参照人民币价格层级推算；各区价格由苹果按汇率与价格层级自动生成本地货币价。
- 代码兜底展示价：`PurchaseManager.fallbackPriceDisplay = "$5.99"`（守门测试 `testPriceFallbackUsesUSDBaseline`）
- 价格只有 ASC 这一处基准来源，App 内不再有任何第二处硬编码价格。

## App Review 备注

PhysApex (bundle ID: com.physicsapex.app) is an interactive physics drill and memory-training app for students preparing for entrance examinations. All interactions are answer-first: users answer multiple-choice and calculation problems, flip self-grading flashcards (recall first, reveal second), adjust parameters in interactive physics simulations, and review mistakes with spaced repetition.

In this version we have completely removed the former biography and narrative modules. The formula section is now a flashcard training mode only — there is no long-form article reading page anywhere in the app. We also removed all "overview / atlas / syllabus-map" style browsing copy and rebuilt that section as a level-clearing drill: each item is a level with a pass state driven by the user's mastery record, not a browsable table of contents. All card and screen copy is now capped to short training lines (a single screen never shows continuous body text). No exam-specific branding remains in the app; the content is described neutrally as entrance-exam physics. The purchase flow was also simplified: a single paywall (price, buy, restore, with links to the terms and privacy policy). It is mounted once at the app root; locked items anywhere in the app open that same paywall.

**Missing in-app purchase in the shipped 3.0.0 — the reason for this 3.0.1.** The 3.0.0 build that is currently on sale was approved without its in-app purchase ever being submitted for review, so the paywall showed no price and the buy button did nothing. This 3.0.1 build attaches the one-time non-consumable product `com.physicsapex.app.full_unlock` (USD 5.99 baseline) to the app version so it is reviewed and goes live together with the update. Nothing else about the product changes.

**Structural change in this build — the core of this resubmission.** Every "browsable collection of knowledge" surface has been removed. There is no glossary, no term index, no chapter tree, and no long-form explanation page anywhere in the app. Specifically: (1) the formula dataset now carries only fields that a training screen actually consumes — the former descriptive fields (English name, derivation, application scenarios, related methods) and all of their data have been deleted; (2) the formula section offers four practice modes only (due today, weakest-first, random draw, full reshuffle), each opening straight into a one-card-at-a-time recall → reveal → self-grade flow; (3) the former knowledge tree is now a queue that exposes five pending levels at a time, with progress shown as a bar rather than a browsable table of contents; (4) every explanatory paragraph is revealed sentence by sentence — the next sentence appears only after the user taps. No screen in the app displays more than one static knowledge item at a time.

**Availability**: territories are Hong Kong, Macau and Taiwan. We understand that territory selection does not change the assessment above; please evaluate this build on its current form.

The app does not provide periodicals, magazines, newspapers, serialized content, news feeds, third-party content distribution, downloadable publications, or document browsing features. All exercises, explanations, and flashcards are original training content created for this app. The primary category is Education.

Note: this release is an in-place update to the existing app record. The bundle ID and the In-App Purchase product ID (com.physicsapex.app.full_unlock, one-time non-consumable) are unchanged, so existing purchasers keep full access after upgrading. The paywall is reachable from the top banner on the home screen and the More tab; tapping any locked card, question row or simulation entry opens the same paywall in place. No screen uses a different purchase flow.

## 避免使用的表达

- 不使用"图书""杂志""电子书""阅读器""出版""文章库""资料库""读物""教材"等表达。
- 不使用"纵览""全景""路线图""知识体系""知识图谱""全库""大全""词条""手册""速查"等带"一览/资料"观感的表达——**这类措辞是判定"含书籍杂志内容"的高频命中点**。
- **不使用"高考"**（销售地区不含中国大陆，措辞统一为「升学考 / 升学物理」）。
- 不把功能描述为内容分发、长文浏览或整本阅读。
- 不使用"武器""打击""战例""秒杀"等军事/暴力色彩的词，统一用"方法""快解""训练"。
- 统一使用"训练、练习、刷题、闪卡、模拟、考点、关卡、解题工具"等表达。

## App Store Connect 人工核对清单（提交前）

- [ ] **销售地区：仅勾选 中国香港 / 中国澳门 / 中国台湾；确认 中国大陆 已取消勾选**（App 資訊 → 一般資訊 / Pricing and Availability）
- [ ] 主分类：教育 (Education)；副分类：工具 (Utilities)——**切勿选图书 (Books)、报刊杂志 (Magazines & Newspapers)，也不要选参考 (Reference)**
- [ ] **定价：基准货币美元，IAP 价格 USD 5.99**（App 內購買項目 → 價格）
- [ ] **本地化：新增「繁體中文」语言，按本文档繁中章节填写名称/副标题/描述/关键词**；截图文字如重做，同步繁中版
- [ ] ASC 内 App 名称改为 PhysApex，副标题/关键词/描述按本文档更新
- [ ] 关键词再扫一遍：确保无"教材/教辅/资料/大全/纵览/全景/文库/词条/手册/高考"类词
- [ ] 界面文案再扫一遍：App 内不应出现"纵览/全景/路线图/知识体系/高考/为什么能秒"（已改为"考点训练 / 升学物理 / 为什么更快"口径）
- [ ] 界面形态人工过一遍：**公式速记**不应出现可逐条翻阅的定律列表；**考点训练**不应出现三级展开树（一次最多 5 关）；解析区解析应为逐句点开，不是整段直出
- [ ] 上传前跑 `ContentIntegrityTests`（含本轮新增的 `testLawModelHasOnlyTrainingFields`）
- [ ] 今后若再收到模板复述：按 `AppStore_2.1_回复文案.md` 回帖，**只回帖，不要同时提诉或重启审核**
- [ ] **内购随本版本提审**：产品 ID `com.physicsapex.app.full_unlock` 保持不变（老用户购买自动有效），产品类型 Non-Consumable
- [ ] 内购名称/描述已按 5.99 口径填好（简中 + 英文 + 繁中三语），沙盘数量统一为 50+
- [ ] **内购在 3.0.1 版本页里已勾选加入本次提交**（3.0.0 已发售，挂不进去）
- [ ] 内购审核截图已备好（用 `-demoPaywall` 启动参数直接进付费墙截图）
- [ ] 隐私政策 URL 与技术支持 URL 可正常访问：`https://botonwa83-byte.github.io/PhysicsApex/privacy.html` / `.../support.html`（docs/ 已补 terms.html、privacy.html，需推送到 GitHub 并开启 Pages）
- [ ] 审核备注附操作录屏，展示刷题→闪卡自评→模拟拖参的交互过程
- [ ] 若审核仍提出出版许可（Guideline 2.1）：按 `AppStore_2.1_回复文案.md` 回帖，**只回帖，不要同时提诉或重启审核**
