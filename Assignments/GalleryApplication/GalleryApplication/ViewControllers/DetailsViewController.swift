//
//  DetailsViewController.swift
//  GalleryApplication
//
//  Created by Rishik Dev on 09/02/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageViewFullSizeImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var photo: GalleryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateDetails()
    }
    
    func populateDetails() {
        guard let photo = photo else { return }
        
        imageViewFullSizeImage.loadImage(from: photo.url ?? Constants.urls.defaultPhoto.rawValue)
        labelTitle.text = photo.title
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
