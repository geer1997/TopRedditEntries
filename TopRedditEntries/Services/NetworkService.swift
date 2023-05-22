//
//  NetworkService.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation
import Alamofire

protocol EndpointType {
    var method: HTTPMethod { get }
    var url: String { get }
    var parameters: Parameters? { get }
    var header: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

struct DecodeType<T: Decodable>: Decodable {
    var data: T?
    var error: String?
    
    private enum CodingKeys: String, CodingKey {
        case
        data = "data",
        error = "error"
    }
    
    init(
        data: T? = nil,
        error: String? = nil
    ) {
        self.data = data
        self.error = error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            data = try container.decode(T.self, forKey: .data)
        } catch(let error) {
            data = nil
            self.error = error.localizedDescription
        }
    }
}

class NetworkService {
    static let share = NetworkService()
    
    private var dataRequest: DataRequest?
    private let baseUrl = "https://www.reddit.com/"
    
    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = ["Content-Type":"application/json"])
    -> DataRequest {
        return Alamofire.Session.default.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    func request<T: EndpointType, D: Codable>(endpoint: T, decodeType: D.Type, isPlainUrl: Bool = false, completion: @escaping (Swift.Result<D?, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = self.baseUrl + endpoint.url
            
            self.dataRequest = self._dataRequest(url: url,
                                                 method: endpoint.method,
                                                 parameters: endpoint.parameters,
                                                 encoding: endpoint.encoding,
                                                 headers: endpoint.header)
            self.dataRequest?.validate()
            
            self.dataRequest?.responseDecodable(of: DecodeType<D>.self) { (response) in
                switch response.result {
                case .success(let value):
                    completion(.success(value.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
