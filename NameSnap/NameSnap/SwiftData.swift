//
//  SwiftData.swift
//  NameSnap
//
//  Created by Shivansh omer on 18/05/25.
//

import Foundation
import SwiftData

@Model
class NamedPhoto: Comparable {
    var name: String
    @Attribute(.externalStorage) var photoData: Data
    var date: Date
    
    init(name: String, photoData: Data) {
        self.name = name
        self.photoData = photoData
        self.date = Date()
    }
    
    // Comparable conformance for sorting
    static func < (lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}
