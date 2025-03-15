import Foundation

protocol MoviesListInteractorProtocol: AnyObject {
    var presenter: MoviesListPresenterProtocol? { get set }
    
    func fetchTopRatedMovies(forceRefresh: Bool)
    func logout()
}

class MoviesListInteractor: MoviesListInteractorProtocol {
    weak var presenter: MoviesListPresenterProtocol?
    
    func fetchTopRatedMovies(forceRefresh: Bool = false) {
        if !forceRefresh && !PersistenceManager.shared.shouldRefreshMovies(),
           let cachedMovies = PersistenceManager.shared.getTopRatedMovies() {
            let topTenMovies = Array(cachedMovies.prefix(10))
            presenter?.moviesRetrieved(topTenMovies)
            return
        }
        
        NetworkManager.shared.fetchTopRatedMovies { [weak self] result in
            switch result {
            case .success(let response):
                let topTenMovies = Array(response.results.prefix(10))
                
                PersistenceManager.shared.saveTopRatedMovies(topTenMovies)
                
                self?.presenter?.moviesRetrieved(topTenMovies)
                
            case .failure(let error):
                self?.presenter?.moviesRetrievalFailed(with: error)
            }
        }
    }
    
    func logout() {
        PersistenceManager.shared.logoutUser()
    }
} 