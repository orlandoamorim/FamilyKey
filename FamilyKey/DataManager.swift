//
//  DataManager.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 02/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation

let sumaryUrl = ""

public class DataManager {
    
    public class func getDataFromFile(_ named:String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: named, ofType:"json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath:filePath), options: .uncached)
            return data
        } catch {
            return nil
        }
        
    }
    
}
