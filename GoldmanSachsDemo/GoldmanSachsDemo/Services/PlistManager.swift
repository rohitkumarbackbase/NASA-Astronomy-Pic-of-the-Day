//
//  PlistManager.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

struct PlistManager {
    
    static var sharedInstance = PlistManager()
    
    private var _favouriteImages = [APODModel]()
    
    var favouriteImages: [APODModel] {
        get {
            return self._favouriteImages
        }
        set {
            self._favouriteImages = newValue
            writePlist(array: newValue)
        }
    }
    
    private init() {
        _favouriteImages = readPlist()
    }
    
    func writePlist(array: [APODModel]) {
        var res: [[String: String?]] = []
        for obj in array {
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
    
    func readPlist() -> [APODModel] {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending(Constants.k_fileName)
        if let obj = NSArray(contentsOfFile: path) {
            return getData(array: obj)
        }
        return [APODModel]()
    }
    
    func getData(array: NSArray) -> [APODModel] {
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
