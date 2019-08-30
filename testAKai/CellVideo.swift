//
//  CellVideo.swift
//  testAKai
//
//  Created by 王偉 on 2/8/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class CellVideo: UICollectionViewCell {
    var parent:UIViewController!
    var npc:String!
    var model:MessageModel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelBgView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.masksToBounds = false
        iconView.layer.cornerRadius = iconView.frame.height/2
        iconView.clipsToBounds = true
   
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 15
        
        let color = UIColor.black
        labelBgView.backgroundColor = color.withAlphaComponent(0.5)
        
        
        btnPlay.addTarget(self ,action:#selector(playVideo), for: .touchUpInside)
        
    }
    

    func addVideoBox(message:MessageModel){
        
        model = message
        
        imageView.image = ImageTool().getImage(path:model.pic!)
        iconView.image = UIImage(named:npc)
        
        
    }
    

    @objc func playVideo(){
        
        VideoPlayer().playOnlineVideo(vc: parent, urlString: model.video!)
        
    }
}
