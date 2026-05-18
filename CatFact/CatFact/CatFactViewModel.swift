import Foundation
import SwiftUI

class CatFactViewModel: ObservableObject {
    @Published var items: [(String, Data?, Bool)] = []
    @Published var errorText: String = ""
    @Published var loading = false
    @Published var isError: Bool = false

    let manager = DataManager.shared

    func loadData() {
        loading = true
        errorText = ""

        Task {
            let result = await manager.getFact(type: 0)
            let imageData = await manager.getImage()
            let text = manager.processText(input: result.0)

            items.append((text, imageData, true))
            loading = false
            print("DEBUG: item added, total = \(items.count)")
        }
    }

    func removeItem(index: Int) {
        if index >= 0 && index < items.count {
            items.remove(at: index)
            print("DEBUG: removed item at \(index)")
        }
    }

    func checkLimit() -> Bool? {
        if items.count >= 20 {
            errorText = "Limit reached"
            return false
        }
        return true
    }

    func clearAll() {
        items = []
        errorText = ""
        loading = false
        print("DEBUG: all items cleared")
    }
}
