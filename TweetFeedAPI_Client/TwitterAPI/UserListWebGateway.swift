import RxSwift

public class UserListWebGateway {

    public static func get(parameters: [String : String]) -> Observable<[List]> {
        return WebGateway()
            .getResource(TwitterClientTarget.list(parameters: parameters))
    }

}
