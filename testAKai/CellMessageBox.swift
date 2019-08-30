//
//  CellMessageBox.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/11.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CellMessageBox: UICollectionViewCell{

    @IBOutlet weak var npcIconView: UIImageView!
    
    var loadingView:LoadingView!
    var npcName:String!
    var content:UILabel!
    var mainView:UIView!
    var picView:UIImageView!
    var needAnswer:Bool = false
    var parentVC:UIViewController!
    var model:MessageModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // npc icon cut to circle
        npcIconView.layer.masksToBounds = false
        npcIconView.layer.cornerRadius = npcIconView.frame.height/2
        npcIconView.clipsToBounds = true
        
    }

    
    
    func addMessageBox(message:MessageModel,vc:UIViewController,block:(Bool)->Void){
        
        parentVC = vc
        model = message
        npcIconView.image = UIImage(named:npcName)
        
        self.cleanView()
        
        // 藉由有無圖片判定跑哪個method
        if message.video != nil {
            self.addVideoBox(message: message)
        }else if message.pic != nil{
            self.addImageBox(message: message)
        }else if message.message != nil{
            self.labelSetting(message: message)
        }else{
            self.toGetLocation(message:message)
        }

        block(true)
    }
//
    func toGetLocation(message:MessageModel){
        
        let labelFrame = CGRect(x:12,y:12,width:200,height:150);
        content = UILabel(frame: labelFrame)
        content.textColor = .black
        content.text = "無法取得定位資訊 請按對話框前往設定"
        content.numberOfLines = 0
        content.sizeToFit()
        
        let viewWidth = content.bounds.width + 24
        let viewHeight = content.bounds.height + 24
        
        mainView = UIView(frame: CGRect(x:36.0,
                                        y:0,
                                        width:viewWidth,
                                        height:viewHeight))
        mainView.backgroundColor = UIColor.init(red:(220/255.0),
                                                green:(221/255.0),
                                                blue:(222/255.0), alpha: 1)
        mainView.layer.cornerRadius = 15
        mainView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(goToSettting))
        mainView.addGestureRecognizer(tap)
        mainView.addSubview(content)
        self.addSubview(mainView)
        
    }
// 純文字方塊
    func labelSetting(message:MessageModel){
        
        
        let screenWidth = self.bounds.width
        
        var labelColor:UIColor!
        var viewColor:UIColor!
        var viewPosition:CGFloat
        // npc 回覆 or 玩家
        if message.senderName == "npc" {
            
            npcIconView.isHidden = false
            labelColor = .black
            viewColor = UIColor.init(red:(220/255.0),
                                     green:(221/255.0),
                                     blue:(222/255.0), alpha: 1)
        }else{
            npcIconView.isHidden = true
            labelColor = .white
            viewColor = UIColor.init(red:(0/255.0),
                                     green:(132/255.0),
                                     blue:(255/255.0), alpha: 1)
            
        }
        
        let labelFrame = CGRect(x:12,y:12,width:200,height:150);
        content = UILabel(frame: labelFrame)
        content.textColor = labelColor
        content.text = message.message
        content.numberOfLines = 0
        content.sizeToFit()
        
        let viewWidth = content.bounds.width + 24
        let viewHeight = content.bounds.height + 24
        
        if message.senderName == "npc" {
            viewPosition = 36.0
        }else{
            viewPosition = (screenWidth - viewWidth) - 20
        }
        
        mainView = UIView(frame: CGRect(x:viewPosition,
                                      y:0,
                                      width:viewWidth,
                                      height:viewHeight))
        mainView.backgroundColor = viewColor
        mainView.layer.cornerRadius = 15
        mainView.layer.masksToBounds = true
        
        
        mainView.addSubview(content)
        self.addSubview(mainView)
    }
func addVideoBox(message:MessageModel){
        
        npcIconView.isHidden = false
    
        mainView = UIView(frame: CGRect(x:36.0,
                                      y:0,
                                  width:200,
                                  height:180))
        mainView.backgroundColor = .black
    
        let tool:ImageTool = ImageTool()
        let image = tool.getImage(path:message.pic!)
//        let webView = UIWebView(frame:CGRect(x:0,y:0,width:200,height:182))
//        let url = String(format:"<iframe width=\"200\" height=\"180\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>",message.video!)
//        webView.loadHTMLString(url, baseURL: nil)
//        mainView.addSubview(webView)
//        self.addSubview(mainView)
        let imageView = UIImageView(frame:mainView.bounds)
        imageView.image = image
    
        mainView.layer.cornerRadius = 15
        mainView.layer.masksToBounds = true
    
        let btn = UIButton(frame:CGRect(x: mainView.bounds.width/2 - 32, y: mainView.bounds.height/2 - 22, width: 64, height: 44))
        btn.setImage(UIImage(named:"YouTube-icon-full"), for: .normal)
        btn.imageView?.contentMode = .scaleToFill
        btn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        mainView.addSubview(imageView)
        mainView.addSubview(btn)
        self.addSubview(mainView)
    
    
    }
// 
    @objc func playVideo(){
        if model.message != nil {
            let videoURL = NSURL(string: "https://firebasestorage.googleapis.com/v0/b/testakay-5d729.appspot.com/o/demo.mov?alt=media&token=94d0919f-1b88-49a9-a696-825eec7cfe4d")
            let player = AVPlayer(url: videoURL! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            parentVC.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }else{
            let arry = model.video?.components(separatedBy: "/")
            //let url = String(format:"https://www.youtube.com/watch?v=%@&autoplay=1",(arry?.last!)!)
            let vc = parentVC.storyboard?.instantiateViewController(withIdentifier:"displayVideoVC") as! DisplayVideoViewController
            vc.id = arry?.last! as String?
            let navi = UINavigationController(rootViewController:vc)
            
            parentVC.present(navi, animated: false , completion: nil)
            
        }
        
        
    }
    
// ImageBox
    
    func addImageBox(message:MessageModel){
        let screenWidth = self.bounds.width
        let tool:ImageTool = ImageTool()
        let image = tool.getImage(path:message.pic!)
        let picWidth = tool.getImageSize(image:image).width
        let picHeight = tool.getImageSize(image:image).height
        
        var viewPosition:CGFloat
        
        
        if message.senderName == "npc" {
            
            npcIconView.isHidden = false
            viewPosition = 36.0
            
        }else{
            
             npcIconView.isHidden = true
             viewPosition = (screenWidth - picWidth)-20
        }
        
        picView = UIImageView(frame:CGRect(x:viewPosition, y:0, width: picWidth, height: picHeight))
        picView.image = image
        picView.layer.cornerRadius = 15
        picView.layer.masksToBounds = true
        picView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        picView.addGestureRecognizer(tap)
        self.addSubview(picView)
    }
// image tap method
    @objc func tapImage(){
        
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier:"displayImageVC") as! DisplayImageViewController
        let image =  picView.image
        vc.image =  image
        vc.isDisplayOnly = true
        parentVC.present(vc, animated: false, completion: nil)
    }
// waiting Request view
    func waitingRequest(){

        self.cleanView()
        
        npcIconView.image = UIImage(named: npcName)
        npcIconView.isHidden = false
        
        mainView = UIView(frame: CGRect(x:36,y:0,width:64,height:44))
        loadingView = LoadingView(frame:mainView.bounds)
        loadingView.loadingAnimate(width:mainView.bounds.width,height:mainView.bounds.height)
        mainView.addSubview(loadingView)
        mainView.backgroundColor = UIColor.init(red:(220/255.0), green:(221/255.0), blue:(222/255.0), alpha: 1)
        mainView.layer.cornerRadius = 15
        mainView.layer.masksToBounds = true
        
        self.addSubview(mainView)
    }
    
    @objc func goToSettting(){
        
        
        UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
        
    }
    
    
// MARK: clean view 
    func cleanView(){
        
        if content != nil {
            
            self.content .removeFromSuperview()
            self.content  = nil
            
        }
        if mainView != nil {
            self.mainView.removeFromSuperview()
            self.mainView = nil
        }
        if picView != nil {
            
            self.picView.removeFromSuperview()
            self.picView = nil
        }

    }
    
}
