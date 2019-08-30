//
//  MessageViewController.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/10.
//  Copyright © 2017年 王偉. All rights reserved.
//
import Firebase
import UIKit 
import AVFoundation
import Photos

class MessageViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
UITextFieldDelegate,UINavigationControllerDelegate,SelectImageDelegate{

// MARK: Property
    
    // Selection CollectionView Height
    @IBOutlet weak var layoutSelectionHeight: NSLayoutConstraint!
    // Btn Send Message
    @IBOutlet weak var btnSend: UIButton!
    // TextField display selection
    @IBOutlet weak var textField: UITextField!
    // Selection CollectionView
    @IBOutlet weak var selectionCollection: UICollectionView!
    // Main CollectionView
    @IBOutlet weak var collecttionView: UICollectionView!
    // Btn to Image Picker
    @IBOutlet weak var btnImage: UIButton!
 
    let imagePicker = UIImagePickerController()
    var npc:NpcModel!
    var selectIndex:IndexPath?
    var messages:NSMutableArray! = NSMutableArray()
    let fakeDatas:NSArray! = ["說個笑話吧","給個圖片吧","出去外面看","在app裡看","猜猜我在哪？"]
    var canRequest:Bool!
    var userDefault = UserDefaults.standard
    var needScrollToBot:Bool! = true
    var lastContentOffset:CGPoint! = CGPoint(x:0,y:0)
    var swipeUP:Bool = false
    
// MARK: View func
    override func viewDidLoad() {
        super.viewDidLoad()
        // imageTool delegate
        let imageTool = ImageTool.shared
        imageTool.delegate = self
        
        self.canRequest = true
        // get navigation title
        self.title = npc.npcName
        
        // 聊天記錄
        self.loadMessages()
        // 送出按鈕 不給案
        self.btnSend.isEnabled = false
        self.btnSend.addTarget(self, action:#selector(sendMessage), for: .touchUpInside)
        
        // 將選項縮小
        self.layoutSelectionHeight.constant = 0
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        self.collecttionView.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let model = self.messages.lastObject as? MessageModel {
            if model.senderName == "self"{
                
                var image:UIImage!
                if model.pic != nil {
                    let tool:ImageTool = ImageTool()
                    image = tool.getImage(path:model.pic!)
                }
                self.randomWaiting(style:model.style!,image:image)
                canRequest = false
                self.canRequest(bool: false)
            }
        }
    }
//MARK: UIGestureRecognizer
    // 收起選項
    @objc func tap(sender:UITapGestureRecognizer){
        self.layoutSelectionHeight.constant = 0
    }
//MARK: ScrollView func
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let currentOffset:CGPoint = scrollView.contentOffset;
//        
//        if scrollView == self.selectionCollection {
//            return
//        }
//        
//        
//        print(currentOffset.y + self.lastContentOffset.y)
//        
//        if (currentOffset.y >= self.lastContentOffset.y)
//        {
//            if offsetY > contentHeight - scrollView.frame.size.height {
//                
//                self.layoutSelectionHeight.constant = 250
//                self.selectionCollection.reloadData()
//                self.collecttionView.reloadData()
//                
//                if messages.count > 0 {
//                    self.delayScroll(delay: 0.1)
//                }
//            }
//        }
//        else if self.lastContentOffset.y - currentOffset.y >= 15
//        {
//           
//            if scrollView.isZoomBouncing {
//                self.layoutSelectionHeight.constant = 0
//            }
//        }
//        self.lastContentOffset = currentOffset;
//        
//    }
    
    
//MARK: IBAction
    @objc func sendMessage(){
        self.canRequest = false
        let string = fakeDatas.object(at:(selectIndex?.row)!) as! String
        
        let model = MessageModel()
        model.message = string
        model.senderName = "self"
        model.style = (selectIndex?.row)! + 1
        self.messages.add(model)
        self.saveMessages()
        
        self.layoutSelectionHeight.constant = 0
        self.selectIndex = nil
        
        self.canRequest(bool: false)

        
        let delayInSeconds = Double(arc4random()%3)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            
            self.randomWaiting(style:model.style!,image:nil)
        }
        
    }
    @IBAction func btn_sendImage(_ sender: Any) {
//            PHPhotoLibrary.requestAuthorization({ status in
//            
//                if status == PHAuthorizationStatus.authorized{
//                    let imagePickerVC = self.storyboard?.instantiateViewController(withIdentifier:"imagePickerVC")
//                    let  navi = UINavigationController(rootViewController: imagePickerVC!)
//                    self.present(navi, animated: true, completion: nil)
//                }else{
//                    
//                    Alert().alert(title:"無法取得權限", message:"請前往 \n設定 -> 隱私權 -> 照片 \n 將本 App 的隱私權開啟\n方能使用本功能", vc: self)
//                    
//                }
//            })
    }
    
    
//MARK: UITextField
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        // open chat selection
        self.layoutSelectionHeight.constant = 250
        self.selectionCollection.reloadData()
        self.collecttionView.reloadData()
        
        if messages.count > 0 {
            self.delayScroll(delay: 0.1)
        }
        
        return false
    }
    
//MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collecttionView {
            
            return messages.count
            
        }else if collectionView == selectionCollection{
            
            if canRequest == true{
                return fakeDatas.count
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collecttionView {
             // 聊天列表 CollectionView
            var collectCell:CellMessageBox!
            
            
            if indexPath.row != 0 {
                
                collectCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellMessageBox", for: indexPath) as? CellMessageBox
            }
            
            if collectCell == nil {
                let nib = UINib(nibName:"CellMessageBox", bundle:nil)
                collectionView.register(nib, forCellWithReuseIdentifier:"cellMessageBox")
                collectCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellMessageBox",
                                                                 for: indexPath) as? CellMessageBox
            }
            
            
            collectCell.npcName = npc.npcImage
            
            if type(of:messages.object(at: indexPath.row)) == type(of: MessageModel()) {
                
                
                collectCell.addMessageBox(message: messages.object(at: indexPath.row) as! MessageModel,vc:self,block:{_ in
                    
                    if needScrollToBot == true {
                        
                        self.collecttionView.scrollToItem(at:IndexPath(row:self.messages.count-1, section:0),at:UICollectionView.ScrollPosition.bottom, animated:false)
                    }
                    
                    if indexPath.row == self.messages.count - 1 {
                        
                        needScrollToBot = false
                    }
                    
                })
                
            }else{
                collectCell.waitingRequest()
                if canRequest == true {
                    
                    let model:MessageModel = self.messages.object(at: self.messages.count-2) as! MessageModel
                    var image:UIImage?
                    if model.pic != nil {
                        image = ImageTool().getImage(path:model.pic!)
                    }
                    needRequest(style: model.style!,
                                image:image,
                                model:self.messages.object(at: self.messages.count-1) as!String)
                }
            }
            
            return collectCell
            
        }else{
            // 回答選項 CollectionView
            var collectCell:CellSelection!
            
            if indexPath.row != 0 {
                
                collectCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellSelection", for: indexPath) as? CellSelection
            }
            
            if collectCell == nil {
                let nib = UINib(nibName:"CellSelection", bundle:nil)
                collectionView.register(nib, forCellWithReuseIdentifier:"cellSelection")
                collectCell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellSelection",
                                                                 for: indexPath) as? CellSelection
            }
            collectCell?.label.text = fakeDatas.object(at: indexPath.row) as? String
            
            if self.selectIndex == nil{
                collectCell.cellDidSelect(bool:false)
            }else {
                
                if self.selectIndex == indexPath{
                    collectCell.cellDidSelect(bool:true)
                }else{
                    collectCell.cellDidSelect(bool:false)
                }
            }
            return collectCell!
            
        }
        
        
    }
//MARK: CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = self.view.bounds.size.width
        
        if collectionView == collecttionView {
            
            guard let model = self.messages.object(at:indexPath.row) as? MessageModel else {
                return  CGSize(width: screenWidth, height:50.0)
            }
            
            if model.video != nil {
                
                return CGSize(width:screenWidth,height:190)
            }
            
            if model.pic != nil {
                
                let image = ImageTool().getImage(path:model.pic!)
                let size = ImageTool().getImageSize(image:image)
                return CGSize(width:screenWidth,height:size.height+10)
            }
            if model.message != nil {
                
                let myLabel = UILabel(frame:CGRect(x:12,y:12,width:200,height:150))
                myLabel.text = model.message
                myLabel.numberOfLines = 0
                myLabel.sizeToFit()
                let size = CGSize(width: screenWidth, height:myLabel.bounds.height+30)
                
                return size
            }
            
            return CGSize(width: screenWidth, height:64)
            
        }else{
            let screenWidth = self.view.bounds.size.width - 16
        
            let size = CGSize(width: screenWidth, height: 64.0)
        
            return size
        }

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == collecttionView{
            
            return UIEdgeInsets(top:4, left: 0, bottom: 4, right: 0)
            
        }else{
            
            return UIEdgeInsets(top: 4, left: 8, bottom:0, right: 8)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView != collecttionView{
            
                if self.selectIndex != nil {
                    if self.selectIndex == indexPath{
                        self.selectIndex = nil
                        self.btnSend.isEnabled = false
                        self.textField.text = ""
                    }else{
                        self.selectIndex = indexPath
                        self.btnSend.isEnabled = true
                        let cell = self.selectionCollection.cellForItem(at: indexPath) as? CellSelection
                        self.textField.text = cell?.label.text
                    }
                }else{
                    self.selectIndex = indexPath
                    self.btnSend.isEnabled = true
                    let cell = self.selectionCollection.cellForItem(at: indexPath) as? CellSelection
                    self.textField.text = cell?.label.text
                }
            
            collectionView.reloadData()
            
        }
    }

// MARK: Random Waiting
func randomWaiting(style:Int,image:UIImage?){
    let wait = "loading"
    self.messages.add(wait)
    self.collecttionView.reloadData()
    let delayInSeconds = Double(arc4random()%3+2)
    self.delayScroll(delay: 0.1)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
        
        self.needRequest(style:style, image:image,model:wait)
    }
        
}
func needRequest(style:Int,image:UIImage?,model:String){
        
    switch style{
        case 1 :
            if #available(iOS 10.0, *) {
                FireBase().jokeData(npc:self.title!,obj:model,block:{obj,model in
                    
                    self.replaceWaitView(obj: obj, model: model)
                })
            } else {
                // Fallback on earlier versions
            }
                break
        case 2 :
            if #available(iOS 10.0, *) {
                FireBase().imageData(npc:self.title!,obj:model,block:{obj,model in
                    
                    self.replaceWaitView(obj: obj, model: model)
                })
            } else {
                // Fallback on earlier versions
            }
                break
        case 3 :
            if #available(iOS 10.0, *) {
                FireBase().videoData(npc:self.title!,obj:model,block:{obj,model in
                    
                    self.replaceWaitView(obj: obj, model: model)
                })
            } else {
                // Fallback on earlier versions
        }
        case 4 :
            if #available(iOS 10.0, *) {
                FireBase().videoInAPP(npc:self.title!,obj:model,block:{obj,model in
                    
                    self.replaceWaitView(obj: obj, model: model)
                })
            } else {
                // Fallback on earlier versions
        }
        case 5 :
                self.placeAnalysis(obj:model)
                break
        default:
                ImageRecognition().imageRecog(pickedImage:image!, block:{string in
                    
                    let new = MessageModel()
                    new.senderName = "npc"
                    new.message = string
                    
                    self.messages.insert(new, at: self.messages.index(of:model))
                    self.messages.remove(model)
                    self.saveMessages()
                    self.canRequest(bool:true)
                })
                break
    }
}
// MARK: PlaceAnalysis

    func placeAnalysis(obj:String){
        
        LocationHelper.shared.getAddress(obj:obj,vc:self,block:{location in
                
                let message = String(format:"你的位置在 %@",location.address!)
                let model = MessageModel()
                model.senderName = "npc"
                model.message = message
                
                self.replaceWaitView(obj: obj, model: model)
            if #available(iOS 10.0, *) {
                LocalNotification().registerNotification(title:self.npc.npcName,
                                                         message:model.message!,
                                                         alertTime:5)
            } else {
                // Fallback on earlier versions
            }
        })
        
    }
    
//MARK:DelayScroll
    func delayScroll(delay:Double){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.collecttionView.scrollToItem(at:IndexPath(row:self.messages.count-1, section:0),at:UICollectionView.ScrollPosition.bottom, animated:true)
        }
    }

// MARK: UserDefault
    func loadMessages(){
        
        if let data = userDefault.object(forKey:npc.npcName) as? Data {
            
            if let arry = NSKeyedUnarchiver.unarchiveObject(with:data) as? NSMutableArray {
                
                self.messages = arry
            }
            
        }

    }
    
    func saveMessages(){
        
        let encodedData:Data = NSKeyedArchiver.archivedData(withRootObject:self.messages)
        self.userDefault.set(encodedData, forKey:self.title!)
        self.userDefault.synchronize()
    
    }
// MARK:Can request or not
    
    func canRequest(bool:Bool){
        
            self.collecttionView.reloadData()
            self.selectionCollection.reloadData()
            self.btnImage.isEnabled = bool
            self.canRequest = bool
            self.delayScroll(delay: 0.1)
        
            if bool == false {
                self.textField.text = ""
                self.btnSend.isEnabled = false
            }
    }
    
    
// MARK: ImageTool Delegate
func getImage(image: UIImage) {
        
        let model = MessageModel()
        model.senderName = "self"
        model.pic = ImageTool().saveImage(image:image)
        model.style = 0
        
        self.textField.text = ""
        self.messages.add(model)
        self.saveMessages()
        self.canRequest(bool:false)
        randomWaiting(style:0, image:image)
        
        
    }
    
// MARK: Replace loadingView
    func replaceWaitView(obj:String,model:MessageModel){
        
        
        guard (self.messages.lastObject as? MessageModel) != nil else{
            if obj == self.messages.lastObject as! String {
                self.messages.replaceObject(at: self.messages.index(of: obj), with: model)
                self.saveMessages()
                self.canRequest(bool:true)
            }
            return
        }
    }

}
