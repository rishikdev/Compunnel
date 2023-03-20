//
//  SignedInTabBarController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SignedInTabBarController: UITabBarController {
    
    var databaseRef: DatabaseReference?
    var storageRef: StorageReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        guard let tabBarItems = tabBar.items else { return }
        
        tabBarItems[0].title = Constants.TabBarTitles.homeTab
        tabBarItems[1].title = Constants.TabBarTitles.exploreTab
        tabBarItems[2].title = Constants.TabBarTitles.messagesTab
        tabBarItems[3].title = Constants.TabBarTitles.settingsTab
        
//        if let homeNavigationController = viewControllers?[0] as? UINavigationController {
//            let homeVC = homeNavigationController.topViewController as! HomeTabViewController
//            homeVC.sharedUser = sharedUser
//        }
    }
}

extension SignedInTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if(tabBarController.selectedIndex == 3) {
            guard let settingsNavigationVC = tabBarController.viewControllers?[3] as? UINavigationController else { return }
            guard let settingsVC = settingsNavigationVC.topViewController as? SettingsTabViewController else { return }
            
            settingsVC.databaseRef = databaseRef
            settingsVC.storageRef = storageRef
        }
    }
}
