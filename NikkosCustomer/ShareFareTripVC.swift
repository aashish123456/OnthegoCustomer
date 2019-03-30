//
//  ShareFareTripVC.swift
//  NikkosCustomer
//
//  Created by Umang on 11/3/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class ShareFareTripVC: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource
    {

    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var personTblView: UITableView!
    var loginObj:LoginModal!
    @IBOutlet var shareFareView: ShareFareView!
    @IBOutlet weak var searchTxt: UITextField!
    var personObj:SearchPersonModal!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var noOfPersonLbl: UILabel!
    @IBOutlet weak var individualShareLbl: UILabel!
    var tripId:Int!
    var tripsArr:NSMutableArray  = NSMutableArray()
    var personsArr:NSMutableArray  = NSMutableArray()
    var tripIdForShare : Int!
    @IBOutlet weak var msgLbl: UILabel!
    
    //heading
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosCustomerManager.GetLocalString(textType: "Share_cost")
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
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 335
        tblView.tableFooterView = UIView()
        personTblView.tableFooterView = UIView()
        shareFareView.frame = self.view.frame
        NikkosCustomerManager.getToolBar(target: self, inputView: searchTxt, selecter: #selector(doneWithNumberPad))
        // Do any additional setup after loading the view.
        //NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fresh), name: NSNotification.Name(rawValue: "RequestAcceptShareTrip"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getPersonList), name: NSNotification.Name(rawValue: "AcceptShareTrip"), object: nil)
        //AcceptShareTrip
        msgLbl.text = NikkosCustomerManager.GetLocalString(textType: "No_Data")
    }
    @objc func doneWithNumberPad()
    {
        self.view.endEditing(true)
        if (searchTxt.text?.count)! > 0
        {
        searchPhoneNumber()
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        getShareTrips()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @objc func fresh(notification: NSNotification)
    {
        //PrimaryId
        let dict = notification.object as! NSDictionary
        tripIdForShare  = dict["PrimaryId"] as! Int
        requestForAcceptShareTrip()

    }
   
    func requestForAcceptShareTrip(){
        
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] = [
            "TripId"      : tripIdForShare as AnyObject,
            "ShareHolderClientId" : self.loginObj.id as AnyObject,
            "HasAccept" : true as AnyObject,
            ]
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/AcceptShareTripRequest", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                   // CIError(data?.valueForKey("Status") as! String)
                    self.getShareTrips()
                }else
                {
                   // CIError(data?.valueForKey("Status") as! String)
                }
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Something_went_wrong"))
            }
            
        }

    }
    func getShareTrips()
    {
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] = [
            "ID"      : self.loginObj.id as AnyObject,
            ]
        
        
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/SharedAndCurrentTripList", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            
            NikkosCustomerManager.dissmissHud()
            self.tripsArr.removeAllObjects()
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"List")) as!  [[String:AnyObject]]
                    
                    for dict in tempArr
                    {
                        let addressObj:ShareFareTripModal = ShareFareTripModal(fromDictionary: dict as NSDictionary)
                        self.tripsArr.add(addressObj)
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
    // MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if tableView == tblView
          {
            if tripsArr.count == 0
            {
                msgLbl.isHidden = false
            }else
            {
                msgLbl.isHidden = true
            }
           return tripsArr.count
          }else
          {
            return personsArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == tblView
        {
            let cell : ShareFareTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ShareFareTableViewCell", for: indexPath) as! ShareFareTableViewCell
        
            let tripObj = tripsArr.object(at: indexPath.row) as! ShareFareTripModal
        
        cell.tripIdLbl.text = String(tripObj.tripId)
        cell.bookingTimeLbl.text = tripObj.bookingTime
        cell.travellingTimeLbl.text = tripObj.tripStartOn
        cell.pickUpAddressLbl.text = tripObj.pickupAddress
        cell.dropOffAddressLbl.text = tripObj.dropAddress
        cell.driverNameLbl.text = tripObj.driverName
        cell.companyNameLbl.text = tripObj.companyName
        cell.siretLbl.text = tripObj.siret
        cell.estimateCostLbl.text = String(tripObj.estimatedCost)
        cell.noOfPersonLbl.text =   String(tripObj.passengerCount)
        cell.individualShareLbl.text = String (tripObj.individualShare)
            
        noOfPersonLbl.text = String(tripObj.passengerCount)
        individualShareLbl.text = String (tripObj.individualShare)
       // nameLbl.text = tripObj.driverName
            /*
        if tripObj.hasOnTrip == false
        {
            cell.statusIndicatorView.hidden = true
        }else
        {
            cell.statusIndicatorView.hidden = false
        }
       */
        
        if tripObj.hasOnTrip == true && tripObj.isTripOwner == true
        {
            cell.shareBtn.isHidden = false
        }else
        {
            cell.shareBtn.isHidden = true
        }
        if tripObj.hasOnTrip == true{
            cell.statusIndicatorView.image = UIImage(named: "green_dot")
        }else{
            cell.statusIndicatorView.image = UIImage(named: "to_dot")
        }
            cell.shareBtn.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        cell.shareBtn.passId = tripObj.tripId
        return cell
        }else
        {
            let cell : ShareFarePersonTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ShareFarePersonTableViewCell", for: indexPath) as! ShareFarePersonTableViewCell
            
            let personObj = personsArr.object(at: indexPath.row) as! PersonListModal
            cell.nameLbl.text = personObj.customerName
            cell.phoneNoLbl.text = personObj.phoneNumber
            cell.crossBtn.addTarget(self, action: #selector(pressedCrossed), for: .touchUpInside)
            cell.crossBtn.passId = personObj.clientId
            return cell

        }
    }
    
    func searchPhoneNumber()
    {
        if searchTxt.text != nil{
        let parameters: [String: AnyObject] =
                [
                    "PhoneNumber"      : searchTxt.text! as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
            WebServiceHelper.webServiceCall(methodname: "Client/getClientByPhoneNumber", parameter: parameters as NSDictionary as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.personObj = SearchPersonModal(fromDictionary: data?.value(forKey: "Data") as! NSDictionary)
                    self.nameLbl.text = self.personObj.clientName
                    self.addToList()
                }else
                {
                    self.nameLbl.text = NikkosCustomerManager.GetLocalString(textType: "NoClient_Register_With_This_Number")
                    // CIError("OOPs something went wrong.")
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
                
            }
            
        }
        }
        
    }

    
    
    @objc func pressedCrossed(sender: CustomButton!)
    {
        let parameters: [String: AnyObject] =
                [
                    "TripId"             : tripId as AnyObject,
                    "ShareHolderId"      : sender.passId as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/DeleteSharePerson", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.getPersonList()
                    
                }else
                {
                    
                    // CIError("OOPs something went wrong.")
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
                
            }
            
        }

    }
    
    
    
    
    @objc func pressed(sender: CustomButton!)
    {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.shareFareView.showInView(aView: self.view)
        
        tripId = sender.passId
        getPersonList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addToListBtnPress(sender: UIButton) {
        //self.view.endEditing(true)
       
        searchPhoneNumber()
        
        
    }

    func addToList(){
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
            [
                "TripId"             : tripId as AnyObject,
                "OwnerId"            : self.loginObj.id as AnyObject,
                "ShareHolderId"      : self.personObj.clientId as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/AddSharePerson", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.getPersonList()
                    
                }else
                {
                    
                    // CIError("OOPs something went wrong.")
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
                
            }
            
        }

    }
    @objc func getPersonList()
    {

        let parameters: [String: AnyObject] = [
            
            
            "ID"      : tripId as AnyObject,
            
            
            ]
        
        
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/SharedTripPersonList", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            
            NikkosCustomerManager.dissmissHud()
            self.personsArr.removeAllObjects()
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"List")) as!  [[String:AnyObject]]
                    
                    for dict in tempArr
                    {
                        let addressObj:PersonListModal = PersonListModal(fromDictionary: dict as NSDictionary)
                        self.personsArr.add(addressObj)
                    }
                    self.personTblView.reloadData()
                    
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
    @IBAction func closeBtnPress(sender: UIButton) {
        self.shareFareView.removeAnimate()
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        getShareTrips()
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
