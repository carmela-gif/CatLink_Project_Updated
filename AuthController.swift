//
//  AuthController.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation
internal import Combine

@MainActor
final class AuthController: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isAdmin = false
    @Published var justRegistered = false

    @Published private(set) var users: [User] = [AuthController.demoUser]
    @Published private(set) var user: User = AuthController.demoUser

    private static let demoUser = User(
        fullName: "Annie Aureada",
        email: "annie@email.com",
        username: "annie_aureada",
        password: "123"
    )

    private let adminUsername = "admin"
    private let adminPassword = "admin123"
    private let adminUser = User(
        fullName: "CatLink Admin",
        email: "admin@catlink.app",
        username: "admin",
        password: "admin123"
    )

    @discardableResult
    func login(username: String, password: String) -> Bool {
        let id = username.trimmed.lowercased()
        justRegistered = false

        if id == adminUsername && password == adminPassword {
            user = adminUser
            isAdmin = true
            isLoggedIn = true
            return true
        }

        if let found = users.first(where: {
            ($0.email.lowercased() == id || $0.username.lowercased() == id) && $0.password == password
        }) {
            user = found
            isAdmin = false
            isLoggedIn = true
            return true
        }
        return false
    }

    @discardableResult
    func register(fullName: String, email: String, username: String, password: String) -> String? {
        let name = fullName.trimmed
        let mail = email.trimmed
        let uname = username.trimmed

        if uname.lowercased() == adminUsername ||
            users.contains(where: { $0.username.lowercased() == uname.lowercased() }) {
            return "That username is already taken."
        }
        if users.contains(where: { $0.email.lowercased() == mail.lowercased() }) {
            return "An account with that email already exists."
        }

        let newUser = User(fullName: name, email: mail, username: uname, password: password)
        users.append(newUser)
        isLoggedIn = false
        isAdmin = false
        justRegistered = true
        return nil
    }

    func updateProfile(fullName: String, email: String, username: String, imageData: Data?) -> String? {
        let name = fullName.trimmed
        let mail = email.trimmed
        let uname = username.trimmed

        guard !name.isEmpty else { return "Name can't be empty." }
        guard Validator.isValidEmail(mail) else { return "Enter a valid email address." }
        guard Validator.isValidUsername(uname) else { return "Username needs at least 3 characters and no spaces." }

        if isAdmin {
            user.fullName = name
            user.email = mail
            user.username = uname
            user.profileImageData = imageData
            return nil
        }

        if uname.lowercased() == adminUsername ||
            users.contains(where: { $0.id != user.id && $0.username.lowercased() == uname.lowercased() }) {
            return "That username is already taken."
        }
        if users.contains(where: { $0.id != user.id && $0.email.lowercased() == mail.lowercased() }) {
            return "An account with that email already exists."
        }
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            return "Account not found."
        }

        users[index].fullName = name
        users[index].email = mail
        users[index].username = uname
        users[index].profileImageData = imageData
        user = users[index]
        return nil
    }

    func resetPassword(identifier: String, newPassword: String) -> Bool {
        let id = identifier.trimmed.lowercased()
        guard let index = users.firstIndex(where: {
            $0.email.lowercased() == id || $0.username.lowercased() == id
        }) else { return false }

        users[index].password = newPassword
        if user.id == users[index].id {
            user = users[index]
        }
        return true
    }

    func logout() {
        isLoggedIn = false
        isAdmin = false
    }
}
