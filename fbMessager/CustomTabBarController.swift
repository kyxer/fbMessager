//
//  CustomTabBarController.swift
//  fbMessager
//
//  Created by IT-German on 3/24/17.
//  Copyright © 2017 german. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let friendController = FriendsController(collectionViewLayout: UICollectionViewFlowLayout())
        let recentMessageController = UINavigationController(rootViewController: friendController)
        recentMessageController.tabBarItem.title = "Recent"
        recentMessageController.tabBarItem.image = UIImage(named: "recent")
        
        
        viewControllers = [recentMessageController, createDummyNavControllerWithTitle(title: "Calls", imagedName: "calls"),
        createDummyNavControllerWithTitle(title: "Groups", imagedName: "group"),
        createDummyNavControllerWithTitle(title: "People", imagedName: "people"),
        createDummyNavControllerWithTitle(title: "Settings", imagedName: "setting")]
    }
    
    private func createDummyNavControllerWithTitle(title:String,imagedName:String)->UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named:imagedName)
        return navigationController
    }
}
