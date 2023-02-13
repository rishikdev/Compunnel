//
//  GalleryCollectionViewController.swift
//  GalleryApplication
//
//  Created by Rishik Dev on 09/02/23.
//

import UIKit

class GalleryCollectionViewController: UIViewController {

    @IBOutlet weak var collectionViewGallery: UICollectionView!
    
    var galleryViewModel: GalleryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureCollectionView()
        galleryViewModel = GalleryViewModel()
        getPhotos()
    }
    
    func configureCollectionView() {
        self.collectionViewGallery.delegate = self
        self.collectionViewGallery.dataSource = self
    }
    
    func getPhotos() {
        galleryViewModel?.getPhotos {
            DispatchQueue.main.async {
                self.collectionViewGallery.reloadData()
            }
        }
    }
}

extension GalleryCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galleryViewModel?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCollectionCell", for: indexPath) as? CustomGalleryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageViewThumbnail.loadImage(from: galleryViewModel?.getPhoto(at: indexPath.row).thumbnailUrl ?? Constants.urls.defaultPhoto.rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.photo = galleryViewModel?.getPhoto(at: indexPath.row)
        
        navigationController?.present(detailsViewController, animated: true)
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                    }
                }
            }
        }
    }
}
