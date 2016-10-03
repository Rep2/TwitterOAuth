import Alamofire
import Foundation

public enum TwitterClientTarget {
    case list(parameters: [String : String]?)
}

extension TwitterClientTarget: WebTarget {
    public static let baseURL = "https://api.twitter.com"

    public var url: String {
        return TwitterClientTarget.baseURL + path
    }

    var path: String {
        switch self {
        case .list(_):
            return "/1.1/lists/list.json"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }

    public var parameters: [String: AnyObject]? {
        switch self {
        case .list:
            return nil
         }
    }

    public var encoding: URLEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .list(let parameters):
            return parameters

        }
    }

//            let tw = TWTROAuthSigning(authConfig: TWTRAuthConfig(consumerKey: "uiuctDMe3ZQlCUfWWPFbpzESB", consumerSecret: "WLhDdpPK13CizU4nlNbCQhS1XjgY2fIZ4S7ncbj1gvFkZjsuwC"), authSession: session)
//
//            var error: NSError?
//            let perams = tw.oAuthEchoHeaders(forRequestMethod: "GET", urlString: "https://api.twitter.com/1.1/lists/list.json", parameters: nil, error: &error)
//
//
//            let nounce = randomString(length: 32)
//            let timestamp = "1475358122"//\(Date.timeIntervalBetween1970AndReferenceDate.rounded())"
//
//            var oauthParameters = [
//                "oauth_consumer_key" : "\(consumerSecret)",
//                "oauth_nonce" : nounce,
//                "oauth_signature_method" : "HMAC-SHA1",
//                "oauth_timestamp" : timestamp,
//                "oauth_token" : "\(authToken)",
//                "oauth_version" : "1.0"
//            ]
//
//            do {
//                let signature = try oauthSignature(consumerSecret: consumerSecret, authTokenSecret: authTokenSecret, baseURL: path, method: method, parameters: oauthParameters)
//
//                oauthParameters["oauth_signature"] = signature
//
//                let oauthString = oauthParameters
//                    .sorted(by: <)
//                    .map({ element -> String in
//                        return element.key + "=\"" + element.value + "\""
//                        })
//                    .joined(separator: ", ")
//
//                return ["Authorization" : "OAuth \(oauthString)"]
//            } catch {
//                print("Failed to create key")
//            }
//
//            return [:]
//        }


}
