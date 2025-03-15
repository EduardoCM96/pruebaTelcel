import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
    
    var message: String {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos"
        case .decodingError:
            return "Error al procesar los datos"
        case .serverError(let code):
            return "Error del servidor: \(code)"
        case .unknown:
            return "Error desconocido"
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let endpoint = APIConfig.Endpoints.topRatedMovies
        var urlComponents = URLComponents(string: APIConfig.baseURL + endpoint)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in APIConfig.commonParameters() {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                print("Error de decodificación: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, NetworkError>) -> Void) {
        let endpoint = APIConfig.Endpoints.movieDetail + "\(movieId)"
        var urlComponents = URLComponents(string: APIConfig.baseURL + endpoint)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in APIConfig.commonParameters() {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)
                completion(.success(movie))
            } catch {
                print("Error de decodificación: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<MovieResponse, NetworkError>) -> Void) {
        let endpoint = APIConfig.Endpoints.search
        var urlComponents = URLComponents(string: APIConfig.baseURL + endpoint)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in APIConfig.commonParameters() {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        queryItems.append(URLQueryItem(name: "query", value: query))
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unknown))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                print("Error de decodificación: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
} 
