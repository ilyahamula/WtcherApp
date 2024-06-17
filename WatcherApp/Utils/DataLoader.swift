//
//  File.swift
//  WatcherApp
//
//  Created by macbook on 07.01.2024.
//

import Foundation

struct DataLoader {

    static func loadBundledContent(fromFileNamed name: String, in bundle: Bundle = .main) -> Data? {
        if let url = getURL(fromFileNamed: name, in: bundle) {
            do {
                let data = try Data(contentsOf: url, options: .alwaysMapped)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }

    static func getURL(fromFileNamed name: String, in bundle: Bundle = .main) -> URL? {
        let index = name.lastIndex(of: ".")
        if index == nil {
            return nil
        }

        guard let url = bundle.url(
            forResource: String(name.prefix(upTo: index!)),
            withExtension: String(name.suffix(from: index!))
        ) else {
           return nil
        }
        return url
    }
}
