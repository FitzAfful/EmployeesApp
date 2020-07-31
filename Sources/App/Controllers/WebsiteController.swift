import Vapor
import Leaf

struct WebsiteController: RouteCollection {

    func boot(router: Router) throws {
        router.get(use: indexHandler)
        router.post(Employee.self, at: "index/add", use: createEmployeeHandler)
        router.post("employees", Employee.parameter, "edit", use: updateEmployeeHandler)
        router.post("employees", Employee.parameter, "delete", use: deleteEmployeeHandler)
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

    func updateEmployeeHandler(_ req: Request) throws -> Future<Response> {
        return try flatMap(to: Response.self, req.parameters.next(Employee.self), req.content.decode(Employee.self), { employee, updatedEmployee in
            employee.name = updatedEmployee.name
            employee.email = updatedEmployee.email
            employee.phone = updatedEmployee.phone
            employee.address = updatedEmployee.address
            return employee.save(on: req).transform(to: req.redirect(to: "/"))
        })
    }

    func deleteEmployeeHandler(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Employee.self).delete(on: req).transform(to: req.redirect(to: "/")) }
}

struct IndexContext: Encodable {
    let title: String
    let employees: [Employee]?
    let total: String
}
