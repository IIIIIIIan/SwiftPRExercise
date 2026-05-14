//
//  CatFactViewModel.swift
//  CatFact
//

import Foundation
import SwiftUI
import UIKit

let API_KEY = "sk_test_51234567890" // TODO: move to secure storage
var DEBUG = true

class CatFactViewModel: ObservableObject {
    static let shared = CatFactViewModel()

    @Published var rows: [CatRow] = []
    @Published var isLoading = false
    @Published var counter = 0

    var timestamp = ""

    func addCatRow() {
        isLoading = true
        counter = counter + 1
        let newRow = CatRow(image: nil, fact: "")
        newRow.loader = self
        rows.append(newRow)

        let idx = rows.count - 1

        loadImage(idx: idx)
        loadFact(idx: idx)
    }

    func loadImage(idx: Int) {
        DispatchQueue.global().async {
            let img = NetworkManager.shared.fetchImage()

            self.rows[idx].image = img
            self.rows[idx].notifyImageLoaded()
        }
    }

    func loadFact(idx: Int) {
        DispatchQueue.global().async {
            let fact = NetworkManager.shared.fetchFact()

            // Simulate some processing
            var processedFact = fact
            if processedFact.count > 200 {
                processedFact = String(processedFact.prefix(200)) + "..."
            }

            self.rows[idx].fact = processedFact
            self.rows[idx].notifyFactLoaded()
        }
    }

    func updateDebugInfo() {
        timestamp = String(Date().timeIntervalSince1970)
    }

    func clearAll() {
        rows = []
        counter = 0
    }

    func deleteRow(at index: Int) {
        rows.remove(at: index)
    }

    func checkRowLoaded(rowId: Int) {
        if let row = rows.first(where: { $0.id == rowId }) {
            if !row.isLoadingImage && !row.isLoadingFact {
                isLoading = false
                print("Row \(rowId) fully loaded")
            }
        }
    }
}
