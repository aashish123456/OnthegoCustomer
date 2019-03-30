//
//  SharedStorage.swift
//  NikkosDrvier
//
//  Created by Umang on 9/1/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class SharedStorage: NSObject
{
    
    
    static func getLanguage() -> String {
        
        let language : String = NikkosCustomerManager.checkNullString(string: UserDefaults.standard.object(forKey: NikkosCustomerManager.k_USER_LANG) as AnyObject)
        return language
    }
    
    static func setLanguage(language : String) -> Bool {
        UserDefaults.standard.set(language, forKey: NikkosCustomerManager.k_USER_LANG)
        return UserDefaults.standard.synchronize()
    }
    
    static func setUser(user : LoginModal) -> Bool {
        let userData:NSData = NSKeyedArchiver.archivedData(withRootObject: user) as NSData
        UserDefaults.standard.set(userData, forKey: "NC_user")
        return UserDefaults.standard.synchronize()
    }
    
    static func getUser() -> LoginModal {
        let userData : NSData = UserDefaults.standard.object(forKey: "NC_user") as! NSData
        return NSKeyedUnarchiver.unarchiveObject(with: userData as Data) as! LoginModal
    }
    static func getIsRememberMe() -> Bool {
        return UserDefaults.standard.bool(forKey: "N_IsRememberMe")
    }
    
    static func setIsRememberMe(isRememberMe: Bool) -> Bool {
        UserDefaults.standard.set(isRememberMe, forKey: "N_IsRememberMe")
        return UserDefaults.standard.synchronize()
    }
    static func setUserId(userId : String) -> Bool {
        UserDefaults.standard.set(userId, forKey: "NC_user_id")
        return UserDefaults.standard.synchronize()
    }
    
    static func getUserId() -> String {
        if (UserDefaults.standard.object(forKey: "NC_user_id") != nil){
            let userDataId = UserDefaults.standard.object(forKey: "NC_user_id") as! String
            return userDataId
        }else{
            return "0"
        }
    }
    
    static func getDeviceToken() -> String
    {
        let token : AnyObject = UserDefaults.standard.object(forKey: "N_DeviceToken") as AnyObject
        let deviceToken : String = NikkosCustomerManager.checkNullString(string: token)
        return deviceToken
    }
    
    static func setDeviceToken(deviceToken : String) -> Bool{
        UserDefaults.standard.set(deviceToken, forKey: "N_DeviceToken")
        return UserDefaults.standard.synchronize()
    }

    static func getLanguageScreenAccess() -> Bool {
        return UserDefaults.standard.bool(forKey: "N_IsLnaguage")
    }
    
    static func setLanguageScreenAccess(isRememberMe: Bool) -> Bool {
        UserDefaults.standard.set(isRememberMe, forKey: "N_IsLnaguage")
        return UserDefaults.standard.synchronize()
    }
    
}
