//
//  TodoService.swift
//  ToDoListTest
//
//  Created by Иван Незговоров on 21.11.2024.
//

import Foundation
class TodoService {
    
    static let shared = TodoService()
    private init () {}
  
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(todoResponse.todos))
            } catch {
                print("error" , error.localizedDescription)
                completion(.failure(error))
            }
        }.resume()
    }
}
