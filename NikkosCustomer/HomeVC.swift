//
//  HomeVC.swift
//  NikkosCustomer
//
//  Created by Umang on 9/14/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import GooglePlaces
import GooglePlacePicker


class HomeVC: UIViewController,SWRevealViewControllerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var mkMapView: MKMapView!
    @IBOutlet weak var pickupTxt: MapTxtField!
    @IBOutlet weak var dropOffTxt: MapTxtField!
    @IBOutlet weak var addressPointer: UIImageView!
    @IBOutlet weak var selectCategoryViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectCategoryViewHeightConstraint: NSLayoutConstraint!
    var vehicleTypeForNearBy : String!
    @IBOutlet weak var selectCategoryTopViewLbl: UILabel!
    @IBOutlet weak var selectCategoryTopView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var nearByDriversArr : NSMutableArray = NSMutableArray()
    var driverCarImg : NSMutableArray = NSMutableArray()
    var carTypeArr : NSMutableArray = NSMutableArray()
    @IBOutlet weak var gpsBottomVConstraint: NSLayoutConstraint!
    @IBOutlet weak var SelectCarCategoryView: UIView!
    @IBOutlet weak var startingView: UIView!
    @IBOutlet weak var addressPointerView: UIView!
    var forFirstTime : Int!
    var forFirstTimeLocationUpdate : Int!
    var selectedCellIndex : Int!
    var selectedReasonCellIndex : Int!
    var pickUpCordinate : CLLocationCoordinate2D!
    var dropOffCordinate : CLLocationCoordinate2D!
    
    @IBOutlet weak var bottomBtn: UIButton!
    @IBOutlet weak var driverImgView: AsyncImageView!
    @IBOutlet var popupView: ReasonView!
    @IBOutlet var ratingView:RatingView!
    @IBOutlet var dateView:DateTimeView!
    @IBOutlet weak var onTripView: UIView!
    @IBOutlet weak var bookNowView: UIView!
    @IBOutlet weak var etaLbl: UILabel!
    @IBOutlet weak var layputCollectionView: UICollectionViewFlowLayout!
    var loginObj:LoginModal!
    var statusObj:CurrentRideStatusModal!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var driverNameLbl: UILabel!
    @IBOutlet weak var driverCarLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var reasonTblView: UITableView!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var ratingValueView: HCSStarRatingView!
    @IBOutlet var lblTripDate: UILabel!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblFinalPrice: UILabel!
    
    var payMentType:String!
    @IBOutlet var cashTypePopUp: CashTypeView!
    @IBOutlet weak var twoPassengerBtn: UIButton!
    @IBOutlet weak var onePassengerBtn: UIButton!
    @IBOutlet weak var numberOfPassengerView: UIView!
    
    
    @IBOutlet weak var driverRatingView: HCSStarRatingView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var requestType:String!
    var navigationType:String!
    @IBOutlet weak var bookForNowBtn: UIButton!
    var globalTripId:Int = -1
    var imgView : AsyncImageView?
    
    var arrAllReasonData : NSMutableArray = NSMutableArray()
    var arrReasonId : NSMutableArray = NSMutableArray()
    var cancelReason : CancelReasonModel!
    var fareEstimate : FareEstimateModel!
    
    @IBOutlet var lblSurge: UILabel!
    @IBOutlet var lblFareAprox: UILabel!
    @IBOutlet var lblEAT: UILabel!
    var minDistance : Double!
    var arrLatMinDistance : NSMutableArray = NSMutableArray()
    var arrLongMinDistance : NSMutableArray = NSMutableArray()
    var arrDistance : NSMutableArray = NSMutableArray()
    var miniLat : Double!
    var miniLong : Double!
    var isCarAvailable : Bool = false
    
    @IBOutlet var btnLocationUpdate: UIButton!
    @IBOutlet var btnActivity: ActivityButton!
    @IBOutlet weak var btnCancelRide: UIButton!
    
    @IBOutlet weak var SearchingLbl: UILabel!
    @IBOutlet var lblNowLate: UILabel!
    var locationManager = CLLocationManager()
    
    
    @IBOutlet var lblBookFor: UILabel!
    @IBOutlet var lblNumberOfPassengerHeading: UILabel!
    @IBOutlet var lblSurgeHeading: UILabel!
    @IBOutlet var lblMinFareHeading: UILabel!
    @IBOutlet var lblETAHeading: UILabel!
    //popup
    @IBOutlet var btnCancelTripH: UIButton!
    @IBOutlet var lblReasonsForCancellationTripH: UILabel!
    @IBOutlet var btnDonePopup: UIButton!
    //rating
    @IBOutlet var lblThanksForRidingWithUs: UILabel!
    @IBOutlet var lblFinalPriceH: UILabel!
    @IBOutlet var lblDriverNameH: UILabel!
    @IBOutlet var lblTripDateH: UILabel!
    @IBOutlet var lblRateTheDriver: UILabel!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var btnSaveRating: UIButton!
    //cash
    @IBOutlet var lblIWouldLikeToPay: UILabel!
    //date
    @IBOutlet var lblSeletDateTime: UILabel!
    @IBOutlet var btnCancelDate: UIButton!
    @IBOutlet var btnDoneCancel: UIButton!
    
    @IBOutlet var btnCard: UIButton!
    @IBOutlet var btnConfirmAccess: UIButton!
    
    @IBOutlet var btnCash: UIButton!
    var isFromRequest : Bool = false
    
    var carAnn:DriverAnnonation!
    var driverLocationTimer: Timer!

    
    var cordinateOfAddress :CLLocationCoordinate2D!
    var addressNameString : String!
    var locationType = "PickUp"
    var notificationName = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        
        vehicleTypeForNearBy = "0"
        selectedCellIndex = -1
        selectedReasonCellIndex = 0
        forFirstTimeLocationUpdate = 0
        popupView.frame = self.view.frame
        cashTypePopUp.frame = self.view.frame
        ratingView.frame = self.view.frame
        dateView.frame = self.view.frame
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        let revealViewController = self.revealViewController()
        revealViewController?.delegate = self
        forFirstTime = 1
        if (( revealViewController ) != nil)
        {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        
        self.title = NikkosCustomerManager.GetLocalString(textType: "Home")
        
        
        pickupTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Pick_Up_Location")
        dropOffTxt.placeholder =  NikkosCustomerManager.GetLocalString(textType: "Drop_Off_Location")
        
        pickupTxt.setLeftImage(imageName: "to_search_icon")
        dropOffTxt.setLeftImage(imageName: "to_search_icon")
        
        mkMapView.delegate = self
        mkMapView.userLocation.addObserver(self, forKeyPath: "location", options: NSKeyValueObservingOptions.old, context: nil)
        
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(("handleTap:")))
        tap.delegate = self
        driverImgView.layer.cornerRadius = 30.0
        driverImgView.clipsToBounds = true
        addressPointer.isHidden = true
        if navigationType != "FROM TRIP"
        {
            self.resetPage()
        }else
        {
            self.navigationItem.rightBarButtonItem = nil
            let backButton = UIBarButtonItem(image: UIImage(named: "back_arrow")!, style: .plain, target: self, action: #selector(self.backPressed))
            backButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem! = backButton
            getCurrentStatus()
        }
        commentView.layer.borderWidth = 1.0
        commentView.layer.borderColor = UIColor.black.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        datePicker.backgroundColor = UIColor.white
        datePicker.layer.cornerRadius = 5.0
        datePicker.layer.shadowOpacity = 0.5
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = NSDate(timeInterval: 60 * 60, since: NSDate() as Date) as Date
        
        //NSDate()
        if navigationType != "FROM TRIP"
        {
            isAvailableForNextRide()
        }
        
        if notificationName == ""{
            print("pulkit")
        }
        // Do any additional setup after loading the view.
        //self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //for update location 
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        let locManager : AnyObject = PCLocationManager.sharedLocationManager() as AnyObject
        if (locManager.isAlreadyUpdatingLocation == false) {
            
            let alert = UIAlertController(title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                let url = URL(string: UIApplicationOpenSettingsURLString)!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        lblSurgeHeading.text =  NikkosCustomerManager.GetLocalString(textType: "Surge")
        lblMinFareHeading.text =  NikkosCustomerManager.GetLocalString(textType: "Min_Fare")
        lblETAHeading.text =  NikkosCustomerManager.GetLocalString(textType: "ETA")
        lblReasonsForCancellationTripH.text =  NikkosCustomerManager.GetLocalString(textType: "Reason_Cancellation")
        lblThanksForRidingWithUs.text =  NikkosCustomerManager.GetLocalString(textType: "Thanks_Riding")
        lblFinalPriceH.text =  NikkosCustomerManager.GetLocalString(textType: "Final_Price")
        lblDriverNameH.text =  NikkosCustomerManager.GetLocalString(textType: "Driver_Name")
        lblTripDateH.text =  NikkosCustomerManager.GetLocalString(textType: "Trip_Date")
        lblRateTheDriver.text =  NikkosCustomerManager.GetLocalString(textType: "Rate_Driver")
        lblComment.text =  NikkosCustomerManager.GetLocalString(textType: "Comment")
        lblIWouldLikeToPay.text =  NikkosCustomerManager.GetLocalString(textType: "I_Would_Like_To_Pay")
        lblSeletDateTime.text =  NikkosCustomerManager.GetLocalString(textType: "Selete_DateTime")
        bookForNowBtn.setTitle("BOOK NOW",for: .normal)
        btnCancelDate.setTitle(NikkosCustomerManager.GetLocalString(textType: "Cancel_Date"),for: .normal)
        btnDoneCancel.setTitle(NikkosCustomerManager.GetLocalString(textType: "Done"),for: .normal)
        btnSaveRating.setTitle(NikkosCustomerManager.GetLocalString(textType: "Save_Rating"),for: .normal)
        btnDonePopup.setTitle(NikkosCustomerManager.GetLocalString(textType: "Done"),for: .normal)
        btnCancelTripH.setTitle(NikkosCustomerManager.GetLocalString(textType: "Cancel_Trip"),for: .normal)
        btnCancelRide.setTitle(NikkosCustomerManager.GetLocalString(textType: "Cancel_Request"), for: UIControlState.normal)
        //NikkosCustomerManager.getToolBarForTextView(target: self, inputView: commentView, selecter: #selector(doneWithNumberPad))
        
        
        /*let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(resetTapped))
        bar.items = [reset]
        bar.sizeToFit()
        commentView.inputAccessoryView = bar*/
        
        
        let locMan = PCLocationManager.sharedLocationManager()
        pickUpCordinate =  (locMan as AnyObject).myLocation1
        self.setRegion()
        
        

        
        cancelBtn.setImage(UIImage(named: "cancel_ride_btn"), for: .normal)
        btnCash.setImage(UIImage(named: "cash_btn"),for: .normal)
        self.startUpdatingLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // your code here
            self.getCurrentLocaiton()
        }
    }
    @objc func resetTapped()
    {
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.view.backgroundColor = UIColor.white
        btnActivity.isHidden = true
        SearchingLbl.isHidden = true
        btnCancelRide.isHidden = true
        self.view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fresh), name: NSNotification.Name(rawValue: "bookingRequest"), object: nil)

        //self.startUpdatingLocation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "bookingRequest"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(true)
        driverLocationTimer = nil
        driverLocationTimer?.invalidate()
        
    }
    
    
    
    @objc func fresh(_ notification: NSNotification)
    {
        let dict = notification.object as! NSDictionary
        //        tripId  = String(dict["PrimaryId"] as! Int)
        //        let tripID = Int(tripId)
        //        SharedStorage.setTripId(tripID!)
        var type = dict["MsgType"] as! String
        print(type)
        print(appDelegate.checkControllerTime)
//        if appDelegate.checkControllerTime == type{
//            return
//        }
//        else{
//            appDelegate.checkControllerTime = type
//        }
        
        if type == "BooNowRequestReply"{
            
            let aps = dict["aps"] as! NSDictionary
            self.hideActivity()
            NikkosCustomerManager.dissmissHud()
            CIError(aps["alert"] as! String)
            
            /*let aps = dict["aps"] as! NSDictionary
            if aps["alert"] as! String == "Driver not available, please try again later"
            {
                self.hideActivity()
                NikkosCustomerManager.dissmissHud()
                CIError(aps["alert"] as! String)
            }else
            {
            }*/
            
        }else if type == "OpenRide"{
            let aps = dict["aps"] as! NSDictionary
            CIError(aps["alert"] as! String)
        }
        else if type == "BookingAccept"{
           /* let reveal = appDelegate.window?.rootViewController as! SWRevealViewController
            let rootController:MyTripsVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTripsVC") as! MyTripsVC
            (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)*/
            
                globalTripId = dict.value(forKey: "PrimaryId") as! Int
                self.resetPage()
                self.hideActivity()
                getCurrentStatus()
            
        }
        else if type == "CancelRide"{
            if globalTripId == dict.value(forKey: "PrimaryId") as! Int
            {
                //        getCurrentStatus()
                CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_canceled_bydriver"))
                
                if self.navigationType == "FROM TRIP"
                {
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.resetPage()
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                }
            }
        }
            
        else if type == "driverArrived"{
            
            CIError(NikkosCustomerManager.GetLocalString(textType: "Driver_has_arrived"))
            
            if globalTripId == dict.value(forKey: "PrimaryId") as! Int
            {
                // CIError("Driver has arrived. Please contact with him.")
            }
        }
        else if type == "StartRide"{
            CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_has_started"))
            if globalTripId == dict.value(forKey: "PrimaryId") as! Int
            {
                getCurrentStatus()
            }
        }
        else if type == "EndRide"{
            driverLocationTimer = nil
            driverLocationTimer?.invalidate()
            
            CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_has_ended"))
            
            if globalTripId == dict.value(forKey: "PrimaryId") as! Int
            {
                getCurrentStatus()
            }
        }
        else if type == "locationUpdate"{
            if forFirstTimeLocationUpdate == 0
            {
                forFirstTimeLocationUpdate = 1
                let locMan = PCLocationManager.sharedLocationManager()
                let center =  (locMan as AnyObject).myLocation1//mkMapView.userLocation.coordinate
                let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mkMapView.setRegion(region, animated: true)
            }
        }
        
    }
    @IBAction func backPressed(_ sender : AnyObject)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func isAvailableForNextRide()
    {
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
                [
                    "ID"      : self.loginObj.id as AnyObject,
                    "DeviceToken" : SharedStorage.getDeviceToken() as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/NextRideForNowOrLater", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            
            
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let nextCheckObj:NextRideModal  =       NextRideModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    if nextCheckObj.bookNow == true
                    {
                        self.bookForNowBtn.isUserInteractionEnabled = true
                        //self.rightBarButton.isEnabled = true
                        self.bookForNowBtn.alpha = 1.0
                    }else
                    {
                       /* self.bookForNowBtn.isUserInteractionEnabled = false
                        self.bookForNowBtn.alpha = 0.5
                        //self.rightBarButton.isEnabled = false
                        CIError(nextCheckObj.bookingMsg)
                        if nextCheckObj.error == 1{
                            let reveal = self.appDelegate.window?.rootViewController as! SWRevealViewController
                            let rootController:MyTripsVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTripsVC") as! MyTripsVC
                            (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                        }*/
                        if nextCheckObj.error == 1{
                            let reveal = self.appDelegate.window?.rootViewController as! SWRevealViewController
                            let rootController:MyTripsVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTripsVC") as! MyTripsVC
                            (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                        }else{
                            self.globalTripId = nextCheckObj.tripId
                            self.resetPage()
                            self.hideActivity()
                            self.getCurrentStatus()
                        }
                        
                        
                    }
                    if nextCheckObj.lookingDriver == true{
                        NikkosCustomerManager.showHud()
                    }
                }else
                {
                    // CIError("OOPs something went wrong.")
                    SharedStorage.setIsRememberMe(isRememberMe: false)
                    NikkosCustomerManager.appDelegate.loadSignInViewController()
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
                SharedStorage.setIsRememberMe(isRememberMe: false)
                NikkosCustomerManager.appDelegate.loadSignInViewController()
                
            }
            
        }
        
    }
    
    
    func startUpdatingLocation(){
        let locManager = PCLocationManager.sharedLocationManager()
        (locManager as AnyObject).startUpdateingLocation()
    }
    
    
    func locationUpdate(notification: NSNotification)
    {
        if forFirstTimeLocationUpdate == 0
        {
            forFirstTimeLocationUpdate = 1
            let locMan = PCLocationManager.sharedLocationManager()
            let center =  (locMan as AnyObject).myLocation1//mkMapView.userLocation.coordinate
            let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mkMapView.setRegion(region, animated: true)
        }
    }
    func endRide(notification: NSNotification)
    {
        driverLocationTimer = nil
        driverLocationTimer?.invalidate()
        //print("test")
        CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_has_ended"))
        let dict = notification.object as! NSDictionary
        if globalTripId == dict.value(forKey: "PrimaryId") as! Int
        {
            getCurrentStatus()
        }
    }
    func startRide(notification: NSNotification)
    {
        //print("test")
        CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_has_started"))
        let dict = notification.object as! NSDictionary
        if globalTripId == dict.value(forKey: "PrimaryId") as! Int
        {
            getCurrentStatus()
        }
    }
    func driverArrived(notification: NSNotification)
    {
            //print("test")
        CIError(NikkosCustomerManager.GetLocalString(textType: "Driver_has_arrived"))
        let dict = notification.object as! NSDictionary
        if globalTripId == dict.value(forKey: "PrimaryId") as! Int
        {
            // CIError("Driver has arrived. Please contact with him.")
        }
    }
    @IBAction func favRideBtnPress(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
    }
    func getCurrentStatus()
    {
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
                [
                    "ClientId"      : self.loginObj.id as AnyObject,
                    "TripRequestId" : self.globalTripId as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/ClientCurrentStatusDetail", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.statusObj  = CurrentRideStatusModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    
                    if self.statusObj.isOnTrip == true
                    {
                        //self.statusObj.driverImage
                        
                        if  (self.statusObj.driverImage != nil)
                        {
                            self.driverImgView.imageURL = NSURL(string: NikkosCustomerManager.checkNullString(string: self.statusObj.driverImage as AnyObject))! as URL
                        }
                        if  (self.statusObj.driverRating != nil)
                        {
                            self.driverRatingView.value = CGFloat(self.statusObj.driverRating)
                        }
                        if  (self.statusObj.driverName != nil)
                        {
                            self.driverNameLbl.text = self.statusObj.driverName
                        }
                        if  (self.statusObj.vehicleName != nil) && (self.statusObj.plateNumber != nil)
                        {
                            self.driverCarLbl.text = self.statusObj.vehicleName + " " + self.statusObj.plateNumber
                        }
                        if self.statusObj.isTripStart == true
                        {
                            self.cancelBtn.isHidden = true
                            self.cancelBtn.isUserInteractionEnabled = false
                            self.cancelBtn.alpha = 0.5
                        }else
                        {
                            self.cancelBtn.isHidden = false
                            self.cancelBtn.isUserInteractionEnabled = true
                            self.cancelBtn.alpha = 1.0
                        }
                        //self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.showOngoingTripView()
                    }else if self.statusObj.hasClientRating == true
                    {
                        self.resetPage()
                        self.dropOffTxt.text = ""
                    }else
                    {
                        // rating submitting screen
                        print("At rating screen")
                        self.navigationItem.leftBarButtonItem?.isEnabled = false
                        //self.navigationItem.rightBarButtonItem?.isEnabled = false
                        self.ratingView.showInView(aView: self.view)
                        self.lblDriverName.text = self.statusObj.driverName
                        self.lblTripDate.text = self.statusObj.tripDate
                        //let price : AnyObject? = self.statusObj.tripAmount as AnyObject
                        self.lblFinalPrice.text = self.statusObj.tripAmount
                       // self.dropOffTxt.text = ""
                    }
                    
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
    
    @IBAction func swipeButtonPress(_ sender: Any)
    {
        if pickupTxt.text != NikkosCustomerManager.GetLocalString(textType: "Getting_address")
        {
            if (pickupTxt.text?.count)! > 0 && (dropOffTxt.text?.count)! > 0
            {
                self.resetPage()
                var temp : CLLocationCoordinate2D!
                var tempStr: String!
                temp = pickUpCordinate
                pickUpCordinate = dropOffCordinate
                dropOffCordinate = temp
                tempStr =  pickupTxt.text
                pickupTxt.text = dropOffTxt.text
                dropOffTxt.text = tempStr
                self.setRegion()
            }
        }
    }
    
    func bookingCanceled(notification: NSNotification)
    {
        // CIError("Ride canceled by driver")
        let dict = notification.object as! NSDictionary
        if globalTripId == dict.value(forKey: "PrimaryId") as! Int
        {
            //getCurrentStatus()
            CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_canceled_bydriver"))
            if self.navigationType == "FROM TRIP"
            {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.resetPage()
                self.navigationItem.leftBarButtonItem?.isEnabled = true
            }
        }
    }
    func bookingRequestAccept(notification: NSNotification)
    {
        let reveal = appDelegate.window?.rootViewController as! SWRevealViewController
        let rootController:MyTripsVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyTripsVC") as! MyTripsVC
        (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
    }
    func bookingRequestResponse(notification: NSNotification)
    {
        let dict = notification.object as! NSDictionary
        let aps = dict["aps"] as! NSDictionary
        if aps["alert"] as! String == "Driver not available, please try again later."
        {
            self.hideActivity()
            NikkosCustomerManager.dissmissHud()
            CIError(aps["alert"] as! String)
        }else
        {
        }
    }
    func showOngoingTripView()
    {
        let alloverlays = self.mkMapView.overlays
        self.mkMapView.removeOverlays(alloverlays)
        NikkosCustomerManager.dissmissHud()
        locationView.isHidden = true
        onTripView.isHidden = false
        startingView.isHidden = true
        self.SelectCarCategoryView.isHidden = true
        let allAnnotations = self.mkMapView.annotations
        self.mkMapView.removeAnnotations(allAnnotations)
        addressPointer.isHidden = true
        etaLbl.isHidden = true
        let pickUpDistanceLocation = CLLocationCoordinate2D(latitude:  Double(self.statusObj.pickupLatitude), longitude: Double(self.statusObj.pickupLongitude))
        let dropOffDistanceLocation = CLLocationCoordinate2D(latitude: Double(self.statusObj.dropLatitude), longitude: Double(self.statusObj.dropLongitude))
        addRoutesOverLayForMapView(pickUpDistanceLocation: pickUpDistanceLocation, dropOffDistanceLocation: dropOffDistanceLocation)
        let annPickUp = DriverAnnonation(coordinate: pickUpDistanceLocation, title: "PickUp",course:"",subtitle: "", descriptionForUrl: "")
        let annDropUp = DriverAnnonation(coordinate: dropOffDistanceLocation, title: "DropOff",course:"",subtitle: "", descriptionForUrl: "")
        annPickUp.title = NikkosCustomerManager.GetLocalString(textType: "PickUp")
        annDropUp.title = NikkosCustomerManager.GetLocalString(textType: "DropOff")
        forFirstTime = -1
        carAnn = DriverAnnonation(coordinate: pickUpDistanceLocation, title: "",course:"",subtitle: "", descriptionForUrl:self.statusObj.VehicleIcon)
        self.mkMapView.removeAnnotations(allAnnotations)
        self.mkMapView.addAnnotation(annPickUp)
        self.mkMapView.addAnnotation(annDropUp)
        self.mkMapView.addAnnotation(carAnn)
        driverLocationTimer = nil
        driverLocationTimer?.invalidate()
        driverLocationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.driverLocation), userInfo: nil, repeats: true)
        let region = MKCoordinateRegion(center: pickUpDistanceLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mkMapView.setRegion(region, animated: true)
    }
    
    @objc func driverLocation()
    {
        let parameters: [String: String] = [
            "ID"         : String(self.statusObj.driverId),
            ]
        // appDelegate.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/getDriverLocation", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            //  self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let driverModalObj  = DriverLocationModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    let driverNewLocation = CLLocationCoordinate2D(latitude:  Double(driverModalObj.latitude), longitude: Double(driverModalObj.longitude))
                    self.mkMapView.removeAnnotation(self.carAnn)
                    self.carAnn = DriverAnnonation(coordinate: driverNewLocation, title: "",course:driverModalObj.course,subtitle: "", descriptionForUrl:self.statusObj.VehicleIcon)
                    self.mkMapView.addAnnotation(self.carAnn)
                    let region = MKCoordinateRegion(center: driverNewLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    self.mkMapView.setRegion(region, animated: true)
                    
                }else
                {
                    
                }
            }
            else
            {
                
            }
            
        }
        
    }
    
    func addRoutesOverLayForMapView(pickUpDistanceLocation: CLLocationCoordinate2D, dropOffDistanceLocation:CLLocationCoordinate2D )
    {
        
        var source:MKMapItem?
        var destination:MKMapItem?
        
        if dropOffDistanceLocation.latitude != -1.0
        {
            let sourcePlacemark = MKPlacemark(coordinate: pickUpDistanceLocation, addressDictionary: nil)
            source = MKMapItem(placemark: sourcePlacemark)
            let desitnationPlacemark = MKPlacemark(coordinate: dropOffDistanceLocation, addressDictionary: nil)
            destination = MKMapItem(placemark: desitnationPlacemark)
            let request:MKDirectionsRequest = MKDirectionsRequest()
            request.source = source
            request.destination = destination
            request.transportType = MKDirectionsTransportType.automobile
            /*let directions = MKDirections(request: request)
            directions.calculate (completionHandler: {
                (response: MKDirectionsResponse?, error: NSError?) in
                            if error == nil
                            {
                                self.showRoute(response: response!)
                            }
                            else
                            {
                                print("trace the error \(String(describing: error?.localizedDescription))")
                            }
                } as! MKDirectionsHandler )*/
            // Calculate the direction
            let directions = MKDirections(request: request)
            
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        return
                    }
                    //self.showRoute(response: response)
                    let route = response.routes[0]
                    self.mkMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    self.mkMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
    }
    
    func showRoute(response:MKDirectionsResponse)
    {
        for route in response.routes
        {
            mkMapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            let routeSeconds = route.expectedTravelTime
            let routeDistance = route.distance
            print("distance between two points is \(routeSeconds) and \(routeDistance)")
        }
    }
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.resetPage()
    }
    @IBAction func locationArrBtnPress(_ sender: UIButton)
    {
        self.getCurrentLocaiton()
    }
    func getCurrentLocaiton(){
        forFirstTime = 1
        let locMan = PCLocationManager.sharedLocationManager()
        let center =  (locMan as AnyObject).myLocation1
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mkMapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        pickupTxt.text = NikkosCustomerManager.GetLocalString(textType: "Getting_address")
    }
    func mapView(_  mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        print("zoom in zoom out")
        if addressPointer.isHidden == false
        {
            let pt = CGPoint(x: addressPointerView.frame.origin.x+addressPointerView.frame.width/2, y: addressPointerView.frame.origin.y+addressPointerView.frame.height)
            print("zoom in zoom out1")
            let latLong = mkMapView.convert(pt, toCoordinateFrom: mkMapView)
            print("zoom in zoom out2")
            self.getAddress(cordinate: latLong)
            if miniLat != nil{
                let coordinate₀ = CLLocation(latitude: miniLat, longitude: miniLong)
                let coordinate₁ = CLLocation(latitude: latLong.latitude, longitude: latLong.longitude)
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                let distanceInKm = distanceInMeters / 100.0
                let distanceInMin = distanceInKm * 0.621371
                if distanceInMin > 60 || isCarAvailable == false{
                    self.etaLbl.text = "NA"
                }else{
                    let min  = Int(distanceInMin)
                    self.etaLbl.text = String(min) + "Min"
                }
            }
            
        }
        
    }
    
    func getAddress(cordinate :CLLocationCoordinate2D)
    {
        self.getAddressFromLatLon(pdblLatitude: String(cordinate.latitude), withLongitude: String(cordinate.longitude), isFromGMS: false)
        self.pickUpCordinate = cordinate
        /*
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = "AIzaSyBfzpJF8M9fybtVSoE_zhiJuAD8kLnVlsw"
        let url = NSURL(string: "\(baseUrl)latlng=\(cordinate.latitude),\(cordinate.longitude)&key=\(apikey)")
        print(url!)
        let data = NSData(contentsOf: url! as URL)
        //print(data)
        if data != nil{
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            
            if let result  = json["results"] as? [NSDictionary] {
                print(result)
                if result.count > 0 {
                    if let address  = result[0]["address_components"] as? [NSDictionary] {
                        
                        let number = address.count >= 1 ? address[0]["short_name"] as! String : ""
                        let street = address.count >= 2 ? address[1]["short_name"] as! String : ""
                        let city   = address.count >= 3 ? address[2]["short_name"] as! String : ""
                        let state  = address.count >= 5 ? address[4]["short_name"] as! String : ""
                        let country  = address.count >= 9 ? address[8]["long_name"] as! String : ""
                        self.pickUpCordinate = cordinate
                        self.pickupTxt.text = String("\n\(number) \(street), \(city), \(state), \(country)")
                        self.getNearByDrivers(vehicleType: self.vehicleTypeForNearBy)
                    }
                    
                }
                
            }
        }*/
        
    }
    
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String, isFromGMS : Bool) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality as Any)
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.postalCode as Any)
                    print(pm.subThoroughfare as Any)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                    print(addressString)
                    if isFromGMS
                    {
                        self.addressNameString = addressString
                    }else{
                        self.pickupTxt.text = addressString
                        self.getNearByDrivers(vehicleType: self.vehicleTypeForNearBy)
                    }
                    
                    
                    
                }
        })
        
    }
    
   /*
    func getAddressFromLatLong(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        var addressString : String = ""
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country as Any)
                    print(pm.locality as Any)
                    print(pm.subLocality as Any)
                    print(pm.thoroughfare as Any)
                    print(pm.postalCode as Any)
                    print(pm.subThoroughfare as Any)
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                    
                    
                    print(addressString)
                    self.addressNameString = addressString
                }
        })
        
        
    }*/
    

    
    
    
    func getNearByDrivers(vehicleType:String)
    {
        let parameters: [String: String] = [
            
            "Latitude"         : String(pickUpCordinate.latitude),//String(locMngr.myLocation.latitude),
            "Longitude"        : String(pickUpCordinate.longitude),
            "VehicleType"      : vehicleType,
            "PassengerCount"   : "0",//String(locMngr.myLocation.longitude),
        ]
        
        // appDelegate.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/GetNearByDrivers", parameter: parameters as NSDictionary as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            //  self.appDelegate.dissmissHud()
            self.nearByDriversArr.removeAllObjects()
            let allAnnotations = self.mkMapView.annotations
            self.mkMapView.removeAnnotations(allAnnotations)
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrLatMinDistance.removeAllObjects()
                    self.arrLongMinDistance.removeAllObjects()
                    self.arrDistance.removeAllObjects()
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [NSDictionary]
                    for dict in tempArr
                    {
                        let driverObj:NearByDriverModal = NearByDriverModal(fromDictionary: dict as NSDictionary)
                        self.nearByDriversArr.add(driverObj)
                        self.arrLatMinDistance.add(driverObj.latitude)
                        self.arrLongMinDistance.add(driverObj.longitude)
                        self.arrDistance.add(driverObj.distance)
                    }
                    if self.nearByDriversArr.count > 0 {
                        self.isCarAvailable = true
                    }else{
                        self.isCarAvailable = false
                    }
                    self.showAnnonationsForNearDrivers()
                }else
                {
                    //CIError(data?.valueForKey("Status") as! String)
                    self.isCarAvailable = false
                }
            }
            else
            {
                //  CIError("OOPs something went wrong.")
                 self.isCarAvailable = false
            }
            
        }
        
    }
    func showAnnonationsForNearDrivers()
    {
        
        let allAnnotations = self.mkMapView.annotations
        self.mkMapView.removeAnnotations(allAnnotations)
        var driverObj : NearByDriverModal
        var myArr :[Double] = []

        for dict in self.nearByDriversArr
        {
            driverObj =  dict as! NearByDriverModal
            print(driverObj.latitude)
           // let minDistance  = driverObj.distance
            
           
            var coordinate = CLLocationCoordinate2D()
                if let latitude = driverObj.latitude, let longitude = driverObj.longitude{
                    coordinate.latitude = latitude
                    coordinate.longitude = longitude
                    let ann = DriverAnnonation(coordinate: coordinate, title: driverObj.vehicleType, course: driverObj.course, subtitle:"" , descriptionForUrl :driverObj.vehicleImage)
                    mkMapView.addAnnotation(ann)
                    myArr.append(driverObj.distance)
                }
            
        }
        if (myArr.count>0){
            minDistance = myArr.min()
            print(minDistance)
            let index = self.arrDistance.index(of: minDistance)
            miniLat = self.arrLatMinDistance .object(at: index) as! Double
            miniLong = self.arrLongMinDistance .object(at: index) as! Double
            print(miniLat,miniLong)
        }
        
        
    }
    
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "MKAnnotationView"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView!.canShowCallout = true
        
        
        
        let annonation1 = annotation as! DriverAnnonation
        if annonation1.course.count > 0
        {
            if (annonation1.course as NSString).doubleValue > 0.0
            {
                pinView?.transform = CGAffineTransform(rotationAngle: CGFloat( M_PI * (Double(annonation1.course))! / 180.0));
            }
        }

        
        
        print("------>>>>>>>>>>>123123")
        //download imageurl
        let img = ((annonation1.descriptionForUrl)! as String?)!
       // let img =  String(annotation.subtitle)
        print("------>>>>>>>>>>>")
        print(img)
        if img != ""{
            if String(img) != nil{
                let imgURL = NSURL(string: img.replacingOccurrences(of: "_", with: "", options: .literal, range: nil))
                let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
                NSURLConnection.sendAsynchronousRequest(
                    request as URLRequest, queue: OperationQueue.main,
                    
                    //completionHandler: {(response: URLResponse?,data: NSData?,error: NSError?) -> Void in
                    completionHandler: { (responseData, response, error) -> Void in
                        if error == nil {
                            // self.image_element.image = UIImage(data: data)
                           // pinView!.image = UIImage(data: data!)
                           
                            // Resize image
                            let pinImage =  UIImage(data: response!)
                            let size = CGSize(width: 26, height: 45)
                            UIGraphicsBeginImageContext(size)
                            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            pinView!.image = resizedImage
                            pinView!.contentMode = UIViewContentMode.scaleAspectFit
                        }
                })
                
            }
        }else{
            
            if annonation1.title == "PickUp"
            {
                pinView!.image = UIImage(named: "To_Pin-1")
            }
            else if annonation1.title == "DropOff"
            {
                pinView!.image = UIImage(named: "from-1")
            }
            else
            {
                pinView!.image = UIImage(named: "")
            }
        }
        
        return pinView
        
    }
    //show route on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
       
        let locMan = PCLocationManager.sharedLocationManager()
        let center = (locMan as AnyObject).myLocation1//mkMapView.userLocation.coordinate
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        if forFirstTime > 0
        {
            self.mkMapView.setRegion(region, animated: true)
        }
        
        
    }
    
    deinit {
        do {
            if((mkMapView) != nil){
              mkMapView.userLocation.removeObserver(self, forKeyPath: "location")
            }
        } catch let anException {
            print(anException)
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
        if((mkMapView) != nil){
            mkMapView.removeFromSuperview()
        }
        // release crashes app
        
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func submitRatingBtnPress(_ sender: Any)
    {
        let rating = "\(ratingValueView.value)"
        print(rating)
        if rating != "-1.0" && rating  != "-0.0"{
            let parameters: [String: AnyObject] =
                
                [
                    "TripRequestId"         : statusObj.tripRequestId as AnyObject,
                    "Feedback"              :  ((commentView.text?.count)!>0 ? commentView.text : "")! as AnyObject,
                    "Rating"                : ratingValueView.value as AnyObject,
                    ]
            print(parameters)
            NikkosCustomerManager.showHud()
            WebServiceHelper.webServiceCall(methodname: "Client/PostRatingAndFeedback", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                NikkosCustomerManager.dissmissHud()
                
                if status == true
                {
                    
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        self.ratingView.removeAnimate()
                        self.dropOffTxt.text = ""
                        self.appDelegate.checkControllerTime = "end"
                        if self.navigationType == "FROM TRIP"
                        {
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            
                            self.resetPage()
                            self.navigationItem.leftBarButtonItem?.isEnabled = true
                        }
                        
                        
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
        }else{
            CIError("Please give rating first.")
        }
        
    }
    @IBAction func suggestionBtnPress(_ sender: UIButton)
    {
        if (sender.tag == 1){
            locationType = "PickUp"
        }else{
            locationType = "DropOff"
        }
        isFromRequest = true
        self.resetPage()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    func getAddressFromAddressSuggestion(){
        if locationType == "PickUp"
        {
            pickupTxt.text = addressNameString
            pickUpCordinate = cordinateOfAddress
            
        }else
        {
            dropOffTxt.text = addressNameString
            dropOffCordinate = cordinateOfAddress
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSuggestions"
        {
            self.resetPage()
            let objController =  segue.destination as! AddressSuggestionVC
            let type = sender as! Int
            if type == 1
            {
                objController.locationType = "Pick"
            }else if type == 2
            {
                objController.locationType = "Drop"
            }
        }
    }
    @IBAction func unwindFromSplitToHome(_ segue: UIStoryboardSegue)
    {
        print(segue.source)
        forFirstTime = -1
        setRegion()
        
    }
    func setRegion()  {
        let center = pickUpCordinate
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mkMapView.setRegion(region, animated: true)
    }
    
    @IBAction func bookForNowBtnPress(_ sender: Any)
    {
        self.lblEAT.text = ""
        self.lblFareAprox.text = ""
        self.lblSurge.text = ""
        self.commentView.text = ""
        if ValidateBookingTripEntries() == false {
            return
        }
        //for get fare estimate
        getFareEstimate()
        requestType = "NOW"
        mkMapView.isUserInteractionEnabled = false
    }
    func ValidateBookingTripEntries() -> Bool
    {
        if NikkosCustomerManager.trimString(string: (pickupTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Enter_Pickup_Location"))
            return false
            
        }else if NikkosCustomerManager.trimString(string: (pickupTxt?.text)!) == NikkosCustomerManager.GetLocalString(textType: "Getting_address")
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Enter_Pickup_Location"))
            return false
            
        }
        else if NikkosCustomerManager.trimString(string: (dropOffTxt?.text)!).isEmpty == true
        {
            CIError(NikkosCustomerManager.GetLocalString(textType: "Enter_dropoff_Location"))
            return false
            
        }
        else{
            return true
        }
        
    }
    
    
    
//    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition)
//    {
//        if position == FrontViewPosition.left     // if it not statisfy try this --> if revealController.frontViewPosition == FrontViewPosition.Left
//        {
//            self.view.isUserInteractionEnabled = true
//        }
//        else
//        {
//            self.view.isUserInteractionEnabled=false
//        }
//    }
    func resetPage()
    {
        startingView.isHidden = false
        SelectCarCategoryView.isHidden = true
        onTripView.isHidden = true
        gpsBottomVConstraint.constant = 2.0
        mkMapView.isUserInteractionEnabled = true
        locationView.isHidden = false
        addressPointer.isHidden = false
        etaLbl.isHidden = false
        if isFromRequest == false{
            let alloverlays = self.mkMapView.overlays
            self.mkMapView.removeOverlays(alloverlays)
            self.locationArrBtnPress(UIButton())
            self.mapView(mkMapView, regionDidChangeAnimated: true)
        }else{
            isFromRequest = false
        }
    }
    
    @IBAction func bottomBtnClicked(_ sender: AnyObject) {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        cashTypePopUp.showInView(aView: self.view)
    }
    func sendBookingRequest()
    {
        let loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
               [
                "ClientId"         : loginObj.id as AnyObject,
                "PickupLatitude"   : pickUpCordinate.latitude as AnyObject,
                "PickupLongitude"  : pickUpCordinate.longitude as AnyObject,
                "DropOffLatitude"  : dropOffCordinate.latitude as AnyObject,
                "DropOffLongitude" : dropOffCordinate.longitude as AnyObject,
                "PickupAddress"    : pickupTxt.text! as AnyObject,
                "DropupAddress"    : dropOffTxt.text! as AnyObject,
                "VehicleType"      : "1" as AnyObject,
                "ExpectedTime"     : "25" as AnyObject,
                "PassengerCount"   : "0" as AnyObject,
                "PaymentMode"      : payMentType as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Trip/BookNowTripRequest", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.isFromRequest = true
                    self.resetPage()
                    self.showActivity()
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
            }
        }
        
    }
    
    func showActivity(){
        self.startingView.alpha = 0.2
        self.btnActivity.isHidden = false
        SearchingLbl.isHidden = false
        self.btnCancelRide.isHidden = false
        self.btnActivity.showLoading()
        self.userInteraction(flag: false)
        self.btnLocationUpdate.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    func hideActivity(){
        self.startingView.alpha = 1.0
        self.btnActivity.isHidden = true
        SearchingLbl.isHidden = true
        btnCancelRide.isHidden = true
        self.btnActivity.hideLoading()
        self.userInteraction(flag: true)
        self.btnLocationUpdate.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    func userInteraction(flag : Bool){
        mkMapView.isUserInteractionEnabled = flag
        addressPointerView.isUserInteractionEnabled = flag
        locationView.isUserInteractionEnabled = flag
        startingView.isUserInteractionEnabled = flag
        SelectCarCategoryView.isUserInteractionEnabled = flag
        onTripView.isUserInteractionEnabled = flag
    }
    @IBAction func btnPressForActivity(_ sender: ActivityButton) {
        let parameters: [String: AnyObject] =
                [
                "ID"    : loginObj.id as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/CancelRideFromClientBeforeAccept", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                self.resetPage()
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.hideActivity()
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
            }
        }
    }
    @IBAction func btnPressForCancelRequest(_ sender: UIButton) {
        let parameters: [String: AnyObject] =
            [
                "ID"    : loginObj.id as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/CancelRideFromClientBeforeAccept", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                self.resetPage()
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.hideActivity()
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
            }
        }
    }
    func getFareEstimate()
    {
        
        let pickup =  pickupTxt.text
        let dropOff = dropOffTxt.text
        
        let lastCharPick = pickup?.suffix(4)
        let lastCharDrop = dropOff?.suffix(4)
//        let lastCharPick = pickup?.last!
//        let lastCharDrop = dropOff?.last!
        
        if(lastCharPick != lastCharDrop){
            CIError("Pickup location and dropOff location should be in same country.")
            return
        }
        
        self.startingView.isHidden = true
        self.SelectCarCategoryView.isHidden = false
        self.gpsBottomVConstraint.constant = 30.0
        let parameters: [String: AnyObject] =
                [
                    "PickupLatitude"   : pickUpCordinate.latitude as AnyObject,
                    "PickupLongitude"  : pickUpCordinate.longitude as AnyObject,
                    "DropLatitude"  : dropOffCordinate.latitude as AnyObject,
                    "DropLongitude" : dropOffCordinate.longitude as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/getFareEstimate", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.fareEstimate = FareEstimateModel(fromDictionary: (data?.value(forKey: "Data"))! as! NSDictionary)
                    self.lblEAT.text = String(self.fareEstimate.time) + "Min"
                    self.lblFareAprox.text = String(self.fareEstimate.amount)
                    if (self.fareEstimate.surge == ""){
                        self.lblSurge.text = "0"
                    }else{
                        self.lblSurge.text = String(format: "%@", self.fareEstimate.surge)
                    }
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    @IBAction func cancelRideBtnPress(_ sender: UIButton) {
        
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = NikkosCustomerManager.GetLocalString(textType: "AppName")
        createAccountErrorAlert.message = NikkosCustomerManager.GetLocalString(textType:"Cancel_PopUP")
        createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType:"NoKey"))
        createAccountErrorAlert.addButton(withTitle: NikkosCustomerManager.GetLocalString(textType:"YesKey"))
        createAccountErrorAlert.show()
    }
    func getCancelReasonList(){
        let parameters: [String: AnyObject] = [
            "ReasonType"     : "1" as AnyObject
        ]
        print(parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Common/CancelReasonList", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let allCancelReasonDict = data?.value(forKey: "Data") as! NSDictionary
                    let arrList  = allCancelReasonDict.value(forKey: "List") as! NSArray
                    self.arrAllReasonData.removeAllObjects()
                    self.arrReasonId.removeAllObjects()
                    for  object  in arrList{
                        self.cancelReason =  CancelReasonModel(fromDictionary: object as! NSDictionary)
                        self.arrAllReasonData .add(self.cancelReason.reason)
                        self.arrReasonId .add(self.cancelReason.reasonId)
                    }
                    self.reasonTblView.reloadData()
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
    
    
    @IBAction func callBtnPress(_ sender: AnyObject) {
        let number = self.statusObj.driverPhoneNumber
        guard let url = URL(string: "tel://" + number!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    // MARK: - TableView Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllReasonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ReasonTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "ReasonCell", for: indexPath) as! ReasonTableViewCell
        cell.lblCancelReason.text = arrAllReasonData.object(at: indexPath.row) as? String
        if selectedReasonCellIndex == indexPath.row
        {
            cell.backgroundColor = UIColor.lightGray
        }else
        {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedReasonCellIndex = indexPath.row
        let object = arrAllReasonData.object(at: selectedReasonCellIndex)
        let index = arrAllReasonData .index(of: object)
        let id : Int = Int(truncating: arrReasonId .object(at: index) as! NSNumber)
        reasonTblView.reloadData()
        cancelRide(id: id)
    }
    func alertView(_ View: UIAlertView, clickedButtonAt buttonIndex: Int){
    //func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex
        {
        case 0:
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            self.popupView.removeAnimate()
            break;
        case 1:
            
            
            self.getCancelReasonList()
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            popupView.showInView(aView: self.view)

            break;
        default:
            break;
            //Some code here..
        }
    }

    @IBAction func popUpDismissBtnPress(_ sender: UIButton)
    {
        self.popupView.removeAnimate()
        self.navigationController?.popViewController(animated: true)
        
    }
    func cancelRide(id : Int)
    {
        let parameters: [String: AnyObject] = [
            "TripId"           : statusObj.tripRequestId as AnyObject,
            "ReasonId"           : id as AnyObject,
            ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/CancelRideFromClient", parameter:parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.popupView.removeAnimate()
                    if self.navigationType == "FROM TRIP"
                    {
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.resetPage()
                        self.navigationItem.leftBarButtonItem?.isEnabled = true
                    }
                   
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    // MARK: - TextView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 64.0{
                self.view.frame.origin.y -= keyboardSize.height-30.0
            }
            else {
                
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height-30
            }
            else {
                
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == commentView)
        {
            if(text == "\n")
            {
                view.endEditing(true)
                return false
            }
            else
            {
                return true
            }
        }else{
            let maxCharacter: Int = 100
            return (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= maxCharacter
        }
        
    }
   
    @IBAction func accessTripConfirmBtnPress(_ sender: UIButton)
    {
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        cashTypePopUp.showInView(aView: self.view)
        
    }
    @IBAction func paymentBtnPress(_ sender: UIButton) {
        
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        cashTypePopUp.removeAnimate()
        if sender.tag == 1
        {
            //cash
            payMentType = "2"
        }else
        {
            //card
            payMentType = "1"
        }
        sendBookingRequest()
        
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

extension HomeVC: GMSAutocompleteViewControllerDelegate
{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
//        print("Place name: \(place.name)")
//        print("Place id: \(place.placeID)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        
        
//        if place.formattedAddress != nil {
//            addressNameString = place.name + place.formattedAddress!
//        }else {
//            addressNameString = place.name
//        }
        
        
//        print(addressNameString)
        self.getAddressFromLatLon(pdblLatitude: String(place.coordinate.latitude), withLongitude: String(place.coordinate.longitude), isFromGMS: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.cordinateOfAddress = place.coordinate
            self.getAddressFromAddressSuggestion()
        }
        
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}



