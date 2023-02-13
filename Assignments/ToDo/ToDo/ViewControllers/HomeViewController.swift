//
//  ViewController.swift
//  ToDo
//
//  Created by Rishik Dev on 10/02/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewToDos: UITableView!
    
    var toDoViewModel: ToDoViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTable()
        toDoViewModel = ToDoViewModel()
        fetchToDos()
    }
    
    func configureTable() {
        self.tableViewToDos.delegate = self
        self.tableViewToDos.dataSource = self
    }
    
    func fetchToDos() {
        toDoViewModel?.getToDos {
            DispatchQueue.main.async {
                print(self.toDoViewModel?.filteredToDos.count ?? 0)
                self.tableViewToDos.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.toDoViewModel?.filteredToDos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        let toDo = toDoViewModel?.getToDo(at: indexPath.row)
        cell.textLabel?.text = toDo?.title
        
        return cell
    }
}
