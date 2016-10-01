enum GatewayError: Error {
    case httpError(code: Int)
    case unboxingError
    case systemError(code: Int, description: String)
    case permissionDenied
    case noDataReturned
    case noDataFor(key: String)
    case codingFailed

    var description: String {
        switch self {
        case .httpError(let code):
            return "HTTP error with status code \(code)"
        case .unboxingError:
            return "Error while mapping response body"
        case .systemError(_, let description):
            return description
        case .permissionDenied:
            return "Permission was denied"
        case .noDataReturned:
            return "Request returned no data"
        case .noDataFor(let key):
            return "No data was found for key \(key)"
        case .codingFailed:
            return "Resource coding failed"
        }

    }
}

extension GatewayError: Equatable {
}

func == (lhs: GatewayError, rhs: GatewayError) -> Bool {
    switch (lhs, rhs) {
    case (.noDataFor(let x), .noDataFor(let y)):
        return x == y
    case (.httpError(let x), .httpError(let y)):
        return x == y
    case (.unboxingError, .unboxingError):
        return true
    case (.systemError(let x, _), .systemError(let y, _)):
        return x == y
    case (.permissionDenied, .permissionDenied):
        return true
    case (.noDataReturned, .noDataReturned):
        return true
    case (.codingFailed, .codingFailed):
        return true
    default:
        return false
    }
}
