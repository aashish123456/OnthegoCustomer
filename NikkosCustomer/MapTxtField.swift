//
//  MapTxtField.swift
//  SuperCustomer
//
//  Created by Umang on 7/13/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class MapTxtField: UITextField {

    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let paddingView = UIView(frame: CGRectMake(0, 0, 20, self.frame.height))
//        self.leftView = paddingView
//        self.leftViewMode = UITextFieldViewMode.Always

        
    }
    func setLeftImage(imageName: String)  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 11, height: 11))
        
        let image = UIImage(named:imageName);
        imageView.image = image;
        imageView.contentMode = UIViewContentMode.center
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = imageView;
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect
   {
    var textRect = super.leftViewRect(forBounds: bounds)
       textRect.origin.x  += 5
       return textRect
   }
//override func textRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset(bounds, 20, 10)
//    }
//    
//override func editingRectForBounds(bounds: CGRect) -> CGRect {
//        return CGRectInset(bounds, 20, 10)
//    }
}
