import Foundation

public struct AccessToken {
    let token: String

    public init(token: String) {
        self.token = token
    }
}

public protocol AccessTokenProvider {
    var accessToken: AccessToken? { get }
}

public class DefaultAccessTokenProvider: AccessTokenProvider {
    public var accessToken: AccessToken? {
        if let token = userStore.getCurrentCredentials()?.accessToken {
            return AccessToken(token: token)
        }
        return nil
    }

    static let shared = DefaultAccessTokenProvider()

    private let userStore: UserDataStore

    init(userStore: UserDataStore = DefaultUserDataStore()) {
        self.userStore = userStore
    }
}
