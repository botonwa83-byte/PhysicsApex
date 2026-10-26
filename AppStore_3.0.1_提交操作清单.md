# PhysApex 3.0.1 · 提交操作清单

配套文档：`AppStore_3.0.1_上架文案.md`（商店文案 + 审核备注 + 核对清单）、`AppStore_2.1_出版许可_应对方案.md`（诊断与策略）、`AppStore_2.1_回复文案.md`（回帖文案）。

> 版本号 `3.0.1`，构建号 `3`（2026-10-26）。3.0.0 已用掉 `3.0.0 (1)`、`3.0.0 (2)`，构建号继续顺延。

> **本轮要做的事只有一个核心：把内购补上。**
> 3.0.0 已经在架，但内购 `com.physicsapex.app.full_unlock` **从未随版本提交审核**，用户进付费墙看不到价格、点购买没反应。
> 已发售的 3.0.0 版本记录挂不进内购，所以用 **3.0.1** 升级提交，把内购一起带审。
> 同步：内购价格统一 **USD 5.99**，解锁入口统一为一个 `PaywallView`（形态对齐 ChemApex）。

---

## 〇、【最新】内购被退回：准则 2.1(b) 应用完整性

> 苹果原文：**「由于未提交所需的二进制文件，我们已退回应用内购买产品。」**
> 解决完问题、准备好二进制后，把内购**与二进制一起**重新提交。

**这句话的意思**：内购是脱离二进制单独提审的（或者挂在了一个还没有二进制的版本上），审核没有东西可测，所以被自动退回。**内购不能单独提审，只能跟着 App 版本走。**

### 处理顺序（顺序不能反）

1. **先把二进制传上去**（没有二进制，后面什么都做不了）
   Xcode → Product → Archive → Distribute App → App Store Connect → Upload
   传完在 ASC 里等构建状态变成 **「处理完成」**（通常几分钟，慢时几小时）。
   打出来的必须是 `3.0.1 (3)`；若报构建号冲突，改 `project.yml` 的 `CURRENT_PROJECT_VERSION` 后重新 `xcodegen generate` 再打包。
2. **打开（或新建）App 版本 `3.0.1`** →「构建」区域 → 选中刚处理完的 `3.0.1 (3)`
3. **把内购加进这个版本页**
   3.0.1 版本页 →「App 内购买项目」区域 → `+` → 勾选 `com.physicsapex.app.full_unlock`
   - 前置条件：内购状态必须先是 **Ready to Submit**。被退后它会变成 **Developer Action Needed**——进内购详情页，改动任意一處（比如描述末尾加个句号）保存，状态即回到 Ready to Submit
   - 勾选列表里找不到它，就说明它还不是 Ready to Submit，先做上一步
4. **提交 App 版本审核**：点版本页的「提交以供审核」
   内购会跟着这个版本一起进审，状态同步变成 **Waiting for Review**。
5. **不要**去点内购详情页里的「提交审核」按钮单独提——**那就是本次被退的原因**

### 几个判断

- 内购被退**不影响**已上架的 3.0.0，也不影响 3.0.1 的 App 审核进度，两者独立
- 内购进版本页之前，必须把**价格（USD 5.99）、三语本地化、审核截图**都填完，否则版本页会提示 incomplete
- 内购过了之后，App 还在审是正常的；反过来 App 过了内购没过，只能再等一个新版本带它

---

## 一、代码侧：本次已改完

| # | 原问题 | 改动 |
|---|---|---|
| 1 | 内购没随 3.0.0 提审，付费墙取不到商品 | 版本升到 3.0.1 重新提交，内购 `com.physicsapex.app.full_unlock` 随版本一起提审；**产品 ID 不变**，老用户购买记录继续有效 |
| 2 | 解锁入口分散、形态不统一 | 全 App 只有一个付费墙 `PaywallView` + 一个调度器 `PaywallPresenter`，**.sheet 全 App 只挂载一次**（`PhysApexApp` 的根视图）。旧的 `UnlockSheet.swift` 已删除 |
| 3 | 付费墙是紧凑小卡，卖点讲不透 | 换成 ChemApex 同款长图：渐变头图 + 5 条权益（快解训练 / 30 个方法 / 互动沙盘 / 138 题 + 三级重访 / 一次买断）+ 大字购买按钮 + 恢复购买 + 用户协议/隐私政策链接；解锁后自动关闭 |
| 4 | **7 处锁卡片点了没反应** | 全部改成可点击：三级重访、段位典型题、章节题目、模拟沙盘、题内「动手验证」卡、方法雷达、降维快解战例卡——点哪个弹哪个，弹的都是同一个付费墙。锁态视觉统一为金色皇冠 +「解锁完整版」角标 + 半透明 |
| 5 | 段位页 / 章节页满屏锁 | 免费档判定从「全局前 10 题」改为「当前列表前 10 题」（`PurchaseManager.isProblemPremiumLocked(_:in:)`）。过滤后的子集按全局下标算会得到"一题都不免费" |
| 6 | 首页没有解锁入口 | 首页（观测站）置顶加解锁横幅（皇冠 + 价格胶囊）；解锁卡片从「更多 → 我的」上提到「更多」页 tab 层级，对齐 ChemApex |
| 7 | 价格在两处口径不一致 | 只保留一个基准来源：`PurchaseManager.fallbackPriceDisplay = "$5.99"`，App 内优先读商品真实价，取不到才用兜底价 |

版本号改动（本次已落盘）：`project.yml` / `project.pbxproj` `MARKETING_VERSION` → `3.0.1`、`CURRENT_PROJECT_VERSION` → `3`；`PromoView.swift` 兜底字符串 → `3.0.1`；`PhysApex.storekit` 展示价 → `5.99`。

配套新增：

- `-demoPaywall` 启动参数：直接进付费墙，用于截内购审核图与自测
- `docs/terms.html`、`docs/privacy.html`：付费墙底部协议链接的目标页（**需推送到 GitHub 并开启 Pages 才能访问**）
- UI 测试改为两条链路：`testHomeBannerOpensPaywallAndPaymentSheetAppears`（首页横幅 → 购买）、`testLockedDescentCardOpensPaywallInPlace`（锁卡片就地弹墙）

---

## 二、验证结果

- ✅ 改动的 Swift 文件 `swiftc -parse` 通过（无语法错误）

⚠️ **`xcodebuild build/test` 我这边跑不了**：运行环境禁用了 `sandbox-exec`，SwiftUI 宏插件进程（`swift-plugin-server`）无法启动。**需要你在本机跑一次**：

```bash
cd ~/Documents/trae_projects/physicsapex
USER=fengwang LOGNAME=fengwang xcodegen generate
xcodebuild -project PhysApex.xcodeproj -scheme PhysApex \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -derivedDataPath .derived test
```

判定标准：`BUILD SUCCEEDED` + 测试通过。另外跑一遍 `UnlockFlowUITests`，确认付费墙里的价格能取到（StoreKit 配置下应为 `$5.99`）。

---

## 三、ASC 后台需要你手动做的（代码改不到）

### 3.1 销售地区 / 分类 / 本地化 / 元数据

这几项 3.0.0 那轮已改完并保持在线，**本次只需复核，不用重做**：

1. **销售地区**：仅 **中国香港 / 中国澳门 / 中国台湾**，中国大陆未勾选（App 資訊 → Pricing and Availability）
2. **分类**：主分类 教育 (Education)，副分类 **工具 (Utilities)**（**不得**是 Reference / 图书 / 报刊杂志）
3. **本地化**：已有 **繁體中文**
4. **元数据**：按 `AppStore_3.0.1_上架文案.md` 的禁词表再扫一遍（含「高考」「纵览」「全景」「路线图」「手册」「秒杀」等）

### 3.2 【本次核心】把内购建起来并随 3.0.1 提审

1. 若内购还不存在：ASC → 我的 App → PhysApex → **App 内购买项目** → 新建 → **非消耗型 (Non-Consumable)**
   - 产品 ID：`com.physicsapex.app.full_unlock`（**必须逐字符一致**，写错 App 内永远查不到商品）
   - 参考名称：Full Unlock
2. **价格**：基准货币 **USD**，价格 **5.99**
   - 中国大陆不在销售范围，**不要**按人民币价格层级推算，各区价格由苹果自动换算
3. **本地化**（简中 / 英文 / 繁中三语都填，缺语言会在对应店面显示空白）：
   - 显示名称：解锁完整功能 / Full Unlock / 解鎖完整功能
   - 描述：用 `PhysApex.storekit` 里已写好的三语文案（138 题 / 68 道快解 / 50+ 沙盘 / 30 个方法，一次买断永久有效）
4. **审核截图**：内购也要传一张截图。用 `-demoPaywall` 启动参数直接进付费墙截一张即可
5. **挂到版本上**：回到 3.0.1 版本页 → **App 内购买项目** 区域 → 把 `com.physicsapex.app.full_unlock` 加进本次提交
   - **这一步最容易漏**——3.0.0 就是因为只传了 App 没挂内购，内购才一直没过审
6. 内购状态从 **Ready to Submit** 变为 **Waiting for Review / Approved** 才算真的在审

### 3.3 提审前的最后两步

7. **审核备注**：用 `AppStore_3.0.1_上架文案.md` 里的英文备注（已新增"Missing in-app purchase in the shipped 3.0.0"整段说明）
8. **录屏**：录一段逐屏走查（刷题 → 闪卡自评 → 模拟拖参 → 付费墙），备用
9. **版本号**：ASC 里新建 App 版本 `3.0.1`，挂构建 `3.0.1 (3)`（见第四节）

---

## 四、版本号改动（3.0.0 → 3.0.1，2026-10-26）

> 升级理由：3.0.0 已上架且处于"已发售"状态，**无法再把内购挂到一个已发售的版本上**。
> 内购要过审，只能跟着一个新的 App 版本一起提审，所以升到 3.0.1。

### 已改的代码 / 工程侧（本次已落盘）

| 文件 | 原值 | 现值 |
|---|---|---|
| `project.yml:10-11` | `MARKETING_VERSION: "3.0.0"` ／ `CURRENT_PROJECT_VERSION: "2"` | `"3.0.1"` ／ `"3"` |
| `PhysApex.xcodeproj/project.pbxproj` | `MARKETING_VERSION = 3.0.0;` ／ `CURRENT_PROJECT_VERSION = 2;` | `3.0.1` ／ `3` |
| `PhysApex/Features/Onboarding/PromoView.swift:102` | 版本号兜底字符串 `"3.0.0"` | `"3.0.1"` |
| `PhysApex.storekit` → `displayPrice` | `"2.99"` | `"5.99"` |
| `PhysApex/Core/Engine/PurchaseManager.swift` → `fallbackPriceDisplay` | `"$2.99"` | `"$5.99"` |
| `AppStore_3.0.0_上架文案.md` → **重命名** `AppStore_3.0.1_上架文案.md` | 标题 / 版本信息 / What's New 抬头 / 定价 / 审核备注 / 核对清单 | 全部 3.0.1 |
| `AppStore_3.0.0_提交操作清单.md` → **重命名** `AppStore_3.0.1_提交操作清单.md` | 同上 + 第三、四、五节重写 | 全部 3.0.1 |

> ⚠️ `PhysApex.storekit` 里的 `"version": { "major": 3, "minor": 0, "patch": 0 }` **不是 App 版本号**，是 StoreKit 配置文件的格式版本，**不要改**。

### ASC 侧注意

1. **构建号用 `3`**：`3.0.0 (1)`、`3.0.0 (2)` 都已用过，同一构建号不能重复上传；`CURRENT_PROJECT_VERSION` 已设为 `3`，打出的是 `3.0.1 (3)`，直接上传。
2. **必须新建 `3.0.1` 版本**：3.0.0 已在架，不能在它上面改版本号；ASC → 我的 App → PhysApex → + 新建版本 → `3.0.1`。
3. **版本号必须大于线上已上架版本**（3.0.0）。若线上实际已是 3.0.1 或更高，跟我说一声再改。

---

## 五、提交顺序（这一步别搞错）

1. **先上传二进制**：Archive → Distribute → Upload，等状态变成「处理完成」（见第〇节第 1 条）
2. **再建版本并挂二进制**：新建 App 版本 `3.0.1` → 构建区域选中 `3.0.1 (3)`
3. **把内购加进版本页**：版本页 →「App 内购买项目」→ `+` → 勾选 `com.physicsapex.app.full_unlock`（它会随版本一起提审）
4. 填审核备注，点版本页的「提交以供审核」
5. **若内购被退回 2.1(b)**：说明它是单独提的或缺二进制——按第〇节重走 1→4 步，**内购永远跟着版本提交，不要单独提**
6. 若审核问到内购：回帖说明"产品 ID 与 3.0.0 完全一致，仅本次补提审"，**只回帖，不要同时提 App Review Board 上诉**

---

## 六、还没动的（下一轮的备选杠杆）

- **「武器」系列表述**（武器雷达 / 30 把武器 / 降维打击 / 解锁全套解题武器）：属军事色彩词，与"出版内容"判定无关，本轮**没动**。想一并清理的话说一声，我做一次机械替换（武器 → 快解方法 / 解法）。
- **模拟沙盘页有重复分组**：`SimulationView.swift` 里「热学」「光学」两组被渲染了两遍，沙盘入口会显示重复项。不影响解锁，但看着乱，下次一并去重。
- 「武器」系列措辞仍未清理（武器雷达 / 30 把武器 / 解锁全套解题武器）。
