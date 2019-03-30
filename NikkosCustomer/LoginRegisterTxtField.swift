//
//  LoginRegisterTxtField.swift
//  NikkosDrvier
//
//  Created by Umang on 9/1/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class LoginRegisterTxtField: UITextField {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        let fieldBGImage = UIImage(named: "user_bg.png")!.stretchableImageWithLeftCapWidth(20, topCapHeight: 22)
      
    }
 
    func setLeftImage(imageName: String)  {
        let frameSize = CGRect(x: 0, y: 0, width: 22, height: 22)
        let imageView = UIImageView(frame: frameSize)
        let image = UIImage(named:imageName);
        imageView.image = image;
        imageView.frame =  frameSize.insetBy(dx:-10, dy:0)
        imageView.contentMode = UIViewContentMode.center
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = imageView;
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x  += 10
        return textRect
    }
//    override func leftViewRect(_: forBounds , bounds: CGRect) -> CGRect
//    {
//        var textRect = super.leftViewRect(forBounds: bounds)
//        textRect.origin.x  += 10
//        return textRect
//
//    }
    
    

}


