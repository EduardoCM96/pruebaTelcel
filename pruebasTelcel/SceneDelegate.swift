import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        showSplashScreen()
        
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Navigation
    private func showSplashScreen() {
        let splashVC = SplashViewController { [weak self] in
            self?.navigateToMainScreen()
        }
        window?.rootViewController = splashVC
    }
    
    private func navigateToMainScreen() {
        if PersistenceManager.shared.isUserLoggedIn() {
            let moviesListVC = MoviesListRouter.createMoviesListModule()
            let navigationController = UINavigationController(rootViewController: moviesListVC)
            
            UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = navigationController
            }, completion: nil)
        } else {
            let loginVC = LoginRouter.createLoginModule()
            
            UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.window?.rootViewController = loginVC
            }, completion: nil)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

