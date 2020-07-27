import FluentSQLite
import Vapor


final class Employee: SQLiteModel {
    typealias Database = SQLiteDatabase
    var id: Int?
    var name: String
    var email: String
    var phone: String
    var address: String

    /// Creates a new `Employee`.
    init(id: Int? = nil, name: String, email: String, phone: String, address: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
    }
}

/// Allows `Employee` to be used as a dynamic migration.
extension Employee: Migration { }

/// Allows `Employee` to be encoded to and decoded from HTTP messages.
extension Employee: Content { }

/// Allows `Employee` to be used as a dynamic parameter in route definitions.
extension Employee: Parameter { }
