import Alamofire

enum OAuthSignatureError: Error {
    case uncodableString
    case unallowedMethod
}

let consumerKey = "cifpa97EH7fNgvuaUrbXFaQH5"
let consumerSecret = "kq5vhapuS21PaC0M8fBQRGJPrXl7MypPH6fPXZWXrW8hdgAoSn"

let accessToken = "772738531236122624-iYs4KCVxTPUczMb1saBTSriuuttxYU4"
let accessTokenSecret = "YDEvVzxmNgnmvlH0UQECZjVMOrRL8NDqiQUft4biqvFTT"

func generateOAuthAuthorizationHeader(url: String, method: HTTPMethod, queries: [String : String] = [:]) throws -> String {
    return try generateOAuthAuthorizationHeader(consumerKey: consumerKey, consumerSecret: consumerSecret, accessToken: accessToken,
                                                accessTokenSecret: accessTokenSecret, url: url, method: method, queries: queries)
}

func generateOAuthAuthorizationHeader(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String, url: String,
                                      method: HTTPMethod, queries: [String : String] = [:]) throws -> String {

    let timestamp = IntMax(Date().timeIntervalSince1970)
    let nounce = UUID().uuidString

    let parameters = [
        "oauth_consumer_key" : consumerKey,
        "oauth_nonce" : nounce,
        "oauth_signature_method" : "HMAC-SHA1",
        "oauth_timestamp" : "\(timestamp)",
        "oauth_token" : accessToken,
        "oauth_version" : "1.0"
    ]

    return try generateOAuthAuthorizationHeader(consumerSecret: consumerSecret, authTokenSecret: accessTokenSecret, baseURL: url, method: method, parameters: parameters, queries: queries)
}

func generateOAuthAuthorizationHeader(consumerSecret: String, authTokenSecret: String, baseURL: String, method: HTTPMethod,
                                      parameters: [String : String], queries: [String : String] = [:]) throws -> String {

    var combinedParameters = parameters
    combinedParameters.update(other: queries)

    let signature = try oauthSignature(consumerSecret: consumerSecret, authTokenSecret: authTokenSecret, baseURL: baseURL, method: method, parameters: combinedParameters)

    var oauthParameters = parameters
    oauthParameters["oauth_signature"] = signature

    let oauthString = oauthParameters
        .sorted(by: <)
        .map({ element -> String in
            return element.key + "=\"" + element.value + "\""
        })
        .joined(separator: ", ")

    return "OAuth \(oauthString)"
}

extension Dictionary {
    mutating func update(other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

func oauthSignature(consumerSecret: String, authTokenSecret: String, baseURL: String, method: HTTPMethod, parameters: [String : String]) throws -> String {

    let key = try signingKey(consumerSecret: consumerSecret, tokenSecret: authTokenSecret)

    let base = try oauthBase(baseURL: baseURL, method: method, parameters: parameters)

    return try calculateSignature(base: base, key: key)
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

func calculateSignature(base: String, key: String) throws -> String {
    if let signature = percentageEndcode(string: base.hmac(algorithm: .SHA1, key: key)) {
        return signature
    } else {
        throw OAuthSignatureError.uncodableString
    }
}

func percentageEndcode(string: String) -> String? {
    var characters = CharacterSet.urlQueryAllowed
    characters.remove(charactersIn: "+,!?:/=&")

    return string.addingPercentEncoding(withAllowedCharacters: characters)
}
