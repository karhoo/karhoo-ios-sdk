//
//  TokenRefreshingHttpClient.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class TokenRefreshingHttpClient: HttpClient {

    private let httpClient: HttpClient
    private let refreshTokenProvider: RefreshTokenInteractor
    private let dataStore: UserDataStore
    
    static let shared = TokenRefreshingHttpClient()
    
    init(httpClient: HttpClient = JsonHttpClient.shared,
         refreshTokenProvider: RefreshTokenInteractor = KarhooRefreshTokenInteractor(),
         dataStore: UserDataStore = DefaultUserDataStore()) {
        self.httpClient = httpClient
        self.refreshTokenProvider = refreshTokenProvider
        self.dataStore = dataStore
    }
    
    @discardableResult
    func sendRequest(endpoint: APIEndpoint,
                     data: Data? = nil,
                     urlComponents: URLComponents? = nil,
                     completion: @escaping CallbackClosure<HttpResponse>) -> NetworkRequest? {
        
        if refreshTokenProvider.tokenNeedsRefreshing() == true {
            return refreshTokenChainWithRequest(endpoint: endpoint,
                                                data: data,
                                                completion: completion)
        } else {
            let completion: CallbackClosure<HttpResponse> = { [weak self] result in
                
                if result.errorValue()?.isUnauthorizedError() == true {
                    self?.refreshTokenChainWithRequest(endpoint: endpoint,
                                                       data: data,
                                                       completion: completion)
                } else {
                    completion(result)
                }
            }
            
            return httpClient.sendRequest(endpoint: endpoint,
                                          data: data,
                                          urlComponents: nil,
                                          completion: completion)
        }
    }
    
    // this method is not required in this client
    func sendRequestWithCorrelationId(
        endpoint: APIEndpoint,
        data: Data?,
        urlComponents: URLComponents?,
//        correlationId: String?,
        completion: @escaping CallbackClosureWithCorrelationId<HttpResponse>
    ) -> NetworkRequest? {
        return nil
    }
    
    private func logUserOut() {
        dataStore.removeCurrentUserAndCredentials()
    }
    
    @discardableResult
    private func refreshTokenChainWithRequest(endpoint: APIEndpoint,
                                              data: Data?,
                                              completion: @escaping CallbackClosure<HttpResponse>) -> NetworkRequest? {
        let requestWrapper = AsyncNetworkRequestWrapper()
        
        refreshTokenProvider.refreshToken { [weak self] result in
            
            guard requestWrapper.cancelled == false else {
                return
            }
            
            if let error = result.errorValue(), error.isConnectionError() == true {
                completion(Result.failure(error: error))
                return
            }
            
            if let error = result.errorValue() {
                self?.logUserOut()
                completion(Result.failure(error: error))
                return
            }
            
            requestWrapper.realRequest = self?.httpClient.sendRequest(endpoint: endpoint,
                                                                      data: data,
                                                                      urlComponents: nil,
                                                                      completion: { result in
                                                                        completion(result)
            })
        }
        return requestWrapper
    }
}

class AsyncNetworkRequestWrapper: NetworkRequest {
    private(set) var cancelled = false
    fileprivate(set) var realRequest: NetworkRequest?
    
    var hasRequest: Bool {
        return realRequest != nil
    }
    
    func cancel() {
        cancelled = true
        realRequest?.cancel()
    }
}
