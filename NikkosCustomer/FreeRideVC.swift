//
//  FreeRideVC.swift
//  NikkosCustomer
//
//  Created by Umang on 11/21/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class FreeRideVC: UIViewController,SWRevealViewControllerDelegate {

     @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var promoCodeLbl: UILabel!
    
    @IBOutlet var lblGetFreeRideHeading: UILabel!
    
    @IBOutlet var lblSendYourReferralCodeHeading: UILabel!
    
    var loginObj:LoginModal!
    var referalCode:String!
    var referalLink:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosCustomerManager.GetLocalString(textType: "Free_rides")
        lblGetFreeRideHeading.text = NikkosCustomerManager.GetLocalString(textType:"Get_Free_Ride")
        lblSendYourReferralCodeHeading.text = NikkosCustomerManager.GetLocalString(textType:"Send_Ref")
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
        getReferalCode()
        // Do any additional setup after loading the view.
    }
    func getReferalCode()
    {
        let parameters: [String: AnyObject] = [
            
            "ID"      : self.loginObj.id as AnyObject,

            ]
        
        //NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetReferralCode", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            //   NikkosCustomerManager.dissmissHud()
        
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    let dict = data?.value(forKey: "Data") as! NSDictionary
                    self.referalCode = dict.value(forKey: "ReferralCode") as! String
                    self.referalLink = dict.value(forKey: "UrlLink") as! String
                    self.promoCodeLbl.text = dict.value(forKey: "ReferralCode") as? String
            
                    
                }else
                {
                    //CIError(data?.valueForKey("ResponseMessage") as! String)
                    CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
            
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func shareBtnPress(_ sender: UIButton) {
        
        
        let textToShare = String.init(format: "I'm giving you a free ride on the Onthego app. To accept , use code '%@' to sign up. Enjoy! Details:", referalCode)
        
        let url:URL!
        if UIDevice.isDebugMode {
            url = URL(string: Deeplink.shareReferralCode_dev + (referalCode ?? "####"))
        } else {
            url = URL(string: Deeplink.shareReferralCode + (referalCode ?? "####"))
        }
        
        //if let myWebsite = NSURL(string: referalLink) {
        if let myWebsite = url {
            let objectsToShare = [textToShare as Any, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
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
