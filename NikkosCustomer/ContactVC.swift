//
//  ContactVC.swift
//  NikkosCustomer
//
//  Created by Umang on 11/10/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit
import MessageUI
class ContactVC: UIViewController,SWRevealViewControllerDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var userNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var emailTxt: LoginRegisterTxtField!
    @IBOutlet weak var phoneNoTxt: LoginRegisterTxtField!
    @IBOutlet weak var addressTxtView: UITextView!
    @IBOutlet var lblContactUsHeading: UILabel!
    
    @IBOutlet var lblFeelFreeHeading: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = NikkosCustomerManager.GetLocalString(textType: "Contact_Support")
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
//        let url = NSURL (string: NikkosCustomerManager.baseURL);
//        let requestObj = NSURLRequest(url: url! as URL)
       // myWebView.loadRequest(requestObj);
        userNameTxt.setLeftImage(imageName: "user_icon")
        emailTxt.setLeftImage(imageName: "email")
        phoneNoTxt.setLeftImage(imageName: "phone")
        
        
        lblContactUsHeading.text = NikkosCustomerManager.GetLocalString(textType: "Contact_Us")
        lblFeelFreeHeading.text = NikkosCustomerManager.GetLocalString(textType: "Feel_Free")
        emailTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_Your_Email")
        phoneNoTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Enter_Your_Phone")
        getContactsDetail()
        // Do any additional setup after loading the view.
    }
    func getContactsDetail() 
    {
       
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "CommonDirectAuthori/GetContactus", parameter: [:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
//                    let tempArr =       ((data?.valueForKey("Data") as! NSDictionary).valueForKey("List")) as!  [[String:AnyObject]]
//                    
//                    for dict in tempArr
//                    {
                    
                    let contactObj:ContactModal = ContactModal(fromDictionary: (data?.value(forKey: "Data") as! NSDictionary))
                        self.phoneNoTxt.text = contactObj.phoneNumber
                        self.emailTxt.text = contactObj.email
                        self.addressTxtView.text = contactObj.address
                        
                        
//                    }
                    
                    
                }else
                {
                    //CIError(data?.valueForKey("Status") as! String)
                }
            }
            else
            {
           
                //  CIError("OOPs something went wrong.")
            }
            
        }

    }
    
    @IBAction func emailBtnPress(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            //self.present(mailComposeViewController, animated: true, completion: nil)
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([self.emailTxt.text!])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func PhoneBtnPress(_ sender: AnyObject) {
        print(self.phoneNoTxt.text)
        if let url = NSURL(string: "tel://\(self.phoneNoTxt.text!)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
