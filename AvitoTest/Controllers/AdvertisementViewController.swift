
import Foundation
import UIKit
import SnapKit
import Kingfisher

class AdvertisementViewController: UIViewController {
    
    // MARK: Variables and constants
    private let advertisementViewModel: AdvertisementViewModel
    private let advertisementId: Int
    
    // MARK: UIComponents
    private lazy var advertisementImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buyWithDeliveryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Купить с доставкой", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "ButtonBuyColor")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor(named: "ButtonBuyColor"), for: .normal)
        button.backgroundColor = UIColor(named: "AddToCartButtonColor")
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var createdDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.contentHuggingPriority(for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.text = "Описание"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contactsHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 24)
        label.text = "Контакты"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel : UILabel = UILabel()
    private lazy var phoneNumberLabel : UILabel = UILabel()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isHidden = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var vStackMainView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var vStackDescription: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var vStackContacts: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: Initialization
    init(advertisementId: Int ,advertisementService: AdvertisementsServiceProtocol) {
        self.advertisementId = advertisementId
        self.advertisementViewModel = AdvertisementViewModel(advertisementId: advertisementId,
                                                             advertisementsService: advertisementService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configuration
    func configure(advertisement: AdvertisementDetailed?) {
        if let advertisement = advertisement {
            advertisementImageView.kf.setImage(
                with: URL(string: advertisement.imageURL ?? ""),
                options: [.fromMemoryCacheOrRefresh]
            )
            titleLabel.text = advertisement.title
            priceLabel.text = advertisement.price
            locationLabel.text = (advertisement.location ?? "") + ", " + (advertisement.address ?? "")
            createdDateLabel.text = advertisement.createdDate?.reformatDate()
            descriptionLabel.text = advertisement.description
            emailLabel.text = advertisement.email
            phoneNumberLabel.text = advertisement.phoneNumber
        }
        
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupViewModelBindings()
        setNavigationBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        spinner.startAnimating()
    }
}

extension AdvertisementViewController {
    
    func setupUI() {
        
        view.addSubview(spinner)
        spinner.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        })
        scrollView.addSubview(vStackMainView)
        scrollView.addSubview(advertisementImageView)
        
        advertisementImageView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(10)
            make.width.equalTo(scrollView)
            make.height.equalTo(view.frame.height / 3)
        })
        
        vStackMainView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(advertisementImageView.snp.bottom).offset(20)
            make.width.equalTo(scrollView)
        })
        
        vStackMainView.addArrangedSubview(priceLabel)
        vStackMainView.addArrangedSubview(titleLabel)
        vStackMainView.addArrangedSubview(buyWithDeliveryButton)
        buyWithDeliveryButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        vStackMainView.addArrangedSubview(addToCartButton)
        addToCartButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        vStackMainView.addArrangedSubview(locationLabel)
        
        vStackMainView.addArrangedSubview(vStackDescription)
        vStackDescription.addArrangedSubview(descriptionHeaderLabel)
        vStackDescription.addArrangedSubview(descriptionLabel)
        
        vStackMainView.addArrangedSubview(vStackContacts)
        vStackContacts.addArrangedSubview(contactsHeaderLabel)
        vStackContacts.addArrangedSubview(emailLabel)
        vStackContacts.addArrangedSubview(phoneNumberLabel)
        
        vStackMainView.addArrangedSubview(createdDateLabel)
    }
    
    func loadData() {
        advertisementViewModel.loadAdvertisement()
    }
    
    func setupViewModelBindings() {
        
        advertisementViewModel.onAdvertisementUpdated = { [weak self] in
            self?.configure(advertisement: self?.advertisementViewModel.advertisement)
        }
        
        advertisementViewModel.onErrorMessage = { [weak self] error in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.title = error.localizedDescription
            alert.message = error.localizedDescription
            
            self?.present(alert, animated: true)
        }
        
        advertisementViewModel.onLoadingStateUpdated = { [weak self] in
            self?.spinner.stopAnimating()
            self?.spinner.removeFromSuperview()
            self?.scrollView.isHidden = false
        }
    }
    
    func setNavigationBarButtons() {
        let shareButton = UIBarButtonItem(image: UIImage(named: "share-icon"))
        shareButton.tintColor = .black
        
        let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"))
        favouriteButton.tintColor = .black
        
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"))
        cartButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [cartButton, favouriteButton ,shareButton]
    }
}
