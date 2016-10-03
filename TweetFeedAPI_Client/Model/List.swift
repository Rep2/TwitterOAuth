import Foundation
import Unbox

public struct List {

    public let id: String

    public let description: String
    public let name: String

    public let membersCount: Int

}

extension List: Unboxable {

    public init(unboxer: Unboxer) {
        id = unboxer.unbox(key: "id_str")

        name = unboxer.unbox(key: "name")
        description = unboxer.unbox(key: "description")

        membersCount = unboxer.unbox(key: "member_count")
    }

}
