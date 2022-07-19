import Foundation

public typealias HttpHeaders = [String: String]
typealias HttpStatusCode = Int

public struct HttpResponse {
    let code: HttpStatusCode
    let data: Data

    init(code: HttpStatusCode, data: Data) {
        self.code = code
        self.data = data
    }

    func decodeData<T: Decodable>(ofType type: T.Type) -> T? {
        return decode(ofType: T.self)
    }

    func decodeError() -> KarhooSDKError? {
        return decode(ofType: KarhooSDKError.self)
    }

    func decode<T: Decodable>(ofType type: T.Type) -> T? {
        var decoded: T?
        do {
            decoded = try JSONDecoder().decode(type, from: data)
        } catch let error {
            print("Error decoding JSON: \(error) MODEL: \(type)")
        }
        return decoded
    }
}

enum HttpStatus: Int {
    static let maxValueSuccessCode = 299

    case success = 201
    case badRequest = 400
    case serverError = 500
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}
