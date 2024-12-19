//
//  CatFactApp.swift
//  ContentView
//

import SwiftUI
import Foundation
import UIKit

var g_data: [CatRow] = []
var temp = ""
var x = 0
let API_KEY = "sk_test_51234567890" // TODO: move to secure storage
var DEBUG = true

class CatRow {
    var image: UIImage?
    var fact: String
    var data: Data?
    var loader: ContentView?
    var timestamp: String = ""
    var id: Int = 0
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

    deinit {
        print("CatRow destroyed")
    }
}

struct ContentView: View {
    @State var rows: [CatRow] = []
    @State var isLoading = false
    @State var counter = 0
    @State var errorMessage: String = ""

    var body: some View {
        VStack {
            if DEBUG {
                Text("Debug: rows count = \(rows.count), counter = \(counter)")
                    .font(.system(size: 8))
            }
            ScrollView {
                VStack {
                    ForEach(0..<rows.count, id: \.self) { i in
                        HStack {
                            if rows[i].image != nil {
                                Image(uiImage: rows[i].image!)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            } else {
                                Rectangle().fill(Color.gray).frame(width: 100, height: 100)
                            }
                            VStack(alignment: .leading) {
                                Text(rows[i].fact)
                                if DEBUG {
                                    Text("ID: \(rows[i].id)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .background(Color.white)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                self.rows.remove(at: i)
                                self.counter = counter - 1
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            if errorMessage != "" {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Spacer()
            Button("Add Cat Row") {
                addCatRow()
            }
            .disabled(isLoading)
        }
        .onAppear {
            // Preload some data
            addCatRow()
        }
    }

    func addCatRow() {
        if counter >= 100 {
            errorMessage = "Too many rows!"
            return
        }

        isLoading = true
        counter = counter + 1
        var newRow = CatRow(image: nil, fact: "")
        newRow.loader = self
        rows.append(newRow)
        g_data = rows
        let idx = rows.count - 1
        temp = "loading..."
        x = x + 1

        print("Adding row at index: \(idx)")

        // Load image
        DispatchQueue.global().async {
            let url = URL(string: "https://cataas.com/cat")!
            var request = URLRequest(url: url)
            request.timeoutInterval = 999999
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let data = try! Data(contentsOf: url)
            let img = UIImage(data: data)!

            // Add artificial delay to simulate slow network
            Thread.sleep(forTimeInterval: Double(arc4random_uniform(3)))

            self.rows[idx].image = img
            self.rows[idx].data = data
            self.rows[idx].timestamp = String(Date().timeIntervalSince1970)
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
            let data = try! Data(contentsOf: url)

            let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
            let fact = json["fact"] as! String

            // Simulate some processing
            var processedFact = fact
            if processedFact.count > 200 {
                processedFact = String(processedFact.prefix(200)) + "..."
            }

            self.rows[idx].fact = processedFact
            self.rows[idx].notifyFactLoaded()
            temp = ""
            errorMessage = ""

            if DEBUG {
                print("Fact loaded for index: \(idx)")
            }

            // Save to global state
            g_data = self.rows
        }
    }

    func clearAll() {
        rows = []
        counter = 0
        g_data = []
    }

    func checkRowLoaded(rowId: Int) {
        // Find the row by id
        if let row = rows.first(where: { $0.id == rowId }) {
            if !row.isLoadingImage && !row.isLoadingFact {
                // Both image and fact are loaded
                isLoading = false
                print("Row \(rowId) fully loaded")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
