import Vapor
import Leaf
import FluentSQLite

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Configure Leaf
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: TemplateRenderer.self)
    
    // Configure FluentSQLite
    try services.register(FluentSQLiteProvider())
    let sqlite = try SQLiteDatabase(storage: .memory)
    
    var databases = DatabaseConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Student.self, database: .sqlite)
    services.register(migrationConfig)
    
    //Tried implementing JSON decoding
    var contentConfig = ContentConfig.default()
    contentConfig.use(decoder: JSONDecoder(), for: .json)
    services.register(contentConfig)
}
