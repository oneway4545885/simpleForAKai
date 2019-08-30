//
//  DisplayVideoViewController.swift
//  testAKai
//
//  Created by 王偉 on 2/13/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import YouTubePlayer

class DisplayVideoViewController: UIViewController, UIWebViewDelegate,YouTubePlayerDelegate{

    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var player: YouTubePlayerView!
    var id:String!
    var videoPlayer:YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//       let videoPlayer = YouTubePlayerView(frame: self.view.bounds)
//       videoPlayer.loadVideoURL(url)
//        
//       videoPlayer.play()
        
//      web.delegate = self
//      web.loadRequest(URLRequest(url: url!))
        
       // self.playerView.load(withVideoId: id)
    
        videoPlayer = YouTubePlayerView(frame: self.view.frame)
        videoPlayer.delegate = self
        self.view.addSubview(videoPlayer)
        videoPlayer.loadVideoID(id)
        
        
    }
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.play()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        print(request.url!)
        return true
}
@IBAction func btn_dismiss(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
}

}
