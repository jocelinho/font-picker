//
//  FontModel.swift
//  font-picker
//
//  Created by Jocelin Ho on 2024/7/18.
//

import Foundation

struct FontList: Codable {
    let items: [Font]
}

struct Font: Codable, Identifiable {
    let family: String
    let variants: [String]
    let subsets: [String]
    let version: String
    let lastModified: String
    let files: [String: String]
    let category: String
    let kind: String
    let menu: String
    
    var id: String { family }
}
