//
//  ViewController.swift
//  GalleryApplication
//
//  Created by Rishik Dev on 09/02/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewGallery: UITableView!
    var galleryViewModel: GalleryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        galleryViewModel = GalleryViewModel()
        getPhotos()
    }
    
    func configureTableView() {
        self.tableViewGallery.delegate = self
        self.tableViewGallery.dataSource = self
    }
    
    func getPhotos() {
        galleryViewModel?.getPhotos {
            DispatchQueue.main.async {
                self.tableViewGallery.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        galleryViewModel?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "galleryCell", for: indexPath) as? CustomGalleryTableViewCell else { return UITableViewCell() }
        
        let photo = galleryViewModel?.getPhoto(at: indexPath.row)
        
        cell.imageViewThumbnail.loadImage(from: photo?.thumbnailUrl ?? Constants.urls.defaultPhoto.rawValue)
        cell.labelTitle.text = photo?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.photo = galleryViewModel?.getPhoto(at: indexPath.row)
        
        navigationController?.present(detailsViewController, animated: true)
    }
}
