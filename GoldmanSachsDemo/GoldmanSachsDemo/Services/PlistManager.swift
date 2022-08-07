//
//  PlistManager.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

// MARK: - 'PlistManager'

/// Handles transaction requiring interaction with plist
struct PlistManager {
    
    /// Represents shared instance for single point of access.
    static var sharedInstance = PlistManager()
    
    /// Stores images marked as favourite
    private var _favouriteImages = [APODModel]()
    
    /// Directs to fetch and store the favourite images
    var favouriteImages: [APODModel] {
        get {
            return self._favouriteImages
        }
        set {
            self._favouriteImages = newValue
            writePlist(modelArray: newValue)
        }
    }
    
    private init() {
        _favouriteImages = readPlist()
    }
    
    /// Crestaes and writes to the plist
    /// - Parameter array: Array of object to be stored in plist
    func writePlist(modelArray: [APODModel]) {
        var res: [[String: String?]] = []
        for obj in modelArray {
            res.append(obj.toDict())
        }
        let dicContent = NSArray(array: res)
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending(Constants.k_fileName)
        if (!fileManager.fileExists(atPath: path)) {
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been created!")
            }
        } else {
            print("file already exist")
            let _ = dicContent.write(toFile: path, atomically: true)
        }
    }
    
    /// Reads from the plist
    /// - Returns: Array of the model objects
    func readPlist() -> [APODModel] {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending(Constants.k_fileName)
        if let obj = NSArray(contentsOfFile: path) {
            return getData(array: obj)
        }
        return [APODModel]()
    }
    
    /// Converts data to model array
    /// - Parameter array: NSArray from the plist to be converted
    /// - Returns: array of model object from plist
    private func getData(array: NSArray) -> [APODModel] {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            do{
                let webDescription = try
                JSONDecoder().decode([APODModel].self, from: jsonData)
                return webDescription
            }catch let jsonErr{
                print(Constants.k_jsonSerialisationErrorMsg, jsonErr)
            }
        } catch {
            print(error.localizedDescription)
        }
        return [APODModel]()
    }
}
