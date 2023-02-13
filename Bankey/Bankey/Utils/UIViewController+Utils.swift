//
//  UIViewController+Utils.swift
//  Bankey
//
//  Created by Michael Gimara on 13/02/2023.
//

import UIKit

extension UIViewController {
    
    func setStatusBar(color: UIColor) {
        let statusBarSize = view.window?.windowScene?.statusBarManager?.statusBarFrame.size ?? .zero
        let frame = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView = UIView(frame: frame)
        statusBarView.backgroundColor = color
        view.addSubview(statusBarView)
    }
    
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
