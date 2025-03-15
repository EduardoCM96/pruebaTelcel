import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    // MARK: - User Authentication
    
    private let userDefaultsKey = "loggedInUser"
    private let isLoggedInKey = "isLoggedIn"
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            UserDefaults.standard.set(true, forKey: isLoggedInKey)
        }
    }
    
    func getUser() -> User? {
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            return nil
        }
        return user
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func logoutUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
    
    // MARK: - Movies Persistence
    
    private let topRatedMoviesKey = "topRatedMovies"
    private let lastFetchTimeKey = "lastFetchTime"
    private let cacheDuration: TimeInterval = 3600
    
    func saveTopRatedMovies(_ movies: [Movie]) {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: topRatedMoviesKey)
            UserDefaults.standard.set(Date(), forKey: lastFetchTimeKey)
        }
    }
    
    func getTopRatedMovies() -> [Movie]? {
        guard let moviesData = UserDefaults.standard.data(forKey: topRatedMoviesKey),
              let movies = try? JSONDecoder().decode([Movie].self, from: moviesData) else {
            return nil
        }
        return movies
    }
    
    func shouldRefreshMovies() -> Bool {
        guard let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchTimeKey) as? Date else {
            return true
        }
        
        return Date().timeIntervalSince(lastFetchDate) > cacheDuration
    }
    
    // MARK: - Movie Details Persistence
    
    func saveMovieDetail(_ movie: Movie) {
        let movieKey = "movie_\(movie.id)"
        if let encoded = try? JSONEncoder().encode(movie) {
            UserDefaults.standard.set(encoded, forKey: movieKey)
        }
    }
    
    func getMovieDetail(id: Int) -> Movie? {
        let movieKey = "movie_\(id)"
        guard let movieData = UserDefaults.standard.data(forKey: movieKey),
              let movie = try? JSONDecoder().decode(Movie.self, from: movieData) else {
            return nil
        }
        return movie
    }
} 