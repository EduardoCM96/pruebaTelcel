import Foundation

struct APIConfig {
    // MARK: - TMDB API
    static let apiKey = "10886e6b450b6662b3d452abfd776f2b"
    static let baseURL = "https://api.themoviedb.org/3"
    
    struct Endpoints {
        static let topRatedMovies = "/movie/top_rated"
        static let movieDetail = "/movie/"
        static let search = "/search/movie"
    }
    
    static func commonParameters() -> [String: String] {
        return [
            "api_key": apiKey,
            "language": "es-MX"
        ]
    }
} 
