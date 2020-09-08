//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol HeaderProvider {

    func combine(headers: inout HttpHeaders, with otherHeaders: HttpHeaders) -> HttpHeaders

    func headersWithAuthorization(headers: inout HttpHeaders, endpoint: APIEndpoint) -> HttpHeaders

    func headersWithCorrelationId(headers: inout HttpHeaders, endpoint: APIEndpoint) -> HttpHeaders

    func headersWithJSONContentType(headers: inout HttpHeaders) -> HttpHeaders

    func headersWithFormEncodedType(headers: inout HttpHeaders) -> HttpHeaders
    
    func headersWithAcceptJSONType(headers: inout HttpHeaders) -> HttpHeaders

}
