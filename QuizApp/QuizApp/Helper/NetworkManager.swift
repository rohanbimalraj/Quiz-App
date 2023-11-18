//
//  NetworkManager.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let BASE_URL = "https://opentdb.com/api.php"
    
    private init() {}
    
    typealias APIResult = Result<Data, Error>
    
    func getData() async -> APIResult {
        let fetchTask = Task { () -> Data in
            
            guard var url = URL(string: BASE_URL) else {
                throw AppErrors.invalidUrl
            }
            
            url.append(queryItems:
                        [URLQueryItem(name: "amount", value: "10"),
                         URLQueryItem(name: "category", value: "18"),
                         URLQueryItem(name: "difficulty", value: "easy"),
                         URLQueryItem(name: "type", value: "multiple")
                        ])
            print("URL:", url)
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        let result = await fetchTask.result
        return result
    }
}
