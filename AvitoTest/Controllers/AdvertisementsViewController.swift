
import Foundation
import UIKit

final class AdvertisementsViewController: UIViewController {

    // MARK: Variables
    private let advertisementsViewModel: AdvertisementsViewModel
    private let advertisementsService: AdvertisementsServiceProtocol
    
    // MARK: UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AdvertisementCollectionViewCell.self, forCellWithReuseIdentifier: AdvertisementCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        return collectionView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: Initialization
    init(advertisementsService: AdvertisementsServiceProtocol) {
        self.advertisementsViewModel = AdvertisementsViewModel(advertisementsService: advertisementsService)
        self.advertisementsService = advertisementsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        loadData()
        setupViewModelBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner.startAnimating()
    }
}

private extension AdvertisementsViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor(.white)
        
        view.addSubview(spinner)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadData() {
        advertisementsViewModel.loadAdvertisements()
    }
    
    func setupViewModelBindings() {
        
        advertisementsViewModel.onAdvertisementsUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        advertisementsViewModel.onErrorMessage = { [weak self] error in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.title = error.localizedDescription
            alert.message = error.localizedDescription
            
            self?.present(alert, animated: true)
        }
        
        advertisementsViewModel.onLoadingStateUpdated = { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.removeFromSuperview()
            self?.collectionView.isHidden = false
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AdvertisementsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advertisementsViewModel.advertisements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        let advertisementId: Int = Int(advertisementsViewModel.advertisements[indexPath.row].id ?? "") ?? 0
        let advertisementViewController = AdvertisementViewController(advertisementId: advertisementId,
                                                                      advertisementService: advertisementsService)
        navigationController?.pushViewController(advertisementViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertisementCollectionViewCell.identifier, for: indexPath) as? AdvertisementCollectionViewCell else {
            fatalError("Failed to dequeue CharacterCell in CharacterViewController")
        }
        let advertisement = advertisementsViewModel.advertisements[indexPath.row]
        cell.configure(with: advertisement)
        return cell
    }
}

extension AdvertisementsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width / 2) - 15
        let height = (self.view.frame.height / 3) - 3.34
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
