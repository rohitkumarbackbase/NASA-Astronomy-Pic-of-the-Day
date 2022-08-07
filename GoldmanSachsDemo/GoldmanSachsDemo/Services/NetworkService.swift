//
//  NetworkService.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 05/08/22.
//

import Foundation
import Alamofire

// MARK: - 'NetworkService'

/// Single point of contact for network services.
struct NetworkService {
    
    /// Represents shared instance for single point of access of network services.
    static let sharedInstance = NetworkService()
    
    /// Loads image details for the particular date.
    /// - Parameters:
    ///   - date: Optional string conating the date for which image needs to load
    ///   - completion: The block to execute after data fetched from network call
    func fetchingImageData(for date: String?, completion:@escaping (APODModel) -> ()) {
        
        let jsonURLString = Constants.k_serverURL
        let queryItems = [URLQueryItem(name: Constants.k_api_key, value: Constants.k_apiKey),
                          URLQueryItem(name: Constants.k_date, value: date)]
        guard var urlComps = URLComponents(string: jsonURLString)  else { return }
        urlComps.queryItems = queryItems
        guard let finalURL = urlComps.url else { return }

        URLSession.shared.dataTask(with: finalURL) { (data, response, err) in
            guard let data = data else {return}
            let dataString = String(data: data, encoding: String.Encoding.isoLatin1)
            // Converted to supported string format
            // Unbale to convert the response to String format due to unsupported string content in the response
            if let dataObject = dataString?.data(using: String.Encoding.utf8) {
                do{
                    let webDescription = try
                        JSONDecoder().decode(APODModel.self, from: dataObject)
                    completion(webDescription)
                }catch let jsonErr{
                    print(Constants.k_jsonSerialisationErrorMsg, jsonErr)
                }
            }
            }.resume()
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        if let networkManager = NetworkReachabilityManager() {
            return networkManager.isReachable
        } else {
            return false
        }
    }
}

