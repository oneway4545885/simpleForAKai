//
//  AmznTestViewController.swift
//  testAKai
//
//  Created by 王偉 on 3/9/17.
//  Copyright © 2017 王偉. All rights reserved.
//

//import UIKit
//import LoginWithAmazon
//import LFLiveKit
//
//class AmznTestViewController: UIViewController,LFLiveSessionDelegate{
//
//    lazy var session: LFLiveSession = {
//        let audioConfiguration = LFLiveAudioConfiguration.default()
//        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3, outputImageOrientation: UIInterfaceOrientation.unknown)
//        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
//
//        session?.delegate = self
//        session?.preView = self.view
//        return session!
//    }()
//
//    //MARK: - Event
//    func startLive() -> Void {
//        let stream = LFLiveStreamInfo()
//        stream.url = "your server rtmp url";
//        session.startLive(stream)
//    }
//
//    func stopLive() -> Void {
//        session.stopLive()
//    }
//
//    //MARK: - Callback
//    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?){
//
//    }
//    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode){
//
//    }
//    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState){
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }

//}
