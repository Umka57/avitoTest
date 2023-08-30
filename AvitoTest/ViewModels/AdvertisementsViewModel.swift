
import Foundation

final class AdvertisementsViewModel {
    
    // MARK: Constants
    private let advertisementsService: AdvertisementsServiceProtocol
    
    // MARK: States
    var onAdvertisementsUpdated: (() -> Void)?
    var onErrorMessage: ((NetworkServiceError) -> Void)?
    var onLoadingStateUpdated: (() -> Void)?
    
    // MARK: StateUpdated Variables
    private(set) var isLoading: Bool? = true {
        didSet {
            onLoadingStateUpdated?()
        }
    }
    
    private(set) var advertisements: [Advertisement] = [] {
        didSet {
            onAdvertisementsUpdated?()
        }
    }
    
    // MARK: Initialization
    init(advertisementsService: AdvertisementsServiceProtocol) {
        self.advertisementsService = advertisementsService
    }
    
    // MARK: Functions
    func loadAdvertisements() {
        advertisementsService.getAdvertisements(completion: { [weak self] result in
            switch result {
            case .success(let advertisements):
                self?.isLoading = false
                self?.advertisements = advertisements
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        })
    }
}
