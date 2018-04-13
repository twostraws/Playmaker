//
//  App.swift
//  Playmaker
//
//  Created by Paul Hudson on 13/04/2018.
//

import Foundation

/**
 The Playmaker app, which assembles a collection
 of Page instances and writes them all to disk.
 */
struct App {
    /**
     Stores the directory where Markdown files are
     being read from, and where the finished playground
     will be written.
     */
    private struct Options {
        var readURL: URL
        var destinationURL: URL
    }

    /**
     Parses settings, creates Page instances,
     checks all the data is good, then writes
     the finished playground.
    */
    func process(using options: [String]) {
        let options = parse(options)
        let pages = loadPages(options)
        runPreflight(options, pages)
        writeOutput(options, using: pages)
    }

    /**
     Parses options from user input. We only expect one
     at this time, which is the directory to convert.
    */
    private func parse(_ options: [String]) -> Options {
        let readPath = options.first ?? FileManager.default.currentDirectoryPath

        let readURL = URL(fileURLWithPath: readPath)
        let playgroundName = readURL.lastPathComponent
        let destinationURL = readURL.appendingPathComponent(playgroundName).appendingPathExtension("playground")
        return Options(readURL: readURL, destinationURL: destinationURL)
    }

    /**
     Runs some simple checks to make sure the playground
     can be created.
    */
    private func runPreflight(_ options: Options, _ pages: [Page]) {
        if FileManager.default.fileExists(atPath: options.destinationURL.path) {
            quit("\(options.destinationURL.lastPathComponent) already exists.")
        }

        if pages.isEmpty {
            quit("Unable to locate any pages. Please create at least one page called \"1. Introduction.md\".")
        }

        if pages.filter({ $0.title == "Introduction" }).isEmpty {
            quit("You must have at least one file called Introduction, e.g. \"1. Introduction.md\" or \"001. Introduction.md\".")
        }

    }

    /**
     Scans the input directory for Markdown files, and loads
     them in ready for processing.
    */
    private func loadPages(_ options: Options) -> [Page] {
        if let contents = try? FileManager.default.contentsOfDirectory(at: options.readURL, includingPropertiesForKeys: nil, options: []) {
            let markdownFiles = contents.filter { $0.pathExtension == "md" }
            let sortedFiles = markdownFiles.sorted { $0.path < $1.path }
            return sortedFiles.map { Page(url: $0) }
        } else {
            quit("Unable to read directory \(options.readURL.path).")
        }
    }

    /**
     Writes this playground to disk.
    */
    private func writeOutput(_ options: Options, using pages: [Page]) {
        // prepare the directories we need to work with
        let pagesURL = options.destinationURL.appendingPathComponent("Pages")
        let workspaceURL = options.destinationURL.appendingPathComponent("playground.xcworkspace")

        createOutputDirectory(options.destinationURL)
        createOutputDirectory(pagesURL)
        createOutputDirectory(workspaceURL)

        // write the workspace data
        write(App.workspaceData, toFile: workspaceURL.appendingPathComponent("contents.xcworkspacedata"))

        // assemble the user-facing table of contents
        let tableOfContents = pages.map { page -> String in
            let url = page.title.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? page.title
            return "* [\(page.title)](\(url))"
        }.joined(separator: "\n")

        // flatten all pages, handling first and last separately
        pages.first?.flatten(to: pagesURL, position: .first, toc: tableOfContents)
        pages.dropFirst().dropLast().forEach { $0.flatten(to: pagesURL, position: .other) }
        pages.last?.flatten(to: pagesURL, position: .last)

        // assemble and write the XML table of contents
        let pageList = pages.map { "        <page name='\($0.title)'/>" }.joined(separator: "\n")
        let contents = App.contents.replacingOccurrences(of: "$pages", with: pageList)
        write(contents, toFile: options.destinationURL.appendingPathComponent("contents.xcplayground"))
    }
}
