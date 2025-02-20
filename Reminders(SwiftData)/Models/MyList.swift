//
//  MyList.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 20/02/2025.
//

import Foundation
import SwiftData

@Model
class MyList {
    
    var name: String
    var colorCode: String

    init(name: String, colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
}

