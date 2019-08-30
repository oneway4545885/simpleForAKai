//
//  ImageRecognition.swift
//  testAKai
//
//  Created by 王偉 on 2/3/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import SwiftyJSON

class ImageRecognition: NSObject {
    
    
/**
  *   image recognition
  */
func imageRecog(pickedImage:UIImage,block:@escaping (String)->Void){
 
    let binaryImageData = base64EncodeImage(pickedImage)
    createRequest(with: binaryImageData,closures: { jsonData in
            var string = ""
            let responses: JSON = jsonData["responses"][0]
            let faceAnnotations: JSON? = responses["faceAnnotations"]
            if faceAnnotations != nil {
                
                let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
                let numPeopleDetected:Int = faceAnnotations!.count
    
                if numPeopleDetected > 0 {
                        string = string.appending("People detected: \(numPeopleDetected)\n\nEmotions detected:\n")
                    
                        var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
                        var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
                    
                        for index in 0..<numPeopleDetected {
                            let personData:JSON = faceAnnotations![index]
                        
                            for emotion in emotions {
                                let lookup = emotion + "Likelihood"
                                let result:String = personData[lookup].stringValue
                                emotionTotals[emotion]! += emotionLikelihoods[result]!
                            }
                        }
                    
                        for (emotion, total) in emotionTotals {
                            let likelihood:Double = total / Double(numPeopleDetected)
                            let percent: Int = Int(round(likelihood * 100))
                            string = string.appending("\(emotion): \(percent)%\n")
                        }

                }
                
             }else {
                
             }
        
            let labelAnnotations: JSON = responses["labelAnnotations"]
            let numLabels: Int = labelAnnotations.count
            var labels: Array<String> = []
            if numLabels > 0 {
                var labelResultsText:String = "Labels found: "
                for index in 0..<numLabels {
                    let label = labelAnnotations[index]["description"].stringValue
                    labels.append(label)
                }
                for label in labels {
                    
                    if labels[labels.count - 1] != label {
                        labelResultsText += "\(label), "
                    } else {
                        labelResultsText += "\(label)"
                    }
                }
                 string = string.appending(labelResultsText)
            } else {
                 string = string.appending("No labels found")
            }

                block(string)
            
    })
}
/**
  *  convert image to base64Encode
  */
func base64EncodeImage(_ image: UIImage) -> String {
    var imagedata = image.pngData()
        
    if ((imagedata?.count)! > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
    return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
}
/**
  *  resize image
  */
    
func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
    
    UIGraphicsBeginImageContext(imageSize)
    image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    let resizedImage = newImage!.pngData()
    UIGraphicsEndImageContext()
    return resizedImage!
}
/**
  *  convert image to base64Encode
  */
    
func createRequest(with imageBase64: String,closures:@escaping (JSON) -> Void) {
        
    var request = URLRequest(url:URL(string:"https://vision.googleapis.com/v1/images:annotate?key=AIzaSyCwxVnZir7SMtRPVwsPXTaLaaD7lWTtlBI")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
    
    let jsonRequest = [
            "requests": ["image": ["content": imageBase64],
                "features": [["type": "LABEL_DETECTION","maxResults": 10],
                ["type": "FACE_DETECTION","maxResults": 10]]]
        ]

        let jsonObject = JSON.init(jsonRequest)
        
        guard let data = try? jsonObject.rawData() else {
            return
        }
        request.httpBody = data
        
        DispatchQueue.global().async {
        
                let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
            }
                
            DispatchQueue.main.async(execute: {
                    
                let json = JSON(data: data)
                    let errorObj: JSON = json["error"]
                    
                    
                    if (errorObj.dictionaryValue != [:]) {
                        
                    } else {
                        
                        print(json)
                        closures(json)
                    }
                })
            }
            task.resume()
        }
}
    

}
