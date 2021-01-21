//
//  TasksViewModel.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit

class TasksViewModel {
    
    private var tasks: [Any] = []
    
    init() {
        self.loadTasks()
    }
    
    func getTasks() -> [Any] {
        //
        //
        return self.tasks
    }
    
    private func loadTasks() {
        //
    }
    
}
