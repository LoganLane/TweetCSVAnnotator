//
//  CSVParser.swift
//  TweetCSVAnnotator
//
//  Created by Logan Lane on 2/28/21.
//

import Foundation
import CodableCSV



func parseCSV(){
    queue.async {
        timingSemaphore.wait()
        let decode = CSVDecoder {
            $0.headerStrategy = .firstLine
            $0.nilStrategy = .empty
            $0.bufferingStrategy = .sequential
            $0.delimiters.row = "\r\n"
        }
        let parsedData = CSVData
        let result: [Tweet] = try! decode.decode([Tweet].self, from: decode2!)
        
        print(result)
       
        TweetList = result
        DispatchQueue.main.async {
            NotificationCenter
                .default
                .post(Notification(name: Notification.Name(rawValue: "dataParsed")))
        }
        
        print(TweetList.count)
        print(TweetList[5])
    }
    
}
