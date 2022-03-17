//
//  ShellLauncher.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 27/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

enum IOError: Error {
    case deviceNotConnected
    case scriptFailure
}

typealias BLEAppleScriptCompletionBlock = (Result<String, IOError>) -> Void

protocol CommandExecuting {
    func execute(commandName: String, arguments: [String], completion: @escaping BLEAppleScriptCompletionBlock)
}

final class BashExecutor: CommandExecuting {

    // MARK: - CommandExecuting

    func execute(commandName: String, arguments: [String], completion: @escaping BLEAppleScriptCompletionBlock) {
        
        guard var bashCommand = execute(command: "/bin/bash" , arguments: ["-l", "-c", "which \(commandName)"]) else {
            completion(.failure(IOError.scriptFailure))
            return
        }
        
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let output = execute(command: bashCommand, arguments: arguments)
        
        if let data = output,
            data.isEmpty == false {
            completion(.success(data))
        } else {
            completion(.failure(IOError.deviceNotConnected))
        }
    }
    
    // MARK: Private
    
    private func execute(command: String, arguments: [String] = []) -> String? {
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        DispatchQueue.global().async {
             process.waitUntilExit()
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        return output
    }
}
