//
//  HTTPError.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public struct HTTPError: KarhooError, Equatable {
    public let statusCode: Int
    public let errorType: ErrorType
    public let message: String

    public var code: String {
        return "HTTP\(statusCode)"
    }

    public init(statusCode: Int,
                error: NSError?) {
        self.statusCode = statusCode
        self.errorType = ErrorType(rawValue: error?.code ?? 0) ?? .unknown
        self.message = error?.localizedDescription ?? ""
    }

    public init(statusCode: Int,
                errorType: ErrorType,
                message: String = "") {
        self.statusCode = statusCode
        self.errorType = errorType
        self.message = message
    }

    static var unauthorizedError: HTTPError {
        return HTTPError(statusCode: 401, errorType: .userAuthenticationRequired)
    }

    public enum ErrorType: Int {
        case unknown = -1
        case cancelled = -999
        case badURL = -1000
        case timedOut = -1001
        case unsupportedURL = -1002
        case cannotFindHost = -1003
        case cannotConnectToHost = -1004
        case connectionLost = -1005
        case lookupFailed = -1006
        case HTTPTooManyRedirects = -1007
        case resourceUnavailable = -1008
        case notConnectedToInternet = -1009
        case redirectToNonExistentLocation = -1010
        case badServerResponse = -1011
        case userCancelledAuthentication = -1012
        case userAuthenticationRequired = -1013
        case zeroByteResource = -1014
        case cannotDecodeRawData = -1015
        case cannotDecodeContentData = -1016
        case cannotParseResponse = -1017
        case appTransportSecurityRequiresSecureConnection = -1022
        case fileDoesNotExist = -1100
        case fileIsDirectory = -1101
        case noPermissionsToReadFile = -1102
        case dataLengthExceedsMaximum = -1103

        // SSL errors
        case secureConnectionFailed = -1200
        case serverCertificateHasBadDate = -1201
        case serverCertificateUntrusted = -1202
        case serverCertificateHasUnknownRoot = -1203
        case serverCertificateNotYetValid = -1204
        case clientCertificateRejected = -1205
        case clientCertificateRequired = -1206
        case cannotLoadFromNetwork = -2000

        // Download and file I/O errors
        case cannotCreateFile = -3000
        case cannotOpenFile = -3001
        case cannotCloseFile = -3002
        case cannotWriteToFile = -3003
        case cannotRemoveFile = -3004
        case cannotMoveFile = -3005
        case downloadDecodingFailedMidStream = -3006
        case downloadDecodingFailedToComplete = -3007

        case internationalRoamingOff = -1018
        case callIsActive = -1019
        case dataNotAllowed = -1020
        case requestBodyStreamExhausted = -1021

        case backgroundSessionRequiresSharedContainer = -995
        case backgroundSessionInUseByAnotherProcess = -996
        case backgroundSessionWasDisconnected = -997
    }

    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        return lhs.statusCode == rhs.statusCode && lhs.errorType == rhs.errorType
    }
}
