import Foundation

enum APIEndpoint {

    case quoteListId(locale: String?)
    case quotes(identifier: String, locale: String?)
    case bookTrip
    case bookTripWithNonce
    case cancelTrip(identifier: String)
    case cancelTripFollowCode(followCode: String)
    case cancellationFee(identifier: String)
    case cancellationFeeFollowCode(followCode: String)
    case trackDriver(identifier: String)
    case trackTrip(identifier: String)
    case trackTripFollowCode(followCode: String)
    case tripSearch
    case tripStatus(identifier: String)
    case getFareDetails(identifier: String)
    case locationInfo
    case placeSearch
    case reverseGeocode(position: Position)
    case login
    case paymentSDKToken(payload: PaymentSDKTokenPayload)
    case addPaymentDetails
    case karhooUserTokenRefresh
    case custom(path: String, method: HttpMethod)
    case authTokenExchange
    case authRevoke
    case authUserInfo
    case authRefresh
    case paymentProvider
    case adyenPaymentMethods(paymentAPIVersion: String)
    case adyenPayments(paymentAPIVersion: String)
    case adyenPaymentsDetails(paymentAPIVersion: String)
    case adyenPublicKey
    case adyenClientKey
    case quoteCoverage(coverageCheckRequest: QuoteCoverageRequest)
    case vehicleImageRules
    case verifyQuote(quoteID: String)
    case loyaltyStatus(identifier: String)
    case loyaltyBurn(identifier: String, currency: String, amount: Int)
    case loyaltyEarn(identifier: String, currency: String, amount: Int, burnPoints: Int)
    case loyaltyPreAuth(identifier: String)
    case loyaltyBalance(identifier: String)
    case loyaltyConversion(identifier: String)
    
    var path: String {
        switch self {
        case .custom(let path, _):
            return path
        case .loyaltyStatus( _),
                .loyaltyBurn( _, _, _),
                .loyaltyEarn( _, _, _, _),
                .loyaltyPreAuth( _):
            return relativePath
        default:
            return "/\(version)\(relativePath)"
        }
    }

    var relativePath: String {
        switch self {
        case .quoteListId(let locale):
            return isNilEmptyOrWhitespace(text: locale) ? "/quotes/" : "/quotes?locale=\(locale!)"
        case .quotes(let identifier, let locale):
            return isNilEmptyOrWhitespace(text: locale) ? "/quotes/\(identifier)" : "/quotes/\(identifier)?locale=\(locale!)"
        case .bookTrip:
            return "/bookings"
        case .bookTripWithNonce:
            return "/bookings/with-nonce"
        case .cancelTrip(let identifier):
            return "/bookings/\(identifier)/cancel"
        case .cancelTripFollowCode(let followCode):
            return "/bookings/follow/\(followCode)/cancel"
        case .trackDriver(let identifier):
            return "/bookings/\(identifier)/track"
        case .trackTrip(let identifier):
            return "/bookings/\(identifier)"
        case .trackTripFollowCode(let followCode):
            return "/bookings/follow/\(followCode)"
        case .tripSearch:
            return "/bookings/search"
        case .tripStatus(let identifier):
            return "/bookings/\(identifier)/status"
        case .cancellationFee(let identifier):
            return "/bookings/\(identifier)/cancel-fee"
        case .cancellationFeeFollowCode(let identifier):
            return "/bookings/follow/\(identifier)/cancel-fee"
        case .getFareDetails(let identifier):
            return "/fares/trip/\(identifier)"
        case .locationInfo:
            return "/locations/place-details"
        case .placeSearch:
            return "/locations/address-autocomplete"
        case .reverseGeocode(let position):
            return "/locations/reverse-geocode?latitude=\(position.latitude)&longitude=\(position.longitude)"
        case .login:
            return "/auth/token"
        case .paymentSDKToken(let payload):
            return "/payments/payment-methods/braintree/client-tokens?organisation_id=\(payload.organisationId)"
                   + "&currency=\(payload.currency)"
        case .addPaymentDetails:
            return "/payments/payment-methods/braintree/add-payment-details"
        case .karhooUserTokenRefresh:
            return "/auth/refresh"
        case .custom(let path, _):
            return path
        case .authTokenExchange:
            return "/oauth/v2/token-exchange"
        case .authRevoke:
            return "/oauth/v2/revoke"
        case .authUserInfo:
            return "/oauth/v2/userinfo"
        case .authRefresh:
            return "/oauth/v2/token"
        case .paymentProvider:
            return "/payments/providers"
        case .adyenPaymentMethods(let paymentAPIVersion):
            return "/payments/adyen\(paymentAPIVersion)/payments-methods"
        case .adyenPayments(let paymentAPIVersion):
            return "/payments/adyen\(paymentAPIVersion)/payments"
        case .adyenPaymentsDetails(let paymentAPIVersion):
            return "/payments/adyen\(paymentAPIVersion)/payments-details"
        case .adyenPublicKey:
            return "/payments/adyen/public-key"
        case .adyenClientKey:
            return "/payments/adyen/client-key"
        case .quoteCoverage(let coverageRequest):
            return "/quotes/coverage?latitude=\(coverageRequest.latitude)&longitude=\(coverageRequest.longitude)&local_time_of_pickup=\(coverageRequest.localTimeOfPickup ?? "")"
        case .vehicleImageRules:
            return "https://cdn.karhoo.com/s/images/vehicles/config.json"
        case .verifyQuote(let quoteID):
            return "/quotes/verify/\(quoteID)"
        case .loyaltyStatus(let identifier):
            return "/loyalty-\(identifier)/status"
        case .loyaltyBurn(let identifier, let currency, let amount):
            return "/loyalty-\(identifier)/exrates/\(currency)/burnpoints?amount=\(amount)"
        case .loyaltyEarn(let identifier, let currency, let amount, let burnPoints):
            return "/loyalty-\(identifier)/exrates/\(currency)/earnpoints?total_amount=\(amount)&burn_points=\(burnPoints)"
        case .loyaltyPreAuth(let identifier):
            return "/loyalty-\(identifier)/pre-auth"
        case .loyaltyBalance(let identifier):
            return "/payments/loyalty/programmes/\(identifier)/balance"
        case .loyaltyConversion(let identifier):
            return "/payments/loyalty/programmes/\(identifier)/rates"
        }
    }

    var method: HttpMethod {
        switch self {
        case .quoteListId: return .post
        case .quotes: return .get
        case .bookTrip: return .post
        case .bookTripWithNonce: return .post
        case .cancelTrip: return .post
        case .cancelTripFollowCode: return .post
        case .cancellationFee: return .get
        case .cancellationFeeFollowCode: return .get
        case .trackDriver: return .get
        case .trackTrip: return .get
        case .trackTripFollowCode: return .get
        case .tripSearch: return .post
        case .tripStatus: return .get
        case .getFareDetails: return .get
        case .locationInfo: return .post
        case .placeSearch: return .post
        case .reverseGeocode: return .get
        case .login: return .post
        case .paymentSDKToken: return .post
        case .addPaymentDetails: return .post
        case .karhooUserTokenRefresh: return .post
        case .authTokenExchange: return .post
        case .authRevoke: return .post
        case .authUserInfo: return .get
        case .authRefresh: return .post
        case .custom(_, let method): return method
        case .paymentProvider: return .get
        case .adyenPaymentMethods: return .post
        case .adyenPayments: return .post
        case .adyenPaymentsDetails: return .post
        case .adyenPublicKey: return .get
        case .adyenClientKey: return .get
        case .quoteCoverage: return .get
        case .vehicleImageRules: return .get
        case .verifyQuote: return .get
        case .loyaltyStatus: return .get
        case .loyaltyBurn: return .get
        case .loyaltyEarn: return .get
        case .loyaltyPreAuth: return .post
        case .loyaltyBalance: return .get
        case .loyaltyConversion: return .get
        }
    }

    private var version: String {
        switch self {
        case .addPaymentDetails: return "v2"
        case .paymentSDKToken: return "v2"
        case .quotes(_, _): return "v2"
        case .quoteListId: return "v2"
        case .paymentProvider: return "v3"
        case .adyenPaymentMethods: return "v3"
        case .adyenPayments: return "v3"
        case .adyenPaymentsDetails: return "v3"
        case .adyenPublicKey: return "v3"
        case .adyenClientKey: return "v3"
        case .quoteCoverage: return "v2"
        case .vehicleImageRules: return ""
        case .verifyQuote: return "v2"
        case .loyaltyBalance: return "v3"
        case .loyaltyConversion: return "v3"
        default: return "v1"
        }
    }
    
    private func isNilEmptyOrWhitespace(text: String?) -> Bool {
        return text == nil || text?.isEmpty ?? true || text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
    }
}

extension APIEndpoint: Equatable {
    public static func == (lhs: APIEndpoint, rhs: APIEndpoint) -> Bool {
        return lhs.path == rhs.path
    }
    public static func == (lhs: APIEndpoint?, rhs: APIEndpoint) -> Bool {
        return lhs?.path == rhs.path
    }
    public static func == (lhs: APIEndpoint, rhs: APIEndpoint?) -> Bool {
        return lhs.path == rhs?.path
    }
}
