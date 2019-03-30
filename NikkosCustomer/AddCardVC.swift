//
//  AddCardVC.swift
//  NikkosCustomer
//
//  Created by Umang on 10/25/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class AddCardVC: UIViewController,UITextViewDelegate
{
    
    
    @IBOutlet weak var nameTxt: LoginRegisterTxtField!
    @IBOutlet weak var cardNumberTxt: LoginRegisterTxtField!
    @IBOutlet weak var cvvTxt: LoginRegisterTxtField!
    @IBOutlet weak var monthTxt: TextfieldPicker!
    @IBOutlet weak var yearTxt: TextfieldPicker!
    
    @IBOutlet weak var cardTypeTxt: TextfieldPicker!
    @IBOutlet var btnAddCardTitle: UIButton!
    @IBOutlet var lblExpiryDateHeading: UILabel!
    @IBOutlet var lblCardDetailsHeading: UILabel!
    var loginObj:LoginModal!
    
    var cardTypeArr : NSMutableArray = ["American Expres", "Discover","JCB","MasterCard","Visa","Verve"];
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        nameTxt.setLeftImage(imageName: "name")
//        cardNumberTxt.setLeftImage(imageName: "card")
//        cvvTxt.setLeftImage(imageName: "cvv")
//        monthTxt.setPadding(width: 5.0)
//        yearTxt.setPadding(width: 5.0)
        NikkosCustomerManager.getToolBar(target: self, inputView: cardNumberTxt, selecter: #selector(doneWithNumberPad))
        NikkosCustomerManager.getToolBar(target: self, inputView: cvvTxt, selecter: #selector(doneWithNumberPad))
        monthTxt?.pickerArray = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        let year:NSMutableArray = NSMutableArray()
        for i:NSInteger in 2016  ..< 2026
        {
            year.add(String(i))
        }
        yearTxt.pickerArray = year
        self.loginObj = SharedStorage.getUser()
        self.title = NikkosCustomerManager.GetLocalString(textType: "Add_card")
        //lblCardDetailsHeading.text = NikkosCustomerManager.GetLocalString(textType: "Card_Detail")
        lblExpiryDateHeading.text = NikkosCustomerManager.GetLocalString(textType:"Expiry_Date")
       btnAddCardTitle.setTitle(NikkosCustomerManager.GetLocalString(textType:"Add_card"), for: .normal)
        nameTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"NAME")
        cardNumberTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Card_Number")
        cvvTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"CVV")
        monthTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Month")
        yearTxt.placeholder = NikkosCustomerManager.GetLocalString(textType:"Year")
        cardTypeTxt.placeholder = "Card Type"
        cardTypeTxt.pickerArray = cardTypeArr
        // Do any additional setup after loading the view.
    }
    @IBAction func saveBtnPress(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
       
        
        let parameters: [String: AnyObject] =
            [
                "ClientName"        :  NikkosCustomerManager.trimString(string: nameTxt.text!) as AnyObject,
                "CardNumber"        :  NikkosCustomerManager.trimString(string: cardNumberTxt.text!) as AnyObject,
                "Month"             :  NikkosCustomerManager.trimString(string: monthTxt.text!) as AnyObject,
                "Year"              :  NikkosCustomerManager.trimString(string: yearTxt.text!) as AnyObject,
                "CVV"               :  NikkosCustomerManager.trimString(string: cvvTxt.text!) as AnyObject,
            "ClientId"          :  self.loginObj.id as AnyObject,
            "IsDefault"         :  true as AnyObject,
            "ClientEmail"       :  "" as AnyObject,
            "CardType"          : NikkosCustomerManager.trimString(string: cardTypeTxt.text!) as AnyObject,
            ]
        

        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/AddCardDetail", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    if (data?.value(forKey: "Data") as! NSDictionary).value(forKey:"success") as! Bool == true{
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }else{
                        CIError((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"Message") as! String)
                    }
                    self.navigationController?.popViewController(animated: true)
        
                }else
                {
                    if ((data?.value(forKey: "ResponseMessage")) != nil){
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }else{
                        CIError("Opps something went wrong.")
                    }
                }
            }
            else
            {
                CIError(data?.value(forKey: "Status") as! String)
            }
            
        }
        
        
        
        
    }
    
    func ValidateEntries() -> Bool {
        if NikkosCustomerManager.trimString(string: (nameTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_cardholderName"))
            return false
            
        }else if NikkosCustomerManager.trimString(string: (cardNumberTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_cardNumber"))
            return false
            
        }else  if NikkosCustomerManager.trimString(string: (cardNumberTxt?.text)!).count < 12 ||  NikkosCustomerManager.trimString(string: (cardNumberTxt?.text)!).count > 18
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_cardNo_atleast12char"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (cvvTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_cvvCode"))
            return false
        }
        else if NikkosCustomerManager.trimString(string: (cardTypeTxt?.text)!).isEmpty == true
        {
            CIError("Please enter card type")
            return false
        }
        else if NikkosCustomerManager.trimString(string: (monthTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_expiryMonth"))
            return false
            
        }
        else if NikkosCustomerManager.trimString(string: (yearTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Please_enter_expiryYear"))
            return false
        }
        
        else{
            return true
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let  newLength = (textField.text?.characters.count)!+string.characters.count-range.length
        
        if (textField == cardNumberTxt) {
            return (newLength > 18) ? false : true
        }
        else if (textField == cvvTxt) {
            return (newLength > 4) ? false : true
        }
        
        return true
    }

    @objc func doneWithNumberPad()
    {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backBtnPress(_ sender: AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
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
