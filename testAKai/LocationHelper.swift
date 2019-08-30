//
//  LocationHelper.swift
//  testAKai
//
//  Created by 王偉 on 2/15/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import CoreLocation




class LocationHelper: NSObject,CLLocationManagerDelegate {

/**
  *   CLLocationManager
  */
    
var locationManager:CLLocationManager!
    
/**
  *   目前經緯度
  */
    
var currentLocation:CLLocation!
 
/**
  *   Singleton
  */
class var shared : LocationHelper {
        
    struct Static {
        static let instance : LocationHelper = LocationHelper()
    }
        
    return Static.instance
}

/**
  *   CLLocationManager start search
  */
func startLocation(){
    locationManager = CLLocationManager()
    locationManager.activityType = .automotiveNavigation
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
}
    
/**
  *   Get address from location
  */
func getAddress(obj:String,vc:UIViewController,block:@escaping(LocationModel)->Void){
        
    let geocoder = CLGeocoder()
    
    guard let location = self.currentLocation else {
        // 檢查定位權限
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse &&
            UIApplication.shared.applicationState == UIApplication.State.active {
                
            Alert().alert(title:"無法取得權限",
                          message:"請前往 \n設定 -> 隱私權 -> 定位 \n 將本 App 的隱私權開啟\n方能使用本功能", vc:vc)
                
        }
        // 重新執行 定位
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
        
            self.startLocation()
            self.getAddress(obj:obj,vc:vc,block:{location in
                        
                let messageVC = vc as! MessageViewController
                messageVC.placeAnalysis(obj: obj)
            })
        }
            return
    }
    // placemark 轉換成 address
    geocoder.reverseGeocodeLocation(location, completionHandler:{placemarks,error in
        
        for placemark in placemarks! {
                
            let locationDic = LocationModel()
            locationDic.setLocation(dic:placemark.addressDictionary)
                
            block(locationDic)
        }
    })
        
}
    
    
    
/**
  *   CLLocationManager Delegate
  */
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    currentLocation = locations.last
        
}
    
}


