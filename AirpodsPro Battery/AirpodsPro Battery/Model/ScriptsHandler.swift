//
//  ScriptsHandler.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 09/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

typealias ExecutingCompletionBlock = (Result<String, IOError>) -> Void

protocol ScriptingProtocol {
    
    var scriptingFolderPath: String { get set }
    var searchPathDirectory: FileManager.SearchPathDirectory {get set }
    
    func askPermissionsForUser()
    func directoryExistsAtPath(_ path: String) -> Bool
    func writeScriptToDisk(scriptsFiles: [String])
    func scriptDiskFilePath(scriptName: String) -> String
}

protocol ExecutingProtocol {
    func execute(commandName: String, arguments: [String], completion: @escaping ExecutingCompletionBlock)
}

struct ScriptsHandler {
    
    private(set) var bashExecutor: CommandExecuting
    private(set) var scriptsName: [String]
    
    var scriptingFolderPath: String = "AirpodsProBattery/script/"
    var searchPathDirectory: FileManager.SearchPathDirectory = .libraryDirectory
    
    init(bashExecutor: CommandExecuting = BashExecutor(), scriptsName: [String]) {
        self.bashExecutor = bashExecutor
        self.scriptsName = scriptsName
        self.writeScriptToDisk(scriptsFiles: scriptsName)
    }
    
    /**
        Write file to a specific Disk URL
     
        - Parameter file: Script File Name required to be written on disk
        - Parameter destinationURL: as the name is saying
        */
    fileprivate func write(file: String, at destinationURL: URL) {
        
        let directoryPath = destinationURL.appendingPathComponent(scriptingFolderPath).relativePath
        let scriptURL = URL(fileURLWithPath: directoryPath, isDirectory: true)
        if !directoryExistsAtPath(directoryPath) {
            guard let _ = try? FileManager.default.createDirectory(at: scriptURL, withIntermediateDirectories: true) else {
                print("directory should be created and permissions allowed")
                return
            }
        }
        
        let components = file.contains(".") ? file.components(separatedBy: ".") : []
        let fileExtension = components.last
        let fileName = components.first
        
        guard  components.count > 0,
            let ext = fileExtension,
            let fName = fileName,
            let localScriptPath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
                print("File \(fileName ?? "") does not exist")
                return
        }
        
        let finalFileURL = scriptURL.appendingPathComponent("\(fName).\(ext)").relativePath
        guard let _ = try? FileManager.default.createFile(atPath: finalFileURL, contents: Data(contentsOf: URL(fileURLWithPath: localScriptPath)), attributes: nil) else {
            print("File has not been created at \(finalFileURL)")
            return
        }
    }
}

extension ScriptsHandler: ExecutingProtocol {
      /**
       Execute the bash script and return the string output
    
       - Parameter commandName: script name to fetch
       - Parameter arguments: parameters to pass to the command (e.g sh scriptLink Arg1 Arg2 will be [scriptLink, Arg1,Arg2]
       - Parameter completion: completion block with the result from the script called
       */
    func execute(commandName: String, arguments: [String], completion: @escaping ExecutingCompletionBlock) {
        bashExecutor.execute(commandName: commandName, arguments: arguments) { (result) in
            completion(result)
        }
    }
}

extension ScriptsHandler: ScriptingProtocol {
    
    /**
     Detect if the Script Directory is already existing or not
        */
    func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    /**
     Write a bunch of script files on Library folder
     - Parameter scriptsFiles: list of files required to be saved on disk
     */
    func writeScriptToDisk(scriptsFiles: [String]) {
        
        guard let locationURL = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first else {
            return
        }
        
        scriptsFiles.forEach { (file) in
            self.write(file: file, at: locationURL)
        }
    }
    
    /**
     Return the path of a script by name
     - Parameter scriptName: script name to fetch
     */
    func scriptDiskFilePath(scriptName: String) -> String {
        
        guard let scriptFileURL = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first else {
            return ""
        }
        
        return "\(scriptFileURL)\(scriptingFolderPath)\(scriptName)".replacingOccurrences(of: "file://", with: "")
    }
    
    // MARK: - Unused (Sandbox Specific)
    /**
       (Unused)
       If app require to be on Sandbox Mode. It is asking to the user to select a folder to write the script files
       */
      func askPermissionsForUser() {
          
          guard let directoryURL = try? FileManager.default.url(for: searchPathDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
              return
          }
          
          let openPanel = NSOpenPanel()
          openPanel.directoryURL = directoryURL
          openPanel.canChooseDirectories = true
          openPanel.canChooseFiles = false
          openPanel.prompt = "Select Script Folder"
          openPanel.message = "Please select the User > Library > Application Scripts > com.iconfactory.Scriptinator folder"
          openPanel.begin(completionHandler: { result in
              
              if result == NSApplication.ModalResponse.OK {
                  
                  let selectedURL = openPanel.url
                  
                  if selectedURL == directoryURL {
                      
                      self.scriptsName.forEach { (script) in
                          
                          guard let destinationURL = selectedURL?.appendingPathComponent(script),
                              let sourceURL = Bundle.main.url(forResource: script.components(separatedBy: ".").first, withExtension: script.components(separatedBy: ".").last) else {
                                  return
                          }
                          
                          let fileManager = FileManager.default
                          
                          do {
                              try fileManager.copyItem(at: sourceURL, to: destinationURL)
                          } catch let error {
                              print("\(#function) error = \(error)")
                              if (error as NSError?)?.code == NSFileWriteFileExistsError {
                                  do {
                                      try fileManager.removeItem(at: destinationURL)
                                      print("Existing file deleted.")
                                  } catch {
                                      print("Failed to delete existing file:\n\((error as NSError).description)")
                                  }
                                  do {
                                      try fileManager.copyItem(at: sourceURL, to: destinationURL)
                                      print("Existing file copied.")
                                  } catch {
                                      print("Failed to delete not copied:\n\((error as NSError).description)")
                                  }
                              } else {
                                  // the item couldn't be copied, try again
                                  self.askPermissionsForUser()
                              }
                          }
                      }
                  } else {
                      // try again because the user changed the folder path
                      self.askPermissionsForUser()
                  }
              }
          })
      }
}

