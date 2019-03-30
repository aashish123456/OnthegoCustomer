//
//  NikkosCustomerManager.swift
//  NikkosCustomer
//
//  Created by Umang on 9/13/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class NikkosCustomerManager: NSObject {

    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static let k_USER_LANG : String = "USERLANGUAGE"
    static let k_FRENCH : String = "French"
    static let k_ENGLISH : String = "English"
    static let k_SPENSISH : String = "Spanish"
    static var fbId : String = ""
    //static var baseURL : String = "http://wds2.projectstatus.co.uk/NikkosWorkingWeb/api/"
    //static var baseURL : String = "http://www.nikkos.fr/api/"
    static func showHud(){
        SVProgressHUD.show(with: .black)
    }
    
    static func dissmissHud(){
        SVProgressHUD.dismiss()
    }
    static func showHudWithStatus(status: String){
        SVProgressHUD.show(withStatus: status, maskType: .black)
    }
    
    static func UIColorFromRGB( r : Int, g: Int , b :Int) -> UIColor {
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    static func GetLocalString(textType: String) -> String {
        var path: String
        let prefs = UserDefaults.standard
        var myString = prefs.string(forKey: k_USER_LANG)
        if (myString == k_FRENCH) {
            myString = "fr"
        }
        else if (myString == k_SPENSISH) {
            myString = "es"
        }
        else {
            myString = "en"
        }
        path = Bundle.main.path(forResource: myString, ofType: "lproj")!
        let languageBundle = Bundle(path: path)
        let str = languageBundle!.localizedString(forKey: textType, value: "", table: nil)
        return str
    }
    static  func trimString(string :String) -> String{
//        return string.stringByTrimmingCharactersInSet(
//            NSCharacterSet.whitespaceAndNewlineCharacterSet()
//        )
        return string.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func getToolBar(target: AnyObject, inputView: AnyObject , selecter: Selector)
    {
        
        let customToolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: 320, height: 50))
        customToolBar.barStyle = UIBarStyle.blackTranslucent
        customToolBar.barTintColor = UIColor(red: 227/255.0, green: 231/255.0, blue: 235.0/255.0, alpha: 1)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: target, action: selecter)
        doneButton.tintColor =  NikkosCustomerManager.UIColorFromRGB(r: 3, g: 50, b: 98)
        
        customToolBar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), doneButton]
        customToolBar.sizeToFit()
            let  txtInput : UITextField = inputView as! UITextField
            txtInput.inputAccessoryView = customToolBar
        
    }
    static func getToolBarForTextView(target: AnyObject, inputView: AnyObject , selecter: Selector)
    {
        
        let customToolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: 320, height: 50))
        customToolBar.barStyle = UIBarStyle.blackTranslucent
        customToolBar.barTintColor = UIColor(red: 227/255.0, green: 231/255.0, blue: 235.0/255.0, alpha: 1)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: target, action: selecter)
        doneButton.tintColor =  NikkosCustomerManager.UIColorFromRGB(r: 3, g: 50, b: 98)
        
        customToolBar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), doneButton]
        customToolBar.sizeToFit()
        let  txtInput : UITextView = inputView as! UITextView
        txtInput.inputAccessoryView = customToolBar
        
    }

    static  func checkNullString(string : AnyObject?) -> String{
        
        if string?.isEmpty == true
        {
            return ""
        } else {
            let str = string as? String
            if (str != nil){
                return str!
            }else{
                return ""
            }
            
        }
    }

  
    
    
}
