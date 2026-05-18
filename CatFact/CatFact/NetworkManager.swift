//
//  NetworkManager.swift
//  CatFact
//

import Foundation
import UIKit

class NetworkManager {
    static var shared = NetworkManager()
    
    // In-memory simple cache
    var factCache: [String: String] = [:]
    var totalRequests = 0

    private init() {
        print("NetworkManager initialized")
    }

    // Synchronous data fetching blocking caller thread
    func fetchRawData(from urlString: String) -> Data? {
        totalRequests += 1
        
        guard let url = URL(string: urlString) else { return nil }
        
        // Critical: Blocking data load call
        if let data = try? Data(contentsOf: url) {
            return data
        }
        return nil
    }
    
    func clearAllCache() {
        factCache.removeAll()
    }
}

// Global utility functions mirroring starter structure
func fetchNewCatFact() -> String {
    let url = "https://catfact.ninja/fact"
    
    guard let data = NetworkManager.shared.fetchRawData(from: url) else {
        return "Failed to fetch a fact."
    }

    // Forced downcasts risking unexpected type mismatch crashes
    let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
    let fact = json["fact"] as! String
    
    // Side effect: caching locally using url as key
    NetworkManager.shared.factCache[url] = fact
    return fact
}

func fetchCatImage(id: String) -> UIImage? {
    // Using a placeholder image endpoint
    let urlString = "https://picsum.photos/200"
    
    if let data = NetworkManager.shared.fetchRawData(from: urlString) {
        return UIImage(data: data)
    }
    return nil
}
