import Foundation

protocol NetworkServiceProtocol {
    
    func baseRequest<ResponseType: Decodable>(endpointPath: String,
                                              completionHandler: @escaping (Result<ResponseType, NetworkServiceError>) -> ())
}

