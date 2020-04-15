import Foundation

public struct KarhooEnvironmentDetails {
    public let host: String
    public let guestHost: String
    public let authHost: String

    public init(host: String,
                authHost: String,
                guestHost: String) {
        self.host = host
        self.authHost = authHost
        self.guestHost = guestHost
    }
}

internal extension KarhooEnvironmentDetails {

    init(environment: KarhooEnvironment) {
        switch environment {
        case .custom(let environment):
            self.host = environment.host
            self.authHost = environment.authHost
            self.guestHost = environment.guestHost
        case .sandbox:
            self.host = "https://rest.sandbox.karhoo.com"
            self.authHost = "https://sso.sandbox.karhoo.com"
            self.guestHost = "https://public-api.sandbox.karhoo.com"
        case .production:
            self.host = "https://rest.karhoo.com"
            self.authHost = "https://sso.karhoo.com"
            self.guestHost = "https://public-api.karhoo.com"
        }
    }
}
