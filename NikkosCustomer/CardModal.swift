//
//	CardModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CardModal : NSObject, NSCoding{
    
    

	var cardId : Int!
	var cardNumber : String!
	var clientId : Int!
	var isDefault : Bool!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		cardId = dictionary["CardId"] as? Int
		cardNumber = dictionary["CardNumber"] as? String
		clientId = dictionary["ClientId"] as? Int
		isDefault = dictionary["IsDefault"] as? Bool
		name = dictionary["Name"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if cardId != nil{
			dictionary["CardId"] = cardId
		}
		if cardNumber != nil{
			dictionary["CardNumber"] = cardNumber
		}
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if isDefault != nil{
			dictionary["IsDefault"] = isDefault
		}
		if name != nil{
			dictionary["Name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cardId = aDecoder.decodeObject(forKey:"CardId") as? Int
         cardNumber = aDecoder.decodeObject(forKey:"CardNumber") as? String
         clientId = aDecoder.decodeObject(forKey:"ClientId") as? Int
         isDefault = aDecoder.decodeObject(forKey:"IsDefault") as? Bool
         name = aDecoder.decodeObject(forKey:"Name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
        
		if cardId != nil{
			aCoder.encode(cardId, forKey: "CardId")
		}
		if cardNumber != nil{
			aCoder.encode(cardNumber, forKey: "CardNumber")
		}
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if isDefault != nil{
			aCoder.encode(isDefault, forKey: "IsDefault")
		}
		if name != nil{
			aCoder.encode(name, forKey: "Name")
		}

	}

}
