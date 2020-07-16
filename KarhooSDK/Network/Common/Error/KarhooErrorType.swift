//
//  KarhooErrorType.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

//swiftlint:disable cyclomatic_complexity function_body_length

import Foundation

public enum KarhooErrorType {

    // KSDKxxx Internal SDK
    case unknownError
    case missingUserPermission
    case userAlreadyLoggedIn

    // K0xxx General Errors
    case generalRequestError
    case invalidRequestPayload
    case couldNotReadAuthorisationToken
    case couldNotParseAuthorisationToken
    case authenticationIsRequiredForThisPath
    case missingRequiredRoleForThisRequest
    case rateLimitExceeded
    case circuitBreakerHasTriggeredForThisRoute
    // K1xxx Users
    case couldNotRegister
    case couldNotGetUserDetails
    case couldNotAddToOrganisation
    case organisationDoesntExist
    case roleDoesntExist
    case missingPermissionsToViewProfile
    case passwordInWrongFormat

    // K2xxx Location
    case couldNotGetAddress
    case couldNotAutocompleteAddress

    // K3xxx Quotes
    case couldNotGetEstimates
    case couldNotFindSpecifiedQuote
    case originAndDestinationAreTheSame

    // K4xxx Booking
    case couldNotBookTrip
    case couldNotBookTripInvalidRequest
    case couldNotBookTripCouldNotFindQuote
    case couldNotBookTripAttemptToBookExpiredQuote
    case couldNotBookTripPermissionsDenied
    case couldNotBookTripPaymentPreAuthFailed
    case couldNotCancelTrip
    case couldNotCancelTripCouldNotFindSpecifiedTrip
    case couldNotCancelTripPermissionsDenied
    case couldNotCancelTripAlreadyCanceled
    case couldNotGetTrip
    case couldNotGetTripCouldNotFindSpecifiedTrip
    case couldNotGetTripPermissionsDenied
    case couldNotBookTripCouldNotBookTripAsAgent
    case couldNotBookTripCouldNotBookTripAsTraveller
    case couldNotBookTripQuoteNoLongerAvailable

    // K5xxx Availability
    case noAvailabilityInRequestedArea
    case noAvailableCategoriesInRequestedArea
    
    // KPxxx Braintree Payments
    case couldNotFindCustomer
    case couldNotInitailizeClient
    case couldNotFindDefaultPayment
    case couldNotFindDefaultCard
    case failedToGenerateNonce
    case failedToCallMoneyService
}

extension KarhooErrorType {
    init(error: KarhooError) {
        switch error.code {

        // KSDKxxx Internal SDK
        case "KSDK01": self = .unknownError
        case "KSDK02": self = .missingUserPermission
        case "KSDK03": self = .userAlreadyLoggedIn

        // K0xxx General Errors
        case "K0001": self = .generalRequestError
        case "K0002": self = .invalidRequestPayload
        case "K0003": self = .couldNotReadAuthorisationToken
        case "K0004": self = .couldNotParseAuthorisationToken
        case "K0005": self = .missingRequiredRoleForThisRequest
        case "K0006": self = .rateLimitExceeded
        case "K0007": self = .circuitBreakerHasTriggeredForThisRoute

        // K1xxx Users
        case "K1001", "K1003", "K1004": self = .couldNotRegister
        case "K1005", "K1006": self = .couldNotGetUserDetails
        case "K1007": self = .couldNotAddToOrganisation
        case "K1008": self = .organisationDoesntExist
        case "K1009": self = .roleDoesntExist
        case "K1010": self = .missingPermissionsToViewProfile
        case "K1011": self = .passwordInWrongFormat

        // K2xxx Location
        case "K2001": self = .couldNotGetAddress
        case "K2002": self = .couldNotAutocompleteAddress

        // K3xxx Quotes
        case "K3001": self = .couldNotGetEstimates
        case "K3002", "K5002": self = .noAvailabilityInRequestedArea
        case "K3003": self = .couldNotFindSpecifiedQuote

        case "Q0001": self = .originAndDestinationAreTheSame

        // K4xxx Booking
        case "K4001": self = .couldNotBookTrip
        case "K4002": self = .couldNotBookTripInvalidRequest
        case "K4003": self = .couldNotBookTripCouldNotFindQuote
        case "K4004": self = .couldNotBookTripAttemptToBookExpiredQuote
        case "K4005": self = .couldNotBookTripPermissionsDenied
        case "K4006": self = .couldNotBookTripPaymentPreAuthFailed
        case "K4007": self = .couldNotCancelTrip
        case "K4008": self = .couldNotCancelTripCouldNotFindSpecifiedTrip
        case "K4009": self = .couldNotCancelTripPermissionsDenied
        case "K4010": self = .couldNotCancelTripAlreadyCanceled
        case "K4011": self = .couldNotGetTrip
        case "K4012": self = .couldNotGetTripCouldNotFindSpecifiedTrip
        case "K4013": self = .couldNotGetTripPermissionsDenied
        case "K4014": self = .couldNotBookTripCouldNotBookTripAsAgent
        case "K4015": self = .couldNotBookTripCouldNotBookTripAsTraveller
        case "K4018": self = .couldNotBookTripQuoteNoLongerAvailable

        // K5xxx Availability
        case "K5001": self = .couldNotGetEstimates
        case "K5003": self = .noAvailableCategoriesInRequestedArea
            
        // KPxxx Payments
        case "KP001": self = .couldNotFindCustomer
        case "KP002": self = .couldNotInitailizeClient
        case "KP003": self = .couldNotFindDefaultPayment
        case "KP004": self = .couldNotFindDefaultCard
        case "KP005": self = .failedToGenerateNonce
        case "P0002": self = .failedToCallMoneyService

        default: self = .unknownError
        }
    }
}
