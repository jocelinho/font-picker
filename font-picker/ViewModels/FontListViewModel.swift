//
//  FontListViewModel.swift
//  font-picker
//
//  Created by Jocelin Ho on 2024/7/18.
//

import Foundation

@MainActor
class FontListViewModel: ObservableObject {
    @Published var fonts: [Font] = []
    @Published var displayedFonts: [Font] = []
    @Published var isLoading = false
    @Published var errorMsg: String?
    @Published var fontManager = FontManager()
    @Published var downloadedFontFamilies: Set<String> = []
    @Published var searchedText = "" {
        didSet {
            filterFonts()
        }
    }
    
    private let service = FontFetchService()
    
    func loadFonts() async {
        isLoading = true
        errorMsg = nil
        
        do {
            let fontList = try await service.fetchFonts()
            self.fonts = fontList.items
            self.displayedFonts = self.fonts
            self.updateDownloadedFontFamilies()
        } catch {
            errorMsg = "Fonts fetch failed"
        }
        
        isLoading = false
    }
    
    func downloadFont(_ font: Font) async {
        do {
            try await fontManager.downloadFont(font: font)
            updateDownloadedFontFamilies()
        } catch {
            errorMsg = "Failed to download font: \(error.localizedDescription)"
        }
    }
    
    private func updateDownloadedFontFamilies() {
        downloadedFontFamilies = Set(fontManager.downloadedFonts.keys)
    }
    
    private func filterFonts() {
        if searchedText == "" {
            self.displayedFonts = self.fonts
        } else {
            displayedFonts = self.fonts.filter { font in
                return font.family.lowercased().contains(self.searchedText.lowercased())
            }
        }
    }
}
