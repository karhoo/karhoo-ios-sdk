import Foundation

public struct UserRegistration: KarhooCodableModel {

    public let firstName: String
    public let lastName: String
    public let email: String
    public let phoneNumber: String
    public let locale: String?
    public let password: String

    public init(firstName: String = "",
                lastName: String = "",
                email: String = "",
                phoneNumber: String = "",
                locale: String? = nil,
                password: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.locale = locale
        self.password = password
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case phoneNumber = "phone_number"
        case locale
    }
}
