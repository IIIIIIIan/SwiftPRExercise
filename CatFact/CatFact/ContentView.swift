//
//  ContentView.swift
//  CatFact
//
//  Created by Ian Jiang on 20/12/2024.
//

import SwiftUI

struct ContentView: View {
    var c = CatFact()

    var buttonTitle = "Get Fact"

    @State
    var list: [CatFact] = []

    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(list.enumerated()), id: \.offset) { fact in
                    Text(fact.element.fact ?? "")

//                    Text(fact.element.length)
                }

                Button("Get Fact") {
                    Task { @MainActor in
                        try? await c.fetch()
                        list.append(c)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


class CatFact: ObservableObject, Codable {
    var fact: String?
    var length: Int?
    var url: String?

    init(fact: String? = nil, length: Int? = nil, url: String? = nil) {
        self.fact = fact
        self.length = length
        self.url = url
    }

    func fetch() async throws {
        url = "https://catfact.ninja/fact"
        let request = URLRequest(url: URL(string: url!)!)
        let response = try await URLSession.shared.data(for: request)

        let catFact = try JSONDecoder().decode(CatFact.self, from: response.0)

        fact = catFact.fact
        length = catFact.length
    }
}
