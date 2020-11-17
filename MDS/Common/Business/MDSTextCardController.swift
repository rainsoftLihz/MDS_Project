//
//  MDSTextCardController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSTextCardController: MDSBaseController,MDSCardViewDataSource {
    
    let registerID = "MDSCardBaseCell"
    
    //数据源
    var dataArr:[Any] = [] {
        didSet{
            self.cardView.dataArr = dataArr
        }
    }
    
    let cardView:MDSCardView = MDSCardView.init(frame: CGRect.init(x: 0, y: NAV_BAR_HEIGHT+10, width: SCREEN_WIDTH, height:SCREEN_HEIGHT-NAV_BAR_HEIGHT-50-SAFE_AREA_Height ))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        self.addTitle(title: "卡片")
        self.view.addSubview(self.cardView)
        self.cardView.dataSource = self
        self.cardView.isCanScale = false
        self.cardView.didScrollEndDraggingClosure = {(index) in
            print("index ===== \(index)")
        }
    }


    func configCollectionCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(MDSTextCardCell.self, forCellWithReuseIdentifier: self.registerID)
        let cardCell:MDSTextCardCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.registerID, for: indexPath) as! MDSTextCardCell
        cardCell.backendLab.text = String.init(format: "反面%ld", indexPath.row)
        cardCell.frontLab.text = String.init(format: "正面%ld", indexPath.row)
        return cardCell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var arr:[Int] = []
        for i in 0..<10 {
            arr.append(i)
        }
        self.dataArr.append(contentsOf: arr)
    }
}



class MDSTextCardCell: MDSCardBaseCell {
    
    var frontLab:UILabel = UIView.createLab(color: .red, fontSize: 69)
    var backendLab:UILabel = UIView.createLab(color: .black, fontSize: 69)
     override init(frame: CGRect) {
        super.init(frame: frame)
        self.backendView.addSubview(backendLab)
        self.frontView.addSubview(frontLab)
        backendLab.frame = self.backendView.bounds
        frontLab.frame = self.frontView.bounds
        frontLab.textAlignment = .center
        backendLab.textAlignment = .center
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
