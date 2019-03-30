//
//  AddressSuggestionVC.swift
//  SuperCustomer
//
//  Created by Umang on 7/13/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//
//DropUpdate
import UIKit
import GooglePlaces
class AddressSuggestionVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    @IBOutlet weak var searchTblView: UITableView!
    @IBOutlet weak var prefilledAddressTblView: UITableView!
    var searchResultPlaces:NSMutableArray  = NSMutableArray()
    var prefilledPlaces:NSMutableArray  = NSMutableArray()
    @IBOutlet weak var locationTxt: MapTxtField!
    var locationType:String!
    var currentIndex:Int!
    @IBOutlet weak var hieghtConstraint: NSLayoutConstraint!
    var loginObj:LoginModal!
    var nickNameTxtField: UITextField!
    
    var cordinateOfAddress :CLLocationCoordinate2D!
    var addressNameString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // locationTxt.becomeFirstResponder()
        locationTxt.setLeftImage(imageName: "search_icon")
        title = NikkosCustomerManager.GetLocalString(textType: "Select_Address")
        locationTxt.placeholder = NikkosCustomerManager.GetLocalString(textType: "Select_Address")
        searchTblView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "SPGooglePlacesAutocompleteCell")
        prefilledAddressTblView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "SPGooglePlacesAutocompleteCell")
        self.loginObj = SharedStorage.getUser()
        self.getFavouriteAddresses()
        // Do any additional setup after loading the view.
    }
    
    func getFavouriteAddresses()
    {
        let parameters: [String: AnyObject] = [
            "ID"      : self.loginObj.id as AnyObject,
        ]
 
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/GetFavoriteAddress", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            //let triggerTime = (Int64(NSEC_PER_SEC) * 2)
//            dispatch_after(DispatchTime.now( triggerTime), dispatch_get_main_queue(), { () -> Void in
//                NikkosCustomerManager.dissmissHud()
//            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // your code here
                NikkosCustomerManager.dissmissHud()
            }
            
            self.prefilledPlaces.removeAllObjects()
                        if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey:"List")) as!  [[String:AnyObject]]
                    
                    for dict in tempArr
                    {
                        let addressObj:AddressModal = AddressModal(fromDictionary: dict as NSDictionary)
                        self.prefilledPlaces.add(addressObj)
                    
                        
                    }
                    self.prefilledAddressTblView.reloadData()
                    
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
        if tableView == searchTblView
        {
            return searchResultPlaces.count
        }else
        {
            return prefilledPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == searchTblView
        {
            let cell : UITableViewCell  = tableView.dequeueReusableCell(withIdentifier: "SPGooglePlacesAutocompleteCell", for: indexPath)
            
            let aPlacemark = searchResultPlaces.object(at: indexPath.row)
            let arrAddress = (aPlacemark as AnyObject).addressDictionary!!["FormattedAddressLines"]
        
       
            let add = (arrAddress! as AnyObject).componentsJoined(by: ", ")
            cell.textLabel!.text = add
        

            return cell

        }
        else
        {
            let cell : AddressTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
            
            let addressObj = prefilledPlaces.object(at: indexPath.row) as! AddressModal
            cell.lblAddress.text = addressObj.address
            cell.lblNikName.text = addressObj.favoriteName
           // cell.textLabel!.text = addressObj.address
            
            return cell
        }
        
        //return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.textFieldShouldReturn(locationTxt)
        //let triggerTime = (Int64(NSEC_PER_SEC) * 2)
//        dispatch_after(dispatch_time(dispatch_time_t(DispatchTime.now()), triggerTime), dispatch_get_main_queue(), { () -> Void in
        
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.currentIndex =  indexPath.row
            if tableView == self.searchTblView
            {
                if self.locationType == nil{
                    let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType: "Do_you_want_to_add_this_location_inFavorites"), preferredStyle: UIAlertControllerStyle.alert)
                    newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "YesKey"), style: UIAlertActionStyle.default, handler: self.yesBtnPress))
                    newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "NoKey"), style: UIAlertActionStyle.default, handler: self.noBtnPress))
                    self.present(newWordPrompt, animated: true, completion: nil)
                }else{
                    self.addressFromSearch()
                    //self.performSegueWithIdentifier("unwindToHome", sender: nil)
                }
                
            }else
            {
                if self.locationType != nil{
                    self.performSegue(withIdentifier: "unwindToHome", sender: nil)
                    
                }
            }
            
        }
        
    }
    func addressFromSearch()
    {
        //ashish
        //let aPlacemark = searchResultPlaces.objectAtIndex(currentIndex)
        let aPlacemark = locationTxt.text
        if locationType == nil{
            self.navigationController?.popViewController(animated: false)
        }else{
            
            if locationType == "DropUpdate"
            {
                self.performSegue(withIdentifier: "unwindFromdEST", sender: aPlacemark)
            }else
            {
                self.performSegue(withIdentifier: "unwindToHome", sender: aPlacemark)
            }
        }
    }
    func noBtnPress(alert: UIAlertAction!)
    {
        
        
        //let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addressFromSearch()
            }
        //})
        addressFromSearch()
    }
    func yesBtnPress(alert: UIAlertAction!)
    {
        let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType: "Enter_nickname_for_this_address"), preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextField)
        newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "Submit"), style: UIAlertActionStyle.default, handler: self.nickNameEntered))
        
        self.present(newWordPrompt, animated: true, completion: nil)
    }
    func nickNameEntered(alert: UIAlertAction!)
    {
         addToFavourite()
    }
    func addToFavourite()
    {
        
        //ashish
//        let aPlacemark = searchResultPlaces.objectAtIndex(currentIndex) as!  CLPlacemark
//        let arrAddress = aPlacemark.addressDictionary!["FormattedAddressLines"]
        
        let parameters: [String: AnyObject] = [
            "ClientId"      : self.loginObj.id as AnyObject,
            "FavoriteName"  : ((nickNameTxtField.text?.count)!>0 ? nickNameTxtField.text : "")! as AnyObject,
            "Address"       : locationTxt.text! as AnyObject, //arrAddress!.componentsJoinedByString(", "),
            "Latitude"      : cordinateOfAddress.latitude as AnyObject, // (aPlacemark.location?.coordinate.latitude)!,
            "Longitude"     : cordinateOfAddress.longitude as AnyObject,// (aPlacemark.location?.coordinate.longitude)!,
            ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/AddFavoriteAddress", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.prefilledPlaces.removeAllObjects()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.addressFromSearch()
                }
                else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                //  CIError("OOPs something went wrong.")
            }
            
        }

        
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = NikkosCustomerManager.GetLocalString(textType: "NickName")
        nickNameTxtField = textField
    }
    @IBAction func backPress(_ sender: Any) {
        self.textFieldShouldReturn(locationTxt)
        //let triggerTime = (Int64(NSEC_PER_SEC) * 1/2)
       // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
        }
//    })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        print(newString)
        
        if newString.count == 0
        {
            searchResultPlaces.removeAllObjects()
            searchTblView.reloadData()
            prefilledAddressTblView.isHidden = false
            self.adjustHeightOfTableview()
        }
        else
        {
            self.handleSearchForSearchString(searchString: newString)
        }
        return true

    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
//    private func textFieldDidBeginEditing(textField: UITextField) {
////        if textField == txtAddress{
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
////
////        }
//
//
//        
//    }
    func getAddress(cordinate :CLLocationCoordinate2D)
    {
        print("zoom in zoom out3")
        NikkosCustomerManager.showHud()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        print("zoom in zoom out4")
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            print("zoom in zoom out5")
            // Place details
            // var placeMark: CLPlacemark!
            if var placeMark = placemarks?.first
            {
                print("zoom in zoom out9")
                placeMark = (placemarks?[0])!
                print("zoom in zoom out10")
                
                print (placeMark)
                
                if let val:NSArray = placeMark.addressDictionary!["FormattedAddressLines"] as! NSArray?
                {
                    let locatedAt: String = val.componentsJoined(by: ", ")
                    print(val)
                    
                    if self.addressNameString != ""   {
                        self.locationTxt.text = self.addressNameString + "," + locatedAt
                    }else{
                    self.locationTxt.text = locatedAt
                    }
                    if self.locationType == nil{
                        let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType: "Do_you_want_to_add_this_location_inFavorites"), preferredStyle: UIAlertControllerStyle.alert)
                        newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "YesKey"), style: UIAlertActionStyle.default, handler: self.yesBtnPress))
                        newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "NoKey"), style: UIAlertActionStyle.default, handler: self.noBtnPress))
                        self.present(newWordPrompt, animated: true, completion: nil)
                    }else{
                    self.addressFromSearch()
                    }
                }
                
                if let city = placeMark.addressDictionary!["City"]  {
                    print(city)
                   // self.txtCity.text = city as? String
                }
                if let zip = placeMark.addressDictionary!["ZIP"]  {
                    print(zip)
                   // self.txtPostCode.text = zip as? String
                }
                if let state = placeMark.addressDictionary!["State"]  {
                    print(state)
                  //  self.txtAddress1.text = state as? String
                }
                NikkosCustomerManager.dissmissHud()
                
                
            }
            
        })
    }
    func getAddressOfDropLocation(){
        
            self.locationTxt.text = self.addressNameString
        
        if self.locationType == nil{
            let newWordPrompt = UIAlertController(title: NikkosCustomerManager.GetLocalString(textType: "AppName"), message: NikkosCustomerManager.GetLocalString(textType:  "Do_you_want_to_add_this_location_inFavorites"), preferredStyle: UIAlertControllerStyle.alert)
            newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "YesKey"), style: UIAlertActionStyle.default, handler: self.yesBtnPress))
            newWordPrompt.addAction(UIAlertAction(title: NikkosCustomerManager.GetLocalString(textType: "NoKey"), style: UIAlertActionStyle.default, handler: self.noBtnPress))
            self.present(newWordPrompt, animated: true, completion: nil)
        }else{
            self.addressFromSearch()
        }
    }
    func handleSearchForSearchString(searchString  : String)
    {
        let geoCoder = CLGeocoder()
        let locMan = PCLocationManager.sharedLocationManager()
        let centerLocation = CLLocation(latitude: (locMan as AnyObject).myLocation1.latitude, longitude: (locMan as AnyObject).myLocation1.longitude)
        
        geoCoder.geocodeAddressString(searchString, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
                self.searchResultPlaces.removeAllObjects()
                self.searchTblView.reloadData()
                self.prefilledAddressTblView.isHidden = false
                self.adjustHeightOfTableview()
            }else
            {
                //   let placeArray:NSArray = placemarks ?? []
                for placemark: CLPlacemark in placemarks! {
                    if placemark.location!.distance(from: centerLocation) <= 500000 {
                        self.searchResultPlaces.add(placemark)
                    }
                }
                //  self.searchResultPlaces = placeArray.mutableCopy() as! NSMutableArray
                self.prefilledAddressTblView.isHidden = true
                self.searchTblView.reloadData()
                self.adjustHeightOfTableview()
            }
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
    textField.resignFirstResponder()
        return true
    }
    
    func adjustHeightOfTableview()
    {
        
        var height = searchTblView.contentSize.height
        var maxHeight = (searchTblView.superview?.frame.size.height)! - searchTblView.frame.origin.y
        if height > maxHeight {
            height = maxHeight
        }
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: { () -> Void in
            }, completion: { (finished: Bool) -> Void in
               self.hieghtConstraint.constant = height
                self.view.setNeedsUpdateConstraints()
        })
    }
    
 
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let valueLat : Double;
        let long : Double;
        
        let objController =  segue.destination as! HomeVC
        if (sender != nil)
        {
            //ashish
           //let arrAddress = (sender as! CLPlacemark).addressDictionary!["FormattedAddressLines"]
            if segue.identifier == "unwindToHome"
            {
                if locationType == "Pick"
                {
//                    objController.pickupTxt.text = arrAddress!.componentsJoinedByString(", ")
//                    objController.pickUpCordinate = (sender as! CLPlacemark).location?.coordinate
                    
                    objController.pickupTxt.text = locationTxt.text
                    objController.pickUpCordinate = cordinateOfAddress
                    
                }else
                {
//                    objController.dropOffTxt.text = arrAddress!.componentsJoinedByString(", ")
//                    objController.dropOffCordinate = (sender as! CLPlacemark).location?.coordinate
                    objController.dropOffTxt.text = locationTxt.text
                   objController.dropOffCordinate = cordinateOfAddress
                }
                
            }else if segue.identifier == "unwindFromdEST"
            {
//                objController.dropOffTxt.text = arrAddress!.componentsJoinedByString(", ")
//                objController.dropOffCordinate = (sender as! CLPlacemark).location?.coordinate
               objController.dropOffTxt.text = locationTxt.text
                 objController.dropOffCordinate = cordinateOfAddress
            }
        }else
        {
            let addressObj = prefilledPlaces.object(at: currentIndex) as! AddressModal
            if locationType == "Pick"
            {
                objController.pickupTxt.text = addressObj.address
                if (addressObj.latitude != nil){
                     valueLat = Double(addressObj.latitude)
                     long  = Double(addressObj.longitude)
                }else{
                    valueLat = 0.0
                    long  = 0.0
                }
                objController.pickUpCordinate = CLLocationCoordinate2D(latitude:  valueLat, longitude: long)
            }else
            {
                
                if (addressObj.latitude != nil){
                    valueLat = Double(addressObj.latitude)
                    long  = Double(addressObj.longitude)
                }else{
                    valueLat = 0.0
                    long  = 0.0
                }
                
                objController.dropOffTxt.text = addressObj.address
                objController.dropOffCordinate  = CLLocationCoordinate2D(latitude:  valueLat, longitude: long)
            }
        }
    }
    

}
extension AddressSuggestionVC: GMSAutocompleteViewControllerDelegate
{
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place id: \(place.placeID)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
        if place.formattedAddress != nil {
            addressNameString = place.name + place.formattedAddress!
        }else {
            addressNameString = place.name
        }
        cordinateOfAddress = place.coordinate
        getAddressOfDropLocation()
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


