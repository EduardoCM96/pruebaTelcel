import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func showMovieDetail(_ movie: Movie)
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

class MovieDetailViewController: UIViewController {
    
    var presenter: MovieDetailPresenterProtocol?
    private var loadingView: UIView?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sinopsis"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        ratingView.addSubview(starImageView)
        contentView.addSubview(overviewTitleLabel)
        contentView.addSubview(overviewLabel)
        
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentViewHeightConstraint,
            
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 250),
            
            posterImageView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -75),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            ratingView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            ratingView.widthAnchor.constraint(equalToConstant: 100),
            ratingView.heightAnchor.constraint(equalToConstant: 40),
            
            starImageView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 10),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -10),
            
            overviewTitleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 50),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.5
        
        backdropImageView.addSubview(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor)
        ])
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func showMovieDetail(_ movie: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.title = movie.title
            self.titleLabel.text = movie.title
            self.releaseDateLabel.text = "Fecha de estreno: \(movie.formattedReleaseDate)"
            self.overviewLabel.text = movie.overview
            self.overviewLabel.textAlignment = .justified
            self.ratingLabel.text = String(format: "%.1f", movie.voteAverage)
            
            self.backdropImageView.loadImage(from: movie.backdropURL, placeholder: UIImage(systemName: "film"))
            self.posterImageView.loadImage(from: movie.posterURL, placeholder: UIImage(systemName: "film"))
            
            if movie.voteAverage >= 8.0 {
                self.ratingView.backgroundColor = .systemGreen
            } else if movie.voteAverage >= 6.0 {
                self.ratingView.backgroundColor = .systemYellow
            } else {
                self.ratingView.backgroundColor = .systemRed
            }
            
            self.contentView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.contentView.alpha = 1
            }
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showError(error)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView = self?.showLoadingView()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingView()
        }
    }
} 
