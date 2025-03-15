import Foundation

protocol MoviesListPresenterProtocol: AnyObject {
    var view: MoviesListViewProtocol? { get set }
    var interactor: MoviesListInteractorProtocol? { get set }
    var router: MoviesListRouterProtocol? { get set }
    
    func viewDidLoad()
    func refreshMovies()
    func showMovieDetail(movie: Movie)
    func logout()
    func moviesRetrieved(_ movies: [Movie])
    func moviesRetrievalFailed(with error: Error)
}

class MoviesListPresenter: MoviesListPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    var interactor: MoviesListInteractorProtocol?
    var router: MoviesListRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchTopRatedMovies(forceRefresh: false)
    }
    
    func refreshMovies() {
        interactor?.fetchTopRatedMovies(forceRefresh: true)
    }
    
    func showMovieDetail(movie: Movie) {
        router?.navigateToMovieDetail(movie: movie)
    }
    
    func logout() {
        interactor?.logout()
        router?.navigateToLogin()
    }
    
    func moviesRetrieved(_ movies: [Movie]) {
        view?.hideLoading()
        view?.showMovies(movies)
    }
    
    func moviesRetrievalFailed(with error: Error) {
        view?.hideLoading()
        view?.showError(error)
    }
} 