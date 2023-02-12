//
//  ViewController.swift
//  Videos
//
//  Created by Rishik Dev on 10/02/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewVideos: UITableView!

    var videoViewModel: VideoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableView()
        videoViewModel = VideoViewModel()
        fetchVideos()
    }
    
    func configureTableView() {
        self.tableViewVideos.delegate = self
        self.tableViewVideos.dataSource = self
    }

    func fetchVideos() {
        videoViewModel?.getVideos {
            DispatchQueue.main.async {
                self.tableViewVideos.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videoViewModel?.videos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        
        let video = self.videoViewModel?.getVideo(at: indexPath.row)
        cell.textLabel?.text = video?.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transcodingTableViewController = storyboard?.instantiateViewController(withIdentifier: "TranscodingTableViewController") as? TranscodingTableViewController else { return }
        
        let video = videoViewModel?.getVideo(at: indexPath.row)
        transcodingTableViewController.videoTitle = video?.title
        transcodingTableViewController.transcodings = video?.transcodings
        
        navigationController?.pushViewController(transcodingTableViewController, animated: true)
    }
}

