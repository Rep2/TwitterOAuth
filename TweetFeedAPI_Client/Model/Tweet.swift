import Foundation
import Unbox

public struct Tweet {

    public let id: String

    public var author: User

    public let text: String
    public var createdDate: String

    public let retweetCount: Int
    public let favoritedCount: Int

    public let entities: Entities

    public let coordinates: Coordinates?

    fileprivate let dateFormaterTo: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm:ss dd.MM.yyyy"

        return dateFormater
    }()

    fileprivate let dateFormaterFrom: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "E MMM dd HH:mm:ss Z yyyy"

        return dateFormater
    }()
}

extension Tweet: Unboxable {

    public init(unboxer: Unboxer) {
        id = unboxer.unbox(key: "id_str")

        author = unboxer.unbox(key: "user")

        text = unboxer.unbox(key: "text")

        // Date parsing
        createdDate = unboxer.unbox(key: "created_at")
        let date = self.dateFormaterFrom.date(from: createdDate)
        if let date = date {
            createdDate = self.dateFormaterTo.string(from: date)
        }

        retweetCount = unboxer.unbox(key: "retweet_count")
        favoritedCount = unboxer.unbox(key: "favorite_count")

        entities = unboxer.unbox(key: "entities")

        coordinates = unboxer.unbox(key: "coordinates")
    }

}
