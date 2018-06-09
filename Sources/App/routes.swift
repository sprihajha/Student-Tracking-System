import Routing
import Vapor
import FluentSQLite
import HTTP

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    //Add the students to provided sections.
    router.post("create") { req -> Future<Response> in
        let name: String = try req.content.syncGet(at: "name")
        let sec: String = try req.content.syncGet(at: "sec")
        let usr = Student(id: nil, name: name, sec: sec)
        
        return usr.save(on: req).map(to: Response.self) { _ in
            return req.redirect(to: "/")
        }
    }
   
    //Creates the view of homepage
    router.get { req -> Future<View> in
        return Student.query(on: req).all().flatMap(to: View.self) { Students in
            let context = ["Students": Students]
            return try req.view().render("home", context)
        }
    }
    
    //Creates the view of ListofStudents page
    router.get("list") { req -> Future<View> in
        return try Student.query(on: req).sort(\Student.sec, .descending).all().flatMap(to: View.self) { Students in
            let context = ["Students": Students]
            return try req.view().render("list", context)
        }
    }
    
    //Tried implementing delete: but unable to decode the UUID format in order to recognize the user 
    router.post("delete") { req -> Future<Response> in
        let name: String = try req.content.syncGet(at: "name")
        let sec: String = try req.content.syncGet(at: "sec")
       // let id: UUID = try req.content.syncDecode(_:maxSize:)
        let usr = Student(id: nil, name: name, sec: sec)
        
        return usr.delete(on: req).map(to: Response.self) { _ in
            return req.redirect(to: "/")
        }

}
}


