import XCTest

/// 解锁购买链路 UI 验证：在 scheme 的 StoreKit 配置（等同 Xcode Run 注入）下，
/// 首页 → 降维快解 → 解锁横幅 → 确认卡 → 立即解锁，应弹出测试购买确认面板。
final class UnlockFlowUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testUnlockSheetShowsAndPaymentSheetAppears() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-skipPromo"]
        app.launch()

        // ① 首页 → 降维快解 hero 卡
        let hero = app.staticTexts["降维快解"].firstMatch
        XCTAssertTrue(hero.waitForExistence(timeout: 8), "首页未找到「降维快解」入口")
        hero.tap()

        // ② 解锁横幅（免费 10 条之后出现）
        let banner = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '道快解训练'")).firstMatch
        XCTAssertTrue(banner.waitForExistence(timeout: 6), "降维快解页未找到解锁横幅")
        banner.tap()

        // ③ 直购确认卡出现
        let buyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS '立即解锁'")).firstMatch
        XCTAssertTrue(buyButton.waitForExistence(timeout: 6), "确认卡未出现（缺「立即解锁」按钮）")

        // ④ 点击购买 → StoreKit 测试确认面板应弹出（按钮进入处理中状态或面板出现）
        buyButton.tap()

        let processing = app.staticTexts["处理中…"]
        let confirmInApp = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '确认'")).firstMatch
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let confirmOnSpringboard = springboard.staticTexts.matching(NSPredicate(format: "label CONTAINS '购买' OR label CONTAINS '确认'")).firstMatch

        let sheetAppeared = processing.waitForExistence(timeout: 4)
            || confirmInApp.waitForExistence(timeout: 6)
            || confirmOnSpringboard.waitForExistence(timeout: 6)
        XCTAssertTrue(sheetAppeared, "点击「立即解锁」后未出现购买确认面板，也未进入处理中状态")
    }
}
