//
//	FareEstimateModel.swift
//
//	Create by admin on 14/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class FareEstimateModel : NSObject, NSCoding{
    
    

	var amount : String!
	var miles : Double!
	var time : Int!
    var surge : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		amount = dictionary["Amount"] as? String
		miles = dictionary["Miles"] as? Double
		time = dictionary["Time"] as? Int
        surge = dictionary["Surge"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if amount != nil{
			dictionary["Amount"] = amount
		}
		if miles != nil{
			dictionary["Miles"] = miles
		}
		if time != nil{
			dictionary["Time"] = time
		}
        if surge != nil{
            dictionary["Surge"] = surge
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
        amount = aDecoder.decodeObject(forKey: "Amount") as? String
        miles = aDecoder.decodeObject(forKey: "Miles") as? Double
        time = aDecoder.decodeObject(forKey: "Time") as? Int
        surge = aDecoder.decodeObject(forKey: "Surge") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
      
		if amount != nil{
            aCoder.encode(amount, forKey: "Amount")
		}
		if miles != nil{
			aCoder.encode(miles, forKey: "Miles")
		}
		if time != nil{
			aCoder.encode(time, forKey: "Time")
		}
        if surge != nil{
            aCoder.encode(surge, forKey: "Surge")
        }

	}

}
