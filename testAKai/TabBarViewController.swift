//
//  TabBarViewController.swift
//  testAKai
//
//  Created by 王偉 on 1/20/17.
//  Copyright © 2017 王偉. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var i = 0
        
        for vc in viewControllers! {
            
            var image:UIImage!
            var title:String!
            
            switch i {
            case 0:
                image = UIImage(named:"home")
                title = "首頁"
                break
            case 1:
                image = UIImage(named:"index")
                title = "訊息"
                break
            case 2:
                image = UIImage(named:"profile")
                title = "個人"
                break
            default:
                break
            }
            vc.tabBarItem = UITabBarItem(title:title, image:image, tag: 0)
            
            i += 1
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
