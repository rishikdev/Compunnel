//
//  ViewController.swift
//  UserInfo
//
//  Created by Rishik Dev on 10/02/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var stackViewInfo: UIStackView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    
    var userViewModel: UserViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userViewModel = UserViewModel()
        fetchUser()
    }

    func fetchUser() {
        userViewModel?.getUser {
            DispatchQueue.main.async {
                self.populateLabels()
            }
        }
    }
    
    func populateLabels() {
        guard let user = userViewModel?.user else { return }
        
        let date = formatDate(dateCreated: user.created ?? "No Date")
        
        labelName.text = user.name
        labelHeight.text = user.height
        labelCreated.text = date
    }
    
    func formatDate(dateCreated: String) -> String {
        let dateFormatterReceived = DateFormatter()
        let dateFormatterOut = DateFormatter()
        
        dateFormatterReceived.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterOut.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatterReceived.date(from: dateCreated) {
            return dateFormatterOut.string(from: date)
        } else {
            return "No Date"
        }
    }
}

