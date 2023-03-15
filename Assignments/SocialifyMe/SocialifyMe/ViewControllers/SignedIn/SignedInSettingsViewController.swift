//
//  SignedInSettingsViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SignedInSettingsViewController: UIViewController {
    
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var buttonSignOut: UIButton!
    
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var signedInSettingsVM: SignedInSettingsViewModel!
    var localUser: LocalUser!
    var sharedUser: SharedUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialConfiguration()
    }
    
    @IBAction func buttonEditProfileAction(_ sender: Any) {
        editProfile()
    }
    
    @IBAction func buttonSignOutAction(_ sender: Any) {
        signOut()
    }
}
