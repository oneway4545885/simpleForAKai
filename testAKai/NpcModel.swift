//
//  NpcModel.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/10.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit



class NpcModel: NSObject {

    var npcName:String!
    var npcImage:String!
    var npcStory:NSMutableArray!
    

    func setNPC(dic:Dictionary<String,String>) -> NpcModel{
    
        self.npcName = dic["NPC_name"]
        self.npcImage = dic["NPC_image"]

        return self
    }
}
