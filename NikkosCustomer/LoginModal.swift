//
//	LoginModal.swift
//
//	Create by admin on 26/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LoginModal : NSObject, NSCoding{
   
    

	var companyCode : String!
	var companyName : String!
	var creditedAmount : Float!
	var defaultVehicleCategory : Int!
	var defaultVehicleCategoryName : String!
	var email : String!
	var employeeID : String!
	var errorCode : Int!
	var firstName : String!
	var id : Int!
	var invalidNewEmail : Bool!
	var invalidNewPhoneNumber : Bool!
	var isClientActive : Bool!
	var isEmailVerified : Bool!
	var isPhoneVerified : Bool!
	var isPro : Bool!
	var isUserActive : Bool!
	var phoneNumber : String!
	var preferredLanguage : String!
	var profileImage : String!
	var salutation : String!
    var countryId : Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		companyCode = dictionary["CompanyCode"] as? String
		companyName = dictionary["CompanyName"] as? String
		creditedAmount = dictionary["CreditedAmount"] as? Float
		defaultVehicleCategory = dictionary["DefaultVehicleCategory"] as? Int
		defaultVehicleCategoryName = dictionary["DefaultVehicleCategoryName"] as? String
		email = dictionary["Email"] as? String
		employeeID = dictionary["EmployeeID"] as? String
		errorCode = dictionary["ErrorCode"] as? Int
		firstName = dictionary["FirstName"] as? String
		id = dictionary["Id"] as? Int
		invalidNewEmail = dictionary["InvalidNewEmail"] as? Bool
		invalidNewPhoneNumber = dictionary["InvalidNewPhoneNumber"] as? Bool
		isClientActive = dictionary["IsClientActive"] as? Bool
		isEmailVerified = dictionary["IsEmailVerified"] as? Bool
		isPhoneVerified = dictionary["IsPhoneVerified"] as? Bool
		isPro = dictionary["IsPro"] as? Bool
		isUserActive = dictionary["IsUserActive"] as? Bool
		phoneNumber = dictionary["PhoneNumber"] as? String
		preferredLanguage = dictionary["PreferredLanguage"] as? String
		profileImage = dictionary["ProfileImage"] as? String
		salutation = dictionary["Salutation"] as? String
        countryId = dictionary["CountryId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if companyCode != nil{
			dictionary["CompanyCode"] = companyCode
		}
		if companyName != nil{
			dictionary["CompanyName"] = companyName
		}
		if creditedAmount != nil{
			dictionary["CreditedAmount"] = creditedAmount
		}
		if defaultVehicleCategory != nil{
			dictionary["DefaultVehicleCategory"] = defaultVehicleCategory
		}
		if defaultVehicleCategoryName != nil{
			dictionary["DefaultVehicleCategoryName"] = defaultVehicleCategoryName
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if employeeID != nil{
			dictionary["EmployeeID"] = employeeID
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if invalidNewEmail != nil{
			dictionary["InvalidNewEmail"] = invalidNewEmail
		}
		if invalidNewPhoneNumber != nil{
			dictionary["InvalidNewPhoneNumber"] = invalidNewPhoneNumber
		}
		if isClientActive != nil{
			dictionary["IsClientActive"] = isClientActive
		}
		if isEmailVerified != nil{
			dictionary["IsEmailVerified"] = isEmailVerified
		}
		if isPhoneVerified != nil{
			dictionary["IsPhoneVerified"] = isPhoneVerified
		}
		if isPro != nil{
			dictionary["IsPro"] = isPro
		}
		if isUserActive != nil{
			dictionary["IsUserActive"] = isUserActive
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		if preferredLanguage != nil{
			dictionary["PreferredLanguage"] = preferredLanguage
		}
		if profileImage != nil{
			dictionary["ProfileImage"] = profileImage
		}
		if salutation != nil{
			dictionary["Salutation"] = salutation
		}
        if countryId != nil{
            dictionary["CountryId"] = countryId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        companyCode = aDecoder.decodeObject(forKey: "CompanyCode") as? String
         companyName = aDecoder.decodeObject(forKey:"CompanyName") as? String
         creditedAmount = aDecoder.decodeObject(forKey:"CreditedAmount") as? Float
         defaultVehicleCategory = aDecoder.decodeObject(forKey:"DefaultVehicleCategory") as? Int
         defaultVehicleCategoryName = aDecoder.decodeObject(forKey:"DefaultVehicleCategoryName") as? String
         email = aDecoder.decodeObject(forKey:"Email") as? String
         employeeID = aDecoder.decodeObject(forKey:"EmployeeID") as? String
         errorCode = aDecoder.decodeObject(forKey:"ErrorCode") as? Int
         firstName = aDecoder.decodeObject(forKey:"FirstName") as? String
         id = aDecoder.decodeObject(forKey:"Id") as? Int
         invalidNewEmail = aDecoder.decodeObject(forKey:"InvalidNewEmail") as? Bool
         invalidNewPhoneNumber = aDecoder.decodeObject(forKey:"InvalidNewPhoneNumber") as? Bool
         isClientActive = aDecoder.decodeObject(forKey:"IsClientActive") as? Bool
         isEmailVerified = aDecoder.decodeObject(forKey:"IsEmailVerified") as? Bool
         isPhoneVerified = aDecoder.decodeObject(forKey:"IsPhoneVerified") as? Bool
         isPro = aDecoder.decodeObject(forKey:"IsPro") as? Bool
         isUserActive = aDecoder.decodeObject(forKey:"IsUserActive") as? Bool
         phoneNumber = aDecoder.decodeObject(forKey:"PhoneNumber") as? String
         preferredLanguage = aDecoder.decodeObject(forKey:"PreferredLanguage") as? String
         profileImage = aDecoder.decodeObject(forKey:"ProfileImage") as? String
         salutation = aDecoder.decodeObject(forKey:"Salutation") as? String
         countryId = aDecoder.decodeObject(forKey:"CountryId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if companyCode != nil{
            aCoder.encode(companyCode, forKey: "CompanyCode")
		}
		if companyName != nil{
			aCoder.encode(companyName, forKey: "CompanyName")
		}
		if creditedAmount != nil{
			aCoder.encode(creditedAmount, forKey: "CreditedAmount")
		}
		if defaultVehicleCategory != nil{
			aCoder.encode(defaultVehicleCategory, forKey: "DefaultVehicleCategory")
		}
		if defaultVehicleCategoryName != nil{
			aCoder.encode(defaultVehicleCategoryName, forKey: "DefaultVehicleCategoryName")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if employeeID != nil{
			aCoder.encode(employeeID, forKey: "EmployeeID")
		}
		if errorCode != nil{
			aCoder.encode(errorCode, forKey: "ErrorCode")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if invalidNewEmail != nil{
			aCoder.encode(invalidNewEmail, forKey: "InvalidNewEmail")
		}
		if invalidNewPhoneNumber != nil{
			aCoder.encode(invalidNewPhoneNumber, forKey: "InvalidNewPhoneNumber")
		}
		if isClientActive != nil{
			aCoder.encode(isClientActive, forKey: "IsClientActive")
		}
		if isEmailVerified != nil{
			aCoder.encode(isEmailVerified, forKey: "IsEmailVerified")
		}
		if isPhoneVerified != nil{
			aCoder.encode(isPhoneVerified, forKey: "IsPhoneVerified")
		}
		if isPro != nil{
			aCoder.encode(isPro, forKey: "IsPro")
		}
		if isUserActive != nil{
			aCoder.encode(isUserActive, forKey: "IsUserActive")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}
		if preferredLanguage != nil{
			aCoder.encode(preferredLanguage, forKey: "PreferredLanguage")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "ProfileImage")
		}
		if salutation != nil{
			aCoder.encode(salutation, forKey: "Salutation")
		}
        if countryId != nil{
            aCoder.encode(countryId, forKey: "CountryId")
        }

	}

}
