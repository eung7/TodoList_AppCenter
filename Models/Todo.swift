//
//  Todo.swift
//  TodoList_AppCenter
//
//  Created by 김응철 on 2022/04/08.
//

import Foundation

struct Todo: Codable, Equatable {
    let id: Int
    var contents: String
    var isToday: Bool
    var isDone: Bool
    
    mutating func updateTodo(isDone: Bool) {
        self.isDone = isDone
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
