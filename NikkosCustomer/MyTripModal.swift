//
//	MyTripModal.swift
//
//	Create by admin on 7/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MyTripModal : NSObject, NSCoding{
   
    

	var clientId : Int!
	var dateTimeBooking : String!
	var dateTimeTravlling : String!
	var driverName : String!
	var driverPhoneNumber : String!
	var dropAddress : String!
	var isCompleted : Bool!
	var isLaterScheduled : Bool!
	var isOnGoing : Bool!
	var pickupAddress : String!
	var plateNumber : String!
	var tripAmount : String!
	var tripDateTime : String!
	var tripMap : String!
	var tripRequestId : Int!
	var tripStatus : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		clientId = dictionary["ClientId"] as? Int
		dateTimeBooking = dictionary["DateTimeBooking"] as? String
		dateTimeTravlling = dictionary["DateTimeTravlling"] as? String
		driverName = dictionary["DriverName"] as? String
		driverPhoneNumber = dictionary["DriverPhoneNumber"] as? String
		dropAddress = dictionary["DropAddress"] as? String
		isCompleted = dictionary["IsCompleted"] as? Bool
		isLaterScheduled = dictionary["IsLaterScheduled"] as? Bool
		isOnGoing = dictionary["IsOnGoing"] as? Bool
		pickupAddress = dictionary["PickupAddress"] as? String
		plateNumber = dictionary["PlateNumber"] as? String
		tripAmount = dictionary["TripAmount"] as? String
		tripDateTime = dictionary["TripDateTime"] as? String
		tripMap = dictionary["TripMap"] as? String
		tripRequestId = dictionary["TripRequestId"] as? Int
		tripStatus = dictionary["TripStatus"] as? String
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
		if dateTimeBooking != nil{
			dictionary["DateTimeBooking"] = dateTimeBooking
		}
		if dateTimeTravlling != nil{
			dictionary["DateTimeTravlling"] = dateTimeTravlling
		}
		if driverName != nil{
			dictionary["DriverName"] = driverName
		}
		if driverPhoneNumber != nil{
			dictionary["DriverPhoneNumber"] = driverPhoneNumber
		}
		if dropAddress != nil{
			dictionary["DropAddress"] = dropAddress
		}
		if isCompleted != nil{
			dictionary["IsCompleted"] = isCompleted
		}
		if isLaterScheduled != nil{
			dictionary["IsLaterScheduled"] = isLaterScheduled
		}
		if isOnGoing != nil{
			dictionary["IsOnGoing"] = isOnGoing
		}
		if pickupAddress != nil{
			dictionary["PickupAddress"] = pickupAddress
		}
		if plateNumber != nil{
			dictionary["PlateNumber"] = plateNumber
		}
		if tripAmount != nil{
			dictionary["TripAmount"] = tripAmount
		}
		if tripDateTime != nil{
			dictionary["TripDateTime"] = tripDateTime
		}
		if tripMap != nil{
			dictionary["TripMap"] = tripMap
		}
		if tripRequestId != nil{
			dictionary["TripRequestId"] = tripRequestId
		}
		if tripStatus != nil{
			dictionary["TripStatus"] = tripStatus
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
         dateTimeBooking = aDecoder.decodeObject(forKey:"DateTimeBooking") as? String
         dateTimeTravlling = aDecoder.decodeObject(forKey:"DateTimeTravlling") as? String
         driverName = aDecoder.decodeObject(forKey:"DriverName") as? String
         driverPhoneNumber = aDecoder.decodeObject(forKey:"DriverPhoneNumber") as? String
         dropAddress = aDecoder.decodeObject(forKey:"DropAddress") as? String
         isCompleted = aDecoder.decodeObject(forKey:"IsCompleted") as? Bool
         isLaterScheduled = aDecoder.decodeObject(forKey:"IsLaterScheduled") as? Bool
         isOnGoing = aDecoder.decodeObject(forKey:"IsOnGoing") as? Bool
         pickupAddress = aDecoder.decodeObject(forKey:"PickupAddress") as? String
         plateNumber = aDecoder.decodeObject(forKey:"PlateNumber") as? String
         tripAmount = aDecoder.decodeObject(forKey:"TripAmount") as? String
         tripDateTime = aDecoder.decodeObject(forKey:"TripDateTime") as? String
         tripMap = aDecoder.decodeObject(forKey:"TripMap") as? String
         tripRequestId = aDecoder.decodeObject(forKey:"TripRequestId") as? Int
         tripStatus = aDecoder.decodeObject(forKey:"TripStatus") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if dateTimeBooking != nil{
			aCoder.encode(dateTimeBooking, forKey: "DateTimeBooking")
		}
		if dateTimeTravlling != nil{
			aCoder.encode(dateTimeTravlling, forKey: "DateTimeTravlling")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if driverPhoneNumber != nil{
			aCoder.encode(driverPhoneNumber, forKey: "DriverPhoneNumber")
		}
		if dropAddress != nil{
			aCoder.encode(dropAddress, forKey: "DropAddress")
		}
		if isCompleted != nil{
			aCoder.encode(isCompleted, forKey: "IsCompleted")
		}
		if isLaterScheduled != nil{
			aCoder.encode(isLaterScheduled, forKey: "IsLaterScheduled")
		}
		if isOnGoing != nil{
			aCoder.encode(isOnGoing, forKey: "IsOnGoing")
		}
		if pickupAddress != nil{
			aCoder.encode(pickupAddress, forKey: "PickupAddress")
		}
		if plateNumber != nil{
			aCoder.encode(plateNumber, forKey: "PlateNumber")
		}
		if tripAmount != nil{
			aCoder.encode(tripAmount, forKey: "TripAmount")
		}
		if tripDateTime != nil{
			aCoder.encode(tripDateTime, forKey: "TripDateTime")
		}
		if tripMap != nil{
			aCoder.encode(tripMap, forKey: "TripMap")
		}
		if tripRequestId != nil{
			aCoder.encode(tripRequestId, forKey: "TripRequestId")
		}
		if tripStatus != nil{
			aCoder.encode(tripStatus, forKey: "TripStatus")
		}

	}

}
