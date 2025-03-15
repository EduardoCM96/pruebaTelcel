import UIKit

protocol MovieDetailRouterProtocol: AnyObject {
    static func createMovieDetailModule(movie: Movie) -> UIViewController
}

class MovieDetailRouter: MovieDetailRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createMovieDetailModule(movie: Movie) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter()
        let interactor = MovieDetailInteractor()
        let router = MovieDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.movie = movie
        router.viewController = view
        
        return view
    }
} 