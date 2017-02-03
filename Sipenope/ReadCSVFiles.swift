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
    
    static let separatedBy = ";"
    
    //Type method
    class func debug(string:String){
        
        print("CSVScanner: \(string)")
    }
    
    //type method
    class func runFunctionOnRowsFromFile(theColumnNames:Array<String>, withFileName theFileName:String, withFunction theFunction:(Dictionary<String, String>)->()) {
        
        if let strBundle = Bundle.main.path(forResource: theFileName, ofType: "csv") {

            do{
                
                let fileObject = try NSString(contentsOfFile: strBundle, encoding: String.Encoding.macOSRoman.rawValue ) //String.Encoding.utf8.rawValue)

                var fileObjectCleaned = fileObject.replacingOccurrences(of: "\r", with: "\n")
                
                fileObjectCleaned = fileObjectCleaned.replacingOccurrences(of: "\n\n", with: "\n")
                
                let objectArray = fileObjectCleaned.components(separatedBy: "\n")
                
                for anObjectRow in objectArray {
                    
                    let objectColumns = anObjectRow.components(separatedBy: self.separatedBy)
                    
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

            } catch let error as NSError {
                ReadCSVFiles.debug(string: "Unable to load csv file. Error: \(error.debugDescription)")
                
            }
        }else{
            ReadCSVFiles.debug(string: "Unable to get path to csv file: \(theFileName).csv")
        }
    }
    
    
    
    class func loadCollectablesFromCSV() {
        //CSV
        let collectibleInfoDAO = DAOFactory.sharedInstance.collectibleInfoDAO
        
        ReadCSVFiles.runFunctionOnRowsFromFile(theColumnNames: ["Numero", "#", "Sujeto", "Equipo", "Seccion", "Edicion"], withFileName: "fileName", withFunction: {
            
            (aRow:Dictionary<String, String>) in
            
            collectibleInfoDAO?.setNewCollectibleInBackground(collectibleId: aRow["Numero"]!, collectibleName: aRow["Sujeto"]!, collectibleImage: UIImage(), collectibleCategory: aRow["Edicion"]!, collectibleInfo: String(describing: aRow), collectionId: "LigaSantander2016-17")
            
        })
        
        print("Carga realizada")

    }
    
}
