//
//  DataLocalStore.swift
//  Financial Calculator
//
//  Created by Ananthamoorthy Haniman on 2022-04-08.
//

import Foundation


protocol DataLocalStoreProtocol{
    
    func saveForm(_ data: Data, _ key: String)
    func getForm(_ key: String) -> Data?
}


struct DataLocalStore: DataLocalStoreProtocol{
    
    func saveForm(_ data: Data, _ key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func getForm(_ key: String) -> Data? {
        return UserDefaults.standard.object(forKey: key) as? Data
    }
    
    
    
}
