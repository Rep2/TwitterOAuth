import Alamofire

enum OAuthSignatureError: Error {
    case uncodableString
    case unallowedMethod
}

func oauthSignature(consumerSecret: String, authTokenSecret: String, baseURL: String, method: HTTPMethod, parameters: [String : String]) throws -> String {

    let key = try signingKey(consumerSecret: consumerSecret, tokenSecret: authTokenSecret)

    let base = try oauthBase(baseURL: baseURL, method: method, parameters: parameters)

    return calculateSignature(base: base, key: key)
}

func oauthBase(baseURL: String, method: HTTPMethod, parameters: [String : String]) throws -> String {
    var signatureBase = ""

    switch method {
    case .get:
        signatureBase = "GET"
    case .post:
        signatureBase = "POST"
    default:
        throw OAuthSignatureError.unallowedMethod
    }

    signatureBase += "&"

    if let encodedURL = percentageEndcode(string: baseURL) {
        signatureBase += encodedURL
    } else {
        throw OAuthSignatureError.uncodableString
    }

    signatureBase += "&"

    if let encodedParameters = percentageEndcode(string: try oauthEncodeParameters(parameters: parameters)) {
        signatureBase += encodedParameters
    }

    return signatureBase
}

func oauthEncodeParameters(parameters: [String : String]) throws -> String {
    var encodedParameters = [String : String]()

    for (key, value) in parameters {
        let encodedKey = percentageEndcode(string: key)
        let encodedValue = percentageEndcode(string: value)

        if let encodedKey = encodedKey, let encodedValue = encodedValue {
            encodedParameters[encodedKey] = encodedValue
        } else {
            throw OAuthSignatureError.uncodableString
        }
    }

    var combinedParameters = ""

    for (key, value) in encodedParameters.sorted(by: <) {
        if combinedParameters != "" {
            combinedParameters += "&"
        }

        combinedParameters += key + "=" + value
    }

    return combinedParameters
}

func signingKey(consumerSecret: String, tokenSecret: String?) throws -> String {
    var key = ""

    if let codedConsumerSecret = percentageEndcode(string: consumerSecret) {
        key += codedConsumerSecret + "&"
    } else {
        throw OAuthSignatureError.uncodableString
    }

    if let tokenSecret = tokenSecret {
        if let encodedTokenSecret = percentageEndcode(string: tokenSecret) {
            key += encodedTokenSecret
        } else {
            throw OAuthSignatureError.uncodableString
        }
    }

    return key
}

func calculateSignature(base: String, key: String) -> String {
    return base.hmac(algorithm: .SHA1, key: key)
}

func percentageEndcode(string: String) -> String? {
    var characters = CharacterSet.urlQueryAllowed
    characters.remove(charactersIn: "+,!?:/=&")

    return string.addingPercentEncoding(withAllowedCharacters: characters)
}
