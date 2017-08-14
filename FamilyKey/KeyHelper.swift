//
//  KeyHelper.swift
//  FamilyKey
//
//  Created by Orlando Amorim on 01/06/17.
//  Copyright © 2017 Orlando Amorim. All rights reserved.
//

import Foundation

class KeyHelper : NSObject, NSCoding{
    
    var descriptionField : String!
    var firstKeys : [String]!
    var keys : [Key]!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        firstKeys = dictionary["first_keys"] as? [String]
        keys = [Key]()
        if let keysArray = dictionary["keys"] as? [[String:Any]]{
            for dic in keysArray{
                let value = Key(fromDictionary: dic)
                keys.append(value)
            }
        }
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if firstKeys != nil{
            dictionary["first_keys"] = firstKeys
        }
        if keys != nil{
            var dictionaryElements = [[String:Any]]()
            for keysElement in keys {
                dictionaryElements.append(keysElement.toDictionary())
            }
            dictionary["keys"] = dictionaryElements
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        firstKeys = aDecoder.decodeObject(forKey: "first_keys") as? [String]
        keys = aDecoder.decodeObject(forKey :"keys") as? [Key]
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if firstKeys != nil{
            aCoder.encode(firstKeys, forKey: "first_keys")
        }
        if keys != nil{
            aCoder.encode(keys, forKey: "keys")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
