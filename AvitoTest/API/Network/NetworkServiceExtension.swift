import Foundation

extension NetworkService {
    
    func taskResult<ResponceType: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<ResponceType, NetworkServiceError> {
        
        var result: Result<ResponceType, NetworkServiceError>
        
        if let error = error {
            result = .failure(.urlSessionError(error))
        } else if let data = data {
            if let response = response as? HTTPURLResponse {
                if 200...299 ~= response.statusCode {
                    do {
                        let decodedData = try JSONDecoder().decode(ResponceType.self, from: data)
                        result = .success(decodedData)
                    } catch {
                        result = .failure(.decodingError(error))
                    }
                    
                } else {
                    result = .failure(checkResponseStatusCode(statusCode: response.statusCode))
                }
            } else {
                result = .failure(.emptyResponse)
            }
        } else {
            result = .failure(.emptyData)
        }
        
        return result
    }
    
    func checkResponseStatusCode(statusCode: Int) -> NetworkServiceError {
        switch statusCode {
        case 300: return .multipleChoices
        case 301: return .movedPermanently
        case 304: return .notModified
        case 307: return .temporaryRedirect
        case 308: return .permanentRedirect
        case 400: return .badRequest
        case 401: return .unathorized
        case 403: return .forbidden
        case 404: return .pageNotFound
        case 409: return .conflict
        case 500: return .iternalServerError
        case 501: return .notImplemented
        case 502: return .badGateway
        case 503: return .serviceUnavailable
        case 504: return .gatewayTimeout
        default: return .unrecongnizedStatusCode
        }
    }
}
