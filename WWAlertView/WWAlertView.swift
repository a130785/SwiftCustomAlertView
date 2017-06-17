//
//  WWAlertView.swift
//  WWAlertView
//
//  Created by 邬维 on 2017/6/5.
//  Copyright © 2017年 kook. All rights reserved.
//

import UIKit


class WWAlertView: NSObject {

    static let KScreenWidth = UIScreen.main.bounds.size.width
    
   /// <#Description#>
   ///
   /// - Parameters:
   ///   - target: <#target description#>
   ///   - title: <#title description#>
   ///   - contentMsg: <#contentMsg description#>
   static func showAlertViewController(target:UIViewController?,title:String?,contentMsg:String?) {
      self.showAlertViewController(target: target, title: title, contentMsg: contentMsg,style:.alert, actions: nil)
    }
    
    static func showAlertViewController(target:UIViewController?,title:String?,contentMsg:String?,actions:Array<UIAlertAction>?) {
        self.showAlertViewController(target: target, title: title, contentMsg: contentMsg,style:.alert, actions: actions)
    }
    
    //cancel Action not nil
    static func showSheetView(target:UIViewController?,contentMsg:String?,actions:Array<UIAlertAction>?) {
        self.showAlertViewController(target: target, title: nil, contentMsg: contentMsg,style:.actionSheet, actions: actions)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - title: <#title description#>
    ///   - contentMsg: <#contentMsg description#>
    ///   - actions: <#actions description#>
    static func showAlertViewController(target:UIViewController?,
                                        title:String?,
                                        contentMsg:String?,
                                        style:UIAlertControllerStyle,
                                        actions:Array<UIAlertAction>?) {
        
        var actions = actions
        if target == nil {
            assert(false)
            return
        }
    
        let alertController = UIAlertController.init(title: title, message: contentMsg, preferredStyle:style)
        if actions == nil {
            let alertAction = UIAlertAction.init(title: "Done", style: .cancel, handler: { (_) in
                
            })
            actions = [alertAction]
        }
        for action in actions! {
            alertController.addAction(action)
        }
        target!.present(alertController, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - target: <#target description#>
    ///   - title: <#title description#>
    ///   - placeholderText: <#placeholderText description#>
    ///   - completion: <#completion description#>
    static func showTextFieldAlertController(target:UIViewController?, title:String?, placeholderText:String, completion:@escaping (String) -> (Void)) {
        if target == nil {
            assert(false)
            return
        }
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction.init(title: "Done", style: .default) { (action) in
            let filed = alertController.textFields?.first
            guard (filed?.text?.characters.count)! > 0 || placeholderText.characters.count > 0 else {
                return
            }
            if (filed?.text?.characters.count)! > 0{
                completion((filed?.text)!)
            }else{
                completion(placeholderText)
            }
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeholderText
        }
        target!.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - drop-down
    static var _view:UIView?
    static func showTopAffineViewDismissTime(time:TimeInterval, contentText:String, image:UIImage) {
        
        _view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth, height: 65))
        _view?.backgroundColor =  UIColor.init(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1)
        
        let imageView = UIImageView.init(frame: CGRect.init(x: 10, y: 20, width: 25, height: 25))
        imageView.image = image
        _view?.addSubview(imageView)
        
        let lable = UILabel.init(frame: CGRect.init(x: 50, y: 0, width: KScreenWidth - 60, height: 65))
        lable.text = contentText
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textColor = UIColor.white
        _view?.addSubview(lable)
        
        UIApplication.shared.delegate?.window??.addSubview(_view!)
        
        _view?.transform = CGAffineTransform.init(translationX: 0, y: -65)
        UIView.animate(withDuration: 0.25) { 
            _view?.transform = CGAffineTransform.identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+time) { 
            self.dismissView()
        }
    }
    
    static func dismissView() {
        UIView.animate(withDuration: 0.25, animations: {
            _view?.transform = CGAffineTransform.init(translationX: 0, y: -65)
        }) { (finished) in
            _view?.removeFromSuperview()
        }
    }
    
}
