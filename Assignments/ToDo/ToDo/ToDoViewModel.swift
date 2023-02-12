//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

class ToDoViewModel {
    var toDos: [ToDoModel] = []
    var filteredToDos: [ToDoModel] = []
    
    func getToDos(completion: @escaping () -> Void) {
        NetworkManager.sharedInstance.fetchToDos(from: Constants.urls.toDo.rawValue) { [weak self] result in
            switch result {
            case .success(let toDos):
                self?.filteredToDos = toDos.filter { $0.completed ?? false }
                completion()
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func getToDo(at index: Int) -> ToDoModel {
        filteredToDos[index]
    }
}
