//
//  MDSSlectTabController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/3.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

typealias SelectBlock = (String) -> Void

class MDSSlectTabController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cellH:CGFloat = 49.0
    
    var selectBlock:SelectBlock?
    
    var titleArr:[String]?
    
    lazy var tableView:UITableView = {
        let temp:UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.register(MDSSelectCell.self, forCellReuseIdentifier: "MDSSelectCell")
        temp.tableFooterView = self.footerView
        temp.bounces = false
        temp.separatorStyle = .none
        temp.rowHeight = cellH
        temp.delegate = self
        temp.dataSource = self
        return temp
    }()
    
    lazy var footerView:UIView = {
        let temp:UIView = UIView.createView(backgroundColor: .white)
        temp.myFrame(0, 0, SCREEN_WIDTH, cellH+SAFE_AREA_Height+10)
        
        //分割条
        let placeV = UIView.createView(backgroundColor: .groupTableViewBackground)
        placeV.myFrame(0, 0, SCREEN_WIDTH, 10)
        temp.addSubview(placeV)
        
        var lab:UILabel = UIView.createLab(text: "取消", color: .black, fontSize: 15, alignment: .center)
        temp.addSubview(lab)
        lab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-SAFE_AREA_Height)
            make.centerX.equalToSuperview()
        }
        temp.tapAction {[weak self] in
            self!.dismiss(animated: true, completion: nil)
        }
        return temp
    }()

    
    static func showWith(_ superVC:UIViewController,titleArr:[String],selectBlcok:@escaping SelectBlock){
        let selectVC = MDSSlectTabController.init(titleArr: titleArr)
        selectVC.selectBlock = selectBlcok
        selectVC.modalPresentationStyle = .overFullScreen
        superVC.present(selectVC, animated: true, completion: nil)
    }
    
    init(titleArr:[String]) {
        super.init(nibName: nil, bundle: nil)
        self.titleArr = titleArr
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromRGBAlpha(0x000000,0.5)
        self.view.addSubview(self.tableView)
        let H:CGFloat = CGFloat(titleArr!.count)*cellH+self.footerView.height
        self.tableView.myFrame(0, SCREEN_HEIGHT-H, SCREEN_WIDTH, H)
        self.tableView.cornerRadius(cornerRadius: 5, corner: [UIRectCorner.topRight,UIRectCorner.topLeft])
    }
    
    //MARK: ---- table delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr!.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MDSSelectCell = MDSSelectCell.init(style: .default, reuseIdentifier: "MDSSelectCell")
        cell.bottomLine.isHidden = (self.titleArr!.count-1 == indexPath.row)
        cell.titleLab.text = titleArr![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < titleArr!.count {
            let str:String = titleArr![indexPath.row] as String
            self.selectBlock!(str)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("dealloc --- \(self)")
    }
}



class MDSSelectCell: UITableViewCell {
    
    var titleLab:UILabel = UIView.createLab(color: .black, fontSize: 15)
    var bottomLine:UIView = UIView.createView(backgroundColor: .groupTableViewBackground)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
        self.selectionStyle = .none;
        self.contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
