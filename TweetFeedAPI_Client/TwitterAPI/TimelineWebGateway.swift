import RxSwift

public struct TimelineWebGateway {

    public static func get(query: String, accessToken: String, maxId: String? = nil) -> Observable<Timeline> {
        return WebGateway()
            .getResource(TwitterTarget.timeline(queryString: query, maxId: maxId, accessToken: accessToken))
    }

}
