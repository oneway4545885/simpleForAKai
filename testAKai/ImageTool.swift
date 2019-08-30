//
//  ImageTool.swift
//  testAKai
//
//  Created by 王偉 on 2/8/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
/**
  *   SelectImageDelegate
  */
protocol SelectImageDelegate {
    
    func getImage(image:UIImage) -> Void
    
}

class ImageTool: NSObject {

    var delegate:SelectImageDelegate!
    
    
/**
  *   Singleton
  */
class var shared:ImageTool {
        
    struct Static {
        static let instance : ImageTool = ImageTool()
            
    }
        
    return Static.instance
}
    
/**
  *   collectionView image resize
  */
func getImageSize(image:UIImage) -> CGSize{
        
    let pic = UIImageView(frame:CGRect(x:0,y:0,width:image.size.width,height:image.size.height))
    pic.image = image
    
    var picWidth = pic.bounds.width
    var picHeight = pic.bounds.height
        
    if picWidth > 200.0 {
        
        picHeight = picHeight/(picWidth/200.0)
        picWidth = 200.0
            
    }
        
    return CGSize(width: picWidth, height: picHeight)
}
/**
  *   take Image from FileManager
  */
func getImage(path:String) -> UIImage{
        
    let fileManager = FileManager.default
        
    if fileManager.fileExists(atPath:path){
            
        return UIImage(contentsOfFile:path)!
            
    }else{
        print("No Image")
        return UIImage()
    }
}
/**
  *   get Image Data from URL
  */
func getDataFromUrl(url: URL,completion: @escaping (_ data: Data?, _  response: URLResponse?,
                                                                    _ error: Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) {
            
            (data, response, error) in
                completion(data, response, error)
            
        }.resume()
}
/**
  *    save image as File and get path
  */
func saveImage(image:UIImage) -> String{
        
    let uuid = UUID().uuidString
    let fileManager = FileManager.default
    let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(uuid)
    let imageData = image.jpegData(compressionQuality: 0.5)
    fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        
    return path
}

    
}
