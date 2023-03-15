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
    var localUser: LocalUser!
    var sharedUser: SharedUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        
        guard let tabBarItems = tabBar.items else { return }
        
        tabBarItems[0].title = Constants.TabBarTitles.homeTab
        tabBarItems[1].title = Constants.TabBarTitles.friendsTab
        tabBarItems[2].title = Constants.TabBarTitles.messagesTab
        tabBarItems[3].title = Constants.TabBarTitles.settingsTab
        
        if let homeNavigationController = viewControllers?[0] as? UINavigationController {
            let homeVC = homeNavigationController.topViewController as! SignedInHomeViewController
            homeVC.localUser = localUser
            homeVC.sharedUser = sharedUser
        }
    }
}

extension SignedInTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if(tabBarController.selectedIndex == 0) {
            guard let homeNavigationVC = tabBarController.viewControllers?[3] as? UINavigationController else { return }
            guard let homeVC = homeNavigationVC.topViewController as? SignedInHomeViewController else { return }

            homeVC.localUser = localUser
            homeVC.sharedUser = sharedUser
        }
        
        if(tabBarController.selectedIndex == 3) {
            guard let settingsNavigationVC = tabBarController.viewControllers?[3] as? UINavigationController else { return }
            guard let settingsVC = settingsNavigationVC.topViewController as? SignedInSettingsViewController else { return }
            
            settingsVC.databaseRef = databaseRef
            settingsVC.storageRef = storageRef
            settingsVC.localUser = localUser
            settingsVC.sharedUser = sharedUser
        }
    }
}
