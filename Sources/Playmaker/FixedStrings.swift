//
//  FixedStrings.swift
//  Playmaker
//
//  Created by Paul Hudson on 13/04/2018.
//

import Foundation

extension App {
    /**
     Text that will be written intocontents.xcworkspacedata
    */
    static var workspaceData: String {
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <Workspace version = "1.0">
            <FileRef location = "self:"></FileRef>
        </Workspace>
        """
    }

    /**
     Text that will be written into contents.xcplayground,
     where $pages is replaced with actual page data.
    */
    static var contents: String {
        return """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <playground version='6.0' target-platform='ios' display-mode='rendered'>
            <pages>
        $pages
            </pages>
        </playground>
        """
    }
}

extension Page {
    /**
     Navigation bar to be used on the first page.
     */
    static var next: String {
        return "[Next >](@next)"
    }

    /**
     Navigation bar to be used on the final page.
    */
    static var previousHome: String {
        return "[< Previous](@previous)           [Home](Introduction)"
    }

    /**
     Navigation bar to be used on all other pages.
    */
    static var previousHomeNext: String {
        return "[< Previous](@previous)           [Home](Introduction)           [Next >](@next)"
    }
}
