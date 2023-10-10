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

import Security

/**

These options are used to determine when a keychain item should be readable. The default value is AccessibleWhenUnlocked.

*/
public enum KeychainSwiftAccessOptions {
  
  /**
  
  The data in the keychain item can be accessed only while the device is unlocked by the user.
  
  This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute migrate to a new device when using encrypted backups.
  
  This is the default value for keychain items added without explicitly setting an accessibility constant.
  
  */
  case accessibleWhenUnlocked
  
  /**
  
  The data in the keychain item can be accessed only while the device is unlocked by the user.
  
  This is recommended for items that need to be accessible only while the application is in the foreground. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
  
  */
  case accessibleWhenUnlockedThisDeviceOnly
  
  /**
  
  The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
  
  After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute migrate to a new device when using encrypted backups.
  
  */
  case accessibleAfterFirstUnlock
  
  /**
  
  The data in the keychain item cannot be accessed after a restart until the device has been unlocked once by the user.
  
  After the first unlock, the data remains accessible until the next restart. This is recommended for items that need to be accessed by background applications. Items with this attribute do not migrate to a new device. Thus, after restoring from a backup of a different device, these items will not be present.
  
  */
  case accessibleAfterFirstUnlockThisDeviceOnly

  /**
  
  The data in the keychain can only be accessed when the device is unlocked. Only available if a passcode is set on the device.
  
  This is recommended for items that only need to be accessible while the application is in the foreground. Items with this attribute never migrate to a new device. After a backup is restored to a new device, these items are missing. No items can be stored in this class on devices without a passcode. Disabling the device passcode causes all items in this class to be deleted.
  
  */
  case accessibleWhenPasscodeSetThisDeviceOnly
  
  static var defaultOption: KeychainSwiftAccessOptions {
    return .accessibleWhenUnlocked
  }
  
  var value: String {
    switch self {
    case .accessibleWhenUnlocked:
      return toString(kSecAttrAccessibleWhenUnlocked)
      
    case .accessibleWhenUnlockedThisDeviceOnly:
      return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
      
    case .accessibleAfterFirstUnlock:
      return toString(kSecAttrAccessibleAfterFirstUnlock)
      
    case .accessibleAfterFirstUnlockThisDeviceOnly:
      return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)
      
    case .accessibleWhenPasscodeSetThisDeviceOnly:
      return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)
    }
  }
  
  func toString(_ value: CFString) -> String {
    return KeychainSwiftConstants.toString(value)
  }
}
