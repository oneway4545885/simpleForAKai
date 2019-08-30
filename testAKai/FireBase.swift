//
//  FireBase.swift
//  testAKai
//
//  Created by 王偉 on 2/8/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

@available(iOS 10.0, *)
@available(iOS 10.0, *)
@available(iOS 10.0, *)
class FireBase: NSObject {

/**
  *  笑話 Data
  */
func jokeData(npc:String,obj:String,
              block:@escaping (_ obj:String,_ model:MessageModel)->Void){
        
    let ref = Database.database().reference().child("joke")
    
        ref.observe(.value, with: { (snapshot) in
            
            let jokes = snapshot.value as! NSArray
            let random = arc4random() % UInt32(jokes.count)
            let model = MessageModel()
            model.senderName = "npc"
            model.message = jokes.object(at: Int(random)) as? String
            
            LocalNotification().registerNotification(title:npc,
                                                     message:model.message!,
                                                     alertTime:5)
            
            block(obj,model)
        })
}
/**
  *   圖片 Data
  */
func imageData(npc:String,obj:String,
               block:@escaping (_ obj:String,_ model:MessageModel)->Void){
        
    let ref = Database.database().reference().child("image")
    
        ref.observe(.value, with: { (snapshot) in
            
            let images = snapshot.value as! NSArray
            let random = arc4random() % UInt32(images.count)
            let url = URL(string: images.object(at: Int(random)) as! String)
            ImageTool().getDataFromUrl(url: url!, completion: { (data, response, error) in
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    let model = MessageModel()
                    model.senderName = "npc"
                    model.pic = ImageTool().saveImage(image:image!)
                    
                   
                    LocalNotification().registerNotification(title:npc,
                                                             message:"向你傳送一張圖片",
                                                             alertTime:5)
                    
                    block(obj,model)
               }
           })
       })
}
/**
  *   Youtube 影片
  */
func videoData(npc:String,obj:String,
                   block:@escaping (_ obj:String,_ model:MessageModel)->Void){
        
    let ref = Database.database().reference().child("video")
    ref.observe(.value, with: { (snapshot) in
            
        let videos = snapshot.value as! NSArray
        let random = arc4random() % UInt32(videos.count)
        let url = videos.object(at: Int(random)) as! String
            
        let model = MessageModel()
        model.senderName = "npc"
        model.video = url
            
        let arry = url.components(separatedBy:"/")
        let imageUrl:URL = URL(string:String(format:"https://img.youtube.com/vi/%@/0.jpg",arry.last!))!
        ImageTool().getDataFromUrl(url: imageUrl, completion: { (data, response, error) in
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                model.pic = ImageTool().saveImage(image:image!)
                
                LocalNotification().registerNotification(title:npc,
                                                        message:"傳送一個影片",
                                                      alertTime: 5)
                block(obj,model)
            }
        })
    })
}
/**
  *   一般影片
  */
func videoInAPP(npc:String,obj:String,
                block:@escaping (_ obj:String,_ model:MessageModel)->Void){
        
    let ref = Database.database().reference().child("inFirebase")
        
    ref.observe(.value, with: { (snapshot) in
            
        let videos = snapshot.value as! NSArray
        let random = arc4random() % UInt32(videos.count)
        let url = videos.object(at: Int(random)) as! String
            
        let model = MessageModel()
        model.senderName = "npc"
        model.video = url
        model.message = "..."
        
        DispatchQueue.global().async {
                
            let vidURL = URL(string:url)
            let asset = AVURLAsset(url: vidURL! as URL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
                
            do{
                let imageRef = try generator.copyCGImage(at: timestamp,
                                                         actualTime: nil)
                
              DispatchQueue.main.async {
                    model.pic = ImageTool().saveImage(image:UIImage(cgImage: imageRef))
                    LocalNotification().registerNotification(title:npc,
                                                            message:"傳送一個影片",
                                                            alertTime:5)
                    block(obj,model)
              }
            }catch let error as NSError{
                    print("Image generation failed with error \(error)")
            }
        }
    })
}
/**
  *   一般影片
  */
func gifData(npc:String,obj:String,
                    block:@escaping (_ obj:String,_ model:MessageModel)->Void){
        
    let ref = Database.database().reference().child("gif")
        
        ref.observe(.value, with: { (snapshot) in
            
            let gifs = snapshot.value as! NSArray
            let random = arc4random() % UInt32(gifs.count)
            let url = gifs.object(at: Int(random)) as! String
            
            let model = MessageModel()
            model.senderName = "npc"
            model.video = url
            model.message = "..."

        })
}
    
    
}
