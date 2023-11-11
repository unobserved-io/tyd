//
//  ColorHex.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/11/23.
//

import SwiftUI

public extension Color {
    init?(hex: String?) {
        guard let hexString = hex else { return nil }
        
        let r, g, b, a: CGFloat
        let cleanedHex = hexString.cleanedHex
        
        if cleanedHex.count == 8 {
            let scanner = Scanner(string: cleanedHex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat((hexNumber & 0x000000ff) >> 0) / 255
                
                self.init(.sRGB, red: Double(r), green: Double(g), blue: Double(b), opacity: Double(a))
                return
            } else {
                return nil
            }
        } else if cleanedHex.count == 6 {
            let scanner = Scanner(string: cleanedHex)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                
                self.init(.sRGB, red: Double(r), green: Double(g), blue: Double(b))
                return
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var hex: String? {
        let colorString = "\(self)"
        if let colorHex = colorString.isHex() {
            return colorHex.cleanedHex
        } else {
            var colorArray: [String] = colorString.components(separatedBy: " ")
            if colorArray.count < 3 { colorArray = colorString.components(separatedBy: ", ") }
            if colorArray.count < 3 { colorArray = colorString.components(separatedBy: ",") }
            if colorArray.count < 3 { colorArray = colorString.components(separatedBy: " - ") }
            if colorArray.count < 3 { colorArray = colorString.components(separatedBy: "-") }
            
            colorArray = colorArray.filter { colorElement in
                (!colorElement.isEmpty) && (String(colorElement).replacingOccurrences(of: ".", with: "").rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil)
            }
            
            if colorArray.count == 3 { // count == 3 no alpha set
                var r = Float(colorArray[0]) ?? 1
                var g = Float(colorArray[1]) ?? 1
                var b = Float(colorArray[2]) ?? 1
                
                if r < 0.0 { r = 0.0 }
                if g < 0.0 { g = 0.0 }
                if b < 0.0 { b = 0.0 }
                
                if r > 1.0 { r = 1.0 }
                if g > 1.0 { g = 1.0 }
                if b > 1.0 { b = 1.0 }
                
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)).cleanedHex
            } else if colorArray.count == 4 { // count == 4 alpha is set
                var r = Float(colorArray[0]) ?? 1
                var g = Float(colorArray[1]) ?? 1
                var b = Float(colorArray[2]) ?? 1
                var a = Float(colorArray[3]) ?? 1
                
                if r < 0.0 { r = 0.0 }
                if g < 0.0 { g = 0.0 }
                if b < 0.0 { b = 0.0 }
                if a < 0.0 { a = 0.0 }
                
                if r > 1.0 { r = 1.0 }
                if g > 1.0 { g = 1.0 }
                if b > 1.0 { b = 1.0 }
                if a > 1.0 { a = 1.0 }
                
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)).cleanedHex
            } else {
                return nil
            }
        }
    }
}

public extension String {
    /**
     This function will check if the String is a hex.
     
     - warning: This doesn't validate wheter or not this is an actual valid color.
     */
    func isHex() -> Bool {
        if ((self.cleanedHex.count == 6) || (self.cleanedHex.count == 8)) && (self.replacingOccurrences(of: "#", with: "").isAlphanumeric()) {
            return true
        } else {
            return false
        }
    }
    
    /**
     This function will check if the String is a hex and return an alphanumeric string of the hex back.
     This is the hex without special characters.
     */
    func isHex() -> String? {
        if self.isHex() {
            return self.cleanedHex
        } else {
            return nil
        }
    }
    
    /**
     This variable will return you a cleaned **hex** of the given `String`.
     
     - returns: An alphanumeric `String`.
     
     - note: This will remove the "#" from the string.
     */
    var cleanedHex: String {
        return self.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: CharacterSet.alphanumerics.inverted).cleanedString.uppercased()
    }
}

extension String {
    func isAlphanumeric() -> Bool {
        return ((!self.isEmpty) && (self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil))
    }
    
    var cleanedString: String {
        var cleanedString = self
        
        cleanedString = cleanedString.replacingOccurrences(of: "á", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "ä", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "â", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "à", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "æ", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "ã", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "å", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "ā", with: "a")
        cleanedString = cleanedString.replacingOccurrences(of: "ç", with: "c")
        cleanedString = cleanedString.replacingOccurrences(of: "é", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "ë", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "ê", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "è", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "ę", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "ė", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "ē", with: "e")
        cleanedString = cleanedString.replacingOccurrences(of: "í", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "ï", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "ì", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "î", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "į", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "ī", with: "i")
        cleanedString = cleanedString.replacingOccurrences(of: "j́", with: "j")
        cleanedString = cleanedString.replacingOccurrences(of: "ñ", with: "n")
        cleanedString = cleanedString.replacingOccurrences(of: "ń", with: "n")
        cleanedString = cleanedString.replacingOccurrences(of: "ó", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ö", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ô", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ò", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "õ", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "œ", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ø", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ō", with: "o")
        cleanedString = cleanedString.replacingOccurrences(of: "ú", with: "u")
        cleanedString = cleanedString.replacingOccurrences(of: "ü", with: "u")
        cleanedString = cleanedString.replacingOccurrences(of: "û", with: "u")
        cleanedString = cleanedString.replacingOccurrences(of: "ù", with: "u")
        cleanedString = cleanedString.replacingOccurrences(of: "ū", with: "u")
        
        return cleanedString
    }
}
