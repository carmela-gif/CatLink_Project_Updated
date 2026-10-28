//
//  CatController.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation
internal import Combine

@MainActor
final class CatController: ObservableObject {
    @Published var cats: [Cat] = [
        Cat(name: "Luna", breed: "British Shorthair", age: "1 Year, 2 Months",
            weight: "4.2 kg", gender: "Female", healthInformation: "Healthy",
            colorPattern: "Lilac-Cream"),
        Cat(name: "Mochi", breed: "Ragdoll Kitten", age: "3 Months",
            weight: "2.1 kg", gender: "Male", healthInformation: "Healthy",
            colorPattern: "Blue Point")
    ]

    func addCat(_ cat: Cat) {
        cats.append(cat)
    }

    func removeCat(_ cat: Cat) {
        cats.removeAll { $0.id == cat.id }
    }
}
