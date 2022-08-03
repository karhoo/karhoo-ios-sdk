//
// Created by Bartlomiej Sopala on 18/07/2022.
//

import Foundation

protocol PaymentProviderUpdateHandler: AnyObject {
    func updatePaymentProvider(user: UserInfo)
}
