//
//  LanguageSelectController.swift
//  NikkosCustomer
//
//  Created by Umang on 9/13/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class LanguageSelectController: UIViewController,NIDropDownDelegate
{
    @IBOutlet var btnSelect: UIButton!
    var dropDown: NIDropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientImage = UIImage(named: "top_bar_bg.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        if SharedStorage.getIsRememberMe() == true
        {
            NikkosCustomerManager.appDelegate.loadHomeViewController()
        }else if SharedStorage.getLanguageScreenAccess() == true
        {
          NikkosCustomerManager.appDelegate.loadSignInViewController()
        }
        self.title = NikkosCustomerManager.GetLocalString(textType: "Language")
        let prefs = UserDefaults.standard
        let myString = prefs.string(forKey: NikkosCustomerManager.k_USER_LANG)
        //btnSelect.setTitle(myString, for : .normal)
        btnSelect.setTitle(myString, for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectClicked(_ sender: Any) {
        var arr = [AnyObject]()
        //arr = [NikkosCustomerManager.k_ENGLISH,NikkosCustomerManager.k_FRENCH, NikkosCustomerManager.k_SPENSISH]
        arr = [NikkosCustomerManager.k_ENGLISH,NikkosCustomerManager.k_FRENCH] as [AnyObject]
        if dropDown == nil {
            var f: CGFloat = 80
            var index :Int32 =  0
            let prefs = UserDefaults.standard
            let myString = prefs.string(forKey: NikkosCustomerManager.k_USER_LANG)
            if (myString == NikkosCustomerManager.k_FRENCH) {
                index = 1
            }
            else if (myString == NikkosCustomerManager.k_SPENSISH) {
                  index = 2
            }
            else {
                 index = 0
            }
            dropDown = NIDropDown().show(sender as! UIButton, &f, arr, nil, "down",index) as! NIDropDown
            dropDown.delegate = self
        }
        else {
            dropDown.hide(sender as! UIButton)
            self.rel()
        }
    }
    
    func niDropDownDelegateMethod(_ sender: NIDropDown) {
        self.rel()
        print("\(btnSelect.titleLabel!.text!)")
        //["English", "French", "Spanish"]
        if ( (btnSelect.currentTitle)) == NikkosCustomerManager.k_ENGLISH
        {
            SharedStorage.setLanguage(language: NikkosCustomerManager.k_ENGLISH)
        }
        else if ( (btnSelect.currentTitle)) == NikkosCustomerManager.k_FRENCH
        {
            SharedStorage.setLanguage(language: NikkosCustomerManager.k_FRENCH)
        }else
        {
            SharedStorage.setLanguage(language: NikkosCustomerManager.k_SPENSISH)
        }
    }
    
    func rel() {
        //[dropDown release];
        dropDown = nil
    }
    @IBAction func confirmBtnPress(_ sender: Any)
    {
        SharedStorage.setLanguageScreenAccess(isRememberMe: true)
        NikkosCustomerManager.appDelegate.loadSignInViewController()
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
