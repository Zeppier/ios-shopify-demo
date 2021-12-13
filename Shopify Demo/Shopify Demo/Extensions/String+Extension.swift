//
//  String+Extension.swift


import Foundation
import UIKit
import MobileCoreServices


extension UIFont {
    func calculateHeight(text: String, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self],
                                        context: nil)
        return boundingBox.height
    }
}

extension String {
    
    var encodeURL:String{
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func isValidPassword() -> Bool {
        
        let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[@#$%^&*]).{6,}")
        //let emailRegEx = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&? ]).*$"
        let test = NSPredicate(format:"SELF MATCHES %@", passwordreg)
        return test.evaluate(with: self)
    }
    func isUppercaseExists() -> Bool {
        
        let passwordreg =  (".*[A-Z]+.*")
        let test = NSPredicate(format:"SELF MATCHES %@", passwordreg)
        return test.evaluate(with: self)
    }
    func isLowercaseExists() -> Bool {
        
        let passwordreg =  (".*[a-z]+.*")
        //let emailRegEx = "^.*(?=.{6,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&? ]).*$"
        let test = NSPredicate(format:"SELF MATCHES %@", passwordreg)
        return test.evaluate(with: self)
    }
    func isDigitExists() -> Bool {
        
        let passwordreg =  (".*[0-9]+.*")
        let test = NSPredicate(format:"SELF MATCHES %@", passwordreg)
        return test.evaluate(with: self)
    }
    
    func isOfficalEmail() -> Bool {
        
        let emailRegEx = ["@gmail.com", "@hotmail.com", "@yahoo.com", "@outlook.com"]
        var isOffical = true
        for item in emailRegEx{
            if self.contains(item.lowercased()){
                isOffical = false
            }
        }
        return isOffical
    }
    
    public var numericString: String {
        let characterSet = CharacterSet(charactersIn: "0123456789.").inverted
        return components(separatedBy: characterSet)
            .joined()
    }
    var length: Int {
        return count
    }
    
    private var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return fileURL.pathExtension
    }
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
    var mimeType: String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    subscript (i: Int) -> String? {
        if i < self.length{
            return self[i ..< i + 1]
        }
        return nil
    }
    
    func reverseDate() -> String {
        let date = self.split(separator: "-")
        if date.count == 3 {
            return "\(date[2])-\(date[1])-\(date[0])"
        } else {
            return ""
        }
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(fromIndex: Int, range: Int) -> String {
        var index = fromIndex
        if(index < 0) {
            index = fromIndex + length
        }
        return self[index ... (index + range - 1)]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    func nameInital() -> String{
        let comp = self.components(separatedBy: " ")
        let fist = comp[0].substring(toIndex: 1)
        if comp.count > 1{
            let last = comp[1].substring(toIndex: 1)
            return (fist + last)
        }
        return  (comp[0].substring(toIndex: 2))
    }
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    func ascii() -> UInt32 {
        return UnicodeScalar(self)!.value
    }
    
    func convertToDictionary() -> [String: Any]? {
         if let data = self.data(using: .utf8) {
             do {
                 return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
             } catch {
                 print(error.localizedDescription)
             }
         }
         return nil
     }
    func convertToDictionaryArray() -> [[String: Any]]? {
         if let data = self.data(using: .utf8) {
             do {
                 return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
             } catch {
                 print(error.localizedDescription)
             }
         }
         return nil
     }
    
    func attributedText(withString string: String, boldString: String, font: UIFont, fSize:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func isCompletelyEmpty() -> Bool {
        
        let msg = self.trimCharacterNLineSpace()
        return msg.isEmpty
    }
    
    func trimCharacterNLineSpace() -> String{
        
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func getCustomDateFromString(format:String) ->Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: self)
        
        return date ?? Date()
    }
    
    func getLocalDateTimeFormatFromUTCDateString() ->Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let ns = self.components(separatedBy: "+")[0].replacingOccurrences(of: "T", with: " ")
        let fs = ns.components(separatedBy: ".")[0]
        var dateObj:Date! = dateFormatter.date(from: fs)
        if(dateObj == nil){
            dateObj = Date()
        }
        
        let zoneCurrent = TimeZone.current
        let diff = zoneCurrent.secondsFromGMT()
        let localDate:Date! = dateObj.addingTimeInterval(TimeInterval(diff))
        
        return localDate
    }
    
    func getLocalDateTimeFormatFromServerDateString() ->Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let ns = self.components(separatedBy: "+")[0].replacingOccurrences(of: "T", with: " ")
        let fs = ns.components(separatedBy: ".")[0]
        var dateObj:Date! = dateFormatter.date(from: fs)
        if(dateObj == nil){
            dateObj = Date()
            return dateObj
        }else{
            let zoneCurrent = TimeZone.current
            let zoneDubai = TimeZone(identifier: "Asia/Dubai")
            let diff = (zoneCurrent.secondsFromGMT()) - (zoneDubai?.secondsFromGMT())!
            //let diff = zoneCurrent.secondsFromGMT()
            let localDate:Date! = dateObj.addingTimeInterval(TimeInterval(diff))
            return localDate
        }
    }
    
    func getLocalDateTimeFormatFromServerDateStringWithNoDiff() ->Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let ns = self.components(separatedBy: "+")[0].replacingOccurrences(of: "T", with: " ")
        let fs = ns.components(separatedBy: ".")[0]
        var dateObj:Date! = dateFormatter.date(from: fs)
        if(dateObj == nil){
            dateObj = Date()
        }

        return dateObj
    }
    
    func getDeliveryDateTime() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    
    func getOpenTimeFormat() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        var dateObj:Date! = dateFormatter.date(from: self.components(separatedBy: "+")[0].replacingOccurrences(of: "T", with: " "))
        if(dateObj == nil){
            dateObj = Date()
        }
        return dateObj
        
    }
    
    func getCloseTimeFormatFromSelectedDate(closeDate:Date, selectedDate:Date) -> Date{
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.locale = Locale(identifier: "en_US")
        dateFormatterTime.dateFormat = "hh:mm a"
        let closeTime = dateFormatterTime.string(from: closeDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: selectedDate) + " " + closeTime
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        var dateObj:Date! = dateFormatter.date(from: strDate)
        if(dateObj == nil){
            dateObj = selectedDate
        }
        return dateObj.addingTimeInterval(24*3600)
        
    }
    func getOpenTimeFormatFromSelectedDate(openDate:Date, selectedDate:Date) -> Date{
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.locale = Locale(identifier: "en_US")
        dateFormatterTime.dateFormat = "hh:mm a"
        let openTime = dateFormatterTime.string(from: openDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: selectedDate) + " " + openTime
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        var dateObj:Date! = dateFormatter.date(from: strDate)
        if(dateObj == nil){
            dateObj = Date()
        }
        return dateObj
        
    }
    
    func getAppToServerTimeFormat() -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let dateObj = dateFormatter.date(from: self) ?? Date()
    
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: dateObj)
    }
    func getTimeToDate() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm"
        let dateObj = dateFormatter.date(from: self) ?? Date()
        return dateObj
    }
    func getSlotDateTime() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    func getChatTimeFormat() -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self) ?? Date()
    }
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    var xmlEscaped: String {
        return replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "<", with: "&lt;")
    }
    var xmlUnEscaped: String {
        return replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
    }
}


