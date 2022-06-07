//
// 
// Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

@testable import KarhooSDK

final class QuoteMock {

    private var quote: Quote

    init() {
        self.quote = Quote()
    }

    func build() -> Quote {
        return quote
    }

    func set(quoteId: String) -> QuoteMock {
        create(quoteId: quoteId)
        return self
    }

    func set(fleetId: String) -> QuoteMock {
        create(fleetId: fleetId)
        return self
    }

    func set(availabilityId: String) -> QuoteMock {
        create(availabilityId: availabilityId)
        return self
    }

    func set(phoneNumber: String) -> QuoteMock {
        create(phoneNumber: phoneNumber)
        return self
    }

    func set(fleetName: String) -> QuoteMock {
        create(fleetName: fleetName)
        return self
    }

    func set(supplierLogoUrl: String) -> QuoteMock {
        create(supplierLogoUrl: supplierLogoUrl)
        return self
    }

    func set(vehicleClass: String) -> QuoteMock {
        create(vehicleClass: vehicleClass)
        return self
    }

    func set(quoteType: QuoteType) -> QuoteMock {
        create(quoteType: quoteType)
        return self
    }

    func set(highPrice: Int) -> QuoteMock {
        create(highPrice: highPrice)
        return self
    }

    func set(lowPrice: Int) -> QuoteMock {
        create(lowPrice: lowPrice)
        return self
    }

    func set(currencyCode: String) -> QuoteMock {
        create(currencyCode: currencyCode)
        return self
    }

    func set(qtaHighMinutes: Int) -> QuoteMock {
        create(qtaHighMinutes: qtaHighMinutes)
        return self
    }

    func set(qtaLowMinutes: Int) -> QuoteMock {
        create(qtaLowMinutes: qtaLowMinutes)
        return self
    }

    func set(termsAndConditionsUrl: String) -> QuoteMock {
        create(termsConditionsUrl: termsAndConditionsUrl)
        return self
    }

    func set(categoryName: String) -> QuoteMock {
        create(categoryName: categoryName)
        return self
    }
    
    func set(fleet: Fleet) -> QuoteMock {
        create(fleet: fleet)
        return self
    }
    
    func set(vehicle: QuoteVehicle) -> QuoteMock {
        create(vehicle: vehicle)
        return self
    }

    private func create(quoteId: String? = nil,
                        fleetId: String? = nil,
                        availabilityId: String? = nil,
                        phoneNumber: String? = nil,
                        fleetName: String? = nil,
                        supplierLogoUrl: String? = nil,
                        vehicleClass: String? = nil,
                        quoteType: QuoteType? = nil,
                        highPrice: Int? = nil,
                        lowPrice: Int? = nil,
                        currencyCode: String? = nil,
                        qtaHighMinutes: Int? = nil,
                        qtaLowMinutes: Int? = nil,
                        termsConditionsUrl: String? = nil,
                        categoryName: String? = nil,
                        fleet: Fleet? = nil,
                        vehicle: QuoteVehicle? = nil) {
        let quoteVehicle = QuoteVehicle(type: categoryName ?? "",
                                        qta: QuoteQta(highMinutes: qtaHighMinutes ?? 0,
                                                      lowMinutes: qtaLowMinutes ?? 0))
        self.quote = Quote(
                id: quoteId ?? quote.id,
                quoteType: quoteType ?? quote.quoteType,
                fleet: fleet ?? quote.fleet,
                vehicle: quoteVehicle)
    }
}
