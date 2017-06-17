//
//  WWCustomAlertView.swift
//  WWCustomAlertView
//
//  Created by wuwei on 16/8/10.
//  Copyright © 2016年 wuwei. All rights reserved.
//

import UIKit

//扩展
extension UIView {
    
    func bottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func right() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width;
    }
}

//代理
protocol WWCustomAlertViewDelegate {
    //required
    func customDialogButtonTouchUpInside(_ alertView:AnyObject,clickedButtonAtIndex buttonIndex:Int);
    
}


//弹出窗
private var customAlertView:WWCustomAlertView?

class WWCustomAlertView: UIView {
    
    fileprivate final let kCustomIOSAlertViewDefaultButtonHeight:CGFloat = 40
    fileprivate final let kCustomIOSAlertViewDefaultButtonSpacerHeight:CGFloat = 1
    fileprivate final let kCustomIOSAlertViewCornerRadius:CGFloat = 7
    
    fileprivate final let kContainerViewWidth:Int = 300
    fileprivate final let kContainerViewHeight:Int = 150
    
    //
    var dialogView:UIView?     // Dialog's container view
    var containerView:UIView?  // Container within the dialog (place your ui elements here)
    
    var alertDelegate:WWCustomAlertViewDelegate?
    var buttonTitles:Array<String>?
    var buttonImages:Array<String>?
    
    fileprivate var buttonHeight:CGFloat = 0
    fileprivate var buttonSpacerHeight:CGFloat = 0
    
    //初始化
    static func initSharedWithFrame() -> WWCustomAlertView {
        if customAlertView == nil {
            customAlertView = WWCustomAlertView.init()
            customAlertView!.isHidden = false
            customAlertView!.backgroundColor = UIColor.clear
        }
        return customAlertView!
    }

    
    // 创建dialog view, 并且用动画打开
    func show() {
        dialogView = self.createContainerView()
        dialogView!.layer.shouldRasterize = true
        dialogView!.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.addSubview(dialogView!)
        
        let screenSize = self.countScreenSize()
        let dialogSize = self.countDialogSize()
        let keyboardSize = CGSize(width: 0, height: 0);
        dialogView!.frame = CGRect(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - keyboardSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height);
        
        let windows = UIApplication.shared.windows
        windows.first!.addSubview(self)
        
        dialogView!.layer.opacity = 0.5
        dialogView!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.0);
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.4)
            self.dialogView?.layer.opacity = 1.0
            self.dialogView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: nil)
    }
    
    // Creates the container view here: create the dialog, then add the custom content and buttons
    func createContainerView() -> UIView {
        
        if containerView == nil{
            containerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kContainerViewWidth, height: kContainerViewHeight))
        }
        
        let screenSize:CGSize = self.countScreenSize()
        let dialogSize = self.countDialogSize()
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        // This is the dialog's container; we attach the custom content and the buttons to this one
        let dialogContainer = UIView.init(frame: CGRect(x: (screenSize.width - dialogSize.width) / 2, y: (screenSize.height - dialogSize.height) / 2, width: dialogSize.width, height: dialogSize.height))
        
        // First, we style the dialog to match the iOS7 UIAlertView
        let gradient = CAGradientLayer()
        gradient.frame = dialogContainer.bounds
        gradient.colors = [UIColor.white.cgColor,UIColor.white.cgColor,UIColor.white.cgColor]
        gradient.cornerRadius = kCustomIOSAlertViewCornerRadius
        
        dialogContainer.layer.insertSublayer(gradient, at: 0)
        dialogContainer.layer.cornerRadius = kCustomIOSAlertViewCornerRadius
        dialogContainer.layer.borderColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 198/255.0, alpha: 1).cgColor
        dialogContainer.layer.borderWidth = 1
        dialogContainer.layer.shadowRadius = kCustomIOSAlertViewCornerRadius + 5
        dialogContainer.layer.shadowOpacity = 0.1
        dialogContainer.layer.shadowOffset = CGSize(width: 0 - (kCustomIOSAlertViewCornerRadius+5)/2, height: 0 - (kCustomIOSAlertViewCornerRadius+5)/2)
        dialogContainer.layer.shadowColor = UIColor.black.cgColor
        dialogContainer.layer.shadowPath = UIBezierPath.init(roundedRect: dialogContainer.bounds, cornerRadius: dialogContainer.layer.cornerRadius).cgPath
        
        // There is a line above the button
        let lineView = UIView.init(frame: CGRect(x: 0, y: dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, width: dialogContainer.bounds.size.width, height: buttonSpacerHeight))
        lineView.backgroundColor = UIColor.groupTableViewBackground
        dialogContainer.addSubview(lineView)
        
        // Add the custom container if there is any
        dialogContainer.addSubview(containerView!)
        
        // Add the buttons too
        self.addButtonsToView(dialogContainer)
        
        return dialogContainer;
    }
    
    // Helper function: add buttons to container
    func addButtonsToView(_ container:UIView) {
        
        if buttonTitles == nil && buttonImages == nil { return }
        var i:CGFloat = 0
        
        if (buttonImages == nil && (buttonTitles?.count)! > 0) { // 按键只有文字没有图片
            let buttonWidth = container.bounds.size.width / CGFloat(buttonTitles!.count)
            for title in buttonTitles! {
                let closeButton = UIButton(type: .custom)
                closeButton.frame = CGRect(x: i * buttonWidth, y: container.bounds.size.height - buttonHeight, width: buttonWidth, height: buttonHeight)
                closeButton.addTarget(self, action: #selector(customButtonTouchUpInside(_:)), for: .touchUpInside)
                closeButton.tag = Int(i)
                closeButton.setTitle(title, for: UIControlState())
                closeButton.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: UIControlState())
                closeButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
                closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                closeButton.layer.cornerRadius = kCustomIOSAlertViewCornerRadius
                i = i + 1
                container.addSubview(closeButton)
                
            }
        }
        else if buttonImages!.count > 0 && buttonTitles == nil {   //  按键只有图片没有文字
            let buttonWidth = container.bounds.size.width / CGFloat(buttonImages!.count)
            for imgName in buttonImages! {
                let closeButton = UIButton(type: .custom)
                closeButton.frame = CGRect(x: i * buttonWidth, y: container.bounds.size.height - buttonHeight, width: buttonWidth, height: buttonHeight)
                closeButton.addTarget(self, action: #selector(customButtonTouchUpInside(_:)), for: .touchUpInside)
                closeButton.tag = Int(i)
                
                if Int(i) != (buttonImages!.count - 1) {
                    let lineView = UIView(frame: CGRect(x: closeButton.frame.size.width, y: 0, width: 1, height: buttonHeight))
                    lineView.backgroundColor = UIColor.groupTableViewBackground
                    closeButton.addSubview(lineView)
                }
                let image = UIImageView.init(image:  UIImage(named: imgName), highlightedImage:  UIImage(named: imgName))
                let width = image.frame.width
                let height = image.frame.height
                image.frame = CGRect(x: (buttonWidth - width)/2, y: (buttonHeight - height)/2, width: width, height: height)
                closeButton.addSubview(image)
                closeButton.layer.cornerRadius = kCustomIOSAlertViewCornerRadius
                i = i + 1
                container.addSubview(closeButton)
            }
        } else { // 文字+图片
            let buttonWidth = container.bounds.size.width / CGFloat(buttonTitles!.count)
            for title in buttonTitles! {
                let closeButton = UIButton(type: .custom)
                closeButton.frame = CGRect(x: i * buttonWidth, y: container.bounds.size.height - buttonHeight, width: buttonWidth, height: buttonHeight)
                closeButton.addTarget(self, action: #selector(customButtonTouchUpInside(_:)), for: .touchUpInside)
                closeButton.tag = Int(i)
                closeButton.setTitle(title, for: UIControlState())
                closeButton.setImage(UIImage(named:buttonImages![Int(i)] ), for: .highlighted)
                closeButton.setImage(UIImage(named:buttonImages![Int(i)] ), for: .normal)
                closeButton.setTitleColor(UIColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: UIControlState())
                closeButton.setTitleColor(UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
                closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                closeButton.layer.cornerRadius = kCustomIOSAlertViewCornerRadius
                i = i + 1
                container.addSubview(closeButton)
            }
        }
    }
    
    // Button has been touched
    func customButtonTouchUpInside(_ sender:AnyObject) {
        if alertDelegate != nil {
            alertDelegate?.customDialogButtonTouchUpInside(self, clickedButtonAtIndex: sender.tag)
            self.close()
        }
    }
    
    // Dialog close animation then cleaning and removing the view from the parent
    func close() {
        let currentTransform = dialogView!.layer.transform;
        dialogView!.layer.opacity = 1.0
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.0)
            self.dialogView!.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1.0))
            self.dialogView!.layer.opacity = 0.0
        }) { (finished) in
            for view in self.subviews {
                view.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    
    
    
    // Helper function: count and return the dialog's size
    func countDialogSize() -> CGSize {
        let dialogWidth = containerView!.frame.size.width
        let dialogHeight = containerView!.frame.size.height + buttonHeight + buttonSpacerHeight
        return CGSize(width: dialogWidth, height: dialogHeight)
    }
    
    // Helper function: count and return the screen's size
    func countScreenSize() -> CGSize {
        if buttonTitles != nil && (buttonTitles?.count)! > 0 {
            buttonHeight = kCustomIOSAlertViewDefaultButtonHeight
            buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight
        } else if buttonImages != nil && buttonImages!.count > 0 {
            buttonHeight = kCustomIOSAlertViewDefaultButtonHeight
            buttonSpacerHeight = kCustomIOSAlertViewDefaultButtonSpacerHeight
        } else {
            buttonHeight = 0
            buttonSpacerHeight = 0
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        return CGSize(width: screenWidth, height: screenHeight);
    }

    deinit{
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self)
    }
    
}
