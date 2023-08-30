
import Foundation
import UIKit
import Kingfisher
import SnapKit

final class AdvertisementCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AdvertisementCollectionViewCell"
    
    // MARK: Components
    private lazy var advertisementImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var advertisementTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.contentHuggingPriority(for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var advertisementPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var advertisementLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var advertisementDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 17)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.contentHuggingPriority(for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.black), for: .normal)
        return button
    }()
    
    private let hStackTitleAndFavorite: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let vStackDescription: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure
    func configure(with advertisement: Advertisement) {
        advertisementImageView.kf.indicatorType = .activity
        advertisementImageView.kf.setImage(
            with: URL(string: advertisement.imageURL ?? ""),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        
        advertisementTitleLabel.text = advertisement.title
        advertisementPriceLabel.text = advertisement.price
        advertisementLocationLabel.text = advertisement.location
        advertisementDateLabel.text = advertisement.createdDate?.reformatDate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        advertisementImageView.image = nil
        advertisementTitleLabel.text = nil
        advertisementPriceLabel.text = nil
        advertisementLocationLabel.text = nil
        advertisementDateLabel.text = nil
    }
}

extension AdvertisementCollectionViewCell {
    
    func setupUI() {
        
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        addSubview(cardView)
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 5, height: 5)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        advertisementImageView.layer.mask = maskLayer
        
        cardView.addSubview(advertisementImageView)
        cardView.addSubview(vStackDescription)
        
        vStackDescription.addArrangedSubview(hStackTitleAndFavorite)
        hStackTitleAndFavorite.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        hStackTitleAndFavorite.addArrangedSubview(advertisementTitleLabel)
        let favoriteButtonWrapper = UIView()
        favoriteButtonWrapper.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(20)
        })
        hStackTitleAndFavorite.addArrangedSubview(favoriteButtonWrapper)
        vStackDescription.addArrangedSubview(advertisementPriceLabel)
        vStackDescription.addArrangedSubview(advertisementLocationLabel)
        vStackDescription.addArrangedSubview(advertisementDateLabel)
        
        cardView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        advertisementImageView.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(vStackDescription.snp.top).inset(-10)
        })
        
        vStackDescription.snp.makeConstraints({ make in
            make.top.equalTo(advertisementImageView.snp.bottom).inset(-10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        })
    }
}
