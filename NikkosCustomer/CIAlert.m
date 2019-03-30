//
//  CIAlert.m
//  Rondo
//
//  Created by Kjostinden on 20.07.11.
//  Copyright 2011 Creative Intersection. All rights reserved.
//

#import "CIAlert.h"
#import "OnthegoCustomer-Swift.h"
void CIAlert(NSString* title, NSString* alert) {
    
    //var text = NikkosCustomerManager.GetLocalString(textType: "AppName")
    //NSString * strName =  [NikkosCustomerManager GetLocalString:@"AppName"];
//    NSString * strName =  @"Onthego";
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:
//                              strName message:alert delegate:nil
//                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
//  [alertView show];
    
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController * alertController = [UIAlertController
                                 alertControllerWithTitle:@"Onthego"
                                 message:alert
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Ok"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               // [topWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
                               }];
    
    //Add your buttons to alert controller
    [alertController addAction:okButton];
    
    [topWindow makeKeyAndVisible];
    //if (topWindow.rootViewController.presentedViewController != nil){
        //[topWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }else{
//        [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
    
    
    
}

void CIError(NSString* error) {
    //[NikkosCustomerManager GetLocalString:@"AppName"];
  CIAlert(@"Onthego", error);
}

