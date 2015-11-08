//
//  LiveDecode.swift
//  TLSphinx
//
//  Created by Bruno Berisso on 5/29/15.
//  Copyright (c) 2015 Bruno Berisso. All rights reserved.
//

import UIKit
import XCTest
import AVFoundation
import TLSphinx

class LiveDecode: XCTestCase {
    
    func testAVAudioRecorder() {
        
        guard let hmm = modelPathWithExtension("en-us"),
            let lm = modelPathWithExtension("en-us.lm.dmp"),
            let dict = modelPathWithExtension("cmudict-en-us.dict"),
            let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict)) else {
                XCTFail("Can't access pocketsphinx model. Bundle root: \(NSBundle.mainBundle())")
                return
        }
        
        config.showDebugInfo = false
        
        if let decoder = Decoder(config:config) {
            decoder.startDecodingSpeech { (hyp) -> () in
                print("Utterance: \(hyp)")
            }
            
            let expectation = expectationWithDescription("")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))) , dispatch_get_main_queue(), { () -> Void in
                decoder.stopDecodingSpeech()
                expectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(NSTimeIntervalSince1970, handler: { (_) -> Void in
                
            })
        }
        
        
        
    }
}

