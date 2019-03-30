//
//  SideBarVC.swift
//  NikkosCustomer
//
//  Created by Umang on 6/9/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SWRevealViewControllerDelegate {

    @IBOutlet weak var tblView: UITableView!
    var arrSidebarCellData: NSArray = NSArray()
    var selectedCell:Int!
    @IBOutlet weak var profileImg: AsyncImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    var loginObj:LoginModal!
    var tapGestureRecognizer : UITapGestureRecognizer!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var count : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCell = 0
       // Do any additional setup after loading the view.
        
        let revealController: SWRevealViewController? = revealViewController()
        revealController?.panGestureRecognizer
        revealController?.tapGestureRecognizer()
    }
    
    
    
    
    override func viewWillAppear(_  animated: Bool)
    {
        super.viewWillAppear(true)
        //for plist
        arrSidebarCellData = NSArray(contentsOfFile: Bundle.main.path(forResource: "SideBar", ofType: "plist")!)!
        
        self.profileImg.layer.cornerRadius = 37.5
        self.profileImg.clipsToBounds = true
        
        //
        let loginUser = SharedStorage.getUser()
        nameLbl.text = loginUser.firstName
        emailLbl.text = loginUser.email
        profileImg.imageURL = NSURL(string: NikkosCustomerManager.checkNullString(string: loginUser.profileImage as AnyObject))! as URL
        getNotificationCount()
        
        
        
        self.revealViewController().frontViewController.view.isUserInteractionEnabled =  false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled =  true
    }
    
    
    func getNotificationCount()
    {
         self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] = [
            "ID"      : self.loginObj.id as AnyObject,
            ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetTripNotificationCount", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let dict =   data?.value(forKey: "Data") as! NSDictionary
                    self.count = dict.value(forKey: "NotificationCountTotal") as! Int
                    self.tblView.reloadData()
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
    // MARK: - TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return arrSidebarCellData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SidebarTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath) as! SidebarTableViewCell
       
        if (indexPath.row == selectedCell)
        {
            cell.setUpSideBarCellWithDictionary(dictSideBarCelldata: arrSidebarCellData.object(at: indexPath.row) as! NSDictionary, IfCellSelected: true)
        
        }
        else
        {
            cell.setUpSideBarCellWithDictionary(dictSideBarCelldata: arrSidebarCellData.object(at: indexPath.row) as! NSDictionary, IfCellSelected: false)
        }
        
        if indexPath.row == 2
        {
            cell.btnBadgeCount.isHidden = false
            if count == 0
            {
                cell.btnBadgeCount.isHidden = true
            }else
            {
                cell.btnBadgeCount .setTitle(String(count), for : .normal)
            }
        }else
        {
            cell.btnBadgeCount.isHidden = true
        }
        
        

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell = indexPath.row;
        tblView.reloadData()
        if indexPath.row == arrSidebarCellData.count-1 {
            
            
            let createAccountErrorAlert: UIAlertView = UIAlertView()
            createAccountErrorAlert.delegate = self
            createAccountErrorAlert.title = NikkosCustomerManager.GetLocalString(textType: "AppName")
            createAccountErrorAlert.message = NikkosCustomerManager.GetLocalString(textType: "Are_You_Sure_you_want_to_logout")
            createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType: "Cancel"))
            createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType: "Ok_key"))
            createAccountErrorAlert.show()
            
            
        }
       else if indexPath.row == 0
        {
            NikkosCustomerManager.appDelegate.loadHomeViewController()
        }
        else
        {
            
            
//            if indexPath.row == 1
//            {
            self.performSegue(withIdentifier: (arrSidebarCellData.object(at: indexPath.row) as! NSDictionary).value(forKey: "Segue") as! String, sender: nil)
//            }else
//            {
//                CIError("Coming Soon....")
//            }
        }
    }
    
    func alertView(_ View: UIAlertView, clickedButtonAt buttonIndex: Int){
        //func alertView(View: UIAlertView?, clickedButtonAtIndex: Int){
            
        switch buttonIndex
        {
        case 0:
            break;
        case 1:
            
            
            let parameters: [String: AnyObject] =
                [
                    "UserId"      : self.loginObj.id as AnyObject,
                    "Role"      : 3 as AnyObject,
                    ]
            
            // NikkosCustomerManager.showHud()
            WebServiceHelper.webServiceCall(methodname: "Common/Logout", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                //     NikkosCustomerManager.dissmissHud()
                if status == true
                {
                    
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        SharedStorage.setIsRememberMe(isRememberMe: false)
                        NikkosCustomerManager.appDelegate.loadSignInViewController()
                    
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

            break;
        default:
            break;
            //Some code here..
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
