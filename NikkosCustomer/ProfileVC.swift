//
//  ProfileVC.swift
//  NikkosCustomer
//
//  Created by Umang on 9/19/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,SWRevealViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NIDropDownDelegate,UITextFieldDelegate
{
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var txtAmount: LoginRegisterTxtField!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var Salutation: NSMutableArray = NSMutableArray()
    var vehicleArr: NSMutableArray = NSMutableArray()
    var vehicleIdArr: NSMutableArray = NSMutableArray()
    @IBOutlet weak var profileVC: AsyncImageView!
    @IBOutlet weak var titleTxt: TextfieldPicker!
    @IBOutlet weak var userNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var phoneNoTxt: LoginRegisterTxtField!
    @IBOutlet weak var vehchileTypeTxt: TextfieldPicker!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var companyNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var compnayIdTxt: LoginRegisterTxtField!
    @IBOutlet weak var employeeIdTxt: LoginRegisterTxtField!
    var loginObj:LoginModal!
    var userProfileObj:LoginModal!
    @IBOutlet weak var bottomLayoutViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTxt: LoginRegisterTxtField!
    @IBOutlet weak var editSaveBtn: UIButton!
    var imgData : NSData!
    let imagePicker = UIImagePickerController()
    var promoCodeTxtField: UITextField!
    var dropDown: NIDropDown!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var txtCode: TextfieldPicker!
    let arrCode : NSMutableArray = NSMutableArray()
    let arrCodeId : NSMutableArray = NSMutableArray()
    let arrCountoryName : NSMutableArray = NSMutableArray()
    var code : CodeModel!
    @IBOutlet var lblCreditAmount: UILabel!
    
    @IBOutlet var btnAddPromoCode: UIButton!
    @IBOutlet var lblTitleWantToProCustomer: UILabel!
    @IBOutlet var lblTitleCreditAmount: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        self.title = NikkosCustomerManager.GetLocalString(textType: "My_Profile")
        let revealViewController = self.revealViewController()
        editSaveBtn.accessibilityLabel = "edit"
        editSaveBtn.setTitle("EDIT", for: .normal)
        imagePicker.delegate = self
        revealViewController?.delegate = self
        if (( revealViewController ) != nil)
        {
            
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer((revealViewController?.panGestureRecognizer())!)
        }
        self.profileVC.layer.cornerRadius = 60.0
        self.profileVC.clipsToBounds = true
        self.profileVC.layer.borderColor = UIColor.white.cgColor
        self.profileVC.layer.borderWidth = 2.0
        self.titleTxt.isUserInteractionEnabled = false
        userNameTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_your_username")
        phoneNoTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_your_phone_number")
        NikkosCustomerManager.getToolBar(target: self, inputView: phoneNoTxt, selecter: #selector(doneWithNumberPad))
        txtCode.placeholder = NikkosCustomerManager.GetLocalString(textType: "Code")
        titleTxt.placeholder = "Title"
        self.getSalutation()
        emailTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_your_email")
        profileVC.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImgBtnPress)))
        self.loginObj = SharedStorage.getUser()
        getCode()
        self.enableForm(flag: false)
        imgData = nil
//        txtAmount.isUserInteractionEnabled = false
//        txtAmount.placeholder = "Credit amount"
        // Do any additional setup after loading the view.
    }
    @objc func profileImgBtnPress()
    {
        self.view.endEditing(true)
        // 1
        imagePicker.allowsEditing = false
        let optionMenu = UIAlertController(title: nil, message: NikkosCustomerManager.GetLocalString(textType: "Choose_Option"), preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Camera"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Deleted")
            self.imagePicker.sourceType = .camera
            self.showCamera()
            //  presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Photo_Library"), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
            self.imagePicker.sourceType = .photoLibrary
            self.showCamera()
            // presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Cancel"), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    func getCode(){
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/CountryList", parameter:[:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.getProfile()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrCode.removeAllObjects()
                    self.arrCodeId.removeAllObjects()
                    let tempArr = ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        self.code = CodeModel(fromDictionary: dict as NSDictionary)
                        self.arrCode .add(self.code.code)
                        self.arrCodeId.add(self.code.countryId)
                         self.arrCountoryName.add(self.code.name)
                    }
                   // self.txtCode.reloadPickerWithArray(self.arrCode)
                    self.txtCode.reloadPickerWithArrayArray(arr: self.arrCode, arrName: self.arrCountoryName)
                }
                else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String )
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong") )
            }
        }
    }
    func showCamera()
    {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileVC.image = pickedImage
            
            imgData = UIImageJPEGRepresentation(pickedImage, 0.0)! as NSData
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func doneWithNumberPad()
    {
        self.view.endEditing(true)
    }
    
    func getProfile()
    {
        let parameters: [String: AnyObject] =
                [
                    "ID"      : self.loginObj.id as AnyObject,
                ]
        
        WebServiceHelper.webServiceCall(methodname: "Client/GetClientProfile", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.userProfileObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    self.titleTxt.text = self.userProfileObj.salutation
                    self.userNameTxt.text = self.userProfileObj.firstName
                    self.phoneNoTxt.text = self.userProfileObj.phoneNumber
                    self.emailTxt.text = self.userProfileObj.email
                    self.lblAmount.text = String.init(format: "Credit Amount : %.2f", self.userProfileObj.creditedAmount)
                    self.profileVC.imageURL = NSURL(string: NikkosCustomerManager.checkNullString(string: self.userProfileObj.profileImage as AnyObject)) as! URL
                    self.imgData = NSData(contentsOf: NSURL(string: NikkosCustomerManager.checkNullString(string: self.userProfileObj.profileImage as AnyObject))! as URL)
                    SharedStorage.setUser(user: self.userProfileObj)
                    
                    let codeId = self.arrCodeId .index(of: self.userProfileObj.countryId)
                    let code = self.arrCode .object(at: codeId)
                    self.txtCode.text =  code as! String
                }else
                {
                    CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
               
            }
            
        }

    }
    func getVehciles()
    {
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Vehicle/AllCustomVehicleCategory", parameter:[:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.vehicleArr.removeAllObjects()
                    self.vehicleIdArr.removeAllObjects()
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        let vehicleObj:VehicleTypeModal = VehicleTypeModal(fromDictionary: dict as NSDictionary)
                        
                        if vehicleObj.value == 7 || vehicleObj.value == 8{
                            continue
                        }
                        self.vehicleArr.add(vehicleObj.text)
                        self.vehicleIdArr.add(vehicleObj.value)
                        
                    }
                    self.vehchileTypeTxt.pickerArray = self.vehicleArr
                }else
                {
                    CIError(data?.value(forKey: "Message") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
        
        }

    }
    
    @IBAction func editBtnPress(_ sender: Any)
    {
         if editSaveBtn.accessibilityLabel == "edit"
         {
            editSaveBtn.accessibilityLabel = "save"
            editSaveBtn.setTitle("SAVE", for: .normal)
            self.enableForm(flag: true)
         }else
         {
            saveProfileData()
         }
    }
    func saveProfileData()
    {
        self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
        
        let index = arrCode .index(of: txtCode.text!)
        let codeId = arrCodeId .object(at: index)
        
        let parameters: [String: AnyObject] =
            [
                "Id"          : self.loginObj.id as AnyObject,
                "FirstName"   : NikkosCustomerManager.trimString(string: userNameTxt.text!) as AnyObject,
                "Email"       : NikkosCustomerManager.trimString(string: emailTxt.text!) as AnyObject,
                "CountryId"    : codeId as AnyObject,
                "PhoneNumber" : NikkosCustomerManager.trimString(string: phoneNoTxt.text!) as AnyObject,
                "IsPro"       : "" as AnyObject,
                "CompanyName" : "" as AnyObject,
                "CompanyCode" : "" as AnyObject,
                "EmployeeID"  : "" as AnyObject,
                "Salutation"  : titleTxt.text! as AnyObject,
                "ProfileImage": imgData.base64EncodedString(options: []) as AnyObject,
                "DefaultVehicleCategory" : "" as AnyObject,
                "PreferredLanguage" : "en" as AnyObject,
                ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/UpdateClientProfile", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let profileModal = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    
                    if profileModal.isUserActive == true
                    {
                        if profileModal.isPhoneVerified == true
                        {
                            if profileModal.isEmailVerified == true
                            {
                                if profileModal.isClientActive == true
                                {
                                    SharedStorage.setUser(user: profileModal)
                                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                                    self.editSaveBtn.accessibilityLabel = "edit"
                                    self.editSaveBtn.setTitle("EDIT", for: .normal)
                                    self.enableForm(flag: false)
                                    self.getProfile()
                                    
                                }else
                                {
                                    CIError(NikkosCustomerManager.GetLocalString(textType: "Please_wait_for_admin_mail_forActivation"))
                                    self.sendToLogin()
                                }
                            }else{
                                CIError(NikkosCustomerManager.GetLocalString(textType: "Please_verify_your_email"))
                                self.sendToLogin()
                            }
                        }else
                        {
                            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_verify_your_PhoneNumber"))
                            self.sendToLogin()
                        }
                        
                    }else
                    {
                        CIError(NikkosCustomerManager.GetLocalString(textType: "Please_contact_admin_toActivate"))
                        self.sendToLogin()
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
    
    func sendToLogin()
    {
      NikkosCustomerManager.appDelegate.loadSignInViewController()
    }
    
    func ValidateEntries() -> Bool
    {
        if imgData == nil
        {
            CIError("Please attach profile image.")
            return false
        }
        else
            if NikkosCustomerManager.trimString(string: (titleTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_Salutation"))
            return false
            
            }else if NikkosCustomerManager.trimString(string: (userNameTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_name"))
            return false
            
            }
            else  if NikkosCustomerManager.trimString(string: (userNameTxt?.text)!).count > 30
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_name_lessThan15Char"))
            return false
        }
            else if NikkosCustomerManager.trimString(string: (emailTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_email"))
            return false
            
        }
            else if NikkosCustomerManager.isValidEmail(testStr: (emailTxt?.text)!) == false
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_correct_format_mail"))
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
       
        else{
            return true
        }
        
    }

    func enableForm(flag : Bool)
    {
        self.titleTxt.isUserInteractionEnabled = flag
        self.userNameTxt.isUserInteractionEnabled = flag
        self.emailTxt.isUserInteractionEnabled = flag
        self.phoneNoTxt.isUserInteractionEnabled = flag
        self.profileVC.isUserInteractionEnabled = flag
        self.txtCode.isUserInteractionEnabled = flag
    }
    
    func getSalutation()
    {
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname:  "CommonDirectAuthori/GetSalutation", parameter:[:], httpType: "POST") { (status, data, error) -> () in
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
                   // self.titleTxt.userInteractionEnabled = true
                }else
                {
                    CIError(data?.value(forKey: "Message") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redioBtnSelected(sender: UIButton)
    {
        if yesBtn == sender
        {
            yesBtn.isSelected = true
            noBtn.isSelected =  false
            companyNameTxt.isHidden = false
            compnayIdTxt.isHidden = false
            employeeIdTxt.isHidden = false
            bottomLayoutViewConstraint.constant = 300
        }else
        {
            noBtn.isSelected = true
            yesBtn.isSelected = false
            companyNameTxt.isHidden = true
            compnayIdTxt.isHidden = true
            employeeIdTxt.isHidden = true
            bottomLayoutViewConstraint.constant = 170
        }
    }

    @IBAction func addPromoCodeBtnPress(sender: AnyObject)
    {
        let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType: "Enter_promo_code"), preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextField)
        newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Submit"), style: UIAlertActionStyle.default, handler: self.wordEntered))
        self.present(newWordPrompt, animated: true, completion: nil)
    }
    
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        print(promoCodeTxtField.text)
        submitPromoCode()
        
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "PROMO CODE"
        promoCodeTxtField = textField
    }
    func submitPromoCode()
    {
        self.view.endEditing(true)
        let parameters: [String: AnyObject] =
            [
                "PromoCode"   : self.promoCodeTxtField.text! as AnyObject,
                "ClientId"    :  self.loginObj.id as AnyObject,
                ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname:  "Common/ApplyPromoCode", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.getProfile()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txtCode){
            CIError("Please create a new account to change your country")
            return false
        }
        return true
    }

    //for language change
    @IBAction func changeLangBtnPress(_ sender: Any) {
        var arr = [AnyObject]()
        arr = [NikkosCustomerManager.k_ENGLISH,NikkosCustomerManager.k_FRENCH] as [AnyObject]
        if dropDown == nil {
            var f: CGFloat = 80
            var index :Int32 =  0
            
            let prefs = UserDefaults.standard
            let myString = prefs.string(forKey: NikkosCustomerManager.k_USER_LANG)!
            if (myString == NikkosCustomerManager.k_FRENCH) {
                index = 1
            }
            else if (myString == NikkosCustomerManager.k_SPENSISH) {
                index = 2
            }
                
            else {
                index = 0
            }
            
            dropDown = NIDropDown().show(sender as! UIButton, &f, arr, nil, "down",index) as! NIDropDown
            dropDown.delegate = self
        }
        else {
            dropDown.hide(sender as! UIButton)
            self.rel()
        }
        
    }
    
    func niDropDownDelegateMethod(_ sender: NIDropDown) {
        self.rel()
        print("\(btnSelect.titleLabel!.text!)")
        //["English", "French", "Spanish"]
        if ( (btnSelect.currentTitle)) == "English"
        {
           // SharedStorage.setLanguage(NikkosCustomerManager.k_ENGLISH)
        }else if ( (btnSelect.currentTitle)) == "French"
        {
           // SharedStorage.setLanguage(NikkosCustomerManager.k_FRENCH)
            
        }else
        {
          //  SharedStorage.setLanguage(NikkosCustomerManager.k_SPENSISH)
        }
    }
    
    func rel() {
        //    [dropDown release];
        dropDown = nil
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
