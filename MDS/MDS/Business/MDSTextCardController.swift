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
        
        self.dataArr = [1,2,3,4,5,6]
       
    }
    
    override func configureCollectionCell(_ cell: MDSCardBaseCell, data: Any) {
        print("打你哦 怕不怕..........")
    }
    
}

class MDSTextCardCell: MDSCardBaseCell {
    
     override init(frame: CGRect) {
           super.init(frame: frame)
        self.backendView.backgroundColor = .yellow
        self.frontView.backgroundColor = .red
       }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
