//
//	CurrentRideStatusModal.swift
//
//	Create by admin on 8/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CurrentRideStatusModal : NSObject, NSCoding{
    
    

	var clientId : Int!
	var driverId : Int!
	var driverImage : String!
	var driverName : String!
	var driverPhoneNumber : String!
	var driverRating : Float!
	var dropLatitude : Double!
	var dropLongitude : Double!
	var hasClientRating : Bool!
	var isClientActive : Bool!
	var isOnTrip : Bool!
	var isTripStart : Bool!
	var pickupLatitude : Double!
	var pickupLongitude : Double!
	var plateNumber : String!
	var tripAmount : String!
	var tripDate : String!
	var tripRequestId : Int!
	var vehicleName : String!
	var vehicleType : String!
    var VehicleIcon : String!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		clientId = dictionary["ClientId"] as? Int
		driverId = dictionary["DriverId"] as? Int
		driverImage = dictionary["DriverImage"] as? String
		driverName = dictionary["DriverName"] as? String
		driverPhoneNumber = dictionary["DriverPhoneNumber"] as? String
		driverRating = dictionary["DriverRating"] as? Float
		dropLatitude = dictionary["DropLatitude"] as? Double
		dropLongitude = dictionary["DropLongitude"] as? Double
		hasClientRating = dictionary["HasClientRating"] as? Bool
		isClientActive = dictionary["IsClientActive"] as? Bool
		isOnTrip = dictionary["IsOnTrip"] as? Bool
		isTripStart = dictionary["IsTripStart"] as? Bool
		pickupLatitude = dictionary["PickupLatitude"] as? Double
		pickupLongitude = dictionary["PickupLongitude"] as? Double
		plateNumber = dictionary["PlateNumber"] as? String
		tripAmount = dictionary["TripAmount"] as? String
		tripDate = dictionary["TripDate"] as? String
		tripRequestId = dictionary["TripRequestId"] as? Int
		vehicleName = dictionary["VehicleName"] as? String
		vehicleType = dictionary["VehicleType"] as? String
        VehicleIcon = dictionary["VehicleIcon"] as? String
		success = dictionary["success"] as? Bool
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
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if driverImage != nil{
			dictionary["DriverImage"] = driverImage
		}
		if driverName != nil{
			dictionary["DriverName"] = driverName
		}
		if driverPhoneNumber != nil{
			dictionary["DriverPhoneNumber"] = driverPhoneNumber
		}
		if driverRating != nil{
			dictionary["DriverRating"] = driverRating
		}
		if dropLatitude != nil{
			dictionary["DropLatitude"] = dropLatitude
		}
		if dropLongitude != nil{
			dictionary["DropLongitude"] = dropLongitude
		}
		if hasClientRating != nil{
			dictionary["HasClientRating"] = hasClientRating
		}
		if isClientActive != nil{
			dictionary["IsClientActive"] = isClientActive
		}
		if isOnTrip != nil{
			dictionary["IsOnTrip"] = isOnTrip
		}
		if isTripStart != nil{
			dictionary["IsTripStart"] = isTripStart
		}
		if pickupLatitude != nil{
			dictionary["PickupLatitude"] = pickupLatitude
		}
		if pickupLongitude != nil{
			dictionary["PickupLongitude"] = pickupLongitude
		}
		if plateNumber != nil{
			dictionary["PlateNumber"] = plateNumber
		}
		if tripAmount != nil{
			dictionary["TripAmount"] = tripAmount
		}
		if tripDate != nil{
			dictionary["TripDate"] = tripDate
		}
		if tripRequestId != nil{
			dictionary["TripRequestId"] = tripRequestId
		}
		if vehicleName != nil{
			dictionary["VehicleName"] = vehicleName
		}
        if VehicleIcon != nil{
            dictionary["VehicleIcon"] = VehicleIcon
        }
		if vehicleType != nil{
			dictionary["VehicleType"] = vehicleType
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         clientId = aDecoder.decodeObject(forKey:"ClientId") as? Int
         driverId = aDecoder.decodeObject(forKey:"DriverId") as? Int
         driverImage = aDecoder.decodeObject(forKey:"DriverImage") as? String
         driverName = aDecoder.decodeObject(forKey:"DriverName") as? String
         driverPhoneNumber = aDecoder.decodeObject(forKey:"DriverPhoneNumber") as? String
         driverRating = aDecoder.decodeObject(forKey:"DriverRating") as? Float
         dropLatitude = aDecoder.decodeObject(forKey:"DropLatitude") as? Double
         dropLongitude = aDecoder.decodeObject(forKey:"DropLongitude") as? Double
         hasClientRating = aDecoder.decodeObject(forKey:"HasClientRating") as? Bool
         isClientActive = aDecoder.decodeObject(forKey:"IsClientActive") as? Bool
         isOnTrip = aDecoder.decodeObject(forKey:"IsOnTrip") as? Bool
         isTripStart = aDecoder.decodeObject(forKey:"IsTripStart") as? Bool
         pickupLatitude = aDecoder.decodeObject(forKey:"PickupLatitude") as? Double
         pickupLongitude = aDecoder.decodeObject(forKey:"PickupLongitude") as? Double
         plateNumber = aDecoder.decodeObject(forKey:"PlateNumber") as? String
         tripAmount = aDecoder.decodeObject(forKey:"TripAmount") as? String
         tripDate = aDecoder.decodeObject(forKey:"TripDate") as? String
         tripRequestId = aDecoder.decodeObject(forKey:"TripRequestId") as? Int
         vehicleName = aDecoder.decodeObject(forKey:"VehicleName") as? String
         VehicleIcon = aDecoder.decodeObject(forKey:"VehicleIcon") as? String
         vehicleType = aDecoder.decodeObject(forKey:"VehicleType") as? String
         success = aDecoder.decodeObject(forKey:"success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if driverImage != nil{
			aCoder.encode(driverImage, forKey: "DriverImage")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if driverPhoneNumber != nil{
			aCoder.encode(driverPhoneNumber, forKey: "DriverPhoneNumber")
		}
		if driverRating != nil{
			aCoder.encode(driverRating, forKey: "DriverRating")
		}
		if dropLatitude != nil{
			aCoder.encode(dropLatitude, forKey: "DropLatitude")
		}
		if dropLongitude != nil{
			aCoder.encode(dropLongitude, forKey: "DropLongitude")
		}
		if hasClientRating != nil{
			aCoder.encode(hasClientRating, forKey: "HasClientRating")
		}
		if isClientActive != nil{
			aCoder.encode(isClientActive, forKey: "IsClientActive")
		}
		if isOnTrip != nil{
			aCoder.encode(isOnTrip, forKey: "IsOnTrip")
		}
		if isTripStart != nil{
			aCoder.encode(isTripStart, forKey: "IsTripStart")
		}
		if pickupLatitude != nil{
			aCoder.encode(pickupLatitude, forKey: "PickupLatitude")
		}
		if pickupLongitude != nil{
			aCoder.encode(pickupLongitude, forKey: "PickupLongitude")
		}
		if plateNumber != nil{
			aCoder.encode(plateNumber, forKey: "PlateNumber")
		}
		if tripAmount != nil{
			aCoder.encode(tripAmount, forKey: "TripAmount")
		}
		if tripDate != nil{
			aCoder.encode(tripDate, forKey: "TripDate")
		}
		if tripRequestId != nil{
			aCoder.encode(tripRequestId, forKey: "TripRequestId")
		}
		if vehicleName != nil{
			aCoder.encode(vehicleName, forKey: "VehicleName")
		}
        if VehicleIcon != nil{
            aCoder.encode(VehicleIcon, forKey: "VehicleIcon")
        }
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "VehicleType")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}
