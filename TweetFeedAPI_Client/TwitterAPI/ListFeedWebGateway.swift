import RxSwift
import Foundation

public class ListFeedWebGateway {

    public static func get(listID: String) -> Observable<[Tweet]> {
        return WebGateway()
            .getResource(TwitterTarget.listFeed(id: listID))
    }

}
