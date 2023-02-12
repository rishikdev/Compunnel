//
//  TranscodingTableViewController.swift
//  Videos
//
//  Created by Rishik Dev on 10/02/23.
//

import UIKit

class TranscodingTableViewController: UIViewController {
    
    @IBOutlet weak var tableViewTranscoding: UITableView!
    
    var videoTitle: String?
    var transcodings: [Transcodings]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTableView()
    }
    
    func configureTableView() {
        self.tableViewTranscoding.delegate = self
        self.tableViewTranscoding.dataSource = self
    }
}

extension TranscodingTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transcodings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transcodingCell", for: indexPath) as? CustomTranscodingTableViewCell else { return UITableViewCell() }
        if let transcodings = transcodings {
            let transcoding = transcodings[indexPath.row]
            cell.labelTitle.text = videoTitle
            cell.labelID.text = transcoding.transcodingsID
            cell.labelHeight.text = "\(transcoding.height ?? 0)"
            cell.labelWidth.text = "\(transcoding.width ?? 0)"
        }
        
        return cell
    }
}
