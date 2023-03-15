//
//  EditDetailsViewController.swift
//  SignUp
//
//  Created by Rishik Dev on 21/02/23.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class EditDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageViewProfilePhoto: UIImageView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldMiddleName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var buttonSelectGender: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var datePickerDateOfBirth: UIDatePicker!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldCountry: UITextField!
        
    var databaseRef: DatabaseReference?
    var storageRef: StorageReference?
    var editUserDetailsVM: EditUserDetailsViewModel?
    
    var localUser: LocalUser!
    var sharedUser: SharedUser!
    var dateOfBirth: Date?
    var selectedGender: Constants.Genders!
    var genderMenu: UIMenu!
    
    var profilePhotoURLPath: URL?
    var isNewProfilePhotoSelected: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialConfiguration()
    }
    
    @objc func buttonSaveAction() {        
        saveHandler()
    }
    
    @IBAction func dateOfBirthAction(_ sender: UIDatePicker) {
        dateOfBirth = datePickerDateOfBirth.date
        labelAge.text = "\(ValidateData.shared.isValidDateOfBirth(value: dateOfBirth ?? Date()).1 ?? 0)"
    }
}
