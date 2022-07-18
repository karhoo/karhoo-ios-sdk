import Foundation

/**
 *  This class does not refresh JWT token automatically.
 *  Use TokenRefreshingJsonHttpClient outside of login/registration
 */
final class JsonHttpClient: HttpClient {
    
    private var urlSessionSender: URLSessionSender
    private let requestBuilder = JsonHttpRequestBuilder()
    private let headerProvider: HeaderProvider
    private let analyticsService: AnalyticsService

    static let shared = JsonHttpClient()

    init(urlSessionSender: URLSessionSender = KarhooURLSessionSender.shared,
         headerProvider: HeaderProvider = KarhooHeaderProvider(),
         analyticsService: AnalyticsService = KarhooAnalyticsService()) {
        self.urlSessionSender = urlSessionSender
        self.headerProvider = headerProvider
        self.analyticsService = analyticsService
    }

    @discardableResult
    func sendRequest(endpoint: APIEndpoint,
                     data: Data? = nil,
                     completion: @escaping CallbackClosure<HttpResponse>) -> NetworkRequest? {

        let headers: HttpHeaders = addRelativeHeaders(endpoint: endpoint)

        do {
            let url = absoluteUrl(endpoint: endpoint)
            var request: URLRequest

            request = try requestBuilder.request(method: endpoint.method, url: url, headers: headers, data: data)

            return urlSessionSender.send(request: request) { data, response, error in
                self.handle(response: response, data: data, error: error, completion: completion)
            }
        } catch {
            return nil
        }
    }

    @discardableResult
    func sendRequest(endpoint: APIEndpoint, data: Data?, urlComponents: URLComponents? = nil, completion: @escaping CallbackClosure<HttpResponse>) -> NetworkRequest? {
        let headers: HttpHeaders = addRelativeHeaders(endpoint: endpoint)

        do {
            let url = absoluteUrl(endpoint: endpoint)
            var request: URLRequest

            request = try requestBuilder.request(method: endpoint.method,
                                                 url: url, headers: headers,
                                                 data: data,
                                                 urlComponents: urlComponents)

            return urlSessionSender.send(request: request) { data, response, error in
                self.handle(response: response, data: data, error: error, completion: completion)
            }
        } catch {
            return nil
        }
    }

    private func handle(response: URLResponse?, data: Data?, error: Error?,
                        completion: CallbackClosure<HttpResponse>) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let httpResponse = HttpResponse(code: statusCode, data: data ?? Data())
        
        guard error == nil &&
            isValid(statusCode: statusCode) else {
                handleError(requestUrl: response?.url?.absoluteString ?? "",
                            statusCode: statusCode,
                            response: httpResponse,
                            error: error,
                            completion: completion)
            return
        }

        completion(Result.success(result: httpResponse))
    }

    func handleError(requestUrl: String,
                     statusCode: Int,
                     response: HttpResponse,
                     error: Error?,
                     completion: CallbackClosure<HttpResponse>) {
        
        analyticsService.send(eventName: .requestFails, payload: error != nil ? [AnalyticsConstants.Keys.requestError.rawValue: error.debugDescription,
                                                                                 AnalyticsConstants.Keys.requestUrl.rawValue: requestUrl] : [AnalyticsConstants.Keys.requestUrl.rawValue: requestUrl])
        if let error = response.decodeError() {
            if error.code.isEmpty, error.slug.isEmpty {
                completion(Result.failure(error: SDKErrorFactory.unexpectedError()))
            } else {
                completion(Result.failure(error: error))
            }
        } else {
            let httpError = HTTPError(statusCode: statusCode, error: error as NSError?)
            completion(Result.failure(error: httpError))
        }
    }

    private func isValid(statusCode: Int) -> Bool {
        return statusCode <= HttpStatus.maxValueSuccessCode
    }

    private func addRelativeHeaders(endpoint: APIEndpoint) -> HttpHeaders {
        var headers = HttpHeaders()

        if endpoint.method == .post || endpoint.method == .put {
            headers = headerProvider.headersWithJSONContentType(headers: &headers)
        }

        switch endpoint {
        case .authRevoke,
             .authTokenExchange,
             .authRefresh:
            headers = headerProvider.headersWithFormEncodedType(headers: &headers)
            headers = headerProvider.headersWithAcceptJSONType(headers: &headers)
        default:
            headers = headerProvider.headersWithAuthorization(headers: &headers, endpoint: endpoint)
            headers = headerProvider.headersWithCorrelationId(headers: &headers, endpoint: endpoint)
        }
        return headers
    }
}

private extension JsonHttpClient {
    
    func absoluteUrl(endpoint: APIEndpoint) -> URL {
        let environmentDetails = KarhooEnvironmentDetails(environment: Karhoo.configuration.environment())

        switch Karhoo.configuration.authenticationMethod() {
        case .guest:
            guard let guestModeUrl = URL(string: environmentDetails.guestHost + endpoint.path) else {
                fatalError(urlMalformedException)
            }
            return guestModeUrl
        default:
            break
        }

        switch endpoint {
        case .authRevoke,
             .authTokenExchange,
             .authUserInfo,
             .authRefresh:
            guard let authServiceUrl = URL(string: environmentDetails.authHost + endpoint.relativePath) else {
                fatalError(urlMalformedException)
            }
            
            return authServiceUrl
            
        case .vehicleRules:
            guard let url = URL(string: endpoint.path) else {
                fatalError(urlMalformedException)
            }
            return url
        default:
            guard let url = URL(string: environmentDetails.host + endpoint.path) else {
                fatalError(urlMalformedException)
            }
            return url
        }
    }

    var urlMalformedException: String {
       return "KarhooSDK: Could not resolve host URL"
    }
}
