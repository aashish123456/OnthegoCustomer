//
//	ShareFareTripModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ShareFareTripModal : NSObject, NSCoding{
    
    

	var bookingTime : String!
	var companyName : String!
	var driverName : String!
	var dropAddress : String!
	var estimatedCost : Double!
	var hasOnTrip : Bool!
	var individualShare : Double!
	var miles : Int!
	var passengerCount : Int!
	var pickupAddress : String!
	var siret : String!
	var tripId : Int!
	var tripStartOn : String!
	var isTripOwner : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		bookingTime = dictionary["BookingTime"] as? String
		companyName = dictionary["CompanyName"] as? String
		driverName = dictionary["DriverName"] as? String
		dropAddress = dictionary["DropAddress"] as? String
		estimatedCost = dictionary["EstimatedCost"] as? Double
		hasOnTrip = dictionary["HasOnTrip"] as? Bool
		individualShare = dictionary["IndividualShare"] as? Double
		miles = dictionary["Miles"] as? Int
		passengerCount = dictionary["PassengerCount"] as? Int
		pickupAddress = dictionary["PickupAddress"] as? String
		siret = dictionary["Siret"] as? String
		tripId = dictionary["TripId"] as? Int
		tripStartOn = dictionary["TripStartOn"] as? String
		isTripOwner = dictionary["isTripOwner"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if bookingTime != nil{
			dictionary["BookingTime"] = bookingTime
		}
		if companyName != nil{
			dictionary["CompanyName"] = companyName
		}
		if driverName != nil{
			dictionary["DriverName"] = driverName
		}
		if dropAddress != nil{
			dictionary["DropAddress"] = dropAddress
		}
		if estimatedCost != nil{
			dictionary["EstimatedCost"] = estimatedCost
		}
		if hasOnTrip != nil{
			dictionary["HasOnTrip"] = hasOnTrip
		}
		if individualShare != nil{
			dictionary["IndividualShare"] = individualShare
		}
		if miles != nil{
			dictionary["Miles"] = miles
		}
		if passengerCount != nil{
			dictionary["PassengerCount"] = passengerCount
		}
		if pickupAddress != nil{
			dictionary["PickupAddress"] = pickupAddress
		}
		if siret != nil{
			dictionary["Siret"] = siret
		}
		if tripId != nil{
			dictionary["TripId"] = tripId
		}
		if tripStartOn != nil{
			dictionary["TripStartOn"] = tripStartOn
		}
		if isTripOwner != nil{
			dictionary["isTripOwner"] = isTripOwner
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bookingTime = aDecoder.decodeObject(forKey: "BookingTime") as? String
         companyName = aDecoder.decodeObject(forKey: "CompanyName") as? String
         driverName = aDecoder.decodeObject(forKey: "DriverName") as? String
         dropAddress = aDecoder.decodeObject(forKey: "DropAddress") as? String
         estimatedCost = aDecoder.decodeObject(forKey: "EstimatedCost") as? Double
         hasOnTrip = aDecoder.decodeObject(forKey: "HasOnTrip") as? Bool
         individualShare = aDecoder.decodeObject(forKey: "IndividualShare") as? Double
         miles = aDecoder.decodeObject(forKey: "Miles") as? Int
         passengerCount = aDecoder.decodeObject(forKey: "PassengerCount") as? Int
         pickupAddress = aDecoder.decodeObject(forKey: "PickupAddress") as? String
         siret = aDecoder.decodeObject(forKey: "Siret") as? String
         tripId = aDecoder.decodeObject(forKey: "TripId") as? Int
         tripStartOn = aDecoder.decodeObject(forKey: "TripStartOn") as? String
         isTripOwner = aDecoder.decodeObject(forKey: "isTripOwner") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if bookingTime != nil{
			aCoder.encode(bookingTime, forKey: "BookingTime")
		}
		if companyName != nil{
			aCoder.encode(companyName, forKey: "CompanyName")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if dropAddress != nil{
			aCoder.encode(dropAddress, forKey: "DropAddress")
		}
		if estimatedCost != nil{
			aCoder.encode(estimatedCost, forKey: "EstimatedCost")
		}
		if hasOnTrip != nil{
			aCoder.encode(hasOnTrip, forKey: "HasOnTrip")
		}
		if individualShare != nil{
			aCoder.encode(individualShare, forKey: "IndividualShare")
		}
		if miles != nil{
			aCoder.encode(miles, forKey: "Miles")
		}
		if passengerCount != nil{
			aCoder.encode(passengerCount, forKey: "PassengerCount")
		}
		if pickupAddress != nil{
			aCoder.encode(pickupAddress, forKey: "PickupAddress")
		}
		if siret != nil{
			aCoder.encode(siret, forKey: "Siret")
		}
		if tripId != nil{
			aCoder.encode(tripId, forKey: "TripId")
		}
		if tripStartOn != nil{
			aCoder.encode(tripStartOn, forKey: "TripStartOn")
		}
		if isTripOwner != nil{
			aCoder.encode(isTripOwner, forKey: "isTripOwner")
		}

	}

}
