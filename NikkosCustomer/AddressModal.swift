//
//	AddressModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class AddressModal : NSObject, NSCoding{
    
    

	var address : String!
	var addressId : Int!
	var clientId : Int!
	var favoriteName : String!
	var latitude : Double!
	var longitude : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		address = dictionary["Address"] as? String
		addressId = dictionary["AddressId"] as? Int
		clientId = dictionary["ClientId"] as? Int
		favoriteName = dictionary["FavoriteName"] as? String
		latitude = dictionary["Latitude"] as? Double
		longitude = dictionary["Longitude"] as? Double
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if address != nil{
			dictionary["Address"] = address
		}
		if addressId != nil{
			dictionary["AddressId"] = addressId
		}
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if favoriteName != nil{
			dictionary["FavoriteName"] = favoriteName
		}
		if latitude != nil{
			dictionary["Latitude"] = latitude
		}
		if longitude != nil{
			dictionary["Longitude"] = longitude
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey:"Address") as? String
         addressId = aDecoder.decodeObject(forKey:"AddressId") as? Int
         clientId = aDecoder.decodeObject(forKey:"ClientId") as? Int
         favoriteName = aDecoder.decodeObject(forKey:"FavoriteName") as? String
         latitude = aDecoder.decodeObject(forKey:"Latitude") as? Double
         longitude = aDecoder.decodeObject(forKey:"Longitude") as? Double

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
        
		if address != nil{
			aCoder.encode(address, forKey: "Address")
		}
		if addressId != nil{
			aCoder.encode(addressId, forKey: "AddressId")
		}
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if favoriteName != nil{
			aCoder.encode(favoriteName, forKey: "FavoriteName")
		}
		if latitude != nil{
			aCoder.encode(latitude, forKey: "Latitude")
		}
		if longitude != nil{
			aCoder.encode(longitude, forKey: "Longitude")
		}

	}

}
