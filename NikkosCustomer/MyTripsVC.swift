//
//  MyTripsVC.swift
//  NikkosCustomer
//
//  Created by Umang on 11/18/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//
//HomeNav
import UIKit

class MyTripsVC: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var tblView: UITableView!
    var loginObj:LoginModal!
    var tripsArr:NSMutableArray  = NSMutableArray()
    @IBOutlet weak var msgLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosCustomerManager.GetLocalString(textType: "My_Trips")
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
        tblView.estimatedRowHeight = 191
        tblView.tableFooterView = UIView()
          self.loginObj = SharedStorage.getUser()
        msgLbl.text = NikkosCustomerManager.GetLocalString(textType: "No_Data")
        
        // Do any additional setup after loading the view.
    }
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition)
    {
        if position == FrontViewPosition.left     // if it not statisfy try this --> if revealController.frontViewPosition == FrontViewPosition.Left
        {
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            self.view.isUserInteractionEnabled=false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      getMyTrips()
      setNotifications()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    
    func setNotifications()
    {
        let parameters: [String: AnyObject] = [
            
            
            "ID"      : self.loginObj.id as AnyObject,
            
            
            ]
        
        
        
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/ResetTripNotificationCount", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
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
    func getMyTrips()
    {
        let parameters: [String: AnyObject] = [
            "ID"      : self.loginObj.id as AnyObject,
            ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/MyAllTypeTrips", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.tripsArr.removeAllObjects()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        let tripObj:MyTripModal = MyTripModal(fromDictionary: dict as NSDictionary)
                        self.tripsArr.add(tripObj)
                    
                    }
                    let triggerTime = (Int64(NSEC_PER_SEC) * 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.tblView.reloadData()
                    }
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
        
        if tripsArr.count == 0
        {
            msgLbl.isHidden = false
        }else
        {
            msgLbl.isHidden = true
        }
      return tripsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyTripTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MyTripTableViewCell", for: indexPath) as! MyTripTableViewCell
        let tripObj = tripsArr.object(at: indexPath.row) as! MyTripModal
        cell.tripIdLbl.text = tripObj.tripRequestId != nil ? String(tripObj.tripRequestId) : ""
        cell.pickUpAddressLbl.text = tripObj.pickupAddress != nil ? tripObj.pickupAddress : ""
        cell.dropOffAddressLbl.text = tripObj.dropAddress != nil ? tripObj.dropAddress : ""
        cell.tripStatusLbl.text = tripObj.tripStatus != nil ? tripObj.tripStatus : ""
        if (cell.tripStatusLbl.text == "Pending For Feedback"){
            cell.tripStatusLbl.textColor = UIColor.red
        }else{
            cell.tripStatusLbl.textColor = UIColor.black
        }
        cell.lblDateTimeBooking.text = tripObj.dateTimeBooking != nil ? tripObj.dateTimeBooking : ""
        cell.lblDateTimeTravelling.text = tripObj.dateTimeTravlling != nil ? tripObj.dateTimeTravlling : ""
        cell.lblCarNumber.text =  tripObj.driverName != nil ? tripObj.driverName : ""
        cell.lblPlateNo.text = tripObj.plateNumber != nil ? tripObj.plateNumber : ""
        if (tripObj.tripStatus == "Canceled" || tripObj.tripStatus == "Completed"){
            cell.lblCost.text = tripObj.tripAmount != nil ? tripObj.tripAmount : "0"
        }else{
            cell.lblCost.text = "-"
        }
        
        cell.btnCancel.isHidden = true
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(MyTripsVC.btnCancelTripPress), for: UIControlEvents.touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tripObj = tripsArr.object(at: indexPath.row) as! MyTripModal
        if tripObj.isLaterScheduled == false{
            //tripObj.isOnGoing == true ||
        if tripObj.isCompleted == false{
            self.performSegue(withIdentifier: "showHomeVC", sender: tripObj)
        }else{
            self.performSegue(withIdentifier: "Preview", sender: tripObj.tripMap)
        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func btnCancelTripPress(_ sender: Any) {
        let btnRow = (sender as AnyObject).tag
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = NikkosCustomerManager.GetLocalString(textType: "AppName")
        createAccountErrorAlert.tag = btnRow!
        createAccountErrorAlert.message = NikkosCustomerManager.GetLocalString(textType: "Are_you_sure_you_want_to_cancel_trips")
        createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType: "Cancel"))
        createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType: "Ok_key"))
        createAccountErrorAlert.show()
    }
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex
        {
        case 0:
            break;
        case 1:
            cancelTrip(id: View.tag)
            break;
        default:
            break;
            //Some code here..
        }
    }
    func cancelTrip(id : Int){
        let tripObj = tripsArr.object(at: id) as! MyTripModal
        let parameters: [String: AnyObject] = [
            "ClientId"      : self.loginObj.id as AnyObject,
            "AdvanceTripId" : tripObj.tripRequestId as AnyObject,
            ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/CancelBookedTrip", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.tripsArr.removeAllObjects()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.getMyTrips()
                }else
                {
                    
                }
            }
            else
            {
                //  CIError("OOPs something went wrong.")
            }
        }

    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        if segue.identifier == "Preview" {
//            let showImg = segue.destination as! ShowMapImgVC
//            showImg.strImgURL = sender as! String
//        }else{
//            let tripObj = sender as! MyTripModal
//            let homeObj = segue.destination as! HomeVC
//            homeObj.navigationType = "FROM TRIP"
//            homeObj.globalTripId = tripObj.tripRequestId
//
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Preview" {
            let showImg = segue.destination as! ShowMapImgVC
            showImg.strImgURL = sender as! String
        }else{
            let tripObj = sender as! MyTripModal
            let homeObj = segue.destination as! HomeVC
            homeObj.navigationType = "FROM TRIP"
            homeObj.globalTripId = tripObj.tripRequestId
            
        }
    }
    

}
