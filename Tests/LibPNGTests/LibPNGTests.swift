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

    static var allTests = [
        ("testWriteGreyscaleImage", testWriteGreyscaleImage),
    ]
}
