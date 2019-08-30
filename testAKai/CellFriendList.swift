//
//  CellFriendList.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/4.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class CellFriendList: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon.layer.masksToBounds = false
        icon.layer.cornerRadius = icon.frame.height/2
        icon.clipsToBounds = true
    }

    func setStatus(status:String){
        
        self.statusLabel.text = status
        self.statusView.layer.masksToBounds = false
        self.statusView.layer.cornerRadius = self.statusView.frame.height/2
        self.statusView.clipsToBounds = true
        
        if status == "online" {
            
            self.statusLabel.textColor = UIColor.init(red: (2/255.0), green: (164/255.0), blue: (3/255.0), alpha: 1)
            self.statusView.image = UIImage(named:"greenView")

        }else if status == "offline" {
            
            self.statusLabel.textColor = .lightGray
            self.statusView.image = UIImage(named:"grayView")
            
        }else{
            
            self.statusLabel.isHidden = true
            self.statusView.isHidden = true
        }
        
    }
    
}
