import XCTest
import Nimble
import Alamofire
@testable import TweetFeedAPI_Client

class OAuthSignatureTest: XCTestCase {
    let parameters: [String : String] = [
        "status" : "Hello Ladies + Gentlemen, a signed OAuth request!",
        "include_entities" : "\(true)",
        "oauth_consumer_key" : "xvz1evFS4wEEPTGEFPHBog",
        "oauth_nonce" : "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg",
        "oauth_signature_method" : "HMAC-SHA1",
        "oauth_timestamp" : "1318622958",
        "oauth_token" : "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb",
        "oauth_version" : "1.0"
    ]

    let url = "https://api.twitter.com/1/statuses/update.json"
    let method = HTTPMethod.post

    let consumerSecret = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
    let tokenSecret = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

    func test_EncodeParameters() {
        let expectedResult = "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&" +
            "oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&" +
        "status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21"

        do {
            let realResult = try oauthEncodeParameters(parameters: parameters)

            expect(realResult).to(equal(expectedResult))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_EncodeRequest() {
        let expectedResult = "POST&https%3A%2F%2Fapi.twitter.com%2F1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%" +
            "26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxM" +
        "AgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"

        do {
            let realResult = try oauthBase(baseURL: url, method: method, parameters: parameters)
            print(realResult)
            print(expectedResult)

            expect(realResult).to(equal(expectedResult))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_SigningKey() {
        let expectedResult = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

        do {
            let realResult = try signingKey(consumerSecret: consumerSecret, tokenSecret: tokenSecret)

            expect(realResult).to(equal(expectedResult))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_CalculateSignature() {
        let key = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"
        let base = "POST&https%3A%2F%2Fapi.twitter.com%2F1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%" +
            "26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxM" +
        "AgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"

        let expectedResult = "tnnArxj06cWHq44gCs1OSKk%2FjLY%3D"

        do {
            let realResult = try calculateSignature(base: base, key: key)

            expect(realResult).to(equal(expectedResult))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

    func test_OAuthSignature() {
        let expectedResult = "tnnArxj06cWHq44gCs1OSKk%2FjLY%3D"

        do {
            let realResult = try oauthSignature(consumerSecret: consumerSecret, authTokenSecret: tokenSecret, baseURL: url, method: method, parameters: parameters)

            expect(realResult).to(equal(expectedResult))
        } catch {
            expect(true).toNot(beTrue())
        }
    }

}
