//
//  main.swift
//  Playmaker
//
//  Created by Paul Hudson on 13/04/2018.
//

import Foundation


// fetch any command-line options, missing the
// first one – that's the name of our program
let options = CommandLine.arguments.dropFirst()

let app = App()
app.process(using: Array(options))
