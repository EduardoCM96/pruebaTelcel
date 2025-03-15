import Foundation

protocol LoginPresenterProtocol: AnyObject {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorProtocol? { get set }
    var router: LoginRouterProtocol? { get set }
    
    func login(email: String, password: String)
    func loginSuccess()
    func loginFailure(error: String)
}

class LoginPresenter: LoginPresenterProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    func login(email: String, password: String) {
        view?.showLoading()
        let user = User(email: email, password: password)
        
        if !user.isValidEmail() {
            view?.hideLoading()
            view?.showError("El formato del correo electrónico no es válido")
            return
        }
        
        if !user.isValidPassword() {
            view?.hideLoading()
            view?.showError("La contraseña debe tener al menos 6 caracteres")
            return
        }
        interactor?.login(user: user)
    }
    
    func loginSuccess() {
        view?.hideLoading()
        router?.navigateToMoviesList()
    }
    
    func loginFailure(error: String) {
        view?.hideLoading()
        view?.showError(error)
    }
} 
