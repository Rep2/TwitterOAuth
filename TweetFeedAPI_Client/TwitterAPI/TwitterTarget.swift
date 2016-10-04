import Alamofire
import Foundation

public enum TwitterTarget {
    case token(key: String, secret: String)
    case timeline(queryString: String, maxId: String?, accessToken: String)
    case user(id: String, accessToken: String)
    case list(parameters: [String : String])
    case listFeed(id: String)
}

extension TwitterTarget: WebTarget {
    public static let baseURL = "https://api.twitter.com"

    public var url: String {
        return TwitterTarget.baseURL + path
    }

    var path: String {
        switch self {
        case .token:
            return "/oauth2/token"
        case .timeline:
            return "/1.1/search/tweets.json"
        case .user:
            return "/1.1/users/show.json"
        case .list:
            return TwitterTarget.listURL
        case .listFeed:
            return "/1.1/lists/statuses.json"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .token:
            return .post
        case .timeline:
            return .get
        case .user:
            return .get
        case .list:
            return TwitterTarget.listMethod
        case .listFeed:
            return .get
        }
    }

    public var parameters: [String: AnyObject]? {
        switch self {
        case .token:
            return [
                "grant_type" : "client_credentials" as AnyObject
            ]
        case .timeline(let queryParameter, let maxID, _):
            var params = ["q" : queryParameter.URLEscapedString]
            params["max_id"] = maxID

            return params as [String : AnyObject]
        case .user(let id, _):
            return ["user_id" : id as AnyObject]
        case .list:
            return nil
        case .listFeed(let id):
            return ["list_id" : id as AnyObject]
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
        case .token(let key, let secret):
            return [
                "Authorization" : "Basic " + createAuthorizationString(for: key, secret: secret),
                "Content-Type" : "application/x-www-form-urlencoded;charset=UTF-8"
            ]
        case .timeline(_, _, let accessToken):
            return ["Authorization" : "Bearer \(accessToken)"]
        case .list(let parameters):
            return parameters
        case .listFeed(let id):
            do {
            let authHeader = try generateOAuthAuthorizationHeader(url: url, method: method, queries: ["list_id" : id])
                return ["Authorization" : authHeader]
            } catch {
                return nil
            }
        default:
            return nil
        }
    }

    public static var listURL: String {
        return "/1.1/lists/list.json"
    }

    public static var listMethod: HTTPMethod {
        return .get
    }

}

private func createAuthorizationString(for key: String, secret: String) -> String {
    let authorizationData = (key + ":" + secret).data(using: String.Encoding.utf8)
    return authorizationData!.base64EncodedString()
}
