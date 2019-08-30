//
//  MessageModel.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/11.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class MessageModel: NSObject,NSCoding{

    var senderName:String!
    var message:String?
    var pic:String?
    var style:Int?
    var video:String?

    override init() {
        super.init()
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.senderName = aDecoder.decodeObject(forKey: "senderName") as! String
        self.message = aDecoder.decodeObject(forKey: "message") as? String
        self.pic = aDecoder.decodeObject(forKey: "pic") as? String
        self.video = aDecoder.decodeObject(forKey: "video") as? String
        self.style = aDecoder.decodeObject(forKey: "style") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.senderName, forKey:"senderName")
        aCoder.encode(self.message, forKey:"message")
        aCoder.encode(self.pic, forKey:"pic")
        aCoder.encode(self.style, forKey:"style")
        aCoder.encode(self.video, forKey:"video")
    }
    
    
}
