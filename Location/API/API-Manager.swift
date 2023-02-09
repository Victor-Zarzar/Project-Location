//
//  API-Manager.swift
//  Location
//
//  Created by Victor Zarzar on 08/02/23.
//

import Foundation
import SwiftUI

struct IP: Decodable {
    var ip: String
}

struct IPGeo: Decodable {
    var city: String
    var country: String
    var timezone: String
}

struct IPCoordinates: Decodable {
    var latitude: Double
    var longitude: Double
}

class APIManager: ObservableObject {
    func fetchData<T: Decodable>(url: String, model: T.Type, completion:@escaping(T) -> (), failure:@escaping(Error) -> ()) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error { failure(error) }
                return }
            
            
            do {
                let serverData = try JSONDecoder().decode(T.self, from: data)
                completion((serverData))
            } catch {
                failure(error)
            }
            
        }.resume()
        
        
    }
}

