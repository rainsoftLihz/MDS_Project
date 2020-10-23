//
//  MDSLoginVC.swift
//  MDS
//
//  Created by rainsoft on 2020/10/22.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import HandyJSON
class MDSLoginVC: MDSBaseController {
    
    private let _userNameLab:UILabel = {
        let userNameLab = UILabel.init()
        userNameLab.text = "用户名:"
        userNameLab.font = UIFont.systemFont(ofSize: 15)
        return userNameLab
    }()
    
    private let _passdLab:UILabel = {
        let passdLab = UILabel.init()
        passdLab.text = "密  码:"
        passdLab.font = UIFont.systemFont(ofSize: 15)
        return passdLab
    }()
    
    private let _userNameTextF:UITextField = {
        let userNameTextF = UITextField.init()
        userNameTextF.placeholder = "请输入用户名"
        userNameTextF.borderStyle = .none
        userNameTextF.textAlignment = .left
        userNameTextF.font = UIFont.systemFont(ofSize: 15)
        return userNameTextF
    }()
    
    private let _passdTextF:UITextField = {
        let passdTextF = UITextField.init()
        passdTextF.placeholder = "请输入密码"
        passdTextF.borderStyle = .none
        passdTextF.isSecureTextEntry = true
        passdTextF.textAlignment = .left
        passdTextF.font = UIFont.systemFont(ofSize: 15)
        return passdTextF
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginBtn:UIButton = {
            let loginBtn = UIButton.init(type: .custom)
            loginBtn.setTitle("登  录", for: .normal)
            loginBtn.setTitleColor(UIColor.red, for: .normal)
            loginBtn.layer.borderWidth = 0.8
            loginBtn.layer.backgroundColor = UIColor.yellow.cgColor
            loginBtn.layer.cornerRadius = 3
            loginBtn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
            return loginBtn
        }();
        
        
        let view1 = UIView.init()
        view1.layer.borderWidth = 1.0
        view1.layer.borderColor = UIColor.gray.cgColor
        view1.layer.cornerRadius = 3.0
        
        let view2 = UIView.init()
        view2.layer.borderWidth = 1.0
        view2.layer.borderColor = UIColor.gray.cgColor
        view2.layer.cornerRadius = 3.0
        
        
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        view1.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(100)
            make.right.equalTo(-15)
            make.height.equalTo(50)
        }
        
        view2.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(view1.snp_bottom).offset(10)
            make.right.equalTo(-15)
            make.height.equalTo(50)
        }
        
        
        view1.addSubview(_userNameLab)
        view2.addSubview(_passdLab)
        view1.addSubview(_userNameTextF)
        view2.addSubview(_passdTextF)
        
        _userNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(view1)
            make.width.equalTo(50).priorityLow()
        }
        
        _userNameTextF.snp.makeConstraints { (make) in
            make.left.equalTo(_userNameLab.snp_right).offset(15).priorityHigh()
            make.centerY.equalTo(view1)
            make.right.equalTo(-10)
        }
        
        
        _passdLab.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(view2)
            make.width.equalTo(50).priorityLow()
        }
        _passdTextF.snp.makeConstraints { (make) in
            make.left.equalTo(_passdLab.snp_right).offset(15).priorityHigh()
            make.centerY.equalTo(view2)
            make.right.equalTo(-10)
        }
        
        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view1)
            make.top.equalTo(view2.snp_bottom).offset(30)
            make.right.equalTo(-10)
            make.height.equalTo(45)
        }
        _passdTextF.text = "ahuang"
        _userNameTextF.text = "xulu"
        
    }
    
    @objc func loginClick () {
        if _passdTextF.text?.count == 0 || _userNameLab.text?.count == 0 {
            print("请输入用户名密码")
            return
        }
        
        let params:[String:String] = ["password":_passdTextF.text!,"userName":_userNameTextF.text!]
        NetWorkRequest(.login(params: params)) { (response) -> (Void) in
            if response.isSucces == true {
                 UIView.showText("登录成功")
                 //获取cookie
                 let cstorage:HTTPCookieStorage = HTTPCookieStorage.shared
                 let cookies:[HTTPCookie] = cstorage.cookies ?? []
                 for cookie:HTTPCookie in cookies {
                    //print("name：\(cookie.name)", "value：\(cookie.value)")
                    if cookie.name == "SESSION" {
                        let session = "SESSION"+"="+cookie.value
                        UserDefaults.standard.set(session, forKey: "mUserDefaultsCookie")
                        if UserDefaults.standard.synchronize() {
                            let myCookie:String = UserDefaults.standard.string(forKey: "mUserDefaultsCookie")!
                            print("myCookie====\(myCookie)")
                        }
                    }
                 }
                //跳转主页
                let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
                appDelegate.gotoHome()
            }else{
                UIView.showText(response.rtnMsg!)
           }
        }
    }
    
}
