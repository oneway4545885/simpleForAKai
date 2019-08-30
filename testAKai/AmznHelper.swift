//
//  AmznHelper.swift
//  testAKai
//
//  Created by 王偉 on 3/9/17.
//  Copyright © 2017 王偉. All rights reserved.
//
//import LoginWithAmazon
//import UIKit
//
//class AmznHelper: NSObject {
//
//    
//    func checkIsUserSignedIn(){
//        
////        let request = AMZNAuthorizeRequest()
////        request.scopes = [AMZNProfileScope.profile]
////        request.interactiveStrategy = AMZNInteractiveStrategy.never
////     //   AMZNAuthorizationManager.shared().authorize(request, withHandler:self.requestHandler())
////        
//    }
//    
//    
//    
//    func requestHandler() -> AMZNAuthorizationRequestHandler {
//        
//        let requestHandler:AMZNAuthorizationRequestHandler = ({ result,userDidCancel,error in
//            
//            if error != nil {
//                guard let nsError = error as? NSError else {return}
//                if UInt(nsError.code) == kAIApplicationNotAuthorized {
//                    //                    [self showLogInPage];
//                }else{
//                    let errorMessage:String = nsError.userInfo["AMZNLWAErrorNonLocalizedDescription"] as! String
//                    UIAlertView(title: "", message: String(format:"Error occured with message: %@", errorMessage), delegate: nil, cancelButtonTitle: "ok").show()
//                    
//                }
//                
//            }else if userDidCancel {
//                // Your code to handle user cancel scenario.
//                
//            } else{
//                // Authentication was successful. Obtain the user profile data.
//                //let user:AMZNUser = result!.user!;
//                //self.userProfile = user.profileData;
//                //[self loadSignedInUser];
//            }
//            
//        
//       })
//         return requestHandler
//    }
//
//    
//    
//}
