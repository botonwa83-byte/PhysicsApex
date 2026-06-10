# PhysicsApex · 物理闯关 开发方案

> 参考 app：MathApex（高考数学，工程目录 `../mathtree`，品牌名 MathApex）。
> 本项目是 Apex 家族的物理版（PhysicsApex），最大化复用其架构与设计语言。

## 一、产品定位

**一句话**：从初中直觉，到高考硬功，再到竞赛降维——一条进阶线，带你看见物理的更高维解法。

- **主战场**：高考物理（高中），全套刷题 / 秒杀 / 公式 / 错题 / 复习。资源占 ~80%。
- **入门层**：初中物理，少量基础题 + 直觉模拟，做低门槛起点与引流。
- **天花板**：竞赛，精而少，作为"向上仰望"的付费钩子。难度封顶在"够用应付高考"。

## 二、核心机制：三段递进闯关（Stage）

```
初中 🌱 建直觉          高中 ⚔️ 练硬功(主战场)        竞赛 👁 降维打击
现象/图像/基础           受力分析/标准解/规范           守恒·对称·微元·量纲
```

- **同一题三级重访**：斜面滑块 → 初中"滑不滑得动" / 高中"求加速度" / 竞赛"极值原理秒杀"。
- **段位解锁**：高段武器对低段用户可见但锁定，制造憧憬 = 付费动机。
- **进度脊梁**：用户在首页选择/晋升当前段位，题目、武器、巨人金句随段位解锁。

## 三、灵魂模块：上帝视角 · 降维秒杀

对应 MathApex 的「秒杀殿堂 / 降维打击」。每个战例 = 一道高考高频压轴题 + **双解对决**：
- `standardMethod` 常规解：老师会教的、正确但繁琐的硬解。
- `descentMethod` 降维秒杀：用一把"武器"几步拿下。
- 含 `weaponUsed` / `timeRatio`（耗时比）/ `keyInsight` / `commonMistakes`。

**物理武器库（按段位解锁）**
| 段位 | 武器 |
|------|------|
| 初中 | 受力图三步法、能量守恒思想、图像法(v-t/s-t)、控制变量、等效电路 |
| 高中 | 动量守恒、机械能守恒、动能定理、等效法(等效重力/等效电源)、参考系变换、楞次定则、对称法 |
| 竞赛(点缀) | 微元法、量纲分析、对称性、极值/变分原理、矢量叉乘、近似展开、虚功原理 |

**诚信红线**：每条定律必须带 适用条件 + 量纲 + 常见误用；不臆造"某年某卷某题"精确出处（沿用 MathApex 注释精神）。

## 四、信息架构（4 Tab）

| Tab | 物理版 | 对应 MathApex | 内容 |
|-----|--------|--------------|------|
| 探索 | **观测站**(首页) | 指挥中心 | 段位/今日任务/连击/距高考天数/降维秒杀入口 |
| 练习 | **实验场** | 战场 | 分章节·分段位刷题，关键题挂互动模拟(二期) |
| 公式 | **定律宇宙** | 公式宇宙 | 定律 = 物理意义 + 适用条件 + 量纲 + 常见误用 |
| 更多 | — | — | 错题本、复习、物理巨人、佯谬室、我的 |

## 五、内容模块

**主战场（高中）**：力学(运动学/牛顿/动量/能量/圆周/万有引力)、电磁学(电场/电路/磁场/电磁感应/交变电流)、热学、光学、近代物理。

**情感钩子**：
- **物理巨人**（复用 Hero）：牛顿/爱因斯坦/法拉第/麦克斯韦/伽利略/费曼，RPG 属性(洞察/创造/毅力/影响)+金句。
- **物理佯谬/思想实验**（复用 Mystery）：双生子佯谬、薛定谔的猫、麦克斯韦妖、EPR、伽利略斜塔。

**物理独家技能**：单位/量纲训练、"先估后算"费米估算。

## 六、技术方案（复用 MathApex）

| 复用 | 改动 |
|------|------|
| DesignSystem（Spacing/Radius/AppFont/cardSurface） | 直接搬 |
| ThemeColors（apex*/level*/rainbow*） | 直接搬，level* 复用为段位色 |
| Problem / DualSolution / SolutionPath | → PhysicsProblem，几乎不改 |
| Hero / Mystery | → PhysicsGiant / Paradox |
| SM-2 复习 / Streak / 错题本 / 掌握度 | 整套搬 |
| **新增** | Stage 段位系统、Weapon 武器枚举、PhysicsLaw(带量纲)、互动模拟引擎(二期) |

- 技术栈：SwiftUI，iOS 16，Swift 5，XcodeGen 生成工程。
- 品牌名 **PhysicsApex**，bundle id `com.physicsapex.app`，沿用 APEX/登顶 主题。
- 公式渲染：MVP 用文本/Unicode；二期接 KaTeX(同 MathApex)。
- 模拟沙盘：二期，Canvas/TimelineView 起步，复杂上 SpriteKit。

## 七、分期路线

- **一期 MVP（本次）**：4-Tab 骨架 + 段位系统 + 力学示例题库 + 降维秒杀模块 + 定律宇宙 + 错题/复习 + 物理巨人/佯谬(数据+列表)。`xcodebuild` 可构建。
- **二期**：互动模拟沙盘(抛体/碰撞/电路)、完整题库、KaTeX。
- **三期**：竞赛武器、量纲/估算训练、付费墙(对标 SKPaywall)、用户系统。

## 八、目录结构

```
PhysicsApex/
  App/                  应用入口 + 根视图 + TabView
  Core/
    Renderer/           DesignSystem, ThemeColors
    Models/             Stage, PhysicsProblem, Weapon, PhysicsLaw, PhysicsGiant, Paradox, StudentProfile
    Engine/             ProblemBank, DescentCases, LawLibrary, GiantsData, ParadoxData, StreakManager, ReviewScheduler, PracticeManager
  Features/
    ObservationStation/ 观测站(首页)
    Lab/                实验场(练习)
    Descent/            降维秒杀
    LawUniverse/        定律宇宙
    Giants/             物理巨人
    Paradox/            佯谬室
    Profile/            我的 + 更多
  Resources/            Assets.xcassets
```
