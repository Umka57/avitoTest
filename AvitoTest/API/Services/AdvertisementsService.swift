
import Foundation

final class AdvertisementsService: AdvertisementsServiceProtocol {
    
    let network: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        network = networkService
    }
    
    func getAdvertisements(completion: @escaping (Result<[Advertisement], NetworkServiceError>) -> ()) {
        network.baseRequest(endpointPath: "/main-page.json",
                            completionHandler: { (result: Result<ResponseModel, NetworkServiceError>) in
            let mappedResult: Result<[Advertisement], NetworkServiceError> = result.map({ return $0.advertisements })
            completion(mappedResult)
        })
    }
    
    func getAdvertisementDetails(advertisementId: Int, completion: @escaping (Result<AdvertisementDetailed, NetworkServiceError>) -> ()) {
        network.baseRequest(endpointPath: "details/\(advertisementId).json",
                            completionHandler: { (result: Result<AdvertisementDetailed, NetworkServiceError>) in
            let mappedResult: Result<AdvertisementDetailed, NetworkServiceError> = result.map({ return $0 })
            completion(mappedResult)
        })
    }
}

protocol AdvertisementsServiceProtocol {
    
    func getAdvertisements(completion: @escaping (Result<[Advertisement], NetworkServiceError>) -> ())
    
    func getAdvertisementDetails(advertisementId: Int, completion: @escaping (Result<AdvertisementDetailed, NetworkServiceError>) -> ())
}
