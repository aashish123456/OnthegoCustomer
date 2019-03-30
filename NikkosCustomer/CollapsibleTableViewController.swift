//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit

//
// MARK: - Section Data Structure
//
struct Section
{
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

//
// MARK: - View Controller
//
class CollapsibleTableViewController: UITableViewController,SWRevealViewControllerDelegate {
    
    var sections = [Section]()
     @IBOutlet weak var sideBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.title = NikkosCustomerManager.GetLocalString(textType: "Apple_products")
        
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
//        sections = [
//            Section(name: "Mac", items: ["MacBookdsfsdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadfasdfasdfasd"]),
//            Section(name: "iPad", items: ["MacBookdsfsdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadfasdfasdfasd"]),
//            Section(name: "iPhone", items: ["MacBookdsfsdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadfasdfasdfasd"]),
//        ]
        
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

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.separatorStyle = .none
        getFaq()
    }
    
    func getFaq()
    {
        sections.removeAll()
        NikkosCustomerManager.showHud()
        WebServiceHelper.webServiceCall(methodname : "CommonDirectAuthori/GetFaq", parameter: [:], httpType: "POST") { (status, data, error) -> () in
            NikkosCustomerManager.dissmissHud()
            
            
            
            if status == true
            {
                
                print(data)
                
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let tempArr =       ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    
                    for dict in tempArr
                    {
                        
                        let faqObj:FaqModal = FaqModal(fromDictionary: dict as NSDictionary)
                        self.sections.append(Section(name: faqObj.question, items:[faqObj.answer]))
                    }
                    
                    self.tableView.reloadData()
                }else
                {
                    self.tableView.reloadData()
                    //CIError(data?.valueForKey("Status") as! String)
                }
            }
            else
            {
                self.tableView.reloadData()
                //  CIError("OOPs something went wrong.")
            }
            
        }
        
    }

    
}


//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // Cell
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].collapsed! ? 0 : UITableViewAutomaticDimension
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(collapsed: sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [NSIndexPath(row: i, section: section) as IndexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
}
