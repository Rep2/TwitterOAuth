import Alamofire

public protocol StorableTarget {
    var key: String { get }
}

public protocol WebTarget {
    static var baseURL: String { get }

    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : AnyObject]? { get }
    var encoding: URLEncoding { get }
    var headers: [String : String]? { get }
}

public protocol ResourceTarget: StorableTarget, WebTarget {
}

public protocol RefreshableTarget: ResourceTarget {
    func setToken(token: String) -> Self
}
