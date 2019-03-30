//
//	PersonListModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class PersonListModal : NSObject, NSCoding{
    
    

	var clientId : Int!
	var customerName : String!
	var phoneNumber : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		clientId = dictionary["ClientId"] as? Int
		customerName = dictionary["CustomerName"] as? String
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
		if customerName != nil{
			dictionary["CustomerName"] = customerName
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
         customerName = aDecoder.decodeObject(forKey: "CustomerName") as? String
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
		if customerName != nil{
			aCoder.encode(customerName, forKey: "CustomerName")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}

	}

}
