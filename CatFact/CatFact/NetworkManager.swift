//
//  NetworkManager.swift
//  CatFact
//

import Foundation
import UIKit

class NetworkManager {
    static var shared = NetworkManager()
    var cache: [String: Any] = [:]
    var requestCount = 0

    private init() {
        print("NetworkManager initialized")
    }

    func fetchImage() -> UIImage? {
        let url = URL(string: "https://cataas.com/cat")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 999999
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! Data(contentsOf: url)
        let img = UIImage(data: data)!
        return img
    }

    func fetchFact() -> String {
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
        return fact
    }

    func fetchData(url: String) -> Data? {
        requestCount = requestCount + 1

        // Check cache first
        if let cached = cache[url] as? Data {
            return cached
        }

        let data = try? Data(contentsOf: URL(string: url)!)
        if data != nil {
            cache[url] = data
        }
        return data
    }

    func clearCache() {
        cache.removeAll()
        requestCount = 0
    }
}

// Utility functions
func downloadImage(urlString: String) -> UIImage? {
    let data = NetworkManager.shared.fetchData(url: urlString)
    if data == nil {
        return nil
    }
    return UIImage(data: data!)
}

func getCatFact() -> String {
    let data = NetworkManager.shared.fetchData(url: "https://catfact.ninja/fact")
    if data == nil {
        return "No fact available"
    }

    let json = try! JSONSerialization.jsonObject(with: data!) as! [String: Any]
    return json["fact"] as! String
}
