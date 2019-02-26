//
//  MDSChatController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/25.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSChatController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChatCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天";
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView);
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect(x:0, y:0, width: SCREEN_WIDTH, height:SCREEN_HEIGHT), style: UITableView.Style.plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.white;
        tableView.separatorStyle = .none;
    
        // 注册分区cell
        tableView.register(MDSChatMineCell.self, forCellReuseIdentifier: "mine")
        tableView.register(MDSChatNotMineCell.self, forCellReuseIdentifier:"notmine")
        tableView.estimatedRowHeight = 45;
        return tableView
    }();
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MDSChatBaseCell
        let model:MDSChatModel = MDSChatModel();
        model.type = .MessageBodyTypeText;
        
        let contentArr = ["时间到佛山就哦IE今晚佛阿胶哦份文件佛文件俄方，索朗多吉佛山就都发生的，司机佛教为哦i就反胃","一行字吗现实","额同行，保持好奇心，代入感，倒入，无主题无课程，定主题","选框架 配方法 写脚本 平面设计 动画视频","通过今天的学习，希望大家都有个好的心情，七部入微，起锅了","hehe","怎木把动画弄的好看，请用美化大师，GO GO Go"];
        model.content = indexPath.row<contentArr.count-1 ? contentArr[indexPath.row]:"默认conten 这是测试数据";
        model.isMine = indexPath.row%2 == 0;
        
        if model.isMine!  {
           cell = tableView.dequeueReusableCell(withIdentifier: "notmine") as! MDSChatNotMineCell;
        }else {
           cell = tableView.dequeueReusableCell(withIdentifier: "mine") as! MDSChatMineCell;
        }
        
        cell.chatModel = model;
        
        cell.clickBack = {
            NSLog("%d=====index", indexPath.row);
        };
        
        cell.delegate = self;
        return cell;
    }
    
    //MARK:chatDelegate
    func actionWithImgClick(backModel: MDSChatModel, cell: MDSChatBaseCell) {
        var indexPath:IndexPath = self.tableView.indexPath(for: cell)!;
        NSLog("index=====%d", indexPath.row);
        NSLog("content=======%@", backModel.content ?? "");
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
