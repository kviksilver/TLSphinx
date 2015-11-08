//
//  TLSphinxTests.swift
//  TLSphinxTests
//
//  Created by Bruno Berisso on 5/29/15.
//  Copyright (c) 2015 Bruno Berisso. All rights reserved.
//

import UIKit
import XCTest
import TLSphinx

extension XCTestCase {
    
    func getModelPath() -> NSURL? {
        if let path = NSBundle(forClass: self.dynamicType).pathForResource("en-us", ofType: nil) {
            return NSURL(string:path)
        }
        return nil
    }
    
    func modelPathWithExtension(pathComponent: String) -> String? {
        if let modelPath = getModelPath() {
            return modelPath.URLByAppendingPathComponent(pathComponent).path
        } else {
            return nil
        }
    }
}


class BasicTests: XCTestCase {
    
    func testConfig() {
        guard let hmm = modelPathWithExtension("en-us"),
            let lm = modelPathWithExtension("en-us.lm.dmp"),
            let dict = modelPathWithExtension("cmudict-en-us.dict") else {
                XCTFail("Can't access pocketsphinx model. Bundle root: \(NSBundle.mainBundle())")
                return
        }
        let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict))
        XCTAssert(config != nil, "Pass")
    }
    
    func testDecoder() {
        
        guard let hmm = modelPathWithExtension("en-us"),
            let lm = modelPathWithExtension("en-us.lm.dmp"),
            let dict = modelPathWithExtension("cmudict-en-us.dict"),
            let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict)) else {
                XCTFail("Can't access pocketsphinx model. Bundle root: \(NSBundle.mainBundle())")
                return
        }
        
        let decoder = Decoder(config:config)
        XCTAssert(decoder != nil, "Pass")
        
    }
    
    func testSpeechFromFile() {
        
        guard let hmm = modelPathWithExtension("en-us"),
            let lm = modelPathWithExtension("en-us.lm.dmp"),
            let dict = modelPathWithExtension("cmudict-en-us.dict"),
            let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict)),
            let decoder = Decoder(config:config) else {
                XCTFail("Can't access pocketsphinx model. Bundle root: \(NSBundle.mainBundle())")
                return
        }
        
        let audioFile = modelPathWithExtension("goforward.raw")
        let expectation = expectationWithDescription("Decode finish")
        
        decoder.decodeSpeechAtPath(audioFile!) {
            if let hyp = $0 {
                print("Text: \(hyp.text) - Score: \(hyp.score)")
                XCTAssert(hyp.text == "go forward ten meters", "Pass")
            } else {
                XCTFail("Fail to decode audio")
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(NSTimeIntervalSince1970, handler: { (_) -> Void in
            
        })
        
        
    }
}
