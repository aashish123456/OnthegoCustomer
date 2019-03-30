//
//	VehicleTypeModal.swift
//
//	Create by admin on 3/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class VehicleTypeModal : NSObject, NSCoding{
    
    

	var text : String!
	var text2 : String!
	var text3 : Double!
	var value : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		text = dictionary["Text"] as? String
		text2 = dictionary["Text2"] as? String
		text3 = dictionary["Text3"] as? Double
		value = dictionary["Value"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if text != nil{
			dictionary["Text"] = text
		}
		if text2 != nil{
			dictionary["Text2"] = text2
		}
		if text3 != nil{
			dictionary["Text3"] = text3
		}
		if value != nil{
			dictionary["Value"] = value
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         text = aDecoder.decodeObject(forKey:"Text") as? String
         text2 = aDecoder.decodeObject(forKey:"Text2") as? String
         text3 = aDecoder.decodeObject(forKey:"Text3") as? Double
         value = aDecoder.decodeObject(forKey:"Value") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
      
		if text != nil{
			aCoder.encode(text, forKey: "Text")
		}
		if text2 != nil{
			aCoder.encode(text2, forKey: "Text2")
		}
		if text3 != nil{
			aCoder.encode(text3, forKey: "Text3")
		}
		if value != nil{
			aCoder.encode(value, forKey: "Value")
		}

	}

}
