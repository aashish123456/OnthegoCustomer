//
//  ViewController.swift
//  NikkosCustomer
//
//  Created by Umang on 9/12/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet var lblSignInWith: UILabel!
    var signIn: GPPSignIn!
    var strSocialUserType : String!
    @IBOutlet weak var userNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var passwordTxt: LoginRegisterTxtField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var rememberMeBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    var forgotPasswordField: UITextField!
    var otpTxtField: UITextField!
    var loginObj:LoginModal!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if SharedStorage.getIsRememberMe() == true
        {
            NikkosCustomerManager.appDelegate.loadHomeViewController()
        }
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        self.title = NikkosCustomerManager.GetLocalString(textType: "Login")
        userNameTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_your_email")
        passwordTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_your_password")
        loginBtn.setTitle(NikkosCustomerManager.GetLocalString(textType: "Login"), for: .normal)
        rememberMeBtn.titleLabel!.numberOfLines = 0
        rememberMeBtn.titleLabel!.adjustsFontSizeToFitWidth = false
        rememberMeBtn.titleLabel?.textAlignment = .center
        signUpBtn.titleLabel!.numberOfLines = 1
        signUpBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        signUpBtn.titleLabel?.textAlignment = .center
        self.signUpBtn.setTitle("Create Account.", for: .normal)
        self.rememberMeBtn.setTitle(NikkosCustomerManager.GetLocalString(textType: "Remember_Me"), for: .normal)
        forgotPasswordBtn.setTitle(NikkosCustomerManager.GetLocalString(textType: "Forgot_Password"), for: .normal)
        //lblSignInWith.text = NikkosCustomerManager.GetLocalString(textType: "Sign_In_With")
    }
    
    // MARK: - validation
    func validateEmail(_ candidate: String) -> Bool {
        // NOTE: validating email addresses with regex is usually not the best idea.
        // This implementation is for demonstration purposes only and is not recommended for production use.
        // Regex source and more information here: http://emailregex.com
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    @IBAction func rememberMebtnPress(_ sender: Any)
    {
        rememberMeBtn.isSelected = !rememberMeBtn.isSelected
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        print(forgotPasswordField.text)
        self.submitForgotRequest()
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = NikkosCustomerManager.GetLocalString(textType: "Email_Id")
        forgotPasswordField = textField
    }
    // submit forgot request :-
    func submitForgotRequest()
    {
        self.view.endEditing(true)
        if ValidateForgotEntries() == false {
            return
        }
        // pass parameter for ForgetPassword ( email and user role )
        let parameters: [String: String] = [
            "Email"     : NikkosCustomerManager.trimString(string: forgotPasswordField.text!),
            "User_Role" : "3",
        ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/ForgetPassword", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
        }
    }
    @IBAction func userSignUpBtnPress(_ sender: Any)
    {
        self.performSegue(withIdentifier: "showSignUp", sender: nil)
    }
    @IBAction func loginBtnPress(_ sender: Any)
    {
       // NikkosCustomerManager.appDelegate.loadHomeViewController()
            self.view.endEditing(true)
            if ValidateEntries() == false {
                return
            }
            let parameters: [String: String] = [
                "UserName"     : NikkosCustomerManager.trimString(string: userNameTxt.text!),
                "Password"     : NikkosCustomerManager.trimString(string: passwordTxt.text!),
                "PhoneNumber"   : "",
                "DeviceToken"  : SharedStorage.getDeviceToken(),
                "DeviceType"   : "1",
                "UserRole"     : "3",
                ]
            NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/GetClientLogin", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                NikkosCustomerManager.dissmissHud()
                if status == true
                {
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        self.loginObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                        if self.loginObj .isUserActive == true
                        {
                                if self.loginObj.isPhoneVerified == false
                                {
                                    // resend otp :-
                                    self.resendOtpCode()
                                    self.showOtpAlert()
                                }else if self.loginObj.isEmailVerified == false
                                {
                                    //alert :-
                                    CIError(NikkosCustomerManager.GetLocalString(textType: "Please_verify_email_bforLogin"))
                                }else if self.loginObj.isClientActive == false
                                {
                                   //alert :-
                                    CIError(NikkosCustomerManager.GetLocalString(textType: "You_cant_login_before_admin_approves_your_account"))
                                }
                                else
                                {
                                    // select language :-
                                    if self.rememberMeBtn.isSelected == true
                                    {
                                        SharedStorage.setIsRememberMe(isRememberMe: true)
                                    }
                                    SharedStorage.setUser(user: self.loginObj)
                                    SharedStorage.setUserId(userId: String(self.loginObj.id))
                                    
                                    
                                    NikkosCustomerManager.appDelegate.loadHomeViewController()
                                    
                                }
                        }
                        else
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_contact_admin_forActivate"))
                        }
                    }else
                    {
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }
                }
                else
                {
                    CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
                }
                
            }
    }
    // Fb button press :-
    @IBAction func btnFBPress(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile","user_friends"], from: self, handler: { (result, error) -> Void in
            if (error == nil){
                if (!(result?.isCancelled)!) {
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    print(fbloginresult)
                    self.returnUserData()
                }
            }
        })
       
    }
    // Fb data :-
    func returnUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                    self.fbDataToServer(dict: result as! NSDictionary)
                }
            })
        }
    }
    
    func fbDataToServer(dict : NSDictionary) -> Void {
        var fbEmail : String = ""
        if let e = dict.value(forKey: "email") {
            fbEmail = e as! String
        }
        
        NikkosCustomerManager.fbId = dict.value(forKey: "id") as! String
        
        let parameters: [String: String] = [
            "UserName"     : fbEmail,
            "Password"     : "",
            "PhoneNumber"   : "",
            "DeviceToken"  : SharedStorage.getDeviceToken(),
            "DeviceType"   : "1",
            "UserRole"     : "3",
            "GoogleId"     : "",
            "FaceBookId"   : NikkosCustomerManager.fbId,
            ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetClientLogin", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    self.loginObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    if self.loginObj .isUserActive == true
                    {
                        if self.loginObj.isPhoneVerified == false
                        {
                            self.resendOtpCode()
                            self.showOtpAlert()
                        }else if self.loginObj.isEmailVerified == false
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_verify_email_bforLogin"))
                        }else if self.loginObj.isClientActive == false
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "You_cant_login_before_admin_approves_your_account"))
                        }
                        else
                        {
                            if self.rememberMeBtn.isSelected == true
                            {
                                SharedStorage.setIsRememberMe(isRememberMe: true)
                            }
                            SharedStorage.setUser(user: self.loginObj)
                            SharedStorage.setUserId(userId: String(self.loginObj.id))
                            
                            NikkosCustomerManager.appDelegate.loadHomeViewController()
                            
                        }
                    }else
                    {
                        CIError(NikkosCustomerManager.GetLocalString(textType: "Please_contact_admin_forActivate"))
                    }
                }else if data?.value(forKey: "ResponseCode") as! NSNumber == 605
                {
                    //self.loginObj = LoginModal(fromDictionary:(data?.valueForKey("Data") as! NSDictionary))
                    print(parameters)
                    self.performSegue(withIdentifier: "showSignUp", sender: parameters)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
            
        }

        
    }
    

    @IBAction func btnGooglePlusPress(_ sender: Any) {
        NikkosCustomerManager.showHud()
        //strSocialUserType = "g"
        signIn = GPPSignIn.sharedInstance()
       // signIn.clientID = "AIzaSyAXt7XOMYiqaS8gsXtkP7jb8U6mGRDYsV0"
        //signIn.clientID = "531626955459-js0o6t2ot38flmtmmd5i792t8djfa07a.apps.googleusercontent.com"
        signIn.clientID = "739996931074-iipd7pgcnng5reji67v11hfv6o7pr6bs.apps.googleusercontent.com"
        signIn.delegate = self as! GPPSignInDelegate;
        signIn.shouldFetchGooglePlusUser = true
        signIn.shouldFetchGoogleUserEmail = true
        signIn.scopes = ["profile"]
        //signIn.delegate = self
        signIn.authenticate()
   }
    
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        if  (error != nil) {
            NikkosCustomerManager.dissmissHud()
            return
        }
        // dismissViewControllerAnimated(true, completion: nil)
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        print(auth)
        
        var  strFirstName : String!
        var  strLastName : String!
        var  strUserID : String!
        var  strEmail : String!
        
        if (signIn.googlePlusUser.displayName.components(separatedBy: " ").first?.isMember(of: NSNull.self))! {
            strFirstName = ""
        }
        else{
            strFirstName = signIn.googlePlusUser.displayName.components(separatedBy: " ").first
        }
        if (signIn.googlePlusUser.displayName.components(separatedBy: " ").last?.isMember(of: NSNull.self))! {
            strLastName = ""
        }
        else{
            strLastName  = signIn.googlePlusUser.displayName.components(separatedBy: " ").last
        }
        if (signIn.googlePlusUser.identifier?.isMember(of: NSNull.self))!{
            strUserID = ""
        }
        else{
            strUserID = signIn.googlePlusUser.identifier
        }
        
        if  signIn.userEmail!.isKind(of:NSNull.self) {
            strEmail = ""
        }
        else{
            strEmail = signIn.userEmail
        }
        
        
        let parameters: [String: String] = [
            "UserName"     : strEmail,
            "Password"     : "",
            "PhoneNumber"   : "",
            "DeviceToken"  : SharedStorage.getDeviceToken(),
            "DeviceType"   : "1",
            "UserRole"     : "3",
            "GoogleId"     : strUserID,
            "FaceBookId"   : "",
            ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetClientLogin", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {                    
                    self.loginObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    if self.loginObj .isUserActive == true
                    {
                        if self.loginObj.isPhoneVerified == false
                        {
                            self.resendOtpCode()
                            self.showOtpAlert()
                        }else if self.loginObj.isEmailVerified == false
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_verify_email_bforLogin"))
                        }else if self.loginObj.isClientActive == false
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "You_cant_login_before_admin_approves_your_account"))
                        }
                        else
                        {
                            if self.rememberMeBtn.isSelected == true
                            {
                                SharedStorage.setIsRememberMe(isRememberMe: true)
                            }
                            SharedStorage.setUser(user: self.loginObj)
                            SharedStorage.setUserId(userId: String(self.loginObj.id))
                            NikkosCustomerManager.appDelegate.loadHomeViewController()
                        }
                    }else
                    {
                        CIError("Please contact admin for activate.")
                    }
                }else if data?.value(forKey: "ResponseCode") as! NSNumber == 605
                {
                    print(parameters)
                    self.performSegue(withIdentifier: "showSignUp", sender: parameters)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
            
        }

        
    }

    func didDisconnectWithError(error: NSError!) {
        
    }

    func ValidateForgotEntries() -> Bool {
        
        if NikkosCustomerManager.trimString(string: (forgotPasswordField?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_email"))
            return false
        }
        else if NikkosCustomerManager.isValidEmail(testStr: (forgotPasswordField?.text)!) == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_correct_format_mail"))
            return false
        }
        else{
            return true
        }
        
    }

    // MARK: - Validation Method
    
    func ValidateEntries() -> Bool {
        if NikkosCustomerManager.trimString(string: (userNameTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_email"))
            return false
        }
        else if NikkosCustomerManager.isValidEmail(testStr: (userNameTxt?.text)!) == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_correct_format_mail"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (passwordTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_password"))
            return false
        }
        else{
            return true
        }
    }
    //OTP
    func wordEnteredOtp(alert: UIAlertAction!){
        // store the new word
        self.submitOtp()
    }
    
    func resend(alert: UIAlertAction!){
        self.resendOtpCode()
        self.showOtpAlert()
    }
    func addTextFieldOtp(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "OTP"
        textField.keyboardType = UIKeyboardType.numberPad
        textFieldDidBeginEditing(textField: textField)
        otpTxtField = textField
    }
    func textFieldDidBeginEditing(textField: UITextField) -> Bool {
        self.setToolbarOnTextfield(textField: textField)
        return false
    }
    
    func setToolbarOnTextfield(textField : UITextField)  {
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.done,target: self,action: #selector(self.doneButtonPressed))
        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        textField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonPressed() {
        // self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    func showOtpAlert()
    {
        let newWordPrompt = UIAlertController(title:  NikkosCustomerManager.GetLocalString(textType: "Verification"), message: NikkosCustomerManager.GetLocalString(textType: "Please_Enter_OTP"), preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextFieldOtp)
        //newWordPrompt.addAction(UIAlertAction(title:  NikkosCustomerManager.GetLocalString(textType: "Resend"), style: UIAlertActionStyle.default, handler: self.resend))
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.wordEnteredOtp))
        self.present(newWordPrompt, animated: true, completion: nil)
    }

    func submitOtp()
    {
        if otpTxtField.text?.characters.count == 0 {
            showOtpAlert()
            return
        }
        let parameters: [String: AnyObject] =
                [
                "OtpValue"   : self.otpTxtField.text! as AnyObject,
                "ClientId"      : self.loginObj.id as AnyObject,
                ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname:  "CommonDirectAuthori/VerifyClientLoginOTP", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.loginBtnPress(UIButton())
                }else
                {
//                    CIError(data?.value(forKey: "ResponseMessage") as! String)
//                    self.showOtpAlert()
                    
                    let refreshAlert = UIAlertController(title: "Onthego", message: (data?.value(forKey: "ResponseMessage") as! String), preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.resendOtpCode()
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
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
                self.showOtpAlert()
            }
            
        }
        
    }

    func resendOtpCode()
    {
        let parameters: [String: AnyObject] =
                [
                "ID"      : self.loginObj.id as AnyObject,
                ]
       // NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/ResendClientLoginOPT", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
           // NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
//                    self.loginBtnPress(UIButton())
                    self.showOtpAlert()
                }else
                {
//                    self.showOtpAlert()
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
//               self.showOtpAlert()
            }
            
        }

    }
    
    @IBAction func forgotPasswordBtnPress(_ sender: Any)
    {
        let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "Forgot_Password"), message: NikkosCustomerManager.GetLocalString(textType: "Enter_email_id"), preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: addTextField)
        newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Cancel"), style: UIAlertActionStyle.default, handler: nil))
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: wordEntered))
        present(newWordPrompt, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let signUpVC = segue.destination as! SignUpVC
        if sender == nil{
            signUpVC.isFromSocial = false
        }else{
            let socialObj = sender as! [String:String]
            signUpVC.social = socialObj
            signUpVC.isFromSocial = true
        }
    }
}

