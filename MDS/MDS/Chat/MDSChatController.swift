//
//  MDSChatController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/25.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
class MDSChatController: MDSBaseController,UITableViewDelegate,UITableViewDataSource,ChatCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "聊天")
        self.view.addSubview(self.tableView);
        self.requestData();
    }
    
    private var dataArr:[MDSChatModel]?
    
    //网络请求
    func requestData() {
       
            let contentArr = ["时间到佛山就哦IE今晚佛阿胶哦份文件佛文件俄方，索朗多吉佛山就都发生的，司机佛教为哦i就反胃","一行字吗现实","额同行，保持好奇心，代入感，倒入，无主题无课程，定主题","选框架 配方法 写脚本 平面设计 动画视频","通过今天的学习，希望大家都有个好的心情，七部入微，起锅了","hehe","怎木把动画弄的好看，请用美化大师，GO GO Go"];
            var tempArray:[MDSChatModel] = Array.init();
            for i in 0..<10{
                let model:MDSChatModel = MDSChatModel();
                model.content = i<contentArr.count-1 ? contentArr[i]:"默认conten 这是测试数据";
                model.isMine = i%2 == 0;
                tempArray.append(model);
            }
            let dic1:Dictionary<String,Any> = ["list":tempArray];
            var dic:Dictionary<String,Any> = Dictionary<String,Any>.init();
            dic["data"] = tempArray;
            dic["code"] = "200";
            dic["sucess"] = "11";
            
            //首先判断能不能转换
            if (!JSONSerialization.isValidJSONObject(dic)) {
                print("is not a valid json object")
            }else {
                let data = try!JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted);
                let strJson = String(data: data, encoding: String.Encoding.utf8);
                NSLog("===>>>%@", strJson!);
            }
           
            
//            do{
//                let data = try? JSONSerialization.data(withJSONObject: dic, options: []);
//                let strJson = String(data: data!, encoding: String.Encoding.utf8);
//            }catch {
//
//            }
            
//            let encoder = JSONEncoder();
//            let data =
//            print(String(data: data, encoding: .utf8)!)
            
          
            //let j = JSON.init(strJson!);
            
            //var dd = j["data"];
            
            self.dataArr = tempArray ;
            self.tableView.reloadData();
            
//            NSLog("====%@", responseString);
//            let dic : NSDictionary =  self.getDictionaryFromJSONString(jsonString: responseString);
//            NSLog("%@", dic);
        
 
    }
    
    // JSONString转换为字典
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect(x:0, y:self.myNavView.maxY, width: SCREEN_WIDTH, height:SCREEN_HEIGHT-self.myNavView.maxY), style: UITableView.Style.plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColorFromRGB(0xe5e5e5);
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
        return self.dataArr?.count ?? 0;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MDSChatBaseCell
        let model:MDSChatModel = self.dataArr?[indexPath.row] ?? MDSChatModel();
        model.type = .MessageBodyTypeText;
        
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

}
