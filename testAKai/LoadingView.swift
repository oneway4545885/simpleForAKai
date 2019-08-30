//
//  LoadingView.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/13.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit

class LoadingView: UIView {

/**
  *  三顆球
  */
var firstBall:UIView!
var seconBall:UIView!
var thirdBall:UIView!
    
var viewRadius = 10
var ballStartX = 12
var ballDistance = 14
var animateDuration = 0.5
/**
  *  執行載入動畫
  */
func loadingAnimate(width:CGFloat,height:CGFloat){

    for i in 0...2 {
            
        let view = UIView(frame: CGRect(x:ballStartX + (i*ballDistance),
                                        y:viewRadius + (viewRadius/2),
                                    width:viewRadius,
                                   height:viewRadius))
        // make view to ball
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = false
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
        self.addSubview(view)
        
        switch i {
        
            case 0:
                    firstBall = view
                    break
            case 1:
                    seconBall = view
                    break
            case 2:
                    thirdBall = view
                    break
            default:
                    break
        }
    }
        animateUp(view:firstBall)
}
/**
  *  動畫向上
  */
    
func animateUp(view:UIView){
    
    UIView.animate(withDuration:animateDuration, delay:0, options:.curveLinear, animations:{
        view.center = CGPoint(x: view.center.x, y: view.center.y - 10)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                
            if view == self.firstBall {
                    
                self.animateUp(view:self.seconBall)
                    
            }else if view == self.seconBall {
                    
                self.animateUp(view:self.thirdBall)
            }
        }
            
    }, completion:{ bool in
            
            self.animateDown(view: view)
       })
    
}
/**
  *  動畫向下
  */
    
func animateDown(view:UIView){
        
    UIView.animate(withDuration:animateDuration, delay:0, options:.curveLinear, animations:{
            
            view.center = CGPoint(x: view.center.x, y: view.center.y + 10)
            
    }, completion:{ bool in

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                
                if view == self.firstBall {
                     self.animateUp(view: view)
                }
        }
            
    })
        
}
    
    


}
