import Foundation

extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    var UTF8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}
