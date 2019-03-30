//
//  MyCardsVC.swift
//  NikkosCustomer
//
//  Created by Umang on 10/24/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class MyCardsVC: UIViewController,SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate
{
     @IBOutlet weak var sideBarButton: UIBarButtonItem!
     @IBOutlet weak var tblView: UITableView!
     @IBOutlet weak var msgLbl: UILabel!
     var cardsArr:NSMutableArray  = NSMutableArray()
     var loginObj:LoginModal!
     var idForDelete : Int!
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        self.title = NikkosCustomerManager.GetLocalString(textType:  "My_cards")
        tblView.tableFooterView = UIView()
        let revealViewController = self.revealViewController()
        revealViewController?.delegate = self
        if (( revealViewController ) != nil)
        {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer((revealViewController?.panGestureRecognizer())!)
        }
        self.loginObj = SharedStorage.getUser()
        msgLbl.text = NikkosCustomerManager.GetLocalString(textType: "No_Data")
    }
    @IBAction func goToAddCardScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "goToAddCard", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getCards()
    }
    
    func getCards()
    {
        let parameters: [String: AnyObject] = [
            "ID"      : self.loginObj.id as AnyObject,
            ]
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname: "Client/PaymentCardList", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            self.cardsArr.removeAllObjects()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        let addressObj:CardModal = CardModal(fromDictionary: dict as NSDictionary)
                        self.cardsArr.add(addressObj)
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
        if cardsArr.count == 0
        {
            msgLbl.isHidden = false
        }else
        {
            msgLbl.isHidden = true
        }

        return cardsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cell : CardTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath as IndexPath) as! CardTableViewCell
        
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = NikkosCustomerManager.UIColorFromRGB(r: 254, g: 254, b: 255)
        }else
        {
            cell.backgroundColor = NikkosCustomerManager.UIColorFromRGB(r: 248, g: 249, b: 251)
        }
        let cardObj = cardsArr.object(at: indexPath.row) as! CardModal
        if cardObj.cardNumber != nil{
             cell.numberLbl.text = cardObj.cardNumber
        }else{
             cell.numberLbl.text = "**** **** **** ****"
        }
        if cardObj.name != nil{
            cell.nameLbl.text = cardObj.name
        }
        cell.activeBtn.isSelected = cardObj.isDefault
        cell.activeBtn.addTarget(self, action: #selector(pressedActive), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(pressedDelete), for: .touchUpInside)
        cell.deleteBtn.passId = cardObj.cardId
        cell.activeBtn.passId = cardObj.cardId

        
        return cell
    }
    @objc func pressedActive(sender: CustomButton!)
    {
        let parameters: [String: AnyObject] = [
                "ClientId"      : self.loginObj.id as AnyObject,
                "CardId"     : sender.passId as AnyObject,
                "Key"        : "" as AnyObject,
            ]
        WebServiceHelper.webServiceCall(methodname: "Client/SetDefaultPaymentCard", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.cardsArr.removeAllObjects()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.getCards()
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
    @objc func pressedDelete(sender: CustomButton!)
    {
        idForDelete = sender.passId
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        createAccountErrorAlert.delegate = self
        createAccountErrorAlert.title = NikkosCustomerManager.GetLocalString(textType: "AppName")
        createAccountErrorAlert.message = NikkosCustomerManager.GetLocalString(textType: "Do_You_Want_To_Delete_This_Card")
        createAccountErrorAlert.addButton(withTitle:"Cancel")
        createAccountErrorAlert.addButton(withTitle: "Ok")
        createAccountErrorAlert.show()
        
    }
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {

        switch buttonIndex
        {
        case 0:
            break;
        case 1:
            let parameters: [String: AnyObject] = [
                "CardId"     : idForDelete as AnyObject,
                ]
        //  NikkosCustomerManagemethodname: r.showHud()
            WebServiceHelper.webServiceCall(methodname: "Client/DeletePaymentCard", parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                //   NikkosCustomerManager.dissmissHud()
                self.cardsArr.removeAllObjects()
                if status == true
                {
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        self.getCards()
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
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        self.performSegue(withIdentifier: "showAddCardForm", sender: nil)
//    }
    
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
