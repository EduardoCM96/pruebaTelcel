import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    var router: MovieDetailRouterProtocol? { get set }
    
    func viewDidLoad()
    func movieDetailRetrieved(_ movie: Movie)
    func movieDetailRetrievalFailed(with error: Error)
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorProtocol?
    var router: MovieDetailRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchMovieDetail()
    }
    
    func movieDetailRetrieved(_ movie: Movie) {
        view?.hideLoading()
        view?.showMovieDetail(movie)
    }
    
    func movieDetailRetrievalFailed(with error: Error) {
        view?.hideLoading()
        view?.showError(error)
    }
} 