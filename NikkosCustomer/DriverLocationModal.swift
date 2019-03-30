//
//	DriverLocationModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class DriverLocationModal : NSObject, NSCoding{
    
    

	var course : String!
	var driverId : Int!
	var latitude : Double!
	var longitude : Double!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	
    init(fromDictionary dictionary: NSDictionary){
        course = dictionary["Course"] as? String
        driverId = dictionary["DriverId"] as? Int
        latitude = dictionary["Latitude"] as? Double
        longitude = dictionary["Longitude"] as? Double
    }
    
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if course != nil{
			dictionary["Course"] = course
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
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


        course = aDecoder.decodeObject(forKey: "Course") as? String
        driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
        latitude = aDecoder.decodeObject(forKey: "Latitude") as? Double
        longitude = aDecoder.decodeObject(forKey: "Longitude") as? Double

        
        
        
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    
    func encode(with aCoder: NSCoder) {
        
		
        if course != nil{
            aCoder.encode(course, forKey: "course")
        }
        if driverId != nil{
            aCoder.encode(driverId, forKey: "DriverId")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "Latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "Longitude")
        }
        

	}

}
