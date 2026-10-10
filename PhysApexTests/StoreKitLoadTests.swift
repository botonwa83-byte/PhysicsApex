import XCTest
@testable import PhysApex
import StoreKit

/// 商店商品加载链路守护：在 scheme 的 StoreKit 配置下，产品必须能查到。
final class StoreKitLoadTests: XCTestCase {

    func testProductLoads() async throws {
        let products = try await Product.products(for: [PurchaseManager.shared.productID])
        XCTAssertEqual(products.count, 1, "商品查询应返回 1 个产品，实际 \(products.count)")
        XCTAssertEqual(products.first?.id, "com.physicsapex.app.full_unlock")
        XCTAssertEqual(products.first?.type, .nonConsumable)
    }
}
