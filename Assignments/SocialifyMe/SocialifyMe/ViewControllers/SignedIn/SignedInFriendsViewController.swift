//
//  SignedInSearchViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit

class SignedInFriendsViewController: UIViewController {

    @IBOutlet weak var labelNoFriends: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title =  Constants.TabBarTitles.friendsTab
        labelNoFriends.text = Constants.LabelTexts.noFriends
    }
}
