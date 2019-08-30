//
//  ViewController.swift
//  testAKai
//
//  Created by 王偉 on 2017/1/4.
//  Copyright © 2017年 王偉. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
// MARK: property
    @IBOutlet weak var tableView: UITableView!
    let cellHeight:CGFloat = 48.0
    let location = LocationHelper.shared
    var npcArry:NSMutableArray! = NSMutableArray()
    
    
    
// MARK: view
    override func viewDidLoad() {
        super.viewDidLoad()
        location.startLocation()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.npcData()
        
    }
// MARK: Firebase 
    func npcData(){
        let ref = Database.database().reference().child("test_story")
        ref.observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as! Dictionary<String,String>
            let npcModel = NpcModel()
            self.npcArry.add(npcModel.setNPC(dic: value))
            let indexPath = IndexPath(row:self.npcArry.count-1, section:0)
            self.tableView.insertRows(at:[indexPath], with: .automatic)
        })
        
    }
// MARK: tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.npcArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       var cellFriendList = self.tableView.dequeueReusableCell(withIdentifier:"cellFriendList") as? CellFriendList
        
        if cellFriendList == nil {
            
            let nib = UINib(nibName:"CellFriendList", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier:"cellFriendList")
            cellFriendList = self.tableView.dequeueReusableCell(withIdentifier:"cellFriendList") as? CellFriendList
            
        }
        let npc = npcArry[indexPath.row] as! NpcModel
        cellFriendList?.icon.image = UIImage(named:npc.npcImage)
        cellFriendList?.name.text = npc.npcName
        cellFriendList?.setStatus(status:"online")
        return cellFriendList!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"messageVC") as! MessageViewController
        vc.npc = self.npcArry.object(at: indexPath.row) as! NpcModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect(x:0, y:0, width: self.view.bounds.width, height: 30.0))
        view.backgroundColor = UIColor.init(white:(246/255.0), alpha: 1)
        let label = UILabel(frame: CGRect(x:8,y:0,width:self.view.bounds.width-8,height:30.0))
        label.textAlignment = .left
        label.text = "Akei 用戶"
        label.textColor = .lightGray
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
}

