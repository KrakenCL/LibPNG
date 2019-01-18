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

import Foundation
import CPNG

public typealias Pixel = UInt8

public enum LibPNGError: Error {
    case writeError
    case readError
    case incorrectDataSize
}

public enum ColorType: Int32, RawRepresentable {
    
    case greyscale
    case greyscaleAlpha
    case rgb
    case rgba
    
    public var rawValue: Int32 {
        switch self {
        case .greyscale:
            return PNG_COLOR_TYPE_GRAY
        case .greyscaleAlpha:
            return PNG_COLOR_TYPE_GRAY_ALPHA
        case .rgb:
            return PNG_COLOR_TYPE_RGB
        case .rgba:
            return PNG_COLOR_TYPE_RGBA
        }
    }
    
    public var components: Int {
        switch self {
        case .greyscale:
            return 1
        case .greyscaleAlpha:
            return 2
        case .rgb:
            return 3
        case .rgba:
            return 4
        }
    }
}

public class Image {
    
    var width: Int
    var height: Int
    var colorType: ColorType
    var bitDepth: Int
    var pixels: [Pixel]
    
    public init(width: Int, height: Int, colorType: ColorType, bitDepth: Int, pixels: [Pixel]) throws {
        
        guard pixels.count == height * width * colorType.components else {
            throw LibPNGError.incorrectDataSize
        }
        
        self.width = width
        self.height = height
        self.colorType = colorType
        self.bitDepth = bitDepth
        self.pixels = pixels
        
    }
}

extension Image {
    public func write(to url: URL) throws {
        
        let fp = fopen(url.relativeString, "wb")
        let pngPtr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nil, nil, nil)
        guard let ptr = pngPtr else {
            throw LibPNGError.writeError
        }
        
        let info_ptr = png_create_info_struct(ptr)
        png_init_io(ptr, fp)
        png_set_IHDR(ptr,
                     info_ptr,
                     png_uint_32(width),
                     png_uint_32(height),
                     Int32(bitDepth),
                     colorType.rawValue,
                     PNG_INTERLACE_NONE,
                     PNG_COMPRESSION_TYPE_DEFAULT,
                     PNG_FILTER_TYPE_DEFAULT)
        
        png_write_info(ptr, info_ptr)

        for rowNumber in 0..<height {
            let rowWidth = width * colorType.components
            let startPixelIndex = rowNumber * rowWidth
            let endPixelIndex = rowNumber * rowWidth + rowWidth
            let row = pixels[startPixelIndex..<endPixelIndex]
            png_write_row(ptr, Array(row))
        }
        png_write_end(ptr, nil);
        fclose(fp)
    }
}
