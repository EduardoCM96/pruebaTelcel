import UIKit

protocol MoviesListRouterProtocol: AnyObject {
    static func createMoviesListModule() -> UIViewController
    func navigateToMovieDetail(movie: Movie)
    func navigateToLogin()
}

class MoviesListRouter: MoviesListRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createMoviesListModule() -> UIViewController {
        let view = MoviesListViewController()
        let presenter = MoviesListPresenter()
        let interactor = MoviesListInteractor()
        let router = MoviesListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToMovieDetail(movie: Movie) {
        let movieDetailVC = MovieDetailRouter.createMovieDetailModule(movie: movie)
        viewController?.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    func navigateToLogin() {
        let loginVC = LoginRouter.createLoginModule()
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = loginVC
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
} 