//
//  SignedInHomeViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 01/03/23.
//

import UIKit

class SignedInHomeViewController: UIViewController {
        
    @IBOutlet weak var labelNoContent: UILabel!
    
    var signedInHomeVM: SignedInHomeViewModel!
    var localUser: LocalUser!
    var sharedUser: SharedUser!
    var postPhotoURLPath: URL?
    var posts: [PostModel]?
                
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialConfiguration()
    }
}
