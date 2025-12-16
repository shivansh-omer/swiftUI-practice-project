//
//  Student.swift
//  BookwormApp
//
//  Created by Shivansh omer on 23/04/25.
//

import Foundation
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
