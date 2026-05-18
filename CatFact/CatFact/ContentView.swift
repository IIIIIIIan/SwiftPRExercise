import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CatFactViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.loading {
                    ProgressView()
                        .padding()
                }

                List {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        HStack {
                            if viewModel.items[index].1 != nil {
                                Image(uiImage: UIImage(data: viewModel.items[index].1!)!)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            }
                            VStack(alignment: .leading) {
                                Text(viewModel.items[index].0)
                                    .font(.system(size: 14))
                                Text(viewModel.items[index].2 ? "Loaded" : "Pending")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                            }
                        }
                    }
                    .onDelete { indexSet in
                        for i in indexSet {
                            viewModel.removeItem(index: i)
                        }
                    }
                }

                if viewModel.errorText != "" {
                    Text(viewModel.errorText)
                        .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0))
                        .font(.system(size: 12))
                }

                Button(action: {
                    if viewModel.checkLimit() {
                        viewModel.loadData()
                    }
                }) {
                    Text("Get Fact")
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.2, green: 0.5, blue: 1.0))
                        .foregroundColor(Color(red: 1.0, green: 1.0, blue: 1.0))
                        .cornerRadius(10)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("Cat Facts")
        }
    }
}

#Preview {
    ContentView()
}
