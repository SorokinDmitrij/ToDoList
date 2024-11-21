//
//  TaskEntity.swift
//  ToDoListTest
//
//  Created by mac on 15.11.2024.
//

import Foundation
import UIKit
import CoreData

struct TodoResponse: Decodable {
    let todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Todo: Decodable {
    let id: Int
    let todo: String
    var completed: Bool
    let userId: Int
}

struct Task {
    let id: Int
    let title: String
    let todo: String
    var completed: Bool
    let userId: Int
    var date: Date
}
