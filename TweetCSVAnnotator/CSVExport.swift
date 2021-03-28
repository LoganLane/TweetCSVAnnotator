//
//  CSVExport.swift
//  TweetCSVAnnotator
//
//  Created by Logan Lane on 3/22/21.
//

import Foundation
import CodableCSV
import UniformTypeIdentifiers
import MobileCoreServices

var output : Data?
var exportURL : [URL]?
var documentSave : [Data]?


func findDocuments() -> URL{
    let paths2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths2[0]
}

func exportCSV(){
    
        let encoder = CSVEncoder {
            $0.headers = ["tweet", "Type"]
            $0.nilStrategy = .empty
            $0.bufferingStrategy = .sequential
            $0.delimiters.row = "\r\n"
        }
        
        output = try? encoder.encode(TweetList, into: Data.self)
            print("It worked!", output! as NSData)
            let decode = String(decoding: output!, as: UTF8.self)
            print(decode)
        
        let exportu = findDocuments().appendingPathComponent("Export.csv")
        
        do{
            try decode.write(to: exportu, atomically: true, encoding: .utf8)
            print("This is exportu", exportu)
        }
        catch{
            print("Error exporting CSV")
        }
}



