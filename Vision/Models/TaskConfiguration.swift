//
//  TaskConfiguration.swift
//  B-more
//
//  Created by Idan Moshe on 14/01/2021.
//

import Foundation

struct TaskConfiguration {
    var taskId: String
    var title: String?
    var status: Application.TaskStatus = .pending
    var type: Application.TaskType = .call
    var date: Date?
    var contactId: String?
    var comments: String?
    var isPushEnabled: Bool = false
}
