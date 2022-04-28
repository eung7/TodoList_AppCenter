//
//  TodoListViewModel.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/09.
//

import Foundation

enum Section: String, CaseIterable {
    case today
    case upcoming
    
    var headerTitle : String {
        switch self {
        case .today:
            return "Today 🚀"
        case .upcoming:
            return "Upcoming 🚀"
        }
    }
}

class TodoListViewModel {
    
    var lastID: Int = 0
    
    var todos: [Todo] = []
    
    var todayTodos: [Todo] {
        return todos.filter { $0.isToday == true }
    }
    
    var upcomingTodos: [Todo] {
        return todos.filter { $0.isToday == false }
    }
    
    func createTodo(contents: String, isToday: Bool) -> Todo {
        let nextId = lastID + 1
        lastID = nextId
        
        return Todo(id: nextId, contents: contents, isToday: isToday, isDone: false)
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo) {
        todos = todos.filter { $0.id != todo.id }
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].updateTodo(isDone: todo.isDone)
        saveTodo()
    }
    
    func saveTodo() {
        UserDefaults.standard.set(
            try? PropertyListEncoder().encode(todos),
            forKey: "Todos"
        )
    }
    
    func loadTodo() {
        guard let data = UserDefaults.standard.data(forKey: "Todos") else { return }
        todos = (try? PropertyListDecoder().decode([Todo].self, from: data)) ?? []
    }
}
