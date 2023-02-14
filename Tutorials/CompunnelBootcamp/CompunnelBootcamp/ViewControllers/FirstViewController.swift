//
//  ViewController.swift
//  CompunnelBootcamp
//
//  Created by Rishik Dev on 26/01/23.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var imagePlay: UIImageView!
        
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var buttonSignUp: UIButton!
    
    @IBOutlet weak var buttonForgotPassword: UIButton!
    
    @IBOutlet weak var textFieldUserName: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    
    private enum Buttons: String {
        case ButtonLogin = "Login"
        case ButtonSignUp = "Sign Up"
        case ButtonForgotPassword = "Forgot Password"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Stream"
        
        imagePlay.image = UIImage(named: "imagePlay")
        
        configureButton(button: buttonLogin, buttonTitle: Buttons.ButtonLogin.rawValue, buttonColour: .green)
        
        configureButton(button: buttonSignUp, buttonTitle: Buttons.ButtonSignUp.rawValue, buttonColour: .tintColor)
        
        configureButton(button: buttonForgotPassword, buttonTitle: Buttons.ButtonForgotPassword.rawValue, buttonColour: .red)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureButton(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func handleButtonLogin(_ sender: Any) {
        
        if let username = textFieldUserName.text, username.isEmpty {
            
            let alertController = UIAlertController(title: "Error", message: "Username cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true)
            
            return
        }
        
        if let password = textFieldPassword.text, password.isEmpty {
            
            let alertController = UIAlertController(title: "Error", message: "Password cannot be empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true)
            
            return
        }
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ContentListViewController") as? ContentListViewController {
            
            controller.username = textFieldUserName.text
            
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
