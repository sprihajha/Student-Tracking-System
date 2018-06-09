//Student Model

import Foundation
import Vapor
import FluentSQLite

struct Student: Content, SQLiteUUIDModel, Migration, Model{
    var id: UUID?
    var name: String
    var sec: String
    
}
