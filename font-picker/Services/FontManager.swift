//
//  FontManager.swift
//  font-picker
//
//  Created by Jocelin Ho on 2024/7/18.
//

import Foundation
import UIKit

class FontManager {
    
    var downloadedFonts: [String: URL] = [:]
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDirectory.appendingPathComponent("FontCache")
        
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating font cache directory: \(error)")
        }
        
        loadCachedFonts()
    }
    
    func downloadFont(font: Font) async throws {
        if let _ = downloadedFonts[font.family] {
            // Font is already downloaded, no need to download again
            return
        }
        
        guard let url = URL(string: font.files["regular"] ?? "") else {
            throw NSError(domain: "Font Manager", code: 1, userInfo: [NSLocalizedDescriptionKey: "No regular font file found"] )
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (400...499).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Font Manager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Network request failed"])
        }
        
        let cachedFontUrl = cacheDirectory.appendingPathComponent(font.family + ".ttf")
        try data.write(to: cachedFontUrl)
        
        await MainActor.run {
            self.downloadedFonts[font.family] = cachedFontUrl
        }
    }
    
    func loadCustomFont(fontFamily: String) {
        guard let fontURL = downloadedFonts[fontFamily] else { return }
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else { return }
        guard let font = CGFont(fontDataProvider) else { return }
        
        CTFontManagerRegisterGraphicsFont(font, nil)
    }
    
    private func loadCachedFonts() {
        do {
            let cachedFonts = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for fontUrl in cachedFonts {
                let fontFamily = fontUrl.deletingPathExtension().lastPathComponent
                downloadedFonts[fontFamily] = fontUrl
            }
            for (fontFamily, _) in downloadedFonts {
                loadCustomFont(fontFamily: fontFamily)
            }
        } catch {
            print("Error loading cached fonts: \(error)")
        }
    }
}
