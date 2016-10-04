import XCTest
import Nimble
import RxSwift
@testable import TweetFeedAPI_Client

class ListFeedWebGatewayTest: XCTestCase {

    let listID = "770917897015332864"

    func test_RealRequest() {
        var result: [Tweet]?

        waitUntil(timeout: 10) { done in
            _ = ListFeedWebGateway.get(listID: self.listID)
                .subscribe(
                    onNext: { result = $0 },
                    onDisposed: { done() })
        }

        expect(result).toNot(beNil())
    }

}
