//
//  MDSBussinessController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSBussinessController: MDSBaseController {
    
    var content1:MDSDrageView = MDSDrageView.init(frame: CGRect.zero, type: .front)
    var content2:MDSDrageView = MDSDrageView.init(frame: CGRect.zero, type: .backend)
    var content3:MDSDrageView = MDSDrageView.init(frame: CGRect.zero, type: .unSelect)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "业务圈")
        self.view.addSubViews([content1,content2,content3])
        let H:CGFloat = 150
        let startY:CGFloat = self.myNavView.maxY
        content1.myFrame(0, startY, SCREEN_WIDTH, H)
        content2.myFrame(0,content1.maxY, SCREEN_WIDTH, H)
        content3.myFrame(0,content2.maxY, SCREEN_WIDTH, H)
        content1.titleArr = ["美式发音","英式发音","单词","词义","位置","知识点"]
        content2.titleArr = ["朝代","正文","作者"]
        content3.titleArr = ["诗词标题"]
        
        content1.dragBlock = {[weak self] (title:String,index:Int,point:CGPoint) in
            if (self?.content2.frame.contains(point))! {
                self!.content1.titleArr.remove(at: index)
                self?.content2.titleArr.append(title)
            }else if (self?.content3.frame.contains(point))! {
                self!.content1.titleArr.remove(at: index)
                self?.content3.titleArr.append(title)
            }
        }
        
        content2.dragBlock = {[weak self] (title:String,index:Int,point:CGPoint) in
            if (self?.content1.frame.contains(point))! {
                self!.content2.titleArr.remove(at: index)
                self?.content1.titleArr.append(title)
            }else if (self?.content3.frame.contains(point))! {
                self!.content2.titleArr.remove(at: index)
                self?.content3.titleArr.append(title)
            }
        }
        
        content3.dragBlock = {[weak self] (title:String,index:Int,point:CGPoint) in
            if (self?.content2.frame.contains(point))! {
                self!.content3.titleArr.remove(at: index)
                self?.content2.titleArr.append(title)
            }else if (self?.content1.frame.contains(point))! {
                self!.content3.titleArr.remove(at: index)
                self?.content1.titleArr.append(title)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.navigationController?.pushViewController(MDSRecordController(), animated: true);
    }

}
