import Unbox

public class Coordinates: Unboxable {
    let type: String
    let coordinates: [Double]

    public required init(unboxer: Unboxer) {
        type = unboxer.unbox(key: "type")
        coordinates = unboxer.unbox(key: "coordinates")
    }

    public init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
    }
}
