//
//  ActivityButton.swift
//  NikkosCustomer
//
//  Created by Ashish Soni on 20/01/17.
//  Copyright © 2017 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ActivityButton: UIButton {
    
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading() {
        
        //originalButtonText = self.titleLabel?.text
        //self.setTitle(NikkosCustomerManager.GetLocalString("Cancel_Request"), forState: UIControlState.Normal)
        //self.titleLabel?.numberOfLines = 0
        //self.titleLabel?.textAlignment =  .Center
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func hideLoading() {
        
        self.setTitle(originalButtonText, for: .normal)
        if((activityIndicator) != nil){
            activityIndicator.stopAnimating()
        }
        
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.gray
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
