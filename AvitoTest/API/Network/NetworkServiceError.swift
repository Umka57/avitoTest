import Foundation

enum NetworkServiceError: Error {
    
    case incorrectURL
    case urlSessionError(Error)
    case emptyData
    case emptyResponse
    case decodingError(Error)
    case selfUnavailable
    case unrecongnizedStatusCode
    
    //300 error codes
    case multipleChoices
    case movedPermanently
    case notModified
    case temporaryRedirect
    case permanentRedirect
    
    //400 error codes
    case badRequest
    case unathorized
    case forbidden
    case pageNotFound
    case conflict
    
    //500 error codes
    case iternalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    
}
