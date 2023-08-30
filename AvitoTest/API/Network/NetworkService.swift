import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    let baseURL: String
    
    init(baseURL: String){
        self.baseURL = baseURL
    }
    
    func baseRequest<ResponseType: Decodable>(endpointPath: String, completionHandler: @escaping (Result<ResponseType, NetworkServiceError>) -> () ) {
        
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpointPath) else {
            completionHandler(.failure(NetworkServiceError.incorrectURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            let result: Result<ResponseType, NetworkServiceError> = taskResult(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }.resume()
        
    }
}

