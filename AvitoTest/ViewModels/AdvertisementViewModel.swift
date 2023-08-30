
import Foundation

final class AdvertisementViewModel {
    
    // MARK: Constants
    private let advertisementsService: AdvertisementsServiceProtocol
    private var advertisementId: Int
    
    // MARK: States
    var onAdvertisementUpdated: (() -> Void)?
    var onErrorMessage: ((NetworkServiceError) -> Void)?
    var onLoadingStateUpdated: (() -> Void)?
    
    // MARK: StateUpdated Variables
    private(set) var isLoading: Bool? = true {
        didSet {
            onLoadingStateUpdated?()
        }
    }
    
    private(set) var advertisement: AdvertisementDetailed? {
        didSet {
            onAdvertisementUpdated?()
        }
    }
    
    // MARK: Initialization
    init(advertisementId: Int ,advertisementsService: AdvertisementsServiceProtocol) {
        self.advertisementId = advertisementId
        self.advertisementsService = advertisementsService
    }
    
    // MARK: Functions
    func loadAdvertisement() {
        advertisementsService.getAdvertisementDetails(advertisementId: advertisementId, completion: { [weak self] result in
            switch result {
            case .success(let advertisement):
                self?.isLoading = false
                self?.advertisement = advertisement
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        })
    }
}
