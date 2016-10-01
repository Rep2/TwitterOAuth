import Alamofire
import Foundation

public enum TwitterClientTarget {
    case list(useID: String, authorizationToken: String)
}

extension TwitterClientTarget: WebTarget {
    public static let baseURL = "https://api.twitter.com"

    public var url: String {
        return TwitterTarget.baseURL + path
    }

    var path: String {
        switch self {
        case .list(_, _):
            return "/oauth2/token"
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
        case .list(_, _):
            return ["]
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
        case .list(_, _):
            return nil
        }
    }

}
