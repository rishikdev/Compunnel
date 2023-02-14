//
//  DetailsViewController.swift
//  CollectionViewTutorial
//
//  Created by Rishik Dev on 07/02/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageViewMovieImage: UIImageView!
    @IBOutlet weak var labelMovieName: UILabel!
    
    var movieImage: String?
    var movieName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populateDetails()
    }
    
    func populateDetails() {
        if let movieImage = movieImage,
           let movieName = movieName {
            
            imageViewMovieImage.image = UIImage(named: movieImage)
            labelMovieName.text = movieName
        }
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
