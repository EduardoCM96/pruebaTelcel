import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "Aceptar", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func showError(_ error: Error, completion: (() -> Void)? = nil) {
        var message = "Ha ocurrido un error inesperado."
        
        if let networkError = error as? NetworkError {
            message = networkError.message
        } else {
            message = error.localizedDescription
        }
        
        showAlert(title: "Error", message: message, completion: completion)
    }
    
    func showLoadingView() -> UIView {
        let loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.tag = 999
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        return loadingView
    }
    
    func hideLoadingView() {
        if let loadingView = view.viewWithTag(999) {
            loadingView.removeFromSuperview()
        }
    }
} 