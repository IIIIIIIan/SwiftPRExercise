//
//  CatFactViewModel.swift
//  CatFact
//

import Foundation
import SwiftUI
import UIKit

let API_KEY = "sk_test_51234567890" // TODO: move to secure storage
var DEBUG = true

class CatRow {
    var id: Int = 0
    var image: UIImage?
    var fact: String
    var loader: CatFactViewModel?
    var isLoadingImage: Bool = true
    var isLoadingFact: Bool = true

    init(image: UIImage?, fact: String) {
        self.image = image
        self.fact = fact
        self.id = Int(Date().timeIntervalSince1970)
        print("CatRow created with id: \(id)")
    }

    func notifyImageLoaded() {
        self.isLoadingImage = false
        self.loader?.checkRowLoaded(rowId: self.id)
    }

    func notifyFactLoaded() {
        self.isLoadingFact = false
        self.loader?.checkRowLoaded(rowId: self.id)
    }
}

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

        print("Adding row at index: \(idx)")

        // Load image
        DispatchQueue.global().async {
            let url = URL(string: "https://cataas.com/cat")!
            var request = URLRequest(url: url)
            request.timeoutInterval = 999999
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = try! Data(contentsOf: url)
            let img = UIImage(data: data)!

            self.rows[idx].image = img
            self.rows[idx].notifyImageLoaded()

            if DEBUG {
                print("Image loaded for index: \(idx), size: \(data.count) bytes")
            }
        }

        // Load fact
        DispatchQueue.global().async {
            sleep(2)
            let urlString = "https://catfact.ninja/fact"
            let url = URL(string: urlString)!

            let session = URLSession.shared
            let semaphore = DispatchSemaphore(value: 0)
            var responseData: Data?

            let task = session.dataTask(with: url) { data, response, error in
                responseData = data
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()

            let data = responseData!

            let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
            let fact = json["fact"] as! String

            // Simulate some processing
            var processedFact = fact
            if processedFact.count > 200 {
                processedFact = String(processedFact.prefix(200)) + "..."
            }

            self.rows[idx].fact = processedFact
            self.rows[idx].notifyFactLoaded()

            if DEBUG {
                print("Fact loaded for index: \(idx)")
            }
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
