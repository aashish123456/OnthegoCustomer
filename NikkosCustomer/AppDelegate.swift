//
//  AppDelegate.swift
//  NikkosCustomer
//
//  Created by Umang on 9/12/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import GooglePlaces
import Fabric
import Crashlytics
import UserNotifications
import SkyFloatingLabelTextField
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var loginObj:LoginModal!
    var player : AVAudioPlayer!

    var checkControllerTime : String = ""
    var dic = [String: AnyObject]()
    var id :Int!
    
    // Override point for customization after application launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        //google : ifeanyiohalehi@gmail.com / Onthego2018&
        //branch.io : dotsquares.team@gmail.com / Android.team123
        //febric : dotsquares.team@gmail.com / Android.team
        //brach key live : key_live_cjVeBESQ7JYAH3t28w2L5nbfFtbsS5sV
        //branch key test : key_test_cbQkzAUS8GYzL2v7XOotpkbjEwcDG2tZ
        
        // if you are using the TEST key
        //Branch.setUseTestBranchKey(true)
        //test key_test_cbQkzAUS8GYzL2v7XOotpkbjEwcDG2tZ
        
        
        //Branch deepling handling
        Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { params, error in
            guard error == nil else { return }
            guard let userDidClick = params?["+clicked_branch_link"] as? Bool else { return }
            if userDidClick && SharedStorage.getIsRememberMe() == true {
                // This code will execute when your app is opened from a Branch deep link, which
                // means that you can route to a custom activity depending on what they clicked.
                // In this example, we'll just print out the data from the link that was clicked.
                print("deep link data: ", params ?? "Deeplink data not found.")
                // Load a reference to the storyboard and grab a reference to the navigation controller
            }
        })
        
        
        if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? NSDictionary,
            let userActivity = userActivityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity {
            //====================================
            //      Branch deepling handling
            //====================================
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                let url = userActivity.webpageURL!
                print(url.absoluteString)
                print(url.lastPathComponent)
                
                //handle url and open whatever page you want to open.
                if url.lastPathComponent.contains("referralcode") && SharedStorage.getIsRememberMe() == false {
                    //Move to ride detail page: RideDetailsVC]
                    if let referralCode = url.lastPathComponent.components(separatedBy: ":").last {
                        
                        let reveal = self.window?.rootViewController as! SWRevealViewController
                        let rootController:SignUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                        rootController.referralCodeString = referralCode
                        (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                    }
                }
            }
        }
        
        
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            var userInfo = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if SharedStorage.getIsRememberMe() == true
                {
                self.handleUserInfo(objDictionary: userInfo as! Dictionary<String, AnyObject>)
                }
            }
        }
        

        
        //nikkos
//        GMSPlacesClient.provideAPIKey("AIzaSyCKR71GtlbFqKyfgt1u21LbNGpdRjNv7Vo")
//        GMSServices.provideAPIKey("AIzaSyCKR71GtlbFqKyfgt1u21LbNGpdRjNv7Vo")
        
        
        // onthego
        GMSPlacesClient.provideAPIKey("AIzaSyDo-lmMj7N9mwudo_C4Uol8V_wH2VKRQm8")
        GMSServices.provideAPIKey("AIzaSyDo-lmMj7N9mwudo_C4Uol8V_wH2VKRQm8")
        
        let locManager = PCLocationManager.sharedLocationManager()
        (locManager as AnyObject).startUpdateingLocation()
        
        let myString = SharedStorage.getLanguage()
        if myString.count == 0
        {
            SharedStorage.setLanguage(language: NikkosCustomerManager.k_ENGLISH)
        }
        
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else  {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            
            
        }
        
        self.window?.backgroundColor = UIColor.white
        Fabric.with([Crashlytics.self])
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       // Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            print(url.lastPathComponent)
            
            //handle url and open whatever page you want to open.
             if url.lastPathComponent.contains("referralcode") && SharedStorage.getIsRememberMe() == false {
                //Move to signup page with referral code
                if let referralCode = url.lastPathComponent.components(separatedBy: ":").last {
                    
                    let reveal = self.window?.rootViewController as! SWRevealViewController
                    let rootController:SignUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                    rootController.referralCodeString = referralCode
                    (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                }
            }
        }
        return true
    }
    
 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // let deviceTokens : String = deviceToken.description.replacingOccurrences(of:"<", with: "").replacingOccurrences(of:">", with: "").replacingOccurrences(of:" ", with: "") as String
        let deviceTokens = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if deviceTokens != SharedStorage.getDeviceToken()
        {
            if UserDefaults.standard.object(forKey: "NC_user") != nil
            {
                upadteDeviceToken(token: deviceTokens)
            }
        }
        SharedStorage.setDeviceToken(deviceToken: deviceTokens)
        print(":Device token is :::::\(SharedStorage.getDeviceToken())")
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("APNs device token: \(deviceTokenString)")
//        SharedStorage.setDeviceToken(deviceToken: deviceTokenString)
//        let getToken = SharedStorage.getDeviceToken()
//        print(":Device token is ::::: \(getToken)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
        SharedStorage.setDeviceToken(deviceToken: "F6E921B2D76AA5F804FBC46B41B2B451A08E262B181DD8E2F0024DA05B9FCEA8")
    }
    
    func upadteDeviceToken(token:String)
    {
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
            [
                "DeviceToken"      : token as AnyObject,
                "ClientId"         :     self.loginObj.id as AnyObject,
            ]
        NSLog("%@", parameters)
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/UpdateClientDeviceToken", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        //Got Notification
        //Branch.getInstance().handlePushNotification(userInfo)
        print(":::::::::::\(userInfo)")
       // let aps = userInfo["aps"] as? NSDictionary
        if SharedStorage.getIsRememberMe() == true
        {
            self.handleUserInfo(objDictionary: userInfo as! Dictionary<String, AnyObject>)
        }
        
    }
    
    
    func handleUserInfo(objDictionary:Dictionary< String,AnyObject>)
    {
        
        /*
         [aps: {
         alert = "Trip has been end";
         badge = 0;
         sound = default;
         }, MsgType: EndRide, PrimaryId: 204]
         */
        
        var mp3Type : String = "fsadf"
        print("received notifications")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bookingRequest"), object: objDictionary, userInfo: objDictionary)
        
        let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
        let swnav = swrevealControllerVC.frontViewController as! UINavigationController
        
        
        let reveal = self.window?.rootViewController as! SWRevealViewController
        let rootController:HomeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeVC
        
        
        /*let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
        let swnav = swrevealControllerVC.frontViewController as! UINavigationController
        
         let viewControllers = swnav.viewControllers
            for vc in viewControllers {
                if vc.isKind(of: HomeVC.classForCoder()) {
                    print("It is in stack")
                    let homevc = vc as! HomeVC
                    homevc.fresh(objDictionary as NSDictionary)
                    //Your Process
                }
            }*/
        
        if objDictionary["MsgType"] as! String == "BooNowRequestReply"
        {
            
        }else if objDictionary["MsgType"] as! String == "BookingAccept"
        {
            mp3Type = "ForRider_Driver_is_on_route"
        }
        else if objDictionary["MsgType"] as! String == "OpenRide"
        {
            mp3Type = "fsadf"
        }
        else if objDictionary["MsgType"] as! String == "CancelRide"
        {
            mp3Type = "ForDriverAndRider_Trip_canceled"
//            let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
//            let swnav = swrevealControllerVC.frontViewController as! UINavigationController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
            if (swnav.visibleViewController?.isKind(of: HomeVC.self))!{
                
            }
            else
            {
                CIError(NikkosCustomerManager.GetLocalString(textType: "Ride_canceled_bydriver"))
//                let reveal = self.window?.rootViewController as! SWRevealViewController
//                let rootController:HomeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeVC
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            }
        }
        else if objDictionary["MsgType"] as! String == "driverArrived"
        {
            mp3Type = "ForRider_Driver_has_come"
            
//            let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
//            let swnav = swrevealControllerVC.frontViewController as! UINavigationController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
            
            if (swnav.visibleViewController?.isKind(of: HomeVC.self))!{
                
            }
            else
            {
                //ashish
                //CIError(NikkosCustomerManager.GetLocalString("Driver_has_arrived"))
//                let reveal = self.window?.rootViewController as! SWRevealViewController
//                let rootController:HomeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeVC
                
                rootController.navigationType = "FROM NOTI"
                rootController.globalTripId = objDictionary["PrimaryId"] as! Int
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            }
        }
        else if objDictionary["MsgType"] as! String == "StartRide"
        {
//            let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
//            let swnav = swrevealControllerVC.frontViewController as! UINavigationController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
            if (swnav.visibleViewController?.isKind(of: HomeVC.self))!{
                
            }
            else
            {
                //ashish
                //CIError(NikkosCustomerManager.GetLocalString("Ride_has_started"))
//                let reveal = self.window?.rootViewController as! SWRevealViewController
//                let rootController:HomeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeVC
                rootController.navigationType = "FROM NOTI"
                rootController.globalTripId = objDictionary["PrimaryId"] as! Int
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            }
        }
        else if objDictionary["MsgType"] as! String == "EndRide"
        {
            
//            let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
//            let swnav = swrevealControllerVC.frontViewController as! UINavigationController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
            if (swnav.visibleViewController?.isKind(of: HomeVC.self))!{
                
            }
            else
            {
//                let reveal = self.window?.rootViewController as! SWRevealViewController
//                let rootController:HomeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeVC
                rootController.navigationType = "FROM NOTI"
                rootController.globalTripId = objDictionary["PrimaryId"] as! Int
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
           }
        }
        else if objDictionary["MsgType"] as! String == "DeviceUpdatedOnLogin"{
            
            SharedStorage.setIsRememberMe(isRememberMe: false)
            self.loadSignInViewController()
        }
        else if objDictionary["MsgType"] as! String == "TripOffer"{
            
            let rootController:PromotionVCViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PromotionVCViewController") as! PromotionVCViewController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
                let aps = objDictionary["aps"] as! NSDictionary
                rootController.isFromNotification = true
                rootController.promoText = aps.value(forKey: "alert") as! String
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            
        }
        
        let path = Bundle.main.path(forResource: mp3Type, ofType:"mp3")
        
        
        if (path != nil)
        {
            let fileURL = NSURL(fileURLWithPath: path!)
            
            player = try! AVAudioPlayer(contentsOf: fileURL as URL, fileTypeHint: nil)
            player.prepareToPlay()
            player.play()
        }
    }
    
    private func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        // pass the url to the handle deep link call
        let branchHandled = Branch.getInstance().handleDeepLink(url as URL!)
        
        print(url.absoluteString)
        print(url.lastPathComponent)
        
        if (GPPURLHandler.handle(url as URL?, sourceApplication: sourceApplication, annotation: annotation)) {
            return true
        }
        else if (FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)) {
            return true
        }else if (url.lastPathComponent?.contains("referralcode"))! && SharedStorage.getIsRememberMe() == false {
            //Move to signup with referral code
            if let referralCode = url.lastPathComponent?.components(separatedBy: ":").last {
                let reveal = self.window?.rootViewController as! SWRevealViewController
                let rootController:SignUpVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                rootController.referralCodeString = referralCode
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            }
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
      
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    private func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    private func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    private func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    func loadSignInViewController() {
        let objUIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objSWRevealViewController = objUIStoryboard.instantiateViewController(withIdentifier: "signInNavigation")
        window?.rootViewController = objSWRevealViewController
    }
    func loadHomeViewController() {
        let objUIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objSWRevealViewController = objUIStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        window?.rootViewController = objSWRevealViewController
    }

}

