import Unbox
import Foundation

public struct User {
    public let id: Int

    public let name: String
    public let screenName: String
    public let description: String

    public let followersCount: Int
    public let friendsCount: Int
    public let favouritesCount: Int
    public let statusesCount: Int

    public let avatarURLNormalSize: String
    public var avatarURLBigSize: String!
    public var avatarURLOriginalSize: String!

    public let bannerURL: String?
    public let backgroundColor: String
}

extension User: Unboxable {

    public init(unboxer: Unboxer) {
        id = unboxer.unbox(key: "id")

        name = unboxer.unbox(key: "name")
        screenName = unboxer.unbox(key: "screen_name")
        description = unboxer.unbox(key: "description")

        followersCount = unboxer.unbox(key: "followers_count")
        friendsCount = unboxer.unbox(key: "friends_count")
        favouritesCount = unboxer.unbox(key: "favourites_count")
        statusesCount = unboxer.unbox(key: "statuses_count")

        avatarURLNormalSize = unboxer.unbox(key: "profile_image_url")

        bannerURL = unboxer.unbox(key: "profile_banner_url")
        backgroundColor = unboxer.unbox(key: "profile_background_color")

        avatarURLBigSize = avatarURLNormalSize.replacingOccurrences(of: "_normal.", with: "_bigger.")
        avatarURLOriginalSize = avatarURLNormalSize.replacingOccurrences(of: "_normal.", with: ".")
    }

}
