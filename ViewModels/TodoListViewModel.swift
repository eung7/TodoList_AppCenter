//
//  TodoListViewModel.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/09.
//

import Foundation

class TodoListViewModel {
    
    static var lastID: Int = 0
    
    var todos: [Todo] = []

    
    func createTodo(contents: String, isToday: Bool) -> Todo {
        let nextId = TodoManager.lastID + 1
        TodoManager.lastID = nextId
        
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
