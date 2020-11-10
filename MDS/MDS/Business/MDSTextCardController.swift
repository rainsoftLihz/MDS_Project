//
//  MDSTextCardController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSTextCardController: MDSCardController {
 
    override var cellClass: MDSCardBaseCell.Type{
        return MDSTextCardCell.self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBlue
        self.dataArr = [1,2,3,4,5,6]
       
    }
    
    override func configureCollectionCell(_ cell: MDSCardBaseCell, data: Any,indexPath:IndexPath) {
        let textCell = cell as! MDSTextCardCell
        textCell.backendLab.text = String.init(format: "反面%ld", indexPath.row)
        textCell.frontLab.text = String.init(format: "正面%ld", indexPath.row)
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
