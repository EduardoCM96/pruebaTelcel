import UIKit

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 46/255, alpha: 1.0) // Fondo oscuro similar al login
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "movie")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Películas TMDB"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private var completion: (() -> Void)?
    
    // MARK: - Lifecycle
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - Setup
    private func setupUI() {
        setupGradientBackground()
        
        view.addSubview(backgroundView)
        view.addSubview(movieImageView)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            movieImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            movieImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            movieImageView.widthAnchor.constraint(equalToConstant: 180),
            movieImageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        movieImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        movieImageView.alpha = 0
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
            UIColor(red: 1/255, green: 180/255, blue: 228/255, alpha: 1.0).cgColor,
            UIColor(red: 30/255, green: 30/255, blue: 46/255, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Animation
    private func startAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.movieImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: .pi * 2)
            self.movieImageView.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 1.3, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.movieImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 1.0, options: [], animations: {
            self.titleLabel.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.completion?()
            })
        }
    }
} 
