//
//  SimpleDialog.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/09.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//
import UIKit

struct SimpleDialogButton {
    var title: String
    var handler: (UIAlertAction)->Void
}

class SimpleDialog{
    static func make(title: String, message: String, simpleDialogButtons: [SimpleDialogButton],uiviewcontroller: UIViewController){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for simpleDialogbutton in simpleDialogButtons {
            let button = UIAlertAction(title: simpleDialogbutton.title, style: .default, handler: simpleDialogbutton.handler)
            alert.addAction(button)
        }
        uiviewcontroller.present(alert, animated: true, completion: nil)
    }
}
