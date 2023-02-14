//
//  ViewController.swift
//  CollectionViewTutorial
//
//  Created by Rishik Dev on 07/02/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionViewMovies: UICollectionView!
    
    var movies: [Movies] = [
                            Movies(movieImage: "armourOfGod1", movieName: "Armour of God 1"),
                            Movies(movieImage: "armourOfGod2", movieName: "Armour of God 2"),
                            Movies(movieImage: "cityHunter", movieName: "City Hunter"),
                            Movies(movieImage: "policeStory1", movieName: "Police Story 1"),
                            Movies(movieImage: "policeStory2", movieName: "Police Story 2"),
                            Movies(movieImage: "policeStory3", movieName: "Police Story 3"),
                            Movies(movieImage: "projectA", movieName: "Project A"),
                            Movies(movieImage: "projectAPart2", movieName: "Project A Part 2"),
                            Movies(movieImage: "courageTheCowardlyDog", movieName: "Courage The Cowardly Dog"),
                            Movies(movieImage: "scoobyDoo", movieName: "Scooby Doo"),
                            Movies(movieImage: "dextersLaboratory", movieName: "Dexter's Laboratory"),
                            Movies(movieImage: "edEddNEddy", movieName: "Ed, Edd, n Eddy"),
                            Movies(movieImage: "johnnyBravo", movieName: "Johnny Bravo"),
                            Movies(movieImage: "theFlintstones", movieName: "The Flintstones"),
                            Movies(movieImage: "theJetsons", movieName: "The Jetsons"),
                            Movies(movieImage: "thePowerpuffGirls", movieName: "The Powerpuff Girls"),
                            Movies(movieImage: "tomAndJerry", movieName: "Tom And Jerry")
    ]
                            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        movieCell.imageViewMovieImage.image = UIImage(named: movies[indexPath.row].movieImage)
        movieCell.labelMovieName.text = movies[indexPath.row].movieName
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.movieImage = movies[indexPath.row].movieImage
        detailsViewController.movieName = movies[indexPath.row].movieName
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

struct Movies {
    let movieImage: String
    let movieName: String
    
    init(movieImage: String, movieName: String) {
        self.movieImage = movieImage
        self.movieName = movieName
    }
}
