import Foundation

/**
 *  Makes a valid HTTP request with JSON out of provided parameters
 */
final class JsonHttpRequestBuilder {

    func request(method: HttpMethod, url: URL, headers: HttpHeaders?, data: Data?, urlComponents: URLComponents? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        if urlComponents == nil {
            request.httpBody = data
        } else {
            request.httpBody = urlComponents?.query?.data(using: .utf8)
        }

        return request
    }
}
