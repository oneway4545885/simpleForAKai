//
//  LocalNotification.swift
//  testAKai
//
//  Created by 王偉 on 2/21/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import UserNotifications
class LocalNotification: NSObject {
/**
  *  本地推播
  */
    @available(iOS 10.0, *)
    func registerNotification(title:String,message:String,alertTime:NSInteger){
        
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
        content.sound = UNNotificationSound.default
        
    let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval:TimeInterval(alertTime), repeats: false)
    let request = UNNotificationRequest.init(identifier:"FiveSecond",content:content,trigger:trigger)
        
    center.add(request, withCompletionHandler:{error in
            let alert = UIAlertController(title:"", message:".0.", preferredStyle:.alert)
            let cancelAction = UIAlertAction(title:"取消", style:.cancel, handler:nil)
            alert.addAction(cancelAction)
            
    })
}

    
}
