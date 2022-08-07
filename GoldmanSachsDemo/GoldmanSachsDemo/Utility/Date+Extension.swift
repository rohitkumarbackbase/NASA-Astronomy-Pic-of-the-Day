//
//  Date+Extension.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

extension Date {
    
    /// <#Description#>
    var onlyDate: String {
        
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: self)
        }
    }
}
