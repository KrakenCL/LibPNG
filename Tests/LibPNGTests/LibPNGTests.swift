/* Copyright 2018 The KrakenCL Authors. All Rights Reserved.
 
 Created by Volodymyr Pavliukevych
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import XCTest
@testable import LibPNG

final class LibPNGTests: XCTestCase {
    func testWriteGreyscaleImage() {
        var pixels = [UInt8]()
        for r in 0..<200 {
            for c in 0..<300 {
                let value = UInt8((r+c)/2)
                pixels.append(value)
            }
        }
        
        let image = try! Image(width: 300, height: 200, colorType: ColorType.greyscale, bitDepth: 8, pixels: pixels)
        try! image.write(to: URL(string: "/tmp/greyscaleImage.png")!)
    }

    func testWriteDoubleImage() {
        var pixels = [Double]()
        
        for _ in 0..<200 {
            for _ in 0..<300 {
                pixels.append(drand48())
            }
        }
        
        let image = try! Image(width: 300, height: 200, colorType: .greyscale, pixelValues: pixels)
        try! image.write(to: URL(string: "/tmp/greyscaleDoubleNormalisaedImage.png")!)
    }

    func testWriteDoubleColoredImage() {
        var pixels = [Double]()
        
        for r in 0..<200 {
            for _ in 0..<300  {
                if r % 2 == 0 {
                    pixels.append(0.25)
                    pixels.append(0.75)
                    pixels.append(0.25)
                } else {
                    pixels.append(drand48())
                    pixels.append(drand48())
                    pixels.append(drand48())
                }
            }
        }
        
        let image = try! Image(width: 300, height: 200, colorType: .rgb, pixelValues: pixels)
        try! image.write(to: URL(string: "/tmp/greyscaleDoubleColoredNormalisaedImage.png")!)
    }
    
    func testGetImageData() {
        var pixels = [Double]()
        
        for r in 0..<200 {
            for _ in 0..<300  {
                if r % 2 == 0 {
                    pixels.append(0.25)
                    pixels.append(0.75)
                    pixels.append(0.25)
                } else {
                    pixels.append(drand48())
                    pixels.append(drand48())
                    pixels.append(drand48())
                }
            }
        }
        
        let image = try! Image(width: 300, height: 200, colorType: .rgb, pixelValues: pixels)
        if let data = image.data {
            try! data.write(to: URL(string: "file:///tmp/imageData.png")!)
        }
        XCTAssert(image.data != nil)
    }
    static var allTests = [
        ("testGetImageData", testGetImageData),
        ("testWriteDoubleColoredImage", testWriteDoubleColoredImage),
        ("testWriteDoubleImage", testWriteDoubleImage),
        ("testWriteGreyscaleImage", testWriteGreyscaleImage),
    ]
}


