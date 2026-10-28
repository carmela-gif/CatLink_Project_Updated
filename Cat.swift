//
//  Cat.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation

struct Cat: Identifiable {
    let id = UUID()
    var name: String
    var breed: String
    var age: String
    var weight: String
    var gender: String
    var healthInformation: String
    var colorPattern: String = ""
    var imageData: Data? = nil

    var displayID: String {
        "CAT-\(id.uuidString.prefix(4))"
    }
}
