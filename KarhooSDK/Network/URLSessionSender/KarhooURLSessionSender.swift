import Foundation

public class KarhooURLSessionSender: URLSessionSender {
    private var session: URLSession

    public static let shared = KarhooURLSessionSender()

    public init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }

    public var configuration: URLSessionConfiguration {
        return session.configuration
    }

    public func send(request: URLRequest,
                     completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest {
        let task = session.dataTask(with: request) { (data, response, error)  in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        task.resume()
        return task
    }
}

extension URLSessionDataTask: NetworkRequest { }
