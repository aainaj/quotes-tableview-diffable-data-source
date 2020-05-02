//
// Created by Aaina Jain on 01/05/20.
// Copyright (c) 2020 Aaina Jain. All rights reserved.
//

import Foundation

enum JSONLoaderError: Error {
    case loadJSONFileError(message: String, file: StaticString, line: UInt)
}

extension Bundle {
    func decode<T>(from name: String,
                   file: StaticString = #file,
                   line: UInt = #line,
                   keyDecodingStratetgy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T where T: Decodable {
       do {
           let data = try loadFile(name: name, ofType: "json", file: file, line: line)
           let decoder = JSONDecoder()
           decoder.keyDecodingStrategy = keyDecodingStratetgy
           do {
               return try decoder.decode(T.self, from: data)
           } catch DecodingError.keyNotFound(let key, let context) {
               fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
           } catch DecodingError.typeMismatch(_, let context) {
               fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
           } catch DecodingError.valueNotFound(let type, let context) {
               fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
           } catch DecodingError.dataCorrupted(_) {
               fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
           } catch {
               fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
           }
       } catch JSONLoaderError.loadJSONFileError(let message, _, _) {
           fatalError(message)
       } catch {
           fatalError("Failed to load \(file) from bundle")
       }
    }

    func encode<T>(from object: T,
                   keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys) throws -> Data where T: Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        return try encoder.encode(object)
    }

    private func loadFile(name: String,
                          ofType type: String,
                          file: StaticString = #file,
                          line: UInt = #line) throws -> Data {
        guard let url = url(forResource: name + "." + type, withExtension: nil),
              let data: Data = try? Data(contentsOf: url) else {
            let message: String
            if let bundleIdentifier = self.bundleIdentifier {
                message = "Couldn't load file named \(name).\(type) in bundle \(bundleIdentifier)"
            } else {
                message = "Couldn't load file named \(name).\(type)"
            }
            throw JSONLoaderError.loadJSONFileError(message: message, file: file, line: line)
        }
        return data
    }

}
