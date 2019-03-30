//
//	SearchPersonModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SearchPersonModal : NSObject, NSCoding{
    
    

	var clientId : Int!
	var clientName : String!
	var errorCode : Int!
	var phoneNumber : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		clientId = dictionary["ClientId"] as? Int
		clientName = dictionary["ClientName"] as? String
		errorCode = dictionary["ErrorCode"] as? Int
		phoneNumber = dictionary["PhoneNumber"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if clientName != nil{
			dictionary["ClientName"] = clientName
		}
		if errorCode != nil{
			dictionary["ErrorCode"] = errorCode
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        clientId = aDecoder.decodeObject(forKey: "ClientId") as? Int
         clientName = aDecoder.decodeObject(forKey: "ClientName") as? String
         errorCode = aDecoder.decodeObject(forKey: "ErrorCode") as? Int
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if clientId != nil{
            aCoder.encode(clientId, forKey: "ClientId")
		}
		if clientName != nil{
			aCoder.encode(clientName, forKey: "ClientName")
		}
		if errorCode != nil{
			aCoder.encode(errorCode, forKey: "ErrorCode")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}

	}

}
