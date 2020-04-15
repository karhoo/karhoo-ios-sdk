//
//  KarhooCodableModel.Swift
//  KarhooSDK
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

public protocol KarhooCodableModel: Codable {
    func encode() -> Data?

    func equals(_ item: KarhooCodableModel) -> Bool
}

extension KarhooCodableModel {

    public func encode() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch let error {
            print("----Error Encoding model: \(self) | Reason: \(error.localizedDescription)")
            return nil
        }
    }

    public func equals(_ item: KarhooCodableModel) -> Bool {
        return self.encode() == item.encode()
    }
}

extension Array: KarhooCodableModel where Element: KarhooCodableModel {}
