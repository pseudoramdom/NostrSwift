//
//  File.swift
//  
//
//  Created by Ramsundar Shandilya on 12/20/22.
//

import ArgumentParser

struct SporeCLI: ParsableCommand {
    static var configuration = CommandConfiguration(commandName:"spore-cli",
                                                    abstract: "CLI tool to test NostrSwift implementation",
                                                    subcommands: [Event.self,
                                                                  Subscribe.self,
//                                                                  Profile.self
                                                                 ])
}

SporeCLI.main()
