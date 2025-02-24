//
//  String+Extensions.swift
//  Reminders(SwiftData)
//
//  Created by Eric on 21/02/2025.
//

import Foundation

extension String {

    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
