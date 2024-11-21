//
//  ToDoListTestTests.swift
//  ToDoListTestTests
//
//  Created by mac on 15.11.2024.
//

import XCTest
@testable import ToDoListTest

// Протокол сервиса для тестирования
protocol TodoServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void)
}

// Мок-сервис для имитации вызовов
final class MockTodoService: TodoServiceProtocol {
    var todos: [Todo] = []
    var shouldReturnError = false
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "TestError", code: 1, userInfo: nil)))
        } else {
            completion(.success(todos))
        }
    }
}

// Основной тестовый класс
final class TaskListInteractorTests: XCTestCase {
    
    var mockService: MockTodoService!
    var interactor: TaskListInteractor!
    
    override func setUp() {
        super.setUp()
        mockService = MockTodoService() // Инициализация мок-сервиса
        interactor = TaskListInteractor() // Инициализация интеректора
        interactor.presenter = mockService as? any TaskListPresenterProtocol // Внедрение мок-сервиса в интеректор
    }
    
    func testFetchTasksSuccess() {
        // Arrange
        mockService.todos = [
            Todo(id: 1, todo: "Task 1", completed: false, userId: 1),
            Todo(id: 2, todo: "Task 2", completed: true, userId: 1)
        ]
        
        let expectation = self.expectation(description: "Fetch tasks should succeed")
        
        // Act
        interactor.fetchTasks { result in
            // Assert
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 2)
                XCTAssertEqual(tasks.first?.todo, "Task 2") // Проверяем обратный порядок
                XCTAssertEqual(tasks.last?.todo, "Task 1")
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasksFailure() {
        // Arrange
        mockService.shouldReturnError = true
        
        let expectation = self.expectation(description: "Fetch tasks should fail")
        
        // Act
        interactor.fetchTasks { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected an error but got nil")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
