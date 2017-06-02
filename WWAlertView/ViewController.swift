//
//  ViewController.swift
//  WWAlertView
//
//  Created by 邬维 on 2017/5/31.
//  Copyright © 2017年 kook. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WWCustomAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let launchDialog = UIButton.init(type: .custom)
        launchDialog.frame = CGRect.init(x: 20, y: 70, width: 150, height: 50)
        launchDialog.addTarget(self, action: #selector(self.launchDialog), for: .touchUpInside)
        launchDialog.setTitle("Launch Dialog", for: .normal)
        launchDialog.backgroundColor = UIColor.darkGray
        self.view.addSubview(launchDialog)
    }


    //主线程
    func launchDialog() {
        
        let alertView = WWCustomAlertView.initSharedWithFrame(prentFrame: CGRect.init(x: 20, y: 100, width: 300, height: 150))
        // Add some custom content to the alert view
        alertView.containerView = self.createDemoView()
        
        // Modify the parameters
        alertView.buttonImages = ["icon_refuse","icon_answer"]
        alertView.buttonTitles = ["拒绝","接听"]
        alertView.alertDelegate = self
        alertView.show()
    }
    
    func customDialogButtonTouchUpInside(_ alertView: AnyObject, clickedButtonAtIndex buttonIndex: Int) {
        debugPrint("Delegate: Button at position: \(buttonIndex) is clicked on alertView \(alertView.tag)")
    }
    
    //自定义界面
    func createDemoView() -> UIView {
        let infoView = UIView.init(frame:CGRect(x:0, y:0, width:290, height:100))
        
        let imageView = UIImageView.init(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        imageView.image = UIImage.init(named: "add_staff_contact")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        infoView.addSubview(imageView)
        
        let subLabel = UILabel.init(frame: CGRect(x: imageView.right() + 16, y: 25 , width: 100, height: 20))
        subLabel.numberOfLines = 1
        subLabel.text = "张三正在呼叫你"
        subLabel.textAlignment = .left
        subLabel.textColor = UIColor.gray
        subLabel.font = UIFont.systemFont(ofSize: 14)
        infoView.addSubview(subLabel)
        
        
        let txtLabel = UILabel.init(frame: CGRect(x: imageView.right() + 16, y: subLabel.bottom() + 5, width: 180, height: 20))
        txtLabel.numberOfLines = 1
        txtLabel.text = "是否接听通话"
        txtLabel.textAlignment = .left
        txtLabel.textColor = UIColor.gray
        txtLabel.font = UIFont.systemFont(ofSize: 14)
        infoView.addSubview(txtLabel)
        
        return infoView
    }

}

