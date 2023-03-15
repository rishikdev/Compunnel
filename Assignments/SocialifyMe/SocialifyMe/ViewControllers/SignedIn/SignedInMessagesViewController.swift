//
//  SignedInChatsViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit

class SignedInMessagesViewController: UIViewController {

    @IBOutlet weak var labelNoMessages: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title =  Constants.TabBarTitles.messagesTab
        labelNoMessages.text = Constants.LabelTexts.noMessages
    }
}
