//
//  CatRow.swift
//  CatFact
//
//  Created by Ian Jiang on 14/5/2026.
//
import UIKit

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
