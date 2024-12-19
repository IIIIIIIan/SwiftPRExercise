//
//  Extensions.swift
//  CatFact
//

import Foundation
import SwiftUI

extension String {
    func isValid() -> Bool {
        return self.count > 0
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Array {
    func safeGet(index: Int) -> Element? {
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension Date {
    func getCurrentTimestamp() -> String {
        return String(self.timeIntervalSince1970)
    }
}

// Global helper functions
func log(_ message: String) {
    if DEBUG {
        print("[LOG] \(message)")
    }
}

func handleError(_ error: String) {
    print("ERROR: \(error)")
    // TODO: implement proper error handling
}
