//
//  MDSHomeMVVM.swift
//  MDS
//
//  Created by rainsoft on 2019/3/5.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
import Foundation
import HandyJSON
import SwiftyJSON
import Kingfisher
class MDSHomeMVVM: NSObject {
   
    var dataArray:[MDSHomeModel]?
    
    typealias Block = ([MDSHomeModel])->()
    
    func requstData(_ parmas:[String:Any], block:@escaping Block){

        NetWorkRequest(MDSAPI.findHomeworkList(params: parmas),completion: { (response) -> (Void) in
            
            if (response.isSucces){
                if let datList = JSONDeserializer<MDSHomeModel>.deserializeModelArrayFrom(array: response.data as? [Any]) {
                    self.dataArray = datList as? [MDSHomeModel]
                    block((datList as? [MDSHomeModel])!)
                }
            }
            //转json
//            let json = JSON(response)
//            // 从字符串转换为对象实例
//            if let datList = JSONDeserializer<MDSHomeModel>.deserializeModelArrayFrom(json: json["data"].description) {
//                self.dataArray = datList as? [MDSHomeModel]
//            }
            
//            let resultData:MDSResponse = JSONDeserializer<MDSResponse>.deserializeFrom(dict: response)!
//            if let datList = JSONDeserializer<MDSHomeModel>.deserializeModelArrayFrom(array: resultData.data as? [Any]) {
//                self.dataArray = datList as? [MDSHomeModel]
//            }
        });
        
    }
}


extension MDSHomeMVVM {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, indexPath: IndexPath, cell: MDSHomeViewCell){
        cell.model = self.dataArray![indexPath.row]
        /* kf 加载网络图片 */
        //cell.iconImg.kf.setImage(with: ImageResource(downloadURL: URL.init(string: imgStr)! as URL), placeholder: UIImage(named: "wtfk"), options: [.fromMemoryCacheOrRefresh], progressBlock: nil, completionHandler: nil);
        /* sd 加载网络图片 */
        //cell.iconImg.sd_setImage(with: NSURL.init(string: imgStr)! as URL, placeholderImage: UIImage.init(named: "wtfk"), options: [], progress: nil, completed:nil);
    }
}
