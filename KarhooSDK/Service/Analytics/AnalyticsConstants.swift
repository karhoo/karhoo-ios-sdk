//
//  AnalyticsConstants.swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public enum AnalyticsConstants {

    public enum EventNames: String {

        case guestMode = "guest_mode"
        case userLoggedIn = "user_logged_in"
        case userLoggedOut = "user_logged_out"
        case appOpened = "app_opened"
        case appBackgrounded = "app_backgrounded"
        case registrationStarted = "user_registration_started"
        case registrationCompleted = "user_registration_completed"
        case userTermsReviewed = "user_terms_reviewed"
        case appClosed = "app_closed"
        case userProfileSavePressed = "user_profile_save_pressed"
        case userProfileEditPressed = "user_profile_edit_pressed"
        case userProfileDiscardPressed = "user_profile_discard_pressed"
        case userProfileUpdateSuccess = "user_profile_update_success"
        case userProfleUpdateFailed = "user_profile_update_failed"

        case currentLocationPressed = "current_location_pressed"
        case pickupAddressDisplayed = "pickup_address_displayed"
        case pickupAddressSelected = "pickup_address_selected"
        case destinationAddressDisplayed = "destination_address_displayed"
        case destinationAddressSelected = "destination_address_selected"
        case addressesSuggested = "addresses_suggested"
        case bookingRequested = "booking_requested"
        case pickupReverseGeocodeRequested = "pickup_reverse_geocode_requested"
        case pickupReverseGeocodeResponded = "pickup_reverse_geocode_responded"
        case preebookTimeSet = "preebook_time_set"
        case userCardRegistered = "user_card_registered"
        case userCardRegistrationFailed = "user_card_registration_failed"
        case tripCancellationAttempted = "trip_cancellation_attempted_by_user"
        case tripCancellationInitiatedByUser = "trip_cancellation_initiated_by_user"
        case categorySelected = "vehicle_type_selected"
        case availabilityListExpanded = "fleet_list_extended"
        case fleetListSorted = "fleets_sorted"
        case fleetListShown = "fleet_list_shown"
        case locationServicesRejected = "location_services_rejected"
        case prebookOpened = "prebook_picker_opened"
        case prebookTimeSet = "prebook_time_set"
        case stateChangeDisplayed = "state_change_displayed"
        case baseFareDialogViewed = "base_fare_dialog_viewed"
        case destinationFieldPressed = "destination_field_pressed"
        case userCalledDriver = "user_called_driver"
        case rideSummaryExited = "ride_summary_exited"
        case returnRideRequested = "return_ride_requested"
        case changePaymentDetailsPressed = "chenge_payment_details_pressed"
        case tripRatingSubmitted = "trip_rating_submitted"
        case quoteRating = "quote_selection_rating"
        case prePobRating = "pre_pob_experience_rating"
        case pobExperienceRating = "pob_experience_rating"
        case appExperienceRating = "app_experience_rating"
        case additional_feedback = "additional_feedback"
        case additional_feedback_submitted = "additional_feedback_submitted"
        case ssoTokenRevoked = "sso_token_revoked"
        case ssoUserLogIn = "sso_user_logged_in"
        case requestFails = "request_error"

        case bookingScreenOpened = "RIDE_PLANNING_SCREEN"
        case quoteListOpened = "QUOTE_LIST_SCREEN"
        case checkoutOpened = "CHECKOUT_SCREEN"
        case checkoutBookingRequested = "CHECKOUT_BOOKING_REQUESTED"
        case paymentSucceed = "PAYMENT_CONFIRMED"
        case paymentFailed = "PAYMENT_REFUSED_OR_REJECTED"
        case trackTripOpened = "VEHICLE_TRACKING_SCREEN"
        case ridesPastTripsOpened = "RIDES_PAST_LIST"
        case ridesUpcomingTripsOpened = "RIDES_UPCOMING_LIST"
        case ridesUpcomingTrackTripClicked = "RIDES_UPCOMING_VEHICLE_TRACKING_CLICKED"
        case ridesUpcomingContactFleetClicked = "RIDES_UPCOMING_CONTACT_FLEET_CLICKED"
        case ridesUpcomingContactDriverClicked = "RIDES_UPCOMING_CONTACT_DRIVER_CLICKED"
        case trackingContactDriverClicked = "VEHICLE_TRACKING_SCREEN_CONTACT_DRIVER_CLICKED"
        
        public var description: String {
            return rawValue
        }
    }

    public enum Keys: String {

        case userId = "user_id"
        case locationLat = "user_location_latitude"
        case locationLong = "user_location_longitude"
        case locationAccuracy = "user_location_accuracy"

        case sendingApp = "sendingApp"
        case permID = "perm_id"
        case sessionID = "session_id"
        case timestamp = "timestamp"

        case categorySelected = "category"
        case tripState = "tripState"
        case sortType = "sortType"
        case qtaListId = "qta_list_id"
        case quoteListId = "quote_list_id"
        case prebookTimeSet = "prebook_time_set"
        case countAddressOptions = "countAddressOptions"
        case address = "address"
        case requestError = "request_error"
        case requestUrl = "request_url"

        case unkownBundleIdentifier = "unkown app"

        case batteryLife = "batteryLife"
        case networkType = "networkType"
        case appVersion = "appVersion"
        case price = "price"
        case priceCurrency = "priceCurrency"
        case destinationLatitude = "destinationLatitude"
        case destinationLongitude = "destinationLongitude"
        case destinationAddress = "destinationAddress"
        case isPrebook = "isPrebook"

        var description: String {
            return rawValue
        }
    }
}
