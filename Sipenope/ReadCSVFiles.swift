//
//  ReadCSVFiles.swift
//  Sipenope
//
//  Created by Esther Medina on 2/2/17.
//  Copyright © 2017 Esther Medina. All rights reserved.
//

import Foundation
import UIKit


class ReadCSVFiles {
    
    
    class func debug(string:String){
        
        print("CSVScanner: \(string)")
    }
    
    class func runFunctionOnRowsFromFile(theColumnNames:Array<String>, withFileName theFileName:String, withFunction theFunction:(Dictionary<String, String>)->()) {
        
        if let strBundle = Bundle.main.path(forResource: theFileName, ofType: "csv") {
            
            var encodingError:NSError? = nil
            
            
            
            //if let fileObject = NSString(contentsOfFile: strBundle, encoding: NSUTF8StringEncoding, error: &encodingError){
            do{
                
                 let fileObject = try NSString(contentsOfFile: strBundle, encoding: String.Encoding.utf8.rawValue)
                 if fileObject != nil {
                    
                    var fileObjectCleaned = fileObject.replacingOccurrences(of: "\r", with: "\n")
                    
                    fileObjectCleaned = fileObjectCleaned.replacingOccurrences(of: "\n\n", with: "\n")
                    
                    let objectArray = fileObjectCleaned.components(separatedBy: "\n")
                    
                    for anObjectRow in objectArray {
                        
                        let objectColumns = anObjectRow.components(separatedBy: ",")  //componentsSeparatedByString(",")
                        
                        if objectColumns.count == theColumnNames.count {
                        
                            var aDictionaryEntry = Dictionary<String, String>()
                            
                            var columnIndex = 0
                            
                            for anObjectColumn in objectColumns {
                                
                                aDictionaryEntry[theColumnNames[columnIndex]] = anObjectColumn.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.caseInsensitive, range: nil)
                                
                                columnIndex += 1
                            }
                            
                            if aDictionaryEntry.count>1{
                                theFunction(aDictionaryEntry)
                            }else{
                                
                                ReadCSVFiles.debug(string: "No data extracted from row: \(anObjectRow) -> \(objectColumns)")
                            }
                        }
                    }
                }else{
                    ReadCSVFiles.debug(string: "Unable to load csv file from path: \(strBundle)")
                    
                    if let errorString = encodingError?.description {
                        
                        ReadCSVFiles.debug(string: "Received encoding error: \(errorString)")
                    }
                }
            } catch is Error {
                ReadCSVFiles.debug(string: "Unable to load csv file from path: \(strBundle)")
            }
        }else{
            ReadCSVFiles.debug(string: "Unable to get path to csv file: \(theFileName).csv")
        }
    }
}
