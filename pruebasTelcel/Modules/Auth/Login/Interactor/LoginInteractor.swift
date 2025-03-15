import Foundation

protocol LoginInteractorProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
    
    func login(user: User)
}

class LoginInteractor: LoginInteractorProtocol {
    weak var presenter: LoginPresenterProtocol?
    
    func login(user: User) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            PersistenceManager.shared.saveUser(user)
            
            self?.presenter?.loginSuccess()
        }
    }
} 
