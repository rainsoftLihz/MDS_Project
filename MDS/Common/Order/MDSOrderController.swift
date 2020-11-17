//
//  MDSOrderController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSOrderController: MDSBaseController,MDSCardViewDataSource {
    
    let registerID = "MDSCardCell"
    
    //数据源
    var dataArr:[Any]? {
        didSet{
            self.cardView.dataArr = dataArr
            self.cardView1.dataArr = dataArr
        }
    }
    

    let cardView:MDSCardView = MDSCardView.init(frame: CGRect.init(x: 0, y: NAV_BAR_HEIGHT+120, width: SCREEN_WIDTH, height: 384))
    
    let cardView1:MDSCardView = MDSCardView.init(frame: CGRect.init(x: 0, y: NAV_BAR_HEIGHT+130+384, width: SCREEN_WIDTH, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitle(title: "订单")
        
         let imageArray = [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!,UIImage(named: "banner_4")!] //["http://i.imgur.com/7Ze2PdG.png","http://i.imgur.com/cAfBaMR.png","http://i.imgur.com/AimYvXb.png"]
        
        let cycleView:MDSCyclicScrollView = MDSCyclicScrollView.init(frame: CGRect.init(x: 0, y: self.myNavView.maxY+10, width: SCREEN_WIDTH, height: 100), dataArr: imageArray) { (index) in
            print("==========\(index)")
        }
        self.view.addSubview(cycleView)
        cycleView.dataArr = imageArray
        
        self.cardView.isCanScale = true
        self.cardView.dataSource = self
        self.view.addSubview(self.cardView)
        
        self.view.addSubview(self.cardView1)
        self.cardView1.isCanScale = false
        self.cardView1.dataSource = self
        
        self.dataArr =
        
        [UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!,UIImage(named: "banner_4")!,UIImage(named: "banner_1")!,UIImage(named: "banner_2")!,UIImage(named: "banner_3")!,UIImage(named: "banner_4")!]
        
        //self.loadData()
    }
    
    func loadData() {
        let params:[String:Any] = ["lsId":17465,"pageNum":1];
        LearnProvider.request(MDSLearnAPI.getLsLeEntryCarouselByLsId(params: params)) { (response) in
            
        }
    }
    
    func configCollectionCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
      collectionView.register(MDSCardCell.self, forCellWithReuseIdentifier: self.registerID)
      let cell:MDSCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: registerID, for: indexPath) as! MDSCardCell
        cell.backgroundColor = .red
      cell.imgV.image = self.dataArr?[indexPath.item] as? UIImage
      return cell
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dataArr?.append(UIImage(named: "banner_1")!)
        //self.loadData()
    }

}
