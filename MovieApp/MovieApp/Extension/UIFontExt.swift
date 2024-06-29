//
//  UIFontExt.swift

//
//  Created by
//
//

import Foundation
import  UIKit

extension UIFont {
    
    class func families() {
        for family in UIFont.familyNames {
            print(family)
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
    }
    
    class func font_Poppins_Semibold(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_SemiBold.rawValue, size: size)!;
    }
    
    class func font_Poppins_Regular(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_Regular.rawValue, size: size)!;
    }
    
    class func font_Poppins_Medium(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_Medium.rawValue, size: size)!;
    }
    
    class func font_Poppins_BOLD(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_Bold.rawValue, size: size)!;
    }
    
    class func font_OpensSans_Regular(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_Regular.rawValue, size: size)!;
    }
    
    class func font_Poppins_Light(size : CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.Poppins_Light.rawValue, size: size)!;
    }

}


struct Resources {

    struct Fonts {
        //struct is extended in Fonts
    }
}

extension Resources.Fonts {

    enum Weight: String {
        case Poppins_Bold = "Poppins-Bold"
        case Poppins_SemiBold = "Poppins-SemiBold"
        case Poppins_Medium = "Poppins-Medium"
        case Poppins_Light = "Poppins-Light"
        case Poppins_Regular = "Poppins-Regular"
        case Poppins_Black = "Poppins-Black"
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

   
    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage": // Regular
            fontName = Resources.Fonts.Weight.Poppins_Regular.rawValue
        case "CTFontMediumUsage": // Meduym
            fontName = Resources.Fonts.Weight.Poppins_Medium.rawValue
        case "CTFontLightUsage": // Light
            fontName = Resources.Fonts.Weight.Poppins_Light.rawValue
        case "CTFontSemiboldUsage","CTFontDemiUsage": // SemiBold
//                        print("=======>>>>>>> ",fontAttribute)
            fontName = Resources.Fonts.Weight.Poppins_SemiBold.rawValue
        case "CTFontBoldUsage":
            fontName = Resources.Fonts.Weight.Poppins_Bold.rawValue // Bold
        case "CTFontEmphasizedUsage","CTFontHeavyUsage", "CTFontBlackUsage": // Bold
            fontName = Resources.Fonts.Weight.Poppins_Bold.rawValue
            
        default:
            fontName = fontAttribute
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideDefaultTypography() {
        guard self == UIFont.self else { return }

//        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
//            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
//            method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
//        }
//
//        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
//            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
//            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
//        }
//
//        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
//            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
//            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
//        }
//
//        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
//            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
//            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
//        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
