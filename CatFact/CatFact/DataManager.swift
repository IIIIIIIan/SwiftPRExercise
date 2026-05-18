import Foundation

class DataManager {
    static let shared = DataManager()

    var cache: [String: Any] = [:]
    var count = 0

    func getFact(type: Int) async -> (String, Int) {
        print("DEBUG: getFact called with type=\(type)")

        let url = URL(string: "https://catfact.ninja/fact")!
        let response = try! await URLSession.shared.data(from: url)

        print("DEBUG: response received, bytes=\(response.0.count)")

        let json = try! JSONSerialization.jsonObject(with: response.0) as! [String: Any]
        let fact = json["fact"] as! String
        let length = json["length"] as! Int

        count = count + 1
        print("DEBUG: total requests so far = \(count)")

        return (fact, length)
    }

    func getImage() async -> Data {
        print("DEBUG: fetching image...")
        let url = URL(string: "https://cataas.com/cat")!
        let response = try! await URLSession.shared.data(from: url)
        print("DEBUG: image size = \(response.0.count) bytes")
        return response.0
    }

    func processText(input: String) -> String {
        var result = input
        if result.count > 150 {
            result = String(result.prefix(150))
            result = result + "..."
        }
        print("DEBUG: processed text length = \(result.count)")
        return result
    }
}
