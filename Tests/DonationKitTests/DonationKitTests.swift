import XCTest
@testable import DonationKit

final class DonationKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let config = PurchaseConfiguration(id: "test", purchaseProductIdentifiers: ["test"])
        XCTAssert(config.isSecondaryButtonHidden)
    }
}
