//
//  HelperFunctionsSignedInSettingsViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 03/03/23.
//

import UIKit

extension SignedInSettingsViewController {
    func initialConfiguration() {
        self.navigationItem.title =  Constants.VCTitles.signedInSettingsVC
        configureButton(button: buttonEditProfile, buttonTitle: Constants.Buttons.editProfile, buttonColour: .systemBlue)
        configureButton(button: buttonSignOut, buttonTitle: Constants.Buttons.signOut, buttonColour: .systemRed)
        
        self.signedInSettingsVM = SignedInSettingsViewModel()
    }
    
    func editProfile() {
        guard let editDetailsVC = storyboard?.instantiateViewController(withIdentifier: "EditDetailsViewController") as? EditDetailsViewController else { return }
        
        editDetailsVC.databaseRef = databaseRef
        editDetailsVC.localUser = localUser
        editDetailsVC.sharedUser = sharedUser
        editDetailsVC.dateOfBirth = localUser.dateOfBirth
        
        navigationController?.pushViewController(editDetailsVC, animated: true)
    }
    
    func configureButton(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
    }
    
    func signOut() {
        guard let signedOutHomeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignedOutHomeNavigationController") as? UINavigationController else { return }
        
        presentSignOutAlert(title: Constants.Alerts.Titles.confirmation, message: Constants.Alerts.Messages.signOutMessage, switchTo: signedOutHomeNavigationController)
    }
    
    func presentSignOutAlert(title: String, message: String, switchTo viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.signOut, style: .destructive) { _ in
            DispatchQueue.main.async {
                self.signedInSettingsVM.signOut(provider: self.localUser.providerName!) { [weak self] message, isSignedOut in
                    if(isSignedOut) {
                        self?.signedInSettingsVM.deleteAllLocalUsers(entity: Constants.CoreData.entityLocalUser)
                        self?.switchRootViewController(to: viewController)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: Constants.Buttons.cancel, style: .cancel))
        present(alertController, animated: true)
    }
}
