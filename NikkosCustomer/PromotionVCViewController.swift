//
//  PromotionVCViewController.swift
//  OnthegoCustomer
//
//  Created by Ashish Soni on 18/12/18.
//  Copyright © 2018 Dheeraj Kumar. All rights reserved.
//

import UIKit

class PromotionVCViewController: UIViewController,SWRevealViewControllerDelegate ,UITextFieldDelegate{

    @IBOutlet weak var txtFieldPromo : LoginRegisterTxtField!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var loginObj:LoginModal!
    var promoText : String = "";
    var isFromNotification : Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Promotions"
        txtFieldPromo.placeholder = "Promo code"
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        let revealViewController = self.revealViewController()
        revealViewController?.delegate = self
        if (( revealViewController ) != nil)
        {
            
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer((revealViewController?.panGestureRecognizer())!)
        }
        self.loginObj = SharedStorage.getUser()
        if (isFromNotification){
            let index = promoText.range(of: "'", options: .backwards)?.lowerBound
            
            let substring = promoText.substring(to: index!)
            
            let delimiter = "'"
            let newstr = substring
            var token = newstr.components(separatedBy: delimiter)
            
            let substring2 = token[1]
            
            txtFieldPromo.text = substring2
        }
        
    }
    
    @IBAction func btnApplyPress(_ sender: Any) {
        
        self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
        let parameters: [String: AnyObject] =
                [
                "PromoCode"        :  NikkosCustomerManager.trimString(string: txtFieldPromo.text!) as AnyObject,
                "ClientId"          :  self.loginObj.id as AnyObject,
                ]
        
        
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Common/ApplyPromoCode", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.txtFieldPromo.text = ""
                    if (data?.value(forKey: "Data") as! NSDictionary).value(forKey:"success") as! Bool == true{
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }else{
                        CIError((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"Message") as! String)
                    }
                    //self.navigationController?.popViewController(animated: true)
                    
                }else if data?.value(forKey: "ResponseCode") as! NSNumber == 636{
                    let alertController = UIAlertController(title: "Add payment card", message: "Please add your payment card to use promo codes", preferredStyle: .alert)
                    
                    // Create OK button
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                        
                        // Code in this block will trigger when OK button tapped.
                        let reveal = self.appDelegate.window?.rootViewController as! SWRevealViewController
                        let rootController:AddCardVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
                        (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                        
                    }
                    alertController.addAction(OKAction)
                    
                    // Create Cancel button
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                        print("Cancel button tapped");
                    }
                    alertController.addAction(cancelAction)
                    
                    // Present Dialog message
                    self.present(alertController, animated: true, completion:nil)
                }
                else
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
    func ValidateEntries() -> Bool
    {
            if NikkosCustomerManager.trimString(string: (txtFieldPromo?.text)!).isEmpty == true
            {
                CIError("Please enter promo code.")
                return false
            }
            else
            {
                return true
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
