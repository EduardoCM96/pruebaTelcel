import UIKit

protocol MoviesListViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
}

class MoviesListViewController: UIViewController {
    
    var presenter: MoviesListPresenterProtocol?
    private var movies: [Movie] = []
    private var loadingView: UIView?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Películas Mejor Valoradas"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoutButton = UIBarButtonItem(title: "Cerrar Sesión", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutButton
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿Estás seguro que deseas cerrar sesión?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .destructive, handler: { [weak self] _ in
            self?.presenter?.logout()
        }))
        
        present(alert, animated: true)
    }
    
    @objc private func refreshData() {
        presenter?.refreshMovies()
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        presenter?.showMovieDetail(movie: movie)
    }
}

extension MoviesListViewController: MoviesListViewProtocol {
    func showMovies(_ movies: [Movie]) {
        self.movies = movies
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
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

class MovieTableViewCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            posterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            posterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            posterImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            ratingView.widthAnchor.constraint(equalToConstant: 60),
            ratingView.heightAnchor.constraint(equalToConstant: 30),
            
            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor)
        ])
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.masksToBounds = false
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        
        posterImageView.loadImage(from: movie.posterURL, placeholder: UIImage(systemName: "film"))
        
        if movie.voteAverage >= 8.0 {
            ratingView.backgroundColor = .systemGreen
        } else if movie.voteAverage >= 6.0 {
            ratingView.backgroundColor = .systemYellow
        } else {
            ratingView.backgroundColor = .systemRed
        }
    }
} 