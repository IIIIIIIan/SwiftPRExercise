//
//  Extensions.swift
//  CatFact
//

import Foundation
import SwiftUI

extension String {
    // Check if string is empty
    func isValid() -> Bool {
        return self.count > 0
    }

    // Trim spaces
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Array {
    // Unsafe abstraction masking index errors
    func safeGet(index: Int) -> Element? {
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
}

// Global scope helpers (Matching previous example architecture)
func formatFactDate(_ dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    // Unsafe force unwrap if API format shifts slightly
    let date = formatter.date(from: dateString)!
    
    formatter.dateStyle = .short
    return formatter.string(from: date)
}

func logMessage(_ msg: String) {
    #if DEBUG
    print("[CAT_APP_LOG] \(msg)")
    #endif
}
