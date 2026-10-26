import XCTest

/// 解锁链路 UI 验证：在 scheme 的 StoreKit 配置（等同 Xcode Run 注入）下，
/// 入口 1：首页置顶解锁横幅 → 付费墙 → 立即解锁 → 弹出测试购买确认面板。
/// 入口 2：降维快解页里被锁住的战例卡 → 付费墙（验证"每个锁卡片都能就地弹墙"）。
final class UnlockFlowUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testHomeBannerOpensPaywallAndPaymentSheetAppears() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-skipPromo"]
        app.launch()

        // ① 首页置顶解锁横幅
        let banner = app.buttons.matching(NSPredicate(format: "label CONTAINS '一次买断'")).firstMatch
        XCTAssertTrue(banner.waitForExistence(timeout: 8), "首页未找到解锁横幅")
        banner.tap()

        // ② 付费墙出现，且价格取到商品真实价
        assertPaywallAppeared(app)
        tapBuy(app)

        // ③ 点击购买 → StoreKit 测试确认面板应弹出
        assertPaymentSheetAppeared(app)
    }

    func testLockedDescentCardOpensPaywallInPlace() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-skipPromo"]
        app.launch()

        // ① 首页 → 降维快解
        let hero = app.staticTexts["降维快解"].firstMatch
        XCTAssertTrue(hero.waitForExistence(timeout: 8), "首页未找到「降维快解」入口")
        hero.tap()

        // ② 点列表里被锁住的那张战例卡（免费 10 道之后的第 11 张）
        let lockedCard = app.buttons.matching(NSPredicate(format: "label CONTAINS '解锁查看'")).firstMatch
        XCTAssertTrue(lockedCard.waitForExistence(timeout: 6), "降维快解页未找到锁卡片")
        lockedCard.tap()

        // ③ 就地弹出同一个付费墙
        assertPaywallAppeared(app)
    }

    // MARK: 公共断言

    private func assertPaywallAppeared(_ app: XCUIApplication) {
        let paywall = app.scrollViews["paywallScrollView"]
        XCTAssertTrue(paywall.waitForExistence(timeout: 6), "付费墙未出现")

        let buyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS '立即解锁'")).firstMatch
        XCTAssertTrue(buyButton.waitForExistence(timeout: 6), "付费墙缺「立即解锁」按钮")
    }

    /// 长图付费墙的购买按钮在权益清单下方，可能不在首屏，先滚到它再点。
    private func tapBuy(_ app: XCUIApplication) {
        let buyButton = app.buttons.matching(NSPredicate(format: "label CONTAINS '立即解锁'")).firstMatch
        if !buyButton.isHittable {
            app.scrollViews["paywallScrollView"].swipeUp()
            XCTAssertTrue(buyButton.waitForExistence(timeout: 4), "上滑后仍未找到「立即解锁」按钮")
        }
        buyButton.tap()
    }

    private func assertPaymentSheetAppeared(_ app: XCUIApplication) {
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
