//
//  APODModel.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

// MARK: - APODModel
struct APODModel: Codable {
    let copyright, date, explanation: String?
    let hdurl: String
    let mediaType, serviceVersion, title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
    
    /// Converts `APODModel` to dictionary notation
    /// - Returns: Dictonary object
    func toDict() -> [String : String?] {
        let dictionary = ["copyright" : self.copyright,
                          "date" : self.date,
                          "explanation" : self.explanation,
                          "hdurl" : self.hdurl,
                          "media_type" : self.mediaType,
                          "service_version" : self.serviceVersion,
                          "title" : self.title,
                          "url" : self.url
        ]
        return dictionary
    }
}
