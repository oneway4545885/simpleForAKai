//
//  DisplayImageViewController.swift
//  testAKai
//
//  Created by 王偉 on 2/7/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage!
    let maxScale:CGFloat! = 3.0
    let minScale:CGFloat! = 1.0
    var isDisplayOnly:Bool!
    var totalScale:CGFloat! = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        imageView.isUserInteractionEnabled = true

        if isDisplayOnly == true {
        
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImage))
            imageView.addGestureRecognizer(tapGestureRecognizer)
        }else{
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectImage))
            
        }
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(pinch:)))
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
    }
    
    
    @objc func selectImage(){
        
        ImageTool.shared.delegate.getImage(image: self.image)
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @objc func pinchImage(pinch:UIPinchGestureRecognizer){
        
        let scale = pinch.scale;
        
        if(scale > 1.0){
            if(self.totalScale > self.maxScale){
                return
            }
        }
        
        if (scale < 1.0) {
            if (self.totalScale <= self.minScale){
                return
            }
        }
        
        self.imageView.transform = self.imageView.transform.scaledBy(x: scale, y: scale)
        self.totalScale = self.totalScale * scale
        pinch.scale = 1.0
    }
    
    @objc func tapImage(){
        self.dismiss(animated: false, completion: nil)
    }
    
}
