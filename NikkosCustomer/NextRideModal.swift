//
//	NextRideModal.swift
//
//	Create by admin on 19/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NextRideModal : NSObject, NSCoding{
    
    

	var bookLater : Bool!
	var bookNow : Bool!
	var bookedMsg : String!
	var bookingMsg : String!
	var clientId : Int!
	var error : Int!
	var lookingDriver : Bool!
    var tripId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		bookLater = dictionary["BookLater"] as? Bool
		bookNow = dictionary["BookNow"] as? Bool
		bookedMsg = dictionary["BookedMsg"] as? String
		bookingMsg = dictionary["BookingMsg"] as? String
		clientId = dictionary["ClientId"] as? Int
		error = dictionary["Error"] as? Int
		lookingDriver = dictionary["LookingDriver"] as? Bool
        tripId = dictionary["TripId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if bookLater != nil{
			dictionary["BookLater"] = bookLater
		}
		if bookNow != nil{
			dictionary["BookNow"] = bookNow
		}
		if bookedMsg != nil{
			dictionary["BookedMsg"] = bookedMsg
		}
		if bookingMsg != nil{
			dictionary["BookingMsg"] = bookingMsg
		}
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if error != nil{
			dictionary["Error"] = error
		}
		if lookingDriver != nil{
			dictionary["LookingDriver"] = lookingDriver
		}
        if tripId != nil{
            dictionary["TripId"] = tripId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bookLater = aDecoder.decodeObject(forKey:"BookLater") as? Bool
         bookNow = aDecoder.decodeObject(forKey:"BookNow") as? Bool
         bookedMsg = aDecoder.decodeObject(forKey:"BookedMsg") as? String
         bookingMsg = aDecoder.decodeObject(forKey:"BookingMsg") as? String
         clientId = aDecoder.decodeObject(forKey:"ClientId") as? Int
         error = aDecoder.decodeObject(forKey:"Error") as? Int
         lookingDriver = aDecoder.decodeObject(forKey:"LookingDriver") as? Bool
         tripId = aDecoder.decodeObject(forKey:"TripId") as? Int
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder) {
       
		if bookLater != nil{
			aCoder.encode(bookLater, forKey: "BookLater")
		}
		if bookNow != nil{
			aCoder.encode(bookNow, forKey: "BookNow")
		}
		if bookedMsg != nil{
			aCoder.encode(bookedMsg, forKey: "BookedMsg")
		}
		if bookingMsg != nil{
			aCoder.encode(bookingMsg, forKey: "BookingMsg")
		}
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if error != nil{
			aCoder.encode(error, forKey: "Error")
		}
		if lookingDriver != nil{
			aCoder.encode(lookingDriver, forKey: "LookingDriver")
		}
        if tripId != nil{
            aCoder.encode(tripId, forKey: "TripId")
        }

	}

}
