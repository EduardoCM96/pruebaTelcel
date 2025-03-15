import UIKit

protocol LoginViewProtocol: AnyObject {
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
    func navigateToMoviesList()
}

class LoginViewController: UIViewController {
    
    var presenter: LoginPresenterProtocol?
    private var loadingView: UIView?
    
    // MARK: - UI Components
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.layer.shadowColor = UIColor.white.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 46/255, alpha: 0.9)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let usernameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 56/255, alpha: 1.0)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let usernameIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = UIColor(red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Usuario"
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(
            string: "Usuario",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 56/255, alpha: 1.0)
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passwordIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.circle.fill")
        imageView.tintColor = UIColor(red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contraseña"
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Contraseña",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Iniciar sesión 🤌🏼", for: .normal)
        button.backgroundColor = UIColor(red: 79/255, green: 172/255, blue: 254/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(logo)
        view.addSubview(containerView)
        
        containerView.addSubview(usernameContainerView)
        usernameContainerView.addSubview(usernameIconView)
        usernameContainerView.addSubview(emailTextField)
        
        containerView.addSubview(passwordContainerView)
        passwordContainerView.addSubview(passwordIconView)
        passwordContainerView.addSubview(passwordTextField)
        
        containerView.addSubview(loginButton)
        containerView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 100),
            
            containerView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            usernameContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            usernameContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            usernameContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            usernameContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameIconView.leadingAnchor.constraint(equalTo: usernameContainerView.leadingAnchor, constant: 15),
            usernameIconView.centerYAnchor.constraint(equalTo: usernameContainerView.centerYAnchor),
            usernameIconView.widthAnchor.constraint(equalToConstant: 24),
            usernameIconView.heightAnchor.constraint(equalToConstant: 24),
            
            emailTextField.leadingAnchor.constraint(equalTo: usernameIconView.trailingAnchor, constant: 15),
            emailTextField.trailingAnchor.constraint(equalTo: usernameContainerView.trailingAnchor, constant: -15),
            emailTextField.centerYAnchor.constraint(equalTo: usernameContainerView.centerYAnchor),

            passwordContainerView.topAnchor.constraint(equalTo: usernameContainerView.bottomAnchor, constant: 20),
            passwordContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            passwordContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordIconView.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 15),
            passwordIconView.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            passwordIconView.widthAnchor.constraint(equalToConstant: 24),
            passwordIconView.heightAnchor.constraint(equalToConstant: 24),
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordIconView.trailingAnchor, constant: 15),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -15),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordContainerView.centerYAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        
            errorLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loginButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        loginButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    // MARK: - Actions
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.loginButton.transform = .identity
        }
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showError("Para continuar, completa todos los campos")
            return
        }
        
        errorLabel.isHidden = true
        presenter?.login(email: email, password: password)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showError(_ error: String) {
        errorLabel.text = error
        errorLabel.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.errorLabel.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.errorLabel.alpha = 1.0
            }
        }
    }
    
    func showLoading() {
        loadingView = showLoadingView()
    }
    
    func hideLoading() {
        hideLoadingView()
    }
    
    func navigateToMoviesList() {
    }
} 
