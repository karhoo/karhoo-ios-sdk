import Foundation

/**
 *  Interface allowing us to quickly swap networking library if we need to
 */
public protocol URLSessionSender {
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkRequest
}
