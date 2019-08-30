//
//  CellSelection.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/11.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class CellSelection: UICollectionViewCell {

    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15

    }
    
    func cellDidSelect(bool:Bool){
        if bool == true {
            self.backgroundColor = UIColor.init(red:(0/255.0),
                                                green:(132/255.0),
                                                blue:(255/255.0), alpha: 1)
            self.label.textColor = .white
        }else{
            self.backgroundColor = .white
            self.label.textColor = .black
        }
    }

}
