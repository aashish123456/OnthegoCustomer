//
//  PCServerCommunicator.m
//  PopCab
//
//  Created by Vasim Akram on 27/07/15.
//  Copyright (c) 2015 Dheeraj. All rights reserved.
//

#import "PCServerCommunicator.h"

@implementation PCServerCommunicator


+(void)GetDataForMethod:(NSString *)serviceName withParameters:(NSDictionary *)param onCompletion:(CompletionHandler)handlar{
    NSString *urlString = [NSString stringWithFormat:@"http://wds2.projectstatus.co.uk/OnthegoWds/api/%@",serviceName];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"n1@2t3h4e5go6" forHTTPHeaderField:@"AuthorizationToken"];
    [request setValue:@"En" forHTTPHeaderField:@"UserLanguage"];
    
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = requestBodyData;
    
    request.timeoutInterval = 120.0;
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Got Response :%@",strData);
        
        NSError *error;
        if (data==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handlar(NO, connectionError, nil);
                });
            return;
        }
        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (jsonResult != nil){
            if([[jsonResult objectForKey:@"responsecode"] integerValue] == 0){
                //Success
                dispatch_async(dispatch_get_main_queue(), ^{
                    handlar(YES, nil, jsonResult);
                });
                
            }
            else{
                //faliour
                dispatch_async(dispatch_get_main_queue(), ^{
                    handlar(NO, nil, jsonResult);
                });
                
            }
        }
        else if (error != nil) {
            NSLog(@"JSON Parsing error !!!");
            dispatch_async(dispatch_get_main_queue(), ^{
                handlar(NO, error, nil);
            });
        }
        else{
            NSLog(@"Some error !!!");
            dispatch_async(dispatch_get_main_queue(), ^{
                handlar(NO, connectionError, nil);
            });
        }
        
    }];
}


@end