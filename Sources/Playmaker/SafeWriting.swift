//
//  SafeWriting.swift
//  Playmaker
//
//  Created by Paul Hudson on 13/04/2018.
//

import Foundation

/**
 Quit with a nice message.
 */
func quit(_ message: String) -> Never {
    print(message)
    exit(1)
}

/**
 Attempt to create a directory, or quit cleanly.
 */
func createOutputDirectory(_ directory: URL) {
    do {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    } catch {
        quit("Failed to create output directory \(directory.path): \(error.localizedDescription).")
    }
}

/**
 Attempt to write a file, or quit cleanly.
 */
func write(_ string: String, toFile filename: URL) {
    do {
        try string.write(to: filename, atomically: true, encoding: .utf8)
    } catch {
        quit("Failed to create output file \(filename.path): \(error.localizedDescription).")
    }
}
