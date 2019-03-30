//
//  DriverAnnonation.swift
//  SuperCustomer
//
//  Created by Umang on 7/14/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit
import MapKit
class DriverAnnonation: NSObject,MKAnnotation
{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var course:String!
    var subtitle: String?
    var descriptionForUrl: String!
    init(coordinate: CLLocationCoordinate2D, title: String, course: String , subtitle: String , descriptionForUrl: String)
    {
        
        self.coordinate = coordinate
        self.title = title
        self.course = course
        self.subtitle = subtitle
        self.descriptionForUrl = descriptionForUrl
    }
}
