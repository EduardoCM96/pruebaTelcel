import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func createLoginModule() -> UIViewController
    func navigateToMoviesList()
}

class LoginRouter: LoginRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createLoginModule() -> UIViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor()
        let router = LoginRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToMoviesList() {
        let moviesListVC = MoviesListRouter.createMoviesListModule()
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController: moviesListVC)
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
} 