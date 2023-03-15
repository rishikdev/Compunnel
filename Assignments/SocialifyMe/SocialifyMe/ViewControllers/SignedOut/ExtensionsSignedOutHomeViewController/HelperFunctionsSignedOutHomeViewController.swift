//
//  DetermineProvider.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 28/02/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseCrashlytics
import FacebookLogin
import GoogleSignIn

extension SignedOutHomeViewController {
    
    func initialConfiguration() {
        title = Constants.VCTitles.signedOutHomeVCTitle
        
        self.signedOutHomeVM = SignedOutHomeViewModel()
        populateLabelsAndTextFieldPlaceholders()
                
        configureButton(button: buttonSignIn, buttonTitle: Constants.Buttons.signIn, buttonColour: .systemGreen)
        configureButton(button: buttonSignUp, buttonTitle: Constants.Buttons.signUp, buttonColour: .systemBlue)
        configureButton(button: buttonSignInWithGoogle, buttonTitle: Constants.Buttons.signInWithGoogle, buttonColour: .systemOrange)
        configureButton(button: buttonSignInWithFacebook, buttonTitle: Constants.Buttons.signInWithFacebook, buttonColour: .systemBlue)
    }
    
    func populateLabelsAndTextFieldPlaceholders() {
        labelEmail.text = Constants.TextFieldPlaceholders.email
        labelPassword.text = Constants.TextFieldPlaceholders.password
        textFieldEmail.placeholder = Constants.TextFieldPlaceholders.email
        textFieldPassword.placeholder = Constants.TextFieldPlaceholders.password
    }
    
    func configureLogoBackground() {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.viewLogoBackground.frame
        rectShape.position = self.viewLogoBackground.center
        rectShape.path = UIBezierPath(roundedRect: self.viewLogoBackground.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 40, height: 40)).cgPath
        
        self.viewLogoBackground.layer.mask = rectShape
    }
    
    func changeTitleColour(to titleColour: UIColor) {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: titleColour]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: titleColour]
    }
    
    func configureButton(button: UIButton, buttonTitle: String, buttonColour: UIColor) {
        button.configuration = .tinted()
        button.configuration?.title = buttonTitle
        button.configuration?.baseBackgroundColor = buttonColour
        button.configuration?.baseForegroundColor = buttonColour
    }
    
    func configureCrashlytics() {
        Crashlytics.crashlytics().log("View Loaded")
        
        Crashlytics.crashlytics().setCustomValue(2023, forKey: "Year")
        Crashlytics.crashlytics().setCustomValue("Rishik Dev", forKey: "Name")
        Crashlytics.crashlytics().setUserID("303")
        
        // Non fatal errors
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("The request failed", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("The request returned 404", comment: ""),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: ""),
            "ProductID": "111",
            "UserID": "R Dev"
        ]
        let error = NSError(domain: NSURLErrorDomain, code: -1001, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    func addActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    func signUpWithEmailPassword() {
        detailedSignUp()
    }

    // MARK: - Detailed Sign Up
    func detailedSignUp(localUser: LocalUser? = nil) {
        guard let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        signUpVC.databaseRef = databaseRef
        signUpVC.localUser = localUser
        signUpVC.email = textFieldEmail.text
        signUpVC.password = textFieldPassword.text
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK: - Sign In With Email And Password
    /// Signs users in with their **Email** and **Password**.
    ///
    func signInWithEmailPassword() {
        if let email = textFieldEmail.text,
           let password = textFieldPassword.text,
           email != "" && password != "" {
            let activityIndicator = addActivityIndicator()
            
            guard let signedInTabBarController = UIStoryboard(name: "SignedIn", bundle: nil).instantiateViewController(withIdentifier: "SignedInTabBarController") as? SignedInTabBarController else { return }
            signedInTabBarController.databaseRef = databaseRef
            signedInTabBarController.storageRef = storageRef
            
            signedOutHomeVM?.signInWithEmailPassword(email: email, password: password) { [weak self] message, isSignInSuccessful, localUser in
                self?.removeActivityIndicator(activityIndicator: activityIndicator)
                signedInTabBarController.localUser = localUser
                
                if(isSignInSuccessful) {
                    DispatchQueue.main.async {
                        self?.switchRootViewController(to: signedInTabBarController)
                    }
                } else {
                    self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: message)
                }
            }
        } else {
            presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: Constants.Alerts.Messages.unsuccessfulSignIn)
        }
    }
    
    // MARK: - Sign In With Google
    /// Signs users in with **Google**.
    /// 1. If sign in is successful, create a local profile by adding the details of the user fetched from **Real Time Database** to **Core Data**.
    ///     - Step 1 is handled by ``SignedOutHomeViewModel/signInWithGoogle(currentVewController:completion:)`` defined in ``SignedOutHomeViewModel``.
    /// 2. If new user, then create his/her profile in **Firebase Realtime Database**.
    /// 3. Then, ask if the user would like to complete his/her profile.
    ///     - If yes, then take the user to the ``SignUpViewController``. Updation of user's local and online profile is handled there. The steps of signing the user in after updating his/her profile is also handled there.
    ///     - If no, then sign in the user with an incomplete profile
    /// 4. If returning user, then switch `Root View Controller` to ``SignedInTabBarController``.
    ///
    func signInWithGoogle() {
        let activityIndicator = addActivityIndicator()
        
        signedOutHomeVM?.signInWithGoogle(currentVewController: self) { [weak self] message, isSignInSuccessful, localUser, isNewUser in
            self?.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if(isSignInSuccessful) {
                guard let signedInTabBarController = UIStoryboard(name: "SignedIn", bundle: nil).instantiateViewController(withIdentifier: "SignedInTabBarController") as? SignedInTabBarController else { return }
                signedInTabBarController.databaseRef = self?.databaseRef
                signedInTabBarController.storageRef = self?.storageRef
                signedInTabBarController.localUser = localUser
                
                if(isNewUser) {
                    let userModel = UserModel(uid: (localUser?.uid)!,
                                              providerName: (localUser?.providerName)!,
                                              firstName: localUser?.firstName,
                                              middleName: localUser?.middleName,
                                              lastName: localUser?.lastName,
                                              email: (localUser?.email)!)
                    
                    self?.signedOutHomeVM?.createUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] createProfileMessage, isProfileCreated in
                        if(isProfileCreated) {
                            self?.presentAlertAndSwitchVC(title: Constants.Alerts.Titles.successful, message: Constants.Alerts.Messages.completeProfileUponSuccessfulSignUpUsingProvider, localUser: localUser!, switchTo: signedInTabBarController)
                        } else {
                            self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: createProfileMessage)
                        }
                    }
                } else {
                    self?.switchRootViewController(to: signedInTabBarController)
                }
            } else {
                if(message != Constants.Errors.operationTerminatedByTheUser) {
                    self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: message)
                }
            }
        }
    }
    
    // MARK: - Sign In With Facebook
    /// Signs users in with **Facebook**.
    /// 1. If sign in is successful, create a local profile by adding the details of the user fetched from **Real Time Database** to **Core Data**.
    ///     - Step 1 is handled by ``SignedOutHomeViewModel/signInWithFacebook(currentViewController:completion:)`` defined in ``SignedOutHomeViewModel``.
    /// 2. If new user, then create his/her profile in **Firebase Realtime Database**.
    /// 3. Then, ask if the user would like to complete his/her profile.
    ///     - If yes, then take the user to the ``SignUpViewController``. Updation of user's local and online profile is handled there. The steps of signing the user in after updating his/her profile is also handled there.
    ///     - If no, then sign in the user with an incomplete profile
    /// 4. If returning user, then switch `Root View Controller` to ``SignedInTabBarController``.
    ///
    func signInWithFacebook() {
        let activityIndicator = addActivityIndicator()
        
        signedOutHomeVM?.signInWithFacebook(currentViewController: self) { [weak self] message, isSignInSuccessful, localUser, isNewUser in
            self?.removeActivityIndicator(activityIndicator: activityIndicator)
            
            if(isSignInSuccessful) {
                guard let signedInTabBarController = UIStoryboard(name: "SignedIn", bundle: nil).instantiateViewController(withIdentifier: "SignedInTabBarController") as? SignedInTabBarController else { return }
                signedInTabBarController.databaseRef = self?.databaseRef
                signedInTabBarController.storageRef = self?.storageRef
                signedInTabBarController.localUser = localUser
                
                if(isNewUser) {
                    let userModel = UserModel(uid: (localUser?.uid)!,
                                              providerName: (localUser?.providerName)!,
                                              firstName: localUser?.firstName,
                                              middleName: localUser?.middleName,
                                              lastName: localUser?.lastName,
                                              email: (localUser?.email)!)
                    
                    self?.signedOutHomeVM?.createUserProfileInFirebaseDatabase(userModel: userModel) { [weak self] createProfileMessage, isProfileCreated in
                        if(isProfileCreated) {
                            self?.presentAlertAndSwitchVC(title: Constants.Alerts.Titles.successful, message: Constants.Alerts.Messages.completeProfileUponSuccessfulSignUpUsingProvider, localUser: localUser!, switchTo: signedInTabBarController)
                        } else {
                            self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: createProfileMessage)
                        }
                    }
                } else {
                    self?.switchRootViewController(to: signedInTabBarController)
                }
            } else {
                if(message != Constants.Errors.operationTerminatedByTheUser) {
                    self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: message)
                }
            }
        }
    }
    
    // MARK: - Alerts
    /// Presents alert requesting users to sign in with a given `provider`.
    /// 
    func presentAlert(signInWith provider: String) {
        let alertController = UIAlertController(title: Constants.Alerts.Titles.unsuccessful, message: Constants.Alerts.Messages.loginWithDifferentProvider.replacing("***", with: provider), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default))
        present(alertController, animated: true)
    }
    
    /// Presents some information pertinent to the user's actions.
    ///
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default))
        present(alertController, animated: true)
    }
    
    /// Presents some information pertinent to the user's actions and also prompts the user to create a profile.
    ///
    func presentAlertAndSwitchVC(title: String, message: String, localUser: LocalUser, switchTo viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.yesSure, style: .default) { _ in
            self.detailedSignUp(localUser: localUser)
        })
        alertController.addAction(UIAlertAction(title: Constants.Buttons.noMaybeLater, style: .cancel) { _ in
            self.switchRootViewController(to: viewController)
        })
        present(alertController, animated: true)
    }
}
