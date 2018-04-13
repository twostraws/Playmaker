//
//  Page.swift
//  Playmaker
//
//  Created by Paul Hudson on 13/04/2018.
//

import Foundation

/**
 This represents one playground page, complete with all its
 code and comments.
 */
struct Page {
    /**
     Whether this is the first page, last page, or
     any page in between.
     */
    enum Position {
        case first, last, other
    }

    /**
     The title of this page, as extracted from
     the filename.
     */
    var title: String {
        // convert /path/to/028. Hello World.md to just "028. Hello World"
        let baseName = url.deletingPathExtension().lastPathComponent

        // remove all leading digits
        let regex = try! NSRegularExpression(pattern: "(\\d*\\.)? *(.*)", options: [])
        return regex.stringByReplacingMatches(in: baseName, options: [], range: NSRange(location: 0, length: 5), withTemplate: "$2")
    }

    /**
     The URL to the Markdown file for this page.
     */
    var url: URL

    /**
     Reads the input Markdown file, transforms it,
     and writes it back to disk as Swift.
     */
    func flatten(to destination: URL, position: Position, toc: String = "") {
        let pageDirectory = destination.appendingPathComponent("\(title).xcplaygroundpage")
        createOutputDirectory(pageDirectory)

        let contents = transform(position: position, toc: toc)
        write(contents, toFile: pageDirectory.appendingPathComponent("Contents.swift"))
    }

    /**
     Loads a file's content and transforms it into
     Swift, including navigation.
     */
    func transform(position: Position, toc: String) -> String {
        // make sure we can actually find this file
        guard var contents = try? String(contentsOf: url) else {
            quit("Unable to load file \(url.path)")
        }

        // there are three differet navigation bars depending on whether
        // this is the first page, last page, or any other page
        let navigationBar: String

        switch position {
        case .first:
            navigationBar = Page.next
        case .last:
            navigationBar = Page.previousHome
        default:
            navigationBar = Page.previousHomeNext
        }

        // code can be spaced using tabs or spaces, but we only care about spaces here – Markdown uses 4
        contents = contents.replacingOccurrences(of: "\t", with: "    ")

        // strip out any whitespace, to avoid extra spacing when files end with code then line breaks
        contents = contents.trimmingCharacters(in: .whitespacesAndNewlines)

        let lines = contents.components(separatedBy: "\n")

        // we always start in text mode
        var inCode = false
        var output = "/*:\n"

        // don't put at navigation bar at the top of the introduction
        if position != .first {
            output += "\(navigationBar)\n\n"
        }

        // now process every line of Markdown
        for var line in lines {
            // if this is an empty line we shouldn't do anything special –
            // just treat it as whatever it was before
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmed.isEmpty {
                output += "\(line)\n"
                continue
            }

            if line.hasPrefix("    ") {
                // this is code; drop the initial spacing and
                // optionally switch into code mode
                if !inCode {
                    inCode = true
                    output += "*/\n"
                }

                line = String(line.dropFirst(4))
            } else {
                // this isn't code; get out of code mode
                if inCode {
                    inCode = false
                    output += "/*:\n"
                }
            }

            output += "\(line)\n"
        }

        // make sure we're currently in text mode
        if inCode {
            output += "/*:\n"
        }

        if position == .first {
            output += "## Contents\n\(toc)\n"
        }

        output += "\n\n\(navigationBar)\n*/"

        // Playgrounds add lots of spacing around code whether we like it or not,
        // so make all text and code butt right up against each other
        output = output.replacingOccurrences(of: "\n\n*/", with: "\n*/")
        output = output.replacingOccurrences(of: "\n\n/*:", with: "\n/*:")

        return output
    }
}
