//
//  Requester.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import Foundation

protocol RequestExecuter {
    func execute<T: Decodable>(router: Router, completion: @escaping (Result<T, Error>) -> ())
}

final class Requester: RequestExecuter {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute<T: Decodable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard var url = URL(string: router.baseUrl) else {
            return
        }
        url.appendPathComponent(router.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            guard response != nil, let data = data else {
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
