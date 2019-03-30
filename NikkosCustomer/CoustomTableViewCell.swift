//
//  CoustomTableViewCell.swift
//  MoodTracking
//
//  Created by Pulkit on 10/05/16.
//  Copyright © 2016 Vinod Sahu. All rights reserved.
//

import UIKit

class CoustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class SidebarTableViewCell: UITableViewCell {
    
    
    let Selected_Cell     =    NikkosCustomerManager.UIColorFromRGB(r: 255, g: 255, b: 255)//203,210,220
    let UNSelected_Cell   =    NikkosCustomerManager.UIColorFromRGB(r: 255, g: 255, b: 255)//234,237,242
    let Selected_Label    =    NikkosCustomerManager.UIColorFromRGB(r: 21, g: 165, b: 61)//14,30,53
    let UNSelected_Label  =    NikkosCustomerManager.UIColorFromRGB(r: 0, g: 0, b: 0)//14,30,53
    
    @IBOutlet  var lblSideBarCell: UILabel!
    @IBOutlet  var imgSideBarCell: UIImageView!
    
   
    @IBOutlet weak var btnBadgeCount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpSideBarCellWithDictionary(dictSideBarCelldata :NSDictionary,IfCellSelected : Bool)
    {
        if IfCellSelected == true
        {
            let strImageName = dictSideBarCelldata.object(forKey: "image_name")
            imgSideBarCell.image = UIImage(named:strImageName as! String)
            lblSideBarCell.textColor = Selected_Label
            self.backgroundColor = Selected_Cell
            
        }else
        {
            let strImageName = dictSideBarCelldata.object(forKey: "image_name")
             imgSideBarCell.image = UIImage(named: strImageName as! String)
            lblSideBarCell.textColor = UNSelected_Label
            self.backgroundColor = UNSelected_Cell
        }
        lblSideBarCell.text = dictSideBarCelldata.object(forKey: "title") as? String
    }
    
    
    
    
  
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
class MyLocationTableViewCell: UITableViewCell {
    
    @IBOutlet  var favouriteNameLbl : UILabel!
    @IBOutlet  var addressLbl : UILabel!
    @IBOutlet  var deleteBtn : CustomButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class CardTableViewCell: UITableViewCell {

    @IBOutlet  var activeBtn : CustomButton!
    @IBOutlet  var deleteBtn : CustomButton!
    @IBOutlet  var nameLbl : UILabel!
    @IBOutlet  var numberLbl : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class ShareFareTableViewCell: UITableViewCell
{
    @IBOutlet  var tripIdLbl : UILabel!
    @IBOutlet  var bookingTimeLbl : UILabel!
    @IBOutlet  var travellingTimeLbl : UILabel!
    @IBOutlet  var pickUpAddressLbl : UILabel!
    @IBOutlet  var dropOffAddressLbl : UILabel!
    @IBOutlet  var driverNameLbl : UILabel!
    @IBOutlet  var companyNameLbl : UILabel!
    @IBOutlet  var siretLbl : UILabel!
    @IBOutlet  var estimateCostLbl : UILabel!
    @IBOutlet  var estimateDistanceLbl : UILabel!
    @IBOutlet  var noOfPersonLbl : UILabel!
    @IBOutlet  var individualShareLbl : UILabel!
    @IBOutlet  var shareBtn : CustomButton!
    @IBOutlet  var statusIndicatorView : UIImageView!
    
    
    
    
    //heading
    @IBOutlet var lblTripIDH: UILabel!
    @IBOutlet var lblDateTimeOfBookingH: UILabel!
    @IBOutlet var lblDateTimeOfTravellingH: UILabel!
    @IBOutlet var lblFromAddressH: UILabel!
    @IBOutlet var lblToAddressH: UILabel!
    @IBOutlet var lblDriverNameH: UILabel!
    @IBOutlet var lblCompanyNameDriverH: UILabel!
    @IBOutlet var lblSiretH: UILabel!
    @IBOutlet var lblEstimatedCostH: UILabel!
    @IBOutlet var lblEstimatedDistanceH: UILabel!
    @IBOutlet var lblNoOfPersonH: UILabel!
    @IBOutlet var lblIndividualShareH: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTripIDH.text = NikkosCustomerManager.GetLocalString(textType: "Trip_Id")
        lblDateTimeOfBookingH.text = NikkosCustomerManager.GetLocalString(textType: "Date_Time_Booking")
        lblDateTimeOfTravellingH.text = NikkosCustomerManager.GetLocalString(textType: "Date_Time_Travelling")
        lblFromAddressH.text = NikkosCustomerManager.GetLocalString(textType: "Pickup_Address")
        lblToAddressH.text = NikkosCustomerManager.GetLocalString(textType: "DropOff_Address")
        lblDriverNameH.text = NikkosCustomerManager.GetLocalString(textType: "Driver_Name")
        lblCompanyNameDriverH.text = NikkosCustomerManager.GetLocalString(textType: "Company_Name")
        lblSiretH.text = NikkosCustomerManager.GetLocalString(textType: "Siret")
        lblEstimatedCostH.text = NikkosCustomerManager.GetLocalString(textType: "Estimated_Cost")
        lblEstimatedDistanceH.text = NikkosCustomerManager.GetLocalString(textType: "Estimated_Distance")
        lblNoOfPersonH.text = NikkosCustomerManager.GetLocalString(textType: "No_Of_Persons")
        lblIndividualShareH.text = NikkosCustomerManager.GetLocalString(textType: "Individual_Share")

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class ShareFarePersonTableViewCell: UITableViewCell
{
  
    @IBOutlet  var nameLbl : UILabel!
    @IBOutlet  var phoneNoLbl : UILabel!
    @IBOutlet  var crossBtn : CustomButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class MyTripTableViewCell: UITableViewCell
{
    
    //@IBOutlet var lblDriverNumberH: UILabel!
    @IBOutlet var lblDriverNamePlateNoH: UILabel!
    @IBOutlet var lblDateTimeTravellingH: UILabel!
    @IBOutlet var lblDateTimeBookingH: UILabel!
    @IBOutlet  var tripIdLbl : UILabel!
    @IBOutlet  var pickUpAddressLbl : UILabel!
    @IBOutlet  var dropOffAddressLbl : UILabel!
    @IBOutlet  var tripStatusLbl : UILabel!
    @IBOutlet  var ongoingTripBtn : UIButton!
    @IBOutlet  var completedTripBtn : UIButton!
    @IBOutlet  var laterTripBtn : UIButton!
    @IBOutlet weak var lblPlateNo: UILabel!
    
    @IBOutlet weak var lblCost: UILabel!
    @IBOutlet var lblCarNumber: UILabel!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var lblDateTimeBooking: UILabel!
    @IBOutlet var lblDateTimeTravelling: UILabel!
    
    
    @IBOutlet var lblTripIdHeading: UILabel!
    @IBOutlet var lblPickupAddressHeading: UILabel!
    @IBOutlet var lblDropAddressHeading: UILabel!
    @IBOutlet var lblTripStatusHeading: UILabel!
    @IBOutlet var lblOngoingTripHeading: UILabel!
    @IBOutlet var lblLaterRideHeading: UILabel!
    @IBOutlet var lblCompletedHeading: UILabel!
    //@IBOutlet var lblDriverPhoneNumber: UILabel!
    
    
    @IBOutlet var lblRateNow: UILabel!
    @IBOutlet var lblShowRideOnMap: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTripIdHeading.text = NikkosCustomerManager.GetLocalString(textType: "Trip_Id")
//        lblPickupAddressHeading.text = NikkosCustomerManager.GetLocalString(textType:"Pickup_Address")
//        lblDropAddressHeading.text = NikkosCustomerManager.GetLocalString(textType:"DropOff_Address")
        
//        lblOngoingTripHeading.text = NikkosCustomerManager.GetLocalString(textType:"Ongoing_Trip")
//        lblCompletedHeading.text = NikkosCustomerManager.GetLocalString(textType:"Completed_Trip")
        //lblLaterRideHeading.text = NikkosCustomerManager.GetLocalString(textType:"Later_Trip")
        lblTripStatusHeading.text = NikkosCustomerManager.GetLocalString(textType:"Trip_Status")
        
        btnCancel.titleLabel?.text = NikkosCustomerManager.GetLocalString(textType:"Btn_Cancel")
        
        //lblDriverNumberH.text = NikkosCustomerManager.GetLocalString("Driver_Number")
        //lblDriverNamePlateNoH.text = NikkosCustomerManager.GetLocalString(textType:"Driver_Name_plate_no")
        lblDateTimeTravellingH.text = NikkosCustomerManager.GetLocalString(textType:"Date_Time_Travelling")
        lblDateTimeBookingH.text = NikkosCustomerManager.GetLocalString(textType:"Date_Time_Booking")
        
        //lblShowRideOnMap.text = NikkosCustomerManager.GetLocalString(textType:"Show_Ride_On_Map")
        //lblRateNow.text = NikkosCustomerManager.GetLocalString(textType:"Rate_Now")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class ReasonTableViewCell : UITableViewCell{
    
    @IBOutlet var lblCancelReason: UILabel!
}
class AddressTableViewCell : UITableViewCell{
    
    @IBOutlet var lblNikName: UILabel!
    @IBOutlet var lblAddress: UILabel!
}
