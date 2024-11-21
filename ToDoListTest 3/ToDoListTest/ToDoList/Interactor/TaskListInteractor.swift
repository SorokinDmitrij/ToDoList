//
//  TaskListInteractor.swift
//  ToDoListTest
//
//  Created by mac on 15.11.2024.
//

import Foundation

protocol TasksInteractorProtocol {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    var tasks: [Task] { get set }
}

class TaskListInteractor: TasksInteractorProtocol {
    weak var presenter: TaskListPresenterProtocol?
    var tasks: [Task] = []
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        TodoService.shared.fetchTodos { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let todo):
                for i in todo {
                    let newTask = Task(id: i.id, title: "", todo: i.todo, completed: i.completed, userId: i.userId, date: Date())
                    tasks.append(newTask)
                }
                tasks.reverse()
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
