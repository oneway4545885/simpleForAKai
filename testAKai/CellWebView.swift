//
//  CellWebView.swift
//  testAKai
//
//  Created by 王偉 on 2/8/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class CellWebView: UICollectionViewCell {

    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let url = "https://www.youtube.com/embed/u3cKrp96i_M"
        
        webView.loadHTMLString("<iframe width=\"200\" height=\"160\" src=\"https://www.youtube.com/embed/u3cKrp96i_M\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
    }

}
