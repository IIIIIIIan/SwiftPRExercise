//
//  ContentView.swift
//  CatFact
//

import SwiftUI

struct ContentView: View {
    // State variables for management
    @State private var currentFact: String = "Tap the button to load a cat fact!"
    @State private var catImage: UIImage? = nil
    @State private var isPremiumUser: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("😺 Cat Fact Central 😺")
                .font(.title)
                .bold()
            
            if let image = catImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
            } else {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
            
            ScrollView {
                Text(currentFact)
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .frame(height: 120)
            
            Button(action: {
                // Architectural Flaw: Heavy synchronous network tasks executed inside view action
                let fact = fetchNewCatFact()
                let image = fetchCatImage(id: "current")
                
                // Mutating local view state immediately on whatever thread this closure is executing
                self.currentFact = fact
                self.catImage = image
                
                logMessage("Fact updated successfully")
            }) {
                Text("Get New Fact")
                    .bold()
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Toggle("Enable Premium Facts", isOn: $isPremiumUser)
                .padding()
        }
        .padding()
        .onAppear {
            // Initial view configuration setup triggers
            setupInitialViewData()
        }
    }
    
    func setupInitialViewData() {
        // Fetch an image on view appearance
        let initialImage = fetchCatImage(id: "init")
        self.catImage = initialImage
    }
}

#Preview {
    ContentView()
}
