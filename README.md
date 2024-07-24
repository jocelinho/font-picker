# Font Picker iOS App

Font Picker is an iOS application that allows users to browse, download, and preview various fonts. This app demonstrates how to work with custom fonts, download assets, and manage API keys securely in an iOS environment.

## Demo
![Simulator Screenshot - iPhone 14 Pro - 2024-07-24 at 13 35 39](https://github.com/user-attachments/assets/798aaa81-07b4-49b2-937e-598d4de90416)


[👉 Click here for video demo ](https://youtube.com/shorts/yaOaKSm2Ybo?feature=share)

## Features

- Browse a list of fonts from Google Fonts API
- Download and preview selected fonts
- Display font samples with user-input text
- Secure API key management using `.xcconfig` files

## Prerequisites

- Xcode 13.0+
- iOS 15.0+
- Swift 5.5+

## Getting Started

To get the Font Picker app running on your local machine, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/font-picker.git
   cd font-picker
   ```

2. Create a `Secrets.xcconfig` file in the project root:
   ```
   touch Secrets.xcconfig
   ```

3. Open `Secrets.xcconfig` and add your Google Fonts API key:
   ```
   API_KEY = your_google_fonts_api_key_here
   ```

   Note: If you don't have an API key, you can get one from the [Google Fonts Developer API](https://developers.google.com/fonts/docs/developer_api).

4. Open the project in Xcode:
   ```
   open font-picker.xcodeproj
   ```

5. Build and run the project in Xcode.

## Project Structure

- `ContentView.swift`: The main view of the app.
- `FontListViewModel.swift`: ViewModel for managing the font list and download states.
- `FontModel.swift`: Data models for Font and FontList.
- `FontManager.swift`: Manages font downloading and caching.
- `FontFetchService.swift`: Handles API requests to fetch font data.

## Configuration

The project uses `.xcconfig` files for managing environment-specific settings:

- `Secrets.xcconfig`: Contains the API key (not tracked in Git)
- `Debug.xcconfig` and `Release.xcconfig`: Environment-specific configurations

Make sure to set up your `Secrets.xcconfig` file before running the app.

