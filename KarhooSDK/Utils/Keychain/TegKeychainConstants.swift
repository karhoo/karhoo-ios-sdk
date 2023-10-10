/*
 Copyright (c) 2015 - 2021 Evgenii Neumerzhitckii
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import Security

/// Constants used by the library
public struct KeychainSwiftConstants {
  /// Specifies a Keychain access group. Used for sharing Keychain items between apps.
  public static var accessGroup: String { return toString(kSecAttrAccessGroup) }
  
  /**
   
   A value that indicates when your app needs access to the data in a keychain item. The default value is AccessibleWhenUnlocked. For a list of possible values, see KeychainSwiftAccessOptions.
   
   */
  public static var accessible: String { return toString(kSecAttrAccessible) }
  
  /// Used for specifying a String key when setting/getting a Keychain value.
  public static var attrAccount: String { return toString(kSecAttrAccount) }

  /// Used for specifying synchronization of keychain items between devices.
  public static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
  
  /// An item class key used to construct a Keychain search dictionary.
  public static var klass: String { return toString(kSecClass) }
  
  /// Specifies the number of values returned from the keychain. The library only supports single values.
  public static var matchLimit: String { return toString(kSecMatchLimit) }
  
  /// A return data type used to get the data from the Keychain.
  public static var returnData: String { return toString(kSecReturnData) }
  
  /// Used for specifying a value when setting a Keychain value.
  public static var valueData: String { return toString(kSecValueData) }
    
  /// Used for returning a reference to the data from the keychain
  public static var returnReference: String { return toString(kSecReturnPersistentRef) }
  
  /// A key whose value is a Boolean indicating whether or not to return item attributes
  public static var returnAttributes : String { return toString(kSecReturnAttributes) }
    
  /// A value that corresponds to matching an unlimited number of items
  public static var secMatchLimitAll : String { return toString(kSecMatchLimitAll) }
    
  static func toString(_ value: CFString) -> String {
    return value as String
  }
}


