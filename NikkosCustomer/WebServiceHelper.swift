//
//  WebServiceHelper.swift
//  MyHotPlaylist
//
//  Created by Anmol on 11/09/15.
//  Copyright (c) 2015 Dotsquares. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {
    
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func webServiceCall(methodname : String, parameter : NSDictionary, httpType: String, completeBlock:@escaping (_ status : Bool, _ data : NSDictionary?, _ error : NSError?)->()){
       
        
        if ReachabilityForInternet.isConnectedToNetwork()
        {
            //
            //let baseUrl = String("http://wds2.projectstatus.co.uk/OnthegoWds/api/") + methodname
            //let baseUrl = String("http://wds2.projectstatus.co.uk/OnthegoUAT/api/") + methodname
            //let baseUrl = String("http://192.168.0.120:8068/api/") + methodname
            //let baseUrl = String("http://192.168.0.148/OnTheGo/api/") + methodname
            
            //live
            let baseUrl = String("https://admin.onthegocab.com/api/") + methodname
            print(baseUrl)
            let uId = SharedStorage.getUserId()
            let url = NSURL(string: baseUrl)
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = httpType
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("n1@2t3h4e5go6", forHTTPHeaderField: "AuthorizationToken")
            request.addValue("En", forHTTPHeaderField: "UserLanguage")
            if (uId != "0"){
                let loginObj : LoginModal = SharedStorage.getUser()
                print(String(loginObj.countryId))
                request.addValue(String(loginObj.countryId), forHTTPHeaderField: "CountryId")
            }else{
                request.addValue("0", forHTTPHeaderField: "CountryId")
            }
            let timezoneoffset  = NSTimeZone.system.secondsFromGMT()
            print(timezoneoffset)
            request.addValue(String(format: "%d", timezoneoffset), forHTTPHeaderField: "UtcOffsetInSecond")
            
            request.timeoutInterval = 120;
            
            let err : NSError?
            err = nil
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: []);
            } catch _ {
            }
            do {
                if let postData : NSData = try JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData{
                    
                    let json = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                    print(json)
                    
                }
                
            }
            catch {
                print(error)
            }
            
            // var str : NSString = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)!
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(),
            //completionHandler:{ (response:URLResponse?, data: NSData?, error: NSError?) -> Void in
                
                 completionHandler: { (responseData, response, error) -> Void in
                
                
                    let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
                if response != nil{
                    var jsonResult: NSDictionary!
                    jsonResult = nil
                    do {
                       // NSLog(String(data: data!, encoding: NSUTF8StringEncoding)!)
                        jsonResult = try JSONSerialization.jsonObject(with: response!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    } catch _ {
                    }
                    
                    if jsonResult == nil{
//                        dispatch_async(dispatch_get_main_queue(),{
//                           completeBlock(status: false, data: jsonResult, error: err)
//                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(false, jsonResult, err)
                        }
                    }
                    else if jsonResult.value(forKey: "ResponseCode") != nil && (jsonResult.value(forKey:"ResponseCode") as! NSNumber == 303 || jsonResult.value(forKey:"ResponseCode") as! NSNumber == 300 || jsonResult.value(forKey:"ResponseCode") as! NSNumber == 301)
                    {
//                        dispatch_async(dispatch_get_main_queue(),{
//                            //ashish
//                            if jsonResult?.valueForKey("Data") != nil {
//                                completeBlock(status: true, data: jsonResult, error: err)
//                            }
//                            NikkosCustomerManager.dissmissHud()
//                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            if jsonResult?.value(forKey: "Data") != nil {
                                completeBlock(true, jsonResult, err)
                            }
                            NikkosCustomerManager.dissmissHud()
                        }
                    }
                    else if (jsonResult != nil) {
//                        dispatch_async(dispatch_get_main_queue(),{
//                            completeBlock(status: true, data: jsonResult, error: nil)
//                        })
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(true, jsonResult, nil)
                        }
                    }
                }
                else if error != nil{
//                    dispatch_async(dispatch_get_main_queue(),{
//                        completeBlock(status: false, data: nil, error: err)
//                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                }
                else{
//                    dispatch_async(dispatch_get_main_queue(),{
//                        completeBlock(status: false, data: nil, error: err)
//                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                }
            })
        }
        else
        {
            NikkosCustomerManager.dissmissHud()
            CIAlert("", "It seems that you have lost your internet access")
        }
    }
    
    static func uploadImage(image : UIImage, parameter : NSDictionary , completeBlock:@escaping (_ status : Bool, _ data : NSDictionary?, _ error : NSError?)->()){
        
        if ReachabilityForInternet.isConnectedToNetwork(){
            
            let boundary = generateBoundaryString()
            let data = UIImageJPEGRepresentation(image, 0.5)
            
            let dictImage = NSMutableDictionary()
            dictImage.setObject("img.png", forKey: "filename" as NSCopying)
            dictImage.setObject(data! , forKey: "fileData" as NSCopying)
            
            let arrImageData = NSArray(object: dictImage)
            
            let bodyData = createBodyWithParameters(parameters: parameter as? [String : AnyObject], filePathKey: "filename", files: arrImageData as! Array<Dictionary<String, AnyObject>>, boundary: boundary)
            
            
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: NSURL(string: "http://myhotplaylist.com/UploadImage.aspx")! as URL)
            request.addValue("8bit", forHTTPHeaderField: "Content-Transfer-Encoding")
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            var error: NSError?
            request.httpBody = bodyData as Data
            
            if let error = error {
                print("\(error.localizedDescription)")
            }
            
            var err : NSError?
            
            let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
                // Handle response
                var error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
                if data != nil{
                    
                    var jsonResult: NSDictionary!
                    jsonResult = nil
                    
                    do {
                        jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    } catch _ {
                    }
                    if jsonResult == nil{
                        
//                         dispatch_async(dispatch_get_main_queue(),{
//                            completeBlock(false, jsonResult, err)
//                        })
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(false, jsonResult, err)
                        }
                    }
                    else if jsonResult.value(forKey: "Status") != nil && (jsonResult.value(forKey: "Status") as! NSNumber == 201 || jsonResult.value(forKey: "Status") as! NSNumber == 300 || jsonResult.value(forKey: "Status") as! NSNumber == 301)
                    {
//                         dispatch_async(dispatch_get_main_queue(),{
//                            completeBlock(false, jsonResult, err)
//                        })
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(false, jsonResult, err)
                        }
                    }
                    else if (jsonResult != nil) {
//                         dispatch_async(dispatch_get_main_queue(),{
//                            completeBlock(true, jsonResult, nil)
//                        })
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(true, jsonResult, nil)
                        }
                    }
                }
                else if error != nil{
//                     dispatch_async(dispatch_get_main_queue(),{
//                        completeBlock(false, nil, err)
//                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                }
                else{
//                     dispatch_async(dispatch_get_main_queue(),{
//                        completeBlock(false, nil, err)
//                    })
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                }
                
            }
            
            dataTask.resume()
            
        }
        else
        {
            NikkosCustomerManager.dissmissHud()
        }
        
    }
    
    
    static func createBodyWithParameters(parameters: [String: AnyObject]?, filePathKey: String?, files : Array<Dictionary<String, AnyObject>>, boundary: String) -> NSData {
        
        var body : NSMutableData = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
        }
        
        
        for file in files {
            
            let filename : String = file["filename"] as! String
            let fileData : NSData = file["fileData"] as! NSData
            
            
            body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(filename)\"; filename=\"\(filename)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            body.append(fileData as Data)
            body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        }
        body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
        return body
    }
    
    
    static func generateBoundaryString() -> String {
        return "************"
    }
}

import Foundation
import SystemConfiguration

public class ReachabilityForInternet {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = __uint8_t(MemoryLayout.size(ofValue : zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}


