//
//  ShareFareView.swift
//  NikkosCustomer
//
//  Created by Umang on 11/9/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ShareFareView: UIView {

    @IBOutlet var popupInside: UIView!
    
    @IBOutlet var lblSearchUserH: UILabel!
    @IBOutlet var lblNameH: UILabel!
    @IBOutlet var btnAddToList: UIButton!
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblNoOfPerson: UILabel!
    @IBOutlet var lblIndividualShare: UILabel!
    
    override func awakeFromNib() {
        lblSearchUserH.text = NikkosCustomerManager.GetLocalString(textType: "Search_User")
        lblNameH.text = NikkosCustomerManager.GetLocalString(textType:  "NAME")
        btnAddToList.titleLabel?.text = NikkosCustomerManager.GetLocalString(textType: "Add_To_List")
        lblNoOfPerson.text = NikkosCustomerManager.GetLocalString(textType: "No_Of_Persons")
        lblIndividualShare.text = NikkosCustomerManager.GetLocalString(textType: "Individual_Share")
        btnClose.titleLabel?.text = NikkosCustomerManager.GetLocalString(textType: "Close")
    }
    internal func showInView(aView: UIView!)
    {
        popupInside.layer.cornerRadius = 12.0
        aView.addSubview(self)
        self.showAnimate()
    }
    
    
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.removeFromSuperview()
                }
        });
    }


}
