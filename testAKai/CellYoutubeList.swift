//
//  CellYoutubeList.swift
//  testAKai
//
//  Created by 王偉 on 3/7/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class CellYoutubeList: UITableViewCell {

    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

func setCell(model:YoutubeChannelModel){
    self.title.text = model.title
    self.descript.text = model.descrip
    let imageTool = ImageTool()
    imageTool.getDataFromUrl(url:URL(string:model.thumbnail)!, completion:{ data,response,error in
        DispatchQueue.main.async {
            
            if error == nil {
                self.iconView.image = UIImage(data: data!)
            }
            
            
        }
        
    })
        
}
    
    
    
}
