//
//  Karhoo.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public final class Karhoo {

    public private(set) static var configuration: KarhooSDKConfiguration!

    public class func set(configuration: KarhooSDKConfiguration) {
        self.configuration = configuration
    }

    private static var userService: UserService?
    public class func getUserService() -> UserService {
        if userService == nil {
            userService = KarhooUserService()
        }
        return userService!
    }

    private static var availabilityService: AvailabilityService?
    public static func getAvailabilityService() -> AvailabilityService {
        if availabilityService == nil {
            availabilityService = KarhooAvailabilityService()
        }
        return availabilityService!
    }

    private static var addressService: AddressService?
    public static func getAddressService() -> AddressService {
        if addressService == nil {
            addressService = KarhooAddressService()
        }
        return addressService!
    }

    public static func getAnalyticsService() -> AnalyticsService {
        return KarhooAnalyticsService()
    }

    private static var quoteService: KarhooQuoteService?
    public static func getQuoteService() -> QuoteService {
        if quoteService == nil {
            quoteService = KarhooQuoteService()
        }
        return quoteService!
    }

    private static var paymentService: PaymentService?
    public static func getPaymentService() -> PaymentService {
        if paymentService == nil {
            paymentService = KarhooPaymentService()
        }
        return paymentService!
    }

    private static var tripService: KarhooTripService?
    public static func getTripService() -> TripService {

        if tripService == nil {
            tripService = KarhooTripService()
        }
        return tripService!
    }

    private static var driverTrackingService: KarhooDriverTrackingService?
    public static func getDriverTrackingService() -> DriverTrackingService {
        if driverTrackingService == nil {
            driverTrackingService = KarhooDriverTrackingService()
        }
        return driverTrackingService!
    }

    private static var configService: ConfigService?
    public static func getConfigService() -> ConfigService {
        if configService == nil {
            configService = KarhooConfigService()
        }

        return configService!
    }
    
    private static var fareService: FareService?
    public static func getFareService() -> FareService {
        if fareService == nil {
            fareService = KarhooFareService()
        }
        
        return fareService!
    }
    
    private static var authService: AuthService?
    public class func getAuthService() -> AuthService {
        if authService == nil {
            authService = KarhooAuthService()
        }
        return authService!
    }

    public final class Utils {
        public class func getBroadcaster<T>(ofType: T.Type) -> Broadcaster<T> {
            return Broadcaster<T>()
        }
    }
}
