import XCTest
import Nimble
import Alamofire
@testable import TweetFeedAPI_Client

class OAuthGeneratorTest: XCTestCase {

    let consumerKey = "cifpa97EH7fNgvuaUrbXFaQH5"
    let consumerSecret = "kq5vhapuS21PaC0M8fBQRGJPrXl7MypPH6fPXZWXrW8hdgAoSn"

    let accessToken = "772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4"
    let accessTokenSecret = "YDEvVzxmNgnmvlH0UQECZjVMOrRL8NDqiQUft4biqvFTT"

    let method = HTTPMethod.get
    let url = "https://api.twitter.com/1.1/lists/list.json"

    let signatureBase = "GET&https%3A%2F%2Fapi.twitter.com%2F1.1%2Flists%2Flist.json&oauth_consumer_key%3Dcifpa97EH7fNgvuaUrbXFaQH5%26oauth_nonce%3D51a2970051d2441146e14b69cac29934%26oauth_" +
        "signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1475596223%26oauth_token%3D772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4%26oauth_version%3D1.0"
    let signature = "UI2rFrZQGkIPsnDtR3ilPPoyYCQ%3D"

    let authorizationHeader = "OAuth oauth_consumer_key=\"cifpa97EH7fNgvuaUrbXFaQH5\", oauth_nonce=\"51a2970051d2441146e14b69cac29934\", oauth_signature=\"UI2rFrZQGkIPsnDtR3" +
        "ilPPoyYCQ%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1475596223\", oauth_token=\"772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4\", oauth_version=\"1.0\""

    let parameters = [
        "oauth_consumer_key" : "cifpa97EH7fNgvuaUrbXFaQH5",
        "oauth_nonce" : "51a2970051d2441146e14b69cac29934",
        "oauth_signature_method" : "HMAC-SHA1",
        "oauth_timestamp" : "1475596223",
        "oauth_token" : "772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4",
        "oauth_version" : "1.0"
    ]

    let authorizationHeaderWithQuery = "OAuth oauth_consumer_key=\"cifpa97EH7fNgvuaUrbXFaQH5\", oauth_nonce=\"350420c06b9ab8239972c85aaa17129e\", oauth_signature=\"hZWebJpd%2FfbjbECufQ" +
        "0DydtniIs%3D\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1475599358\", oauth_token=\"772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4\", oauth_version=\"1.0\""

    let parameters2 = [
        "oauth_consumer_key" : "cifpa97EH7fNgvuaUrbXFaQH5",
        "oauth_nonce" : "350420c06b9ab8239972c85aaa17129e",
        "oauth_signature_method" : "HMAC-SHA1",
        "oauth_timestamp" : "1475599358",
        "oauth_token" : "772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4",
        "oauth_version" : "1.0"
    ]

    func test_SignatureBase() {
        do {
            let realResult = try oauthBase(baseURL: url, method: method, parameters: parameters)

            expect(realResult).to(equal(signatureBase))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_Signature() {
        do {
            let realResult = try oauthSignature(consumerSecret: consumerSecret, authTokenSecret: accessTokenSecret, baseURL: url, method: method, parameters: parameters)

            expect(realResult).to(equal(signature))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_Header() {
        do {
            let realResult = try generateOAuthAuthorizationHeader(consumerSecret: consumerSecret, authTokenSecret: accessTokenSecret, baseURL: url, method: method, parameters: parameters)

            expect(realResult).to(equal(authorizationHeader))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_HeaderWithQuery() {
        do {
            let queries = ["list_id" : "5458876542387"]

            let realResult = try generateOAuthAuthorizationHeader(consumerSecret: consumerSecret, authTokenSecret: accessTokenSecret,
                                                                  baseURL: url, method: method, parameters: parameters2, queries: queries)

            expect(realResult).to(equal(authorizationHeaderWithQuery))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

}
