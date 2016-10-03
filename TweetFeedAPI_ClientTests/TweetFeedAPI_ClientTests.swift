import XCTest
import Nimble
import Unbox
import RxSwift
@testable import TweetFeedAPI_Client

class UserListWebGatewayTest: XCTestCase {

    let consumerSecret = "WLhDdpPK13CizU4nlNbCQhS1XjgY2fIZ4S7ncbj1gvFkZjsuwC"

    let token = "749954229457027072-46SSCvDkNvDVlXZh5Zjf8s62VUfuopB"
    let tokenSecret = "iUVtoiFPOODppbdFwReZqPoxr0Iy9Kibs3rATL0LvDqOQ"

    func test_UnboxList() {
        let response = "{\r\n \"slug\": \"meetup-20100301\",\r\n    \"name\": \"meetup-20100301\",\r\n" +
            "\"created_at\": \"Sat Feb 27 21:39:24 +0000 2010\",\r\n    \"uri\": \"/twitterapi/meetup-20100301\",\r\n" +
            "\"subscriber_count\": 147,\r\n    \"id_str\": \"8044403\",\r\n    \"member_count\": 116,\r\n" +
            "\"mode\": \"public\",\r\n    \"id\": 8044403,\r\n    \"full_name\": \"@twitterapi/meetup-20100301\",\r\n" +
            "\"description\": \"Guests attending the Twitter meetup on 1 March 2010 at the @twoffice\"\r\n }"

        let responseData = response.data(using: .utf8)!

        do {
            let list: List = try Unbox(data: responseData)

            expect(list.id).to(equal("8044403"))
            expect(list.name).to(equal("meetup-20100301"))
            expect(list.description).to(equal("Guests attending the Twitter meetup on 1 March 2010 at the @twoffice"))
            expect(list.membersCount).to(equal(116))
        } catch {
            expect(true).toNot(beTrue())
        }

    }

    func test_Request() {
        var result: [List]?

        waitUntil(timeout: 10) { done in
            _ = UserListWebGateway
                .get(consumerSecret: self.consumerSecret, authorizationToken: self.token, authorizationTokenSecret: self.tokenSecret)
                .subscribe(onNext: { result = $0 },
                           onError: { print($0) },
                           onDisposed: { done() })
        }

        expect(result).toNot(beNil())

    }

}
