//
//  NetwrokManager.swift
//  Giphy
//
//  Created by Ferrakkem Bhuiyan on 2020-11-21.
//

import Foundation

struct EndPointDetails {
    static let endPoint = "https://api.giphy.com/v1"
    static let apiKey = "ddQCEJvPOjdNT1BxKjQgdJiGT945xmYx"
    static let trendingEndpoint = "https://api.giphy.com/v1/stickers/trending?api_key=ddQCEJvPOjdNT1BxKjQgdJiGT945xmYx&limit=25&rating=g"
    static let searchAPI = "https://api.giphy.com/v1/stickers/search?api_key=ddQCEJvPOjdNT1BxKjQgdJiGT945xmYx&q=&limit=25&offset=0&rating=g&lang=en"
}

class NetwrokManager{
    
    private var dataTask: URLSessionDataTask?
    
    func getTrendingGiphy(completion: @escaping(Result<TrendingModel, Error>) -> Void){
        let basicUrl = EndPointDetails.trendingEndpoint
        
        guard let url = URL(string: basicUrl) else{
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Now Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TrendingModel.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        dataTask?.resume()
        
    }
    
}
