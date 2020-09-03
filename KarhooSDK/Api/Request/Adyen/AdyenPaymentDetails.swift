//
//  AdyenPaymentDetails.swift
//  KarhooSDK
//
//  Created by Nurseda Balcioglu on 01/09/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public struct AdyenPaymentDetails: Codable, KarhooCodableModel {
    
    public let MD: String
    public let PaReq: String
    public let PaRes: String
    public let billingToken: String
    public let cupSecurePlusSmsCode: String
    public let facilitatorAccessToken: String
    public let oneTimePasscode: String
    public let orderID: String
    public let payerID: String
    public let payload: String
    public let paymentID: String
    public let paymentStatus: String
    public let redirectResult: String
    public let returnUrlQueryString: String
    public let threeds2ChallengeResult: String
    public let threeds2Fingerprint: String
    
    public init(MD: String = "",
                PaReq: String = "",
                PaRes: String = "",
                billingToken: String = "",
                cupSecurePlusSmsCode: String = "",
                facilitatorAccessToken: String = "",
                oneTimePasscode: String = "",
                orderID: String = "",
                payerID: String = "",
                payload: String = "",
                paymentID: String = "",
                paymentStatus: String = "",
                redirectResult: String = "",
                threeds2ChallengeResult: String = "",
                threeds2Fingerprint: String = ""
                returnUrlQueryString: String = "") {
        self.MD = MD
        self.PaReq = PaReq
        self.PaRes = PaRes
        self.billingToken = billingToken
        self.cupSecurePlusSmsCode = cupSecurePlusSmsCode
        self.facilitatorAccessToken = facilitatorAccessToken
        self.oneTimePasscode = oneTimePasscode
        self.orderID = orderID
        self.payerID = payerID
        self.payload = payload
        self.paymentID = paymentID
        self.paymentStatus = paymentStatus
        self.redirectResult = redirectResult
        self.returnUrlQueryString = returnUrlQueryString
        self.threeds2ChallengeResult = threeds2ChallengeResult
        self.threeds2Fingerprint = threeds2Fingerprint
    }
    
    enum CodingKeys: String, CodingKey {
        case MD
        case PaReq
        case PaRes
        case billingToken
        case cupSecurePlusSmsCode = "cupsecureplus.smscode"
        case facilitatorAccessToken
        case oneTimePasscode
        case orderID
        case payerID
        case payload
        case paymentID
        case paymentStatus
        case redirectResult
        case returnUrlQueryString
        case threeds2ChallengeResult = "threeds2.challengeResult"
        case threeds2Fingerprint = "threeds2.fingerprintcase"
    }
    
}
