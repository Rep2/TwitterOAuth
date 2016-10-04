import Unbox

public struct Entities: Unboxable {

    public let urls: [URLEntities]?
    public let userMentions: [UserMention]?
    public let hashtags: [Hashtag]?
    public let media: [Media]?

    public init(unboxer: Unboxer) {
        urls = unboxer.unbox(key: "urls")
        userMentions = unboxer.unbox(key: "user_mentions")
        hashtags = unboxer.unbox(key: "hashtags")
        media = unboxer.unbox(key: "media")
    }
}

public struct Indicises {
    public let firstIndex: Int
    public let secondIndex: Int
}

public struct URLEntities: Unboxable {

    public let url: String

    public let indicies: Indicises

    public init(unboxer: Unboxer) {
        url = unboxer.unbox(key: "url")

        let array: [Int] = unboxer.unbox(key: "indices")

        guard array.count == 2 else {
            indicies = Indicises(firstIndex: 0, secondIndex: 0)
            return
        }

        indicies = Indicises(firstIndex: array[0], secondIndex: array[1])
    }
}

public struct UserMention: Unboxable {

    public let screenName: String
    public let name: String
    public let id: String

    public let indicies: Indicises

    public init(unboxer: Unboxer) {
        id = unboxer.unbox(key: "id_str")
        screenName = unboxer.unbox(key: "screen_name")
        name = unboxer.unbox(key: "name")

        let array: [Int] = unboxer.unbox(key: "indices")

        guard array.count == 2 else {
            indicies = Indicises(firstIndex: 0, secondIndex: 0)
            return
        }

        indicies = Indicises(firstIndex: array[0], secondIndex: array[1])
    }
}

public struct Hashtag: Unboxable {

    public let text: String

    public let indicies: Indicises

    public init(unboxer: Unboxer) {
        text = unboxer.unbox(key: "text")

        let array: [Int] = unboxer.unbox(key: "indices")

        guard array.count == 2 else {
            indicies = Indicises(firstIndex: 0, secondIndex: 0)
            return
        }

        indicies = Indicises(firstIndex: array[0], secondIndex: array[1])
    }
}

public enum MediaType: String {
    case photo = "photo"
    case unrecognizedMediaType = "default"
}

extension MediaType: UnboxableEnum {
    public static func unboxFallbackValue() -> MediaType {
        return .unrecognizedMediaType
    }
}

public struct Media: Unboxable {

    public let id: String

    public let indicies: Indicises

    public let type: MediaType
    public let mediaURL: String

    public init(unboxer: Unboxer) {
        id = unboxer.unbox(key: "id_str")

        type = unboxer.unbox(key: "type")

        mediaURL = unboxer.unbox(key: "media_url")

        let array: [Int] = unboxer.unbox(key: "indices")

        guard array.count == 2 else {
            indicies = Indicises(firstIndex: 0, secondIndex: 0)
            return
        }

        indicies = Indicises(firstIndex: array[0], secondIndex: array[1])
    }
}
