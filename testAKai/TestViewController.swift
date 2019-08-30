//
//  TestViewController.swift
//  testAKai
//
//  Created by 王偉 on 1/23/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import KYGooeyMenu
import SwiftyGif
import youtube_ios_player_helper
import MBProgressHUD

class TestViewController: UIViewController,menuDidSelectedDelegate,UITableViewDataSource,UITableViewDelegate{

    var gooeyMenu:KYGooeyMenu!
    @IBOutlet weak var imageView: UIImageView!
    var apiKey = "AIzaSyDjhJFM2ov-Ye7qf98OVtkOZ6xjtKbahL4"
    var desiredChannelsArray = ["UCqN5R22XDqgE9Z6V91TzynQ","UCiLtwQM-6PbImq5QCYALumg"]
    var pageIndex = 0
    var channelsDataArray:[YoutubeChannelModel] = []
    var videoDataArray:[YoutubeChannelModel] = []
    var loadingNewData:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        gooeyMenu = KYGooeyMenu(origin:CGPoint(x:self.view.frame.midX - 50,y:500), andDiameter: 100.0, andDelegate: self, themeColor: UIColor.red)
//        gooeyMenu.menuDelegate = self
//        gooeyMenu.radius = 100/4
//        gooeyMenu.extraDistance = 20
//        gooeyMenu.menuCount = 3
//        gooeyMenu.menuImagesArray = NSMutableArray(array: [UIImage(named:"home")!,UIImage(named:"index")!,UIImage(named:"profile")!])
        

       
        
//        ImageTool().getDataFromUrl(url:URL(string:"https://firebasestorage.googleapis.com/v0/b/testakay-5d729.appspot.com/o/gif.gif?alt=media&token=b6501ea1-6007-475a-acd8-2f9fa6d0e646")!,completion:{data,response,error in
//            
//            DispatchQueue.main.async {
//                
//                let gifmanager = SwiftyGifManager(memoryLimit:20)
//                let gif = UIImage(gifData:data!)
//                self.imageView.backgroundColor = .black
//                self.imageView.setGifImage(gif, manager: gifmanager, loopCount: 2)
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.again(imageView:)))
//                self.imageView.addGestureRecognizer(tap)
//            }
//        })
        navigationHide(bool: false)
        
        for channel in desiredChannelsArray {
            
            self.getChannel(channel: channel)
            
        }
        
}

    func getChannelDetail(index:Int){
        videoDataArray = []
        let playlistID = channelsDataArray[index].playlistID
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(playlistID!)&key=\(apiKey)"
        let targetUrl = NSURL(string: urlString)
        
        performGetRequest(targetURL:targetUrl, completion:{data, HTTPStatusCode, error in
            
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! NSDictionary
                    let items:[NSDictionary] = resultsDict.object(forKey:"items") as! [NSDictionary]
                    

                    for item in items{
                        let model = YoutubeChannelModel()
                        model.nextPage =  resultsDict.object(forKey:"nextPageToken") as? String
                        let snippet = item.object(forKey:"snippet") as! NSDictionary
                        model.title = snippet.object(forKey:"title") as! String?
                        model.descrip = snippet.object(forKey:"description") as! String?
                        let thumbnail = snippet.object(forKey:"thumbnails") as! NSDictionary
                        let defor = thumbnail.object(forKey:"default") as! NSDictionary
                        model.thumbnail = defor.object(forKey:"url") as! String?
                        let resourceId = snippet.object(forKey: "resourceId") as! NSDictionary
                        model.videoID = resourceId.object(forKey:"videoId") as! String?
                        
                        self.videoDataArray.append(model)
                    }
                    self.navigationHide(bool: true)
                    self.tableView.reloadData()
                    
                } catch {
                    print(error)
                }
                
            }else{
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })
        
    }
    func getChannel(channel:String) {
    var urlString: String!
 
    urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(channel)&key=\(apiKey)"
    
        
    let targetURL = NSURL(string: urlString)
        
    performGetRequest(targetURL: targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
        if HTTPStatusCode == 200 && error == nil {
                
            do {
                    
                let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! NSDictionary
                
                let items = resultsDict.object(forKey:"items") as! Array<AnyObject>
                let firstItemDict = items[0] as! NSDictionary
                let snippetDict = firstItemDict.object(forKey:"snippet") as! NSDictionary
                let desiredValuesDict = YoutubeChannelModel()
                desiredValuesDict.title = snippetDict.object(forKey:"title") as! String?
                desiredValuesDict.descrip = snippetDict.object(forKey:"description") as! String?
                let thumbnail = snippetDict.object(forKey:"thumbnails") as! NSDictionary
                let defor = thumbnail.object(forKey:"default") as! NSDictionary
                desiredValuesDict.thumbnail = defor.object(forKey:"url") as! String?
                let detail = firstItemDict.object(forKey:"contentDetails") as! NSDictionary
                let related = detail.object(forKey:"relatedPlaylists") as! NSDictionary
                desiredValuesDict.playlistID = related.object(forKey:"uploads") as! String?
                self.channelsDataArray.append(desiredValuesDict)
                
                self.tableView.reloadData()
                    
            } catch {
                print(error)
            }
                
        }else{
            print("HTTP Status Code = \(HTTPStatusCode)")
            print("Error while loading channel details: \(error)")
        }
    })
}
func performGetRequest(targetURL: NSURL!, completion: @escaping (_ data: NSData?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
        
    var request = URLRequest(url:targetURL as URL)
    request.httpMethod = "GET"
        
    let sessionConfiguration = URLSessionConfiguration.default
        
    let session = URLSession(configuration: sessionConfiguration)
        
    let task = session.dataTask(with: request, completionHandler:{data,response,error in
            
        let httpResponse = response as! HTTPURLResponse
            
        DispatchQueue.main.async {
            completion(data as NSData?,httpResponse.statusCode, error as NSError?)
        }
    })
        
    task.resume()
}
@IBAction func btn_back(_ sender: Any) {
    let indexPath = IndexPath(row: 0, section: 0)
    self.tableView.scrollToRow(at:indexPath, at:.top, animated: false)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
        self.navigationHide(bool: false)
        self.tableView.reloadData()
    }
}

func navigationHide(bool:Bool){
    
    if bool == true {
        pageIndex = 1
        self.navigationController?.isNavigationBarHidden = false
    }else{
        pageIndex = 0
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
    let currentOffset = scrollView.contentOffset.y;
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) && loadingNewData == false && pageIndex != 0{
        loadingNewData = true
        MBProgressHUD.showAdded(to:self.view, animated: true)
        
        let playlistID = channelsDataArray[pageIndex].playlistID
        guard let pageToken = videoDataArray.last?.nextPage else{
            return
        }
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?pageToken=\(pageToken)&part=snippet&playlistId=\(playlistID!)&key=\(apiKey)"
        let targetUrl = NSURL(string: urlString)
        performGetRequest(targetURL:targetUrl, completion:{data, HTTPStatusCode, error in
            
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! NSDictionary
                    let items:[NSDictionary] = resultsDict.object(forKey:"items") as! [NSDictionary]
                   
                    for item in items{
                        let snippet = item.object(forKey:"snippet") as! NSDictionary
                        let model = YoutubeChannelModel()
                        model.nextPage =  resultsDict.object(forKey:"nextPageToken") as? String
                        model.title = snippet.object(forKey:"title") as! String?
                        model.descrip = snippet.object(forKey:"description") as! String?
                        let thumbnail = snippet.object(forKey:"thumbnails") as! NSDictionary
                        let defor = thumbnail.object(forKey:"default") as! NSDictionary
                        model.thumbnail = defor.object(forKey:"url") as! String?
                        let resourceId = snippet.object(forKey: "resourceId") as! NSDictionary
                        model.videoID = resourceId.object(forKey:"videoId") as! String?
                        
                        self.videoDataArray.append(model)
                    }
                    self.navigationHide(bool: true)
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.loadingNewData = false
                    
                } catch {
                    print(error)
                }
                
            }else{
                print("HTTP Status Code = \(HTTPStatusCode)")
                print("Error while loading channel details: \(error)")
            }
        })
    }
    
}
// tableView
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if pageIndex == 0 {
        return channelsDataArray.count
    }else{
       return videoDataArray.count
    }
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cellYoutubeList:CellYoutubeList? = tableView.dequeueReusableCell(withIdentifier: "cellYoutubeList") as! CellYoutubeList?
    
    if cellYoutubeList == nil {
        let nib = UINib(nibName:"CellYoutubeList", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier:"cellYoutubeList")
        cellYoutubeList = tableView.dequeueReusableCell(withIdentifier:"cellYoutubeList") as! CellYoutubeList?
    }
    if pageIndex == 0 {
        cellYoutubeList?.setCell(model: channelsDataArray[indexPath.row])
    }else{
        cellYoutubeList?.setCell(model: videoDataArray[indexPath.row])
    }

    return cellYoutubeList!
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120.0
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
    if pageIndex == 0 {
        self.getChannelDetail(index: indexPath.row)
        self.title = channelsDataArray[indexPath.row].title
    }else{
        let displayVideoVC = self.storyboard?.instantiateViewController(withIdentifier:"displayVideoVC") as! DisplayVideoViewController
        displayVideoVC.id = videoDataArray[indexPath.row].videoID
        displayVideoVC.title = videoDataArray[indexPath.row].title
        let navi = UINavigationController(rootViewController: displayVideoVC)
        self.present(navi, animated: false, completion: nil)
    }
}
    
    
func again(imageView:UIImageView){
        
        imageView.setGifImage(imageView.image!, loopCount: 2)
        
}
    
func menuDidSelected(_ index: Int32) {
        
}

}
