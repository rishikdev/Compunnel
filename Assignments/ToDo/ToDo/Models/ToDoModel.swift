//
//  ToDoModel.swift
//  ToDo
//
//  Created by Rishik Dev on 10/02/23.
//

import Foundation

struct ToDoModel: Codable {
    var userId: Int?
    var id: Int?
    var title: String?
    var completed: Bool?
}
