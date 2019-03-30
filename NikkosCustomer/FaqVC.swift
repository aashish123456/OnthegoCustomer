//
//  FaqVC.swift
//  NikkosCustomer
//
//  Created by Umang on 11/10/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class FaqVC: UIViewController,SWRevealViewControllerDelegate {

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var myWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosCustomerManager.GetLocalString(textType: "FAQ")
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
//        let url = NSURL (string: NikkosCustomerManager.baseURL);
//        let requestObj = NSURLRequest(url: url! as URL);
       // myWebView.loadRequest(requestObj);

        // Do any additional setup after loading the view.
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
