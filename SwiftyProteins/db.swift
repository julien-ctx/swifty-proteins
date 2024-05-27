//
//  db.swift
//  SwiftyProteins
//
//  Created by Minguk on 27/05/2024.
//

import Foundation
import SQLite

class SQLiteManager {
    static let shared = SQLiteManager()
    private let db: Connection?

    private let users = Table("users")
    private let id = Expression<Int64>("id")
    private let username = Expression<String>("username")
    private let password = Expression<String>("password")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
            createTable()
        } catch {
            db = nil
            print("Unable to open database.")
        }
    }

    private func createTable() {
        do {
            try db?.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(username, unique: true)
                table.column(password)
            })
        } catch {
            print("Unable to create table.")
        }
    }
    
    func addUser(username: String, password: String) -> Bool {
        do {
            let insert = users.insert(self.username <- username, self.password <- password)
            try db?.run(insert)
            return true
        } catch {
            print("Insert failed: \(error)")
            return false
        }
    }

    func verifyUser(username: String, password: String) -> Bool {
        do {
            let query = users.filter(self.username == username && self.password == password)
            if let _ = try db?.pluck(query) {
                return true
            }
        } catch {
            print("Select failed: \(error)")
        }
        return false
    }
}
