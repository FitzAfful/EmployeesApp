import Vapor
import Leaf
// 1
struct WebsiteController: RouteCollection {

    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.post(Employee.self, at: "index/add", use: createEmployeeHandler)
    }

    func indexHandler(_ req: Request) throws -> Future<View> {
        return Employee.query(on: req).all().flatMap(to: View.self) { employees in
            let employeesData = employees.isEmpty ? nil : employees
            let context = IndexContext(title: "Employees List", employees: employeesData, total: "\(employees.count)")
            return try req.view().render("index", context)
        }
    }

    func createEmployeeHandler(_ req: Request, employee: Employee) throws -> Future<Response> {
        return employee.save(on: req).map(to: Response.self) { _ in
            return req.redirect(to: "/")
        }
    }
}

struct IndexContext: Encodable {
    let title: String
    let employees: [Employee]?
    let total: String
}
