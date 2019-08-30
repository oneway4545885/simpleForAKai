//
//  PaddingLabel.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/11.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

        
        let padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
//        override func drawText(in rect: CGRect) {
//            let newRect = UIEdgeInsetsInsetRect(rect, padding)
//            super.drawText(in: newRect)
//        }
        
        override public var intrinsicContentSize: CGSize {
            get {
                var intrinsicContentSize = super.intrinsicContentSize
                intrinsicContentSize.height += padding.top + padding.bottom
                intrinsicContentSize.width += padding.left + padding.right
                return intrinsicContentSize
            }
        }
        
    
}
