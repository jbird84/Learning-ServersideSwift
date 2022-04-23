import Fluent
import Vapor

func routes(_ app: Application) throws {

    //get all movies
    app.get("movies") { req in
        Movie.query(on: req.db).all()
    }
    
    //get movie by id
    app.get("movies",":movieId") { req -> EventLoopFuture<Movie> in
        Movie.find(req.parameters.get("movieId"), on: req.db)
            //if movie id not found show not found
            .unwrap(or: Abort(.notFound))
    }
    
    
// how to update movies PUT
    app.put("movies") { req ->EventLoopFuture<HTTPStatus> in
        
        let movie = try req.content.decode(Movie.self)
        
        return Movie.find(movie.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = movie.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    // how to delete a movie -> /movies/id DELETE
    app.delete("movies", ":movieId") { req -> EventLoopFuture<HTTPStatus> in
        
        Movie.find(req.parameters.get("movieId"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: req.db)
            }.transform(to: .ok)
        
    }
    
    //post a movie title
    app.post("movies") { req -> EventLoopFuture<Movie> in

      let movie = try req.content.decode(Movie.self) // content = body of the http request
        return movie.create(on: req.db).map { movie }
    }
    
}
