import Foundation

protocol MovieDetailInteractorProtocol: AnyObject {
    var presenter: MovieDetailPresenterProtocol? { get set }
    var movie: Movie? { get set }
    
    func fetchMovieDetail()
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    weak var presenter: MovieDetailPresenterProtocol?
    var movie: Movie?
    
    func fetchMovieDetail() {
        guard let movie = movie else {
            presenter?.movieDetailRetrievalFailed(with: NetworkError.unknown)
            return
        }
        
        if let cachedMovie = PersistenceManager.shared.getMovieDetail(id: movie.id) {
            presenter?.movieDetailRetrieved(cachedMovie)
            return
        }
        
        NetworkManager.shared.fetchMovieDetails(movieId: movie.id) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                PersistenceManager.shared.saveMovieDetail(movieDetail)
                
                self?.presenter?.movieDetailRetrieved(movieDetail)
                
            case .failure(let error):
                if let movie = self?.movie {
                    self?.presenter?.movieDetailRetrieved(movie)
                } else {
                    self?.presenter?.movieDetailRetrievalFailed(with: error)
                }
            }
        }
    }
} 