//
//  ContentView.swift
//  CatFact
//

import SwiftUI
import Foundation

struct ContentView: View {
    @ObservedObject var viewModel = CatFactViewModel()
    @State var errorMessage: String = ""

    var body: some View {
        let _ = viewModel.updateDebugInfo()

        VStack {
            if DEBUG {
                Text("Debug: rows count = \(viewModel.rows.count), counter = \(viewModel.counter)")
                    .font(.system(size: 8))
            }
            List(0..<viewModel.rows.count, id: \.self) { i in
                HStack {
                    if viewModel.rows[i].image != nil {
                        Image(uiImage: viewModel.rows[i].image!)
                            .resizable()
                            .frame(width: 100, height: 100)
                    } else {
                        Rectangle().fill(Color.gray).frame(width: 100, height: 100)
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.rows[i].fact)
                        if DEBUG {
                            Text("ID: \(viewModel.rows[i].id)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.deleteRow(at: i)
                        viewModel.counter = viewModel.counter - 1
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .id(viewModel.counter)
            if errorMessage != "" {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button("Add Cat Row") {
                addCatRow()
            }
        }
        .onAppear {
            addCatRow()
        }
    }

    func addCatRow() {
        if viewModel.counter >= 100 {
            errorMessage = "Too many rows!"
            return
        }
        errorMessage = ""
        viewModel.addCatRow()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
