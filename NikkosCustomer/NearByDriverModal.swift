//
//	NearByDriverModal.swift
//
//	Create by admin on 9/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NearByDriverModal : NSObject, NSCoding{
    
    

	var course : String!
	var distance : Double!
	var driverId : Int!
	var latitude : Double!
	var longitude : Double!
	var vehicleImage : String!
	var vehicleType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		course = dictionary["Course"] as? String
		distance = dictionary["Distance"] as? Double
		driverId = dictionary["DriverId"] as? Int
		latitude = dictionary["Latitude"] as? Double
		longitude = dictionary["Longitude"] as? Double
		vehicleImage = dictionary["VehicleImage"] as? String
		vehicleType = dictionary["VehicleType"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if course != nil{
			dictionary["Course"] = course
		}
		if distance != nil{
			dictionary["Distance"] = distance
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
		if vehicleImage != nil{
			dictionary["VehicleImage"] = vehicleImage
		}
		if vehicleType != nil{
			dictionary["VehicleType"] = vehicleType
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
         distance = aDecoder.decodeObject(forKey: "Distance") as? Double
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         latitude = aDecoder.decodeObject(forKey: "Latitude") as? Double
         longitude = aDecoder.decodeObject(forKey: "Longitude") as? Double
         vehicleImage = aDecoder.decodeObject(forKey: "VehicleImage") as? String
         vehicleType = aDecoder.decodeObject(forKey: "VehicleType") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
      
		if course != nil{
			aCoder.encode(course, forKey: "Course")
		}
		if distance != nil{
			aCoder.encode(distance, forKey: "Distance")
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
		if vehicleImage != nil{
			aCoder.encode(vehicleImage, forKey: "VehicleImage")
		}
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "VehicleType")
		}

	}

}
