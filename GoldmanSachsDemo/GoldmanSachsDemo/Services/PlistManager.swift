//
//  PlistManager.swift
//  GoldmanSachsDemo
//
//  Created by Rohit Kumar on 07/08/22.
//

import Foundation

struct PlistManager {
    
    static let sharedInstance = PlistManager()
    
    var favouriteImages = [APODModel]()
    
    func writePlist(array: [APODModel]) {
        var res: [[String: String?]] = []
        for obj in array {
            res.append(obj.toDict())
        }
        let dicContent = NSArray(array: res)
        
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/favourite_images.plist")
//        guard let infoPlistPath = Bundle.main.path(forResource: "favourite_images", ofType: "plist") else { return }
        
        if (!fileManager.fileExists(atPath: path)) {
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been created!")
            }else{
                print("unable to create the file")
            }
            
        } else {
            print("file already exist")
            let success:Bool = dicContent.write(toFile: path, atomically: true)
            if success {
                print("file has been edited!")
            }else{
                print("unable to create the file")
            }
        }
    }
    
    func readPlist() -> [APODModel]? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/favourite_images.plist")
        if let obj = NSArray(contentsOfFile: path) {
            return getData(array: obj)
        }
        return nil
    }
    
    func getData(array: NSArray) -> [APODModel]? {
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
        return nil
    }
}
