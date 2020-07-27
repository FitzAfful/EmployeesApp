import Vapor
import Leaf
// 1
struct WebsiteController: RouteCollection {

    func boot(router: Router) throws {
        router.get(use: indexHandler)
    }

    func indexHandler(_ req: Request) throws -> Future<View> {
        return Employee.query(on: req).all().flatMap(to: View.self) { employees in // 2
            let employeesData = employees.isEmpty ? nil : employees
            let context = IndexContext(title: "Employees List", employees: employeesData)
            return try req.view().render("index", context)
        }
    }
}

struct IndexContext: Encodable {
  let title: String
  let employees: [Employee]?
}
