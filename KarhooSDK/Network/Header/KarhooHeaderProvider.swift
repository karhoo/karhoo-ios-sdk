//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

class KarhooHeaderProvider: HeaderProvider {

    fileprivate let accessTokenProvider: AccessTokenProvider
    fileprivate var quoteUUID: String?

    init(authTokenProvider: AccessTokenProvider = DefaultAccessTokenProvider.shared) {
        self.accessTokenProvider = authTokenProvider
    }

    func combine(headers: inout HttpHeaders, with otherHeaders: HttpHeaders) -> HttpHeaders {
        headers.merge(otherHeaders) { (_, new) in new }
        return headers
    }

    func headersWithJSONContentType(headers: inout HttpHeaders) -> HttpHeaders {
        headers[HeaderConstants.contentType] = HeaderConstants.typeJSON
        return headers
    }
    
    func headersWithAcceptJSONType(headers: inout HttpHeaders) -> HttpHeaders {
        headers[HeaderConstants.accept] = HeaderConstants.typeJSON
        return headers
    }

    func headersWithFormEncodedType(headers: inout HttpHeaders) -> HttpHeaders {
        headers[HeaderConstants.contentType] = HeaderConstants.typeEncoded
        return headers
    }

    func headersWithAuthorization(headers: inout HttpHeaders, endpoint: APIEndpoint) -> HttpHeaders {
        switch Karhoo.configuration.authenticationMethod() {
        case .guest(let settings):
            headers[HeaderConstants.identifier] = settings.identifier
            headers[HeaderConstants.referer] = settings.referer
            return headers
        default: break
        }
        
        switch endpoint {
        case .login,
             .karhooUserTokenRefresh,
             .register,
             .passwordReset:
            return headers
        default:
            if let token = accessTokenProvider.accessToken?.token {
                headers[HeaderConstants.authorization] = "\(HeaderConstants.bearer) \(token)"
            }
            return headers
        }
    }

    func headersWithCorrelationId(headers: inout HttpHeaders, endpoint: APIEndpoint) -> HttpHeaders {
        var uuid: String
        switch endpoint {
        case .quoteListId:
            uuid = createQuoteUUID()
        case .bookTrip:
            uuid = bookingUUID()
        default:
            uuid = UUID().uuidString
        }
        headers[HeaderConstants.correlationId] = "\(HeaderConstants.correlationIdPrefix)\(uuid)"
        return headers
    }

    private func createQuoteUUID() -> String {
        quoteUUID = UUID().uuidString
        return bookingUUID()
    }

    private func bookingUUID() -> String {
        return quoteUUID ?? UUID().uuidString
    }
}
