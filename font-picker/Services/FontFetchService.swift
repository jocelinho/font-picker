//
//  FontFetchService.swift
//  font-picker
//
//  Created by Jocelin Ho on 2024/7/18.
//

import Foundation

class FontFetchService {
    private let baseURL = "https://www.googleapis.com/webfonts/v1/webfonts"
    private let APIKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
    
    func fetchFonts() async throws  -> FontList {
        guard let url = URL(string: baseURL + "?key=" + APIKey) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let fontList = try JSONDecoder().decode(FontList.self, from: data)
        return fontList
    }
    
}
