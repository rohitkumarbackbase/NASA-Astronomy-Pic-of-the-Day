//
//  NetworkService.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 05/08/22.
//

import Foundation
import Alamofire

struct NetworkService {
    
    static let sharedInstance = NetworkService()
    
    func fetchingData(for date: String?, completion:@escaping (APODModel) -> ()) {
        
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

