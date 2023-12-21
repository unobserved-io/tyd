//
//  JSONDocument.swift
//  Tyd
//
//  Created by Ricky Kresslein on 12/20/23.
//

import Foundation

import SwiftUI
import UniformTypeIdentifiers

struct JSONDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    var data: Data
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.data = data
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {     
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.preferredFilename = "Tyd-\(dateFormatter.string(from: Date.now)).json"
        return fileWrapper
    }
}
