//
//  File.swift
//  
//
//  Created by Kinney Kare on 4/22/22.
//

import Foundation
import Fluent
import FluentPostgresDriver


struct CreateMovie: Migration {
    
    //this does the migration
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        database.schema("movies") //table name
            .id()
            .field("title", .string) //column name
            .create()
    }
    
    //this is like an UNDO func.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("movies").delete() //drop the table (delete the table)
    }
}
