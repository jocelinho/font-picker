//
//  ContentView.swift
//  font-picker
//
//  Created by Jocelin Ho on 2024/7/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FontListViewModel()
    @State private var userText = "Type your text here..."
    @State private var selectedFont: Font?
    
    let cornerRadius: CGFloat = 16
    let textSize: CGFloat = 18
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading fonts...")
                } else {
                    mainView
                }
            }
            .navigationTitle("Font Picker")
        }
        .task {
            await viewModel.loadFonts()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMsg != nil)) {
            Button("Retry") {
                Task {
                    await viewModel.loadFonts()
                }
            }
        } message: {
            Text(viewModel.errorMsg ?? "An unknown error occurred.")
        }
    }
    
    private var mainView: some View {
        VStack(spacing: 20) {
            TextEditor(text: $userText)
                .font(.custom(selectedFont?.family ?? "Helvetica", size: textSize))
                .frame(height: 100)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(cornerRadius)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
            
            HStack {
                Text("Current Font")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                Text(selectedFont?.family ?? "Default")
                    .font(.custom(selectedFont?.family ?? "Helvetica", size: textSize))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                                       startPoint: .leading,
                                       endPoint: .trailing))
            .cornerRadius(cornerRadius)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search fonts", text: $viewModel.searchedText)
            }
            .padding()
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(cornerRadius)
            .cornerRadius(cornerRadius)
            
            List(viewModel.displayedFonts) { font in
                FontRowView(font: font,
                            isDownloaded: viewModel.downloadedFontFamilies.contains(font.family),
                            textSize: textSize,
                            onDownload: {
                    Task {
                        await downloadFontAndSelect(font)
                    }
                },
                            onSelect: {
                    selectFont(font)
                })
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
    
    private func selectFont(_ font: Font) {
        selectedFont = font
        viewModel.fontManager.loadCustomFont(fontFamily: font.family)
    }
    
    private func downloadFontAndSelect(_ font: Font) async {
        await viewModel.downloadFont(font)
        selectFont(font)
    }
}

struct FontRowView: View {
    let font: Font
    let isDownloaded: Bool
    let textSize: CGFloat
    let onDownload: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Text(font.family)
                .font(.custom(isDownloaded ? font.family : "Helvetica", size: textSize))
            Spacer()
            if isDownloaded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button(action: onDownload) {
                    Image(systemName: "arrow.down.circle")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
        .onTapGesture {
            if isDownloaded {
                onSelect()
            } else {
                onDownload()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
    }
}
