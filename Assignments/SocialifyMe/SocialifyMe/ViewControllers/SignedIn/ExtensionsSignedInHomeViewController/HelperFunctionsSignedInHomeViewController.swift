//
//  HelperFunctionsSignedInHomeViewController.swift
//  SocialifyMe
//
//  Created by Rishik Dev on 10/03/23.
//

import UIKit

extension SignedInHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CreatePostVCProtocol {
    func reloadHomeVC() {
        fetchPosts()
    }
    
    func initialConfiguration() {
        self.navigationItem.title =  Constants.VCTitles.signedInHomeVCTitle
        self.signedInHomeVM = SignedInHomeViewModel()
        self.labelNoContent.text = Constants.LabelTexts.noContent
        self.labelNoContent.isHidden = true
       
        addUploadPostButton()
        fetchPosts()
    }
    
    private func addUploadPostButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(uploadPostButtonHandler))
    }
    
    @objc private func uploadPostButtonHandler() {
        guard let createPostVC = storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as? CreatePostViewController else { return }
        createPostVC.localUser = self.localUser
        createPostVC.delegate = self
        navigationController?.present(createPostVC, animated: true)
    }
    
    private func fetchPosts() {
        let activityIndicator = self.addActivityIndicator()
        self.signedInHomeVM.fetchPostsMetadata() { [weak self] fetchPostMessage, postModelArray, arePostsFetched in
            self?.removeActivityIndicator(activityIndicator: activityIndicator)
            if(arePostsFetched) {
                /// There is at least one post in the database.
                if(!postModelArray!.isEmpty) {
                    self?.posts = postModelArray
                    self?.posts?.sort { p1, p2 in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm"
                        return dateFormatter.date(from: p1.postTimeCreated!)! > dateFormatter.date(from: p2.postTimeCreated!)!
                    }
                    self?.displayPosts()
                } else {
                    /// There are no posts in the database.
                    self?.labelNoContent.isHidden = false
                }
            } else {
                self?.presentAlert(title: Constants.Alerts.Titles.unsuccessful, message: fetchPostMessage)
            }
        }
    }
    
    private func displayPosts() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
                
        let stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
        stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        stackView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
        stackView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        if let posts = self.posts {
            for post in posts {
                let postView = PostView()
                
                if(post.userProfilePhotoFirebaseStorageURL!.isEmpty) {
                    postView.imageViewProfilePhoto.load(Constants.DefaultURLs.noProfilePhoto)
                } else {
                    postView.imageViewProfilePhoto.load(post.userProfilePhotoFirebaseStorageURL!)
                }
                postView.imageViewProfilePhoto.roundImage()
                
                postView.labelUserName.text = post.userName
                postView.labelTimeCreated.text = post.postTimeCreated
                
                postView.imageViewPostPhoto.load(post.postPhotoStorageURL ?? Constants.DefaultURLs.noPostPhoto)
                postView.imageViewPostPhoto.layer.cornerRadius = 10
                
                if(post.postDescription?.trimmingCharacters(in: .whitespaces) != "") {
                    postView.labelUserNameDescription.text = post.userName
                    postView.labelPostDescription.text = post.postDescription
                } else {
                    postView.stackViewDescription.isHidden = true
                }
                
                stackView.addArrangedSubview(postView)
                postView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
                postView.heightAnchor.constraint(greaterThanOrEqualToConstant: 525).isActive = true
            }
        }
    }
    
    private func addActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    private func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.Buttons.ok, style: .default))
        
        present(alertController, animated: true)
    }
}
