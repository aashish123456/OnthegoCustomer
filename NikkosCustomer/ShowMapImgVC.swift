//
//  ShowMapImgVC.swift
//  NikkosCustomer
//
//  Created by Ashish Soni on 14/12/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ShowMapImgVC: UIViewController {

    @IBOutlet var imgView: UIImageView!
    var strImgURL : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if strImgURL != nil{
            imgView.imageURL = NSURL(string: strImgURL) as! URL
        }
    }
}
