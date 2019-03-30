//
//  SignUpVC.swift
//  NikkosCustomer
//
//  Created by Umang on 9/13/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController
{
    @IBOutlet weak var userNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var emailTxt: LoginRegisterTxtField!
    @IBOutlet weak var passwordTxt: LoginRegisterTxtField!
    @IBOutlet weak var confirmPassTxt: LoginRegisterTxtField!
    @IBOutlet weak var phoneNoTxt: LoginRegisterTxtField!
    
    @IBOutlet weak var txtReferralCode: LoginRegisterTxtField!
    var otpTxtField: UITextField!
    var Salutation: NSMutableArray = NSMutableArray()
    @IBOutlet weak var titleTxt: TextfieldPicker!
    var userId:AnyObject!
    var social:[String:String] = [:]
    var isFromSocial : Bool!
    var referralCodeString : String!
    @IBOutlet var txtCode: TextfieldPicker!
    var dropDown: NIDropDown!
    @IBOutlet var btnSignUp: UIButton!
    let arrCode : NSMutableArray = NSMutableArray()
    let arrCountoryName : NSMutableArray = NSMutableArray()
    let arrCodeId : NSMutableArray = NSMutableArray()
    var code : CodeModel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.titleTxt.isUserInteractionEnabled = false
        self.txtCode.isUserInteractionEnabled = false
        let gradientImage = UIImage(named: "navi.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        self.title = NikkosCustomerManager.GetLocalString(textType: "Register")
        userNameTxt.placeholder = "Enter your name"
        titleTxt.placeholder = "title"
        emailTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Enter_your_email")
        passwordTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Enter_your_password")
        confirmPassTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Enter_your_confirm_password")
        phoneNoTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Enter_your_phone_number")
        txtCode.placeholder = NikkosCustomerManager.GetLocalString(textType:"Code")
        NikkosCustomerManager.getToolBar(target: self, inputView: phoneNoTxt, selecter: #selector(doneWithNumberPad))
        self.getSalutation()
        btnSignUp.setTitle("SIGNUP", for: .normal)
        getCode()
        if (referralCodeString != ""){
            txtReferralCode.text = referralCodeString
        }
        txtReferralCode.placeholder = "Referral code"
    }
    
    func getCode(){
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/CountryList", parameter:[:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrCode.removeAllObjects()
                    self.arrCodeId.removeAllObjects()
                    self.arrCountoryName.removeAllObjects()
                    let tempArr = ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        self.code = CodeModel(fromDictionary: dict as NSDictionary)
                        self.arrCode .add(self.code.code)
                        self.arrCodeId.add(self.code.countryId)
                        self.arrCountoryName.add(self.code.name)
                    }
                    self.txtCode.reloadPickerWithArrayArray(arr: self.arrCode, arrName: self.arrCountoryName)
                    self.txtCode.isUserInteractionEnabled = true
                }
                else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType:"Something_went_wrong"))
            }
        }
    }
    // get gender :-
    func getSalutation()
    {
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/GetSalutation", parameter:[:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.Salutation.removeAllObjects()
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        let titleObj:GenderTitleModal = GenderTitleModal(fromDictionary: dict as NSDictionary)
                        self.Salutation.add(titleObj.text)
                    }
                        self.titleTxt.pickerArray = self.Salutation
                        self.titleTxt.isUserInteractionEnabled = true
                }else
                {
                    CIError(data?.value(forKey: "Message") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType:"Something_went_wrong"))
            }
        }
   
    }
    @objc func doneWithNumberPad()
    {
        self.view.endEditing(true)
    }
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        print(otpTxtField.text)
        self.submitOtp()
        
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "OTP"
        textField.keyboardType = UIKeyboardType.numberPad
        otpTxtField = textField
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPress(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpBtnPress(_ sender: UIButton)
    {
         self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
        let index = arrCode .index(of: txtCode.text!)
        let codeId = arrCodeId .object(at: index)
        let parameters: [String: AnyObject] =
            [
                "FirstName"    : NikkosCustomerManager.trimString(string: userNameTxt.text!) as AnyObject,
                "Email"        : NikkosCustomerManager.trimString(string: emailTxt.text!) as AnyObject,
                "CountryId"    : codeId as AnyObject,
                "PhoneNumber"  : NikkosCustomerManager.trimString(string: phoneNoTxt.text!) as AnyObject,
                "Password"     : NikkosCustomerManager.trimString(string: passwordTxt.text!) as AnyObject,
                "FaceBookId"   : "" as AnyObject,
                "GoogleId"     : "" as AnyObject,
                "DeviceToken"  : SharedStorage.getDeviceToken() as AnyObject,
                "DeviceType"   : "1" as AnyObject,
                "UserRole"     : "3" as AnyObject,
                "Salutation"   : titleTxt.text! as AnyObject,
                "PreferredLanguage" : "En" as AnyObject,
                "ReferralCode" : NikkosCustomerManager.trimString(string: txtReferralCode.text!)  as AnyObject
            ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/ClientRegistration", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
          NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    //
                    let dic = data?.value(forKey: "Data") as! NSDictionary
                    let id = dic.value(forKey: "ClientId")
                    self.userId = id as AnyObject
                    SharedStorage.setLanguage(language: NikkosCustomerManager.k_ENGLISH)
                    self.showOtpAlert()
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType:"Something_went_wrong"))
            }
        }
    }
    
    func submitOtp()
    {
        if otpTxtField.text?.count == 0 {
             self.showOtpAlert()
             return
        }
        let parameters: [String: AnyObject] =
                [
                    "OtpValue"   : self.otpTxtField.text! as AnyObject,
                    "ClientId"   : self.userId as AnyObject,
                ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/VerifyClientLoginOTP", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                   CIError(NikkosCustomerManager.GetLocalString(textType:"Please_verify_email_bforLogin"))
                   self.navigationController?.popViewController(animated: true)
                }else
                {
                   // self.showOtpAlert()
                    
                    
                    let refreshAlert = UIAlertController(title: "Onthego", message: (data?.value(forKey: "ResponseMessage") as! String), preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.resendOTP()
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                        self.showOtpAlert()
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType:"Something_went_wrong"))
                self.showOtpAlert()
            }
        }

    }
    func resendOTP()
    {
        let parameters: [String: AnyObject] =
            [
                "ID"   : self.userId as AnyObject,
            ]
       // NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/ResendClientLoginOPT", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
           // NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.showOtpAlert()
                }else
                {
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType:"Something_went_wrong"))
            }
        }
        
    }
    func showOtpAlert()
    {
        let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType:"Verification"), message: NikkosCustomerManager.GetLocalString(textType:"Please_Enter_OTP"), preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextField)
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.wordEntered))
        self.present(newWordPrompt, animated: true, completion: nil)
    }
    
    

    func ValidateEntries() -> Bool
    {
        if NikkosCustomerManager.trimString(string: (titleTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_Salutation"))
            return false
            
        }else if NikkosCustomerManager.trimString(string: (userNameTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_name"))
            return false
            
        }else  if NikkosCustomerManager.trimString(string: (userNameTxt?.text)!).count > 30
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_name_lessThan15Char"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (emailTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_email"))
            return false
            
        }
        else if NikkosCustomerManager.isValidEmail(testStr: (emailTxt?.text)!) == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_correct_format_mail"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (passwordTxt?.text)!).isEmpty == true && isFromSocial == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_password"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (confirmPassTxt?.text)!).isEmpty == true && isFromSocial == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_confirmPassword"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (confirmPassTxt?.text)!) != NikkosCustomerManager.trimString(string: (passwordTxt?.text)!)
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Password_Donotmatch"))
            return false
        }
        else if  txtCode?.text!.isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_code"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (phoneNoTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType:"Please_enter_Phone"))
            return false
        }
        else
        {
             return true
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
