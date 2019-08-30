//
//  LocationModel.swift
//  testAKai
//
//  Created by 王偉 on 2/16/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class LocationModel: NSObject {
    
    var city:String?
    var state:String?
    var name:String?
    var country:String?
    var address:String?
    var zip:String?
    
    func setLocation(dic:[AnyHashable : Any]?){
        
        address = ""
        
        if ((dic?["Country"]) != nil){
            country = dic?["Country"] as? String
            address?.append(country!)
        }else{
            country = ""
        }
        if ((dic?["City"]) != nil){
            city = dic?["City"] as? String
            address?.append(city!)
        }else{
            city = ""
        }
        if ((dic?["Name"]) != nil){
            name = dic?["Name"] as? String
            address?.append(name!)
        }else{
            name = ""
        }

        state = dic?["State"] as! String?
        zip = dic?["ZIP"] as! String?
        
        
    }
}
