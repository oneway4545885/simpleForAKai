//
//  ImagePickerViewController.swift
//  testAKai
//
//  Created by 王偉 on 2/17/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit
import Photos

class ImagePickerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager = PHCachingImageManager()
    let sizeOfCell = (UIScreen.main.bounds.width - 4)/3
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false
        
        
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeImagePicker))
        self.navigationItem.leftBarButtonItem = cancelItem
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.collectionView.scrollToItem(at:IndexPath(row:self.fetchResult.count-1, section:0),at:UICollectionViewScrollPosition.bottom, animated:false)
//        }
        
    }
    
    
    @objc func closeImagePicker(){
    
        self.dismiss(animated: true, completion: nil)
    }

// MARK: Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchResult.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell:CellImage!
        
        
        if indexPath.row != 0 {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellImage", for: indexPath) as? CellImage
        }
        
        if cell == nil {
            
            let nib = UINib(nibName:"CellImage", bundle:nil)
            collectionView.register(nib, forCellWithReuseIdentifier:"cellImage")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cellImage",for: indexPath) as? CellImage
        }
        
        if indexPath.item == 0 {
            
            cell.mainImage.image = UIImage(named:"camera")
            return cell
        }
        
        
        let index:Int = (fetchResult.count - indexPath.item)
        let asset = fetchResult.object(at: index)
        let size = CGSize(width:sizeOfCell, height:sizeOfCell)
        
        imageManager.requestImage(for: asset, targetSize:size, contentMode: .aspectFill, options: nil, resultHandler:{ image,_ in
                cell.mainImage.image = image
        })
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item == 0 {
            
            AVCaptureDevice.requestAccess(for:AVMediaType.video, completionHandler:{ granted in
                if granted == true {
                    self.present(self.imagePicker, animated: true, completion: nil)
                }else{
                    Alert().alert(title:"無法取得權限", message:"請前往\n設定 -> 隱私權 -> 相機\n將本App權限開啟\n方能使用本功能", vc: self)
                }
            })
                return
        }
        
        
        
        let index:Int = (fetchResult.count - indexPath.item)
        let asset = fetchResult.object(at: index)
        imageManager.requestImage(for: asset, targetSize: UIScreen.main.bounds.size, contentMode: .aspectFill, options: nil, resultHandler:{ image,dic in
        
            
            let resultIsDegradedKey = dic?["PHImageResultIsDegradedKey"]! as!  Bool
            
            if resultIsDegradedKey == false {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier:"displayImageVC") as! DisplayImageViewController
                vc.image = image
                vc.isDisplayOnly = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        })
    
    }
// MARK : Camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//
//        self.dismiss(animated: false, completion: { _ in
//
//           let imageTool =  ImageTool.shared
//           imageTool.delegate.getImage(image: pickedImage!)
//
            self.dismiss(animated: false, completion: nil)
 //       })
    }
    
// MARK : Coleection Layout Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width:sizeOfCell, height:sizeOfCell)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
    
        if section % 3 == 0 {
            
            return UIEdgeInsets(top: 1,left: 1,bottom: 0,right: 1)
        }else{
            
            return UIEdgeInsets(top: 1,left: 0,bottom: 0,right: 1)
        }
        
       
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 1
    }

}
