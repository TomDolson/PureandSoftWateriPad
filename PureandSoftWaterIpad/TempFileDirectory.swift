//
//  TempFileDirectory.swift
//  WaterWorks
//
//  Created by Tom Dolson on 6/3/20.
//  Copyright © 2020 Tom Dolson. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


struct GetTempFile : View {
    
//    func getDocumentsDirectory() -> URL {
//        // find all possible documents directories for this user
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//        // just send back the first one, which ought to be the only one
//        return paths[0]
//    }
    
    
    var body: some View {
        VStack {
            Text("Create Text File")
                .onTapGesture {
                    let str = "Test Message"
                    
                    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(),
                    isDirectory: true)
                    
                    let url = temporaryDirectoryURL.appendingPathComponent("message.txt")
                    
                    do {
                        try str.write(to: url, atomically: true, encoding: .utf8)
                        
                        let input = try String(contentsOf: url)
                        print(input)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
            }
        }
    }
}



struct GetTempFile_Previews: PreviewProvider {
    static var previews: some View {
        GetTempFile()
    }
}
