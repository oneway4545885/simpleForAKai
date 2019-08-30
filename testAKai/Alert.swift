//
//  Alert.swift
//  testAKai
//
//  Created by 王偉 on 2/20/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    
/**
  *   default alert
  */
func alert(title:String?,message:String?,vc:UIViewController){
        
    let alert = UIAlertController(title:title, message: message, preferredStyle:.alert)
    let ok = UIAlertAction(title:"確定", style: .default, handler:{_ in
        
        UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        
    })
    let cancel = UIAlertAction(title:"取消", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
}
