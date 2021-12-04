//
//  viewControllerExtension.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import UIKit
extension UIViewController {
    func showAlert(title:String,messageContent:String){
    DispatchQueue.main.async {
        let alertVC = AlertVC(title:title, message:messageContent, buttonTitle:"ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }}
}
