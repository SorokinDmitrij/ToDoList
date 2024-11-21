//
//  TaskListPresenter.swift
//  ToDoListTest
//
//  Created by mac on 15.11.2024.
//

import Foundation
protocol TaskListPresenterProtocol: AnyObject {
    func getTodo()
    var task: [Task] { get set }
}

class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TasksViewProtocol?
    private let interactor: TasksInteractorProtocol
    private let router: TasksRouterProtocol
    var task: [Task] = []
    
    init(view: TasksViewProtocol? = nil, interactor: TasksInteractorProtocol, router: TasksRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        interactor.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                task = tasks
                DispatchQueue.main.async {
                    self.getTodo()
                }
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
    }
    
    func getTodo() {
        view?.reloadTableView()
    }
}
