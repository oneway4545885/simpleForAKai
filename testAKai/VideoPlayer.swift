//
//  VideoPlayer.swift
//  testAKai
//
//  Created by 王偉 on 2/8/17.
//  Copyright © 2017 王偉. All rights reserved.
//
import AVKit
import AVFoundation
import UIKit
class VideoPlayer: NSObject {
    
//    func videoPlayer(vc:UIViewController,location:String){
//        
//        let videoURL = NSURL(fileURLWithPath:location)
//        let player = AVPlayer(url: videoURL as URL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        
//        vc.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//    }
    
/**
  *  play online video
  */
func playOnlineVideo(vc:UIViewController,urlString:String){
        
    let videoURL = URL(string:urlString)!
    let player = AVPlayer(url: videoURL as URL)
    let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        vc.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
}

}
