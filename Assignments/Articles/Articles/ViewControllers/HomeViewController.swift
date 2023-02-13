//
//  ViewController.swift
//  Articles
//
//  Created by Rishik Dev on 10/02/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewArticles: UITableView!
    
    var newsViewModel: NewsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTableView()
        newsViewModel = NewsViewModel()
        fetchStatus()
    }
    
    func configureTableView() {
        self.tableViewArticles.delegate = self
        self.tableViewArticles.dataSource = self
    }

    func fetchStatus() {
        newsViewModel?.getStatus {
            DispatchQueue.main.async {
                self.tableViewArticles.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsViewModel?.articles.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? CustomArticleTableViewCell else { return UITableViewCell() }
        
        let article = newsViewModel?.getArticle(at: indexPath.row)
        cell.imageViewThumbnail.loadImage(from: article?.urlToImage ?? Constants.urls.defaultPhoto.rawValue)
        cell.labelAuthor.text = article?.author
        cell.labelTitle.text = article?.title
        cell.labelDescription.text = article?.description
        cell.labelPublishedAt.text = newsViewModel?.formatDate(dateReceived: article?.publishedAt ?? "No Date")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
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
