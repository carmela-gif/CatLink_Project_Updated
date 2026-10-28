//
//  User.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    var fullName: String
    var email: String
    var username: String
    var password: String
    var profileImageData: Data? = nil
}
