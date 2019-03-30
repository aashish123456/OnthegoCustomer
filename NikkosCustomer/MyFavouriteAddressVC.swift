//
//  MyFavouriteAddressVC.swift
//  NikkosCustomer
//
//  Created by Umang on 10/19/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class MyFavouriteAddressVC: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    
      @IBOutlet weak var sideBarButton: UIBarButtonItem!
      @IBOutlet weak var tblView: UITableView!
    var placesArr:NSMutableArray  = NSMutableArray()
     var loginObj:LoginModal!
    @IBOutlet weak var msgLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        self.title = NikkosCustomerManager.GetLocalString(textType: "Locations")
        let revealViewController = self.revealViewController()
        revealViewController?.delegate = self
        if (( revealViewController ) != nil)
        {
            
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer((revealViewController?.panGestureRecognizer())!)
        }
        msgLbl.text = NikkosCustomerManager.GetLocalString(textType: "No_Data")
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 75
        tblView.tableFooterView = UIView()
        self.loginObj = SharedStorage.getUser()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         getFavouriteAddresses()
    }
    
    
    
    // MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if placesArr.count == 0
        {
            msgLbl.isHidden = false
        }else
        {
            msgLbl.isHidden = true
        }
        
        
        return placesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : MyLocationTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MyLocationTableViewCell", for: indexPath) as! MyLocationTableViewCell
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = NikkosCustomerManager.UIColorFromRGB(r: 254, g: 254, b: 255)
        }else
        {
            cell.backgroundColor = NikkosCustomerManager.UIColorFromRGB(r: 248, g: 249, b: 251)
        }
        let addressObj = placesArr.object(at: indexPath.row) as! AddressModal
        
        cell.addressLbl.text = addressObj.address
        
        if addressObj.favoriteName.characters.count>0
        {
           cell.favouriteNameLbl.text = addressObj.favoriteName
        }else
        {
            cell.favouriteNameLbl.text = NikkosCustomerManager.GetLocalString(textType: "Not_Available")
        }
        cell.deleteBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        cell.deleteBtn.passId = addressObj.addressId
        
        return cell
    }
    @objc func pressed(sender: CustomButton!)
    {
        
        let alertController = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType: "Do_you_want_toDelete_favorite_address"), preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Confirm"), style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("Confirm Pressed")
            let parameters: [String: AnyObject] = [
                
                
                "ClientId"      : self.loginObj.id as AnyObject,
                "AddressId"     : sender.passId as AnyObject,
                
                
                ]
            
            
            
            NikkosCustomerManager.showHud()
            WebServiceHelper.webServiceCall(methodname: "Client/DeleteFavoriteAddress", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                NikkosCustomerManager.dissmissHud()
                self.placesArr.removeAllObjects()
                if status == true
                {
                    
                    print(data)
                    
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        
                        self.getFavouriteAddresses()
                        
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
        let cancelAction = UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Cancel"), style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
    
    }

    func getFavouriteAddresses()
    {
        let parameters: [String: AnyObject] = [
            
            
            "ID"      : self.loginObj.id as AnyObject,
            
            
            ]
        
        
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetFavoriteAddress", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.placesArr.removeAllObjects()
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"List")) as!  [[String:AnyObject]]
                    
                    for dict in tempArr
                    {
                        let addressObj:AddressModal = AddressModal(fromDictionary: dict as NSDictionary)
                        self.placesArr.add(addressObj)
                    }
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
