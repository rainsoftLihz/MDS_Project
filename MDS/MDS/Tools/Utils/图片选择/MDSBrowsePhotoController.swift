//
//  MDSBrowsePhotoController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/4.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import Kingfisher
class MDSBrowsePhotoController: MDSBaseController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var imgArr:[Any] = []
    var lastIndex:Int = 0
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let cellH = self.view.height-20-NAV_BAR_HEIGHT-10
        layout.itemSize = CGSize.init(width: SCREEN_WIDTH, height: cellH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let temp = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        temp.myFrame(0, self.myNavView.maxY, SCREEN_WIDTH, cellH)
        temp.register(MDSPhotoCell.self, forCellWithReuseIdentifier: "MDSPhotoCell")
        temp.delegate = self
        temp.dataSource = self
        temp.isPagingEnabled = true
        return temp
    }()
    
    lazy var numLab:UILabel = {
        let temp:UILabel = UIView.createLab(color: .white, fontSize: 18)
        temp.font = kBloldFont(18)
        temp.myFrame(0, 0, 100, 44)
        temp.textAlignment = .center
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.collectionView)
        self.setNavBar()
    }
    
    func setNavBar(){
        self.myNavView.backgroundColor = UIColorFromRGB(0x333333)
        self.addTitleView(view: self.numLab)
        self.numLab.text = String.init(format: "1/%ld", self.imgArr.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let identifier = "MDSPhotoCell";
        let cell:MDSPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MDSPhotoCell
        let obj = self.imgArr[indexPath.row]
        if (obj is String){
            cell.imgV.kf.setImage(with: NSURL.fileURL(withPath: obj as! String))
        }else if (obj is UIImage){
            cell.imgV.image = (obj as! UIImage)
        }
        cell.imgV.transform = CGAffineTransform.identity
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(scrollView.contentOffset.x/self.collectionView.width)
        self.numLab.text = NSString.init(format: "%ld/%ld", index+1,self.imgArr.count) as String
        if self.lastIndex != index {
            self.collectionView.reloadData()
        }
        self.lastIndex = index
    }

}


class MDSPhotoCell: UICollectionViewCell {
    
    var imgV:UIImageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.contentView.addSubview(self.imgV)
        self.imgV.frame = self.bounds
        self.imgV.isUserInteractionEnabled = true
        //缩放手势
        //let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchView(pinchGestureRecognizer:)))
        //self.imgV.addGestureRecognizer(pinchGesture)
    }
    
    //MARK: ---缩放
    @objc func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer) -> (){
        let view = pinchGestureRecognizer.view
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            view?.transform = view!.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale);
            pinchGestureRecognizer.scale = 1;
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
