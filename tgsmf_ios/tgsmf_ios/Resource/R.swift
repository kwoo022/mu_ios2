//
//  R.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/19.
//

import UIKit
import SwiftUI

public class R {
    static let bundle = Bundle(for: R.self)
   
}

// 이미지 asset
public extension R {
    enum Image { }
}

public extension R.Image {
//    static var sm_swift: UIImage { .load(name: "sm_swift") }
//    static var image02: UIImage { .load(name: "image_02") }
//    static var image03: UIImage { .load(name: "image_03") }
//
//    static var splash_bg1: UIImage { .load(name: "splash_bg1") }
//    static var splash_logo1: UIImage { .load(name: "splash_logo1") }
//
//    static var logo2: UIImage { .load(name: "logo2") }
//    static var checkbox: UIImage { .load(name: "checkbox") }
//    static var checkbox_on: UIImage { .load(name: "checkbox_on") }
//
//    static var alarm1_ic1: UIImage { .load(name: "alarm1_ic1") }
//    static var alarm1on_ic1: UIImage { .load(name: "alarm1on_ic1") }
//    static var foot1_on: UIImage { .load(name: "foot1_on") }
//    static var foot1: UIImage { .load(name: "foot1") }
//    static var foot2_on: UIImage { .load(name: "foot2_on") }
//    static var foot2: UIImage { .load(name: "foot2") }
//    static var foot3_on: UIImage { .load(name: "foot3_on") }
//    static var foot3: UIImage { .load(name: "foot3") }
//    static var foot4_on: UIImage { .load(name: "foot4_on") }
//    static var foot4: UIImage { .load(name: "foot4") }
//    static var head_close_ic1: UIImage { .load(name: "head_close_ic1") }
//    static var head_prev_ic1: UIImage { .load(name: "head_prev_ic1") }
//    static var menu_ic1: UIImage { .load(name: "menu_ic1") }
//
//    static var gnb_close1: UIImage { .load(name: "gnb_close1") }
//    static var gnb_d1_ic1: UIImage { .load(name: "gnb_d1_ic1") }
//    static var gnb_d1on_ic1: UIImage { .load(name: "gnb_d1on_ic1") }
//    static var gnb_d2_ic1: UIImage { .load(name: "gnb_d2_ic1") }
//    static var gnb_d2on_ic1: UIImage { .load(name: "gnb_d2on_ic1") }
//    static var gnb_d3_ic1: UIImage { .load(name: "gnb_d3_ic1") }
//    static var gnb_d3on_ic1: UIImage { .load(name: "gnb_d3on_ic1") }
    

    static var alarm_ic1: UIImage { .load(name: "alarm_ic1") }
    static var alarm1_ic1: UIImage { .load(name: "alarm1_ic1") }
    static var alarm1on_ic1: UIImage { .load(name: "alarm1on_ic1") }
    static var alarm2_ic1: UIImage { .load(name: "alarm2_ic1") }
    static var alarm2on_ic1: UIImage { .load(name: "alarm2on_ic1") }
    static var checkbox_on: UIImage { .load(name: "checkbox_on") }
    static var checkbox: UIImage { .load(name: "checkbox") }
    static var foot1_on: UIImage { .load(name: "foot1_on") }
    static var foot1: UIImage { .load(name: "foot1") }
    static var foot2_on: UIImage { .load(name: "foot2_on") }
    static var foot2: UIImage { .load(name: "foot2") }
    static var foot3_on: UIImage { .load(name: "foot3_on") }
    static var foot3: UIImage { .load(name: "foot3") }
    static var foot4_on: UIImage { .load(name: "foot4_on") }
    static var foot4: UIImage { .load(name: "foot4") }
    static var gnb_close1: UIImage { .load(name: "gnb_close1") }
    static var gnb_d1_ic1: UIImage { .load(name: "gnb_d1_ic1") }
    static var gnb_d1on_ic1: UIImage { .load(name: "gnb_d1on_ic1") }
    static var gnb_d2_ic1: UIImage { .load(name: "gnb_d2_ic1") }
    static var gnb_d2on_ic1: UIImage { .load(name: "gnb_d2on_ic1") }
    static var gnb_d3_ic1: UIImage { .load(name: "gnb_d3_ic1") }
    static var gnb_d3on_ic1: UIImage { .load(name: "gnb_d3on_ic1") }
    
    static var head_close_ic1: UIImage { .load(name: "head_close_ic1") }
    static var head_prev_ic1: UIImage { .load(name: "head_prev_ic1") }
    static var ic_camera1: UIImage { .load(name: "ic_camera1") }
    static var ic_checkbox1: UIImage { .load(name: "ic_checkbox1") }
    static var ic_checkbox1on: UIImage { .load(name: "ic_checkbox1on") }
    static var ic_close1: UIImage { .load(name: "ic_close1") }
    static var ic_delete1: UIImage { .load(name: "ic_delete1") }
    static var ic_lens1: UIImage { .load(name: "ic_lens1") }
    
    static var ic_loading: UIImage { .load(name: "ic_loading") }
    static var nhu_loading: UIImage { .load(name: "loading") }
    
    static var ic_msg1: UIImage { .load(name: "ic_msg1") }
    static var ic_no1: UIImage { .load(name: "ic_no1") }
    static var ic_ok1: UIImage { .load(name: "ic_ok1") }
    static var ic_picture1: UIImage { .load(name: "ic_picture1") }
    static var ic_time1: UIImage { .load(name: "ic_time1") }
    static var longin_logo: UIImage { .load(name: "nhu_login_logo") }
    static var menu_ic1: UIImage { .load(name: "menu_ic1") }
    static var setting_ic1: UIImage { .load(name: "setting_ic1") }
    static var setting_ic2: UIImage { .load(name: "setting_ic2") }
    static var splash_bg: UIImage { .load(name: "nhu_splash2") }
    static var splash_logo: UIImage { .load(name: "splash_logo") }
    static var toggle1_ic1: UIImage { .load(name: "toggle1_ic1") }
    static var toggle1on_ic1: UIImage { .load(name: "toggle1on_ic1") }
    
    
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: R.bundle, compatibleWith: nil) else {
            assert(false, "\(name) 이미지 로드 실패")
            return UIImage()
        }
        return image
    }
}

//color Asset
public extension R {
    enum Color { }
}

public extension R.Color {
    static var color_login_button_bg: Color { UIColor.load(name: "color_login_button_bg") }
    static var color_login_button_text: Color { UIColor.load(name: "color_login_button_text") }
    static var color_login_content_text: Color { UIColor.load(name: "color_login_content_text") }
    static var color_login_input_bg: Color { UIColor.load(name: "color_login_input_bg") }
    static var color_login_input_border: Color { UIColor.load(name: "color_login_input_border") }
    static var color_login_input_text: Color { UIColor.load(name: "color_login_input_text") }
    static var color_login_toggle_bg: Color { UIColor.load(name: "color_login_toggle_bg")}
    static var color_login_line: Color { UIColor.load(name: "color_login_line") }
    static var color_titlebar_text: Color { UIColor.load(name: "color_titlebar_text") }
    
    static var color_sidemenu_top_bg: Color { UIColor.load(name: "color_sidemenu_top_bg") }
    static var color_sidemenu_title_text: Color { UIColor.load(name: "color_sidemenu_title_text") }
    static var color_sidemenu_title_on_text: Color { UIColor.load(name: "color_sidemenu_title_on_text") }
    static var color_sidemenu_sub_text: Color { UIColor.load(name: "color_sidemenu_sub_text") }
    static var color_sidemenu_sub_on_text: Color { UIColor.load(name: "color_sidemenu_sub_on_text") }
    static var color_sidemenu_sub_bg: Color { UIColor.load(name: "color_sidemenu_sub_bg") }
    
    
    static var peach: Color { UIColor.load(name: "peach") }
    static var sampleBlue: Color { UIColor.load(name: "sample_blue") }
    static var sampleGreen: Color { UIColor.load(name: "sample_green") }
    static var sampleYellow: Color { UIColor.load(name: "sample_yellow") }

}

extension UIColor {
    static func load(name: String) -> Color {
        
        guard let uiColor = UIColor(named: name, in: R.bundle, compatibleWith: nil) else {
            assert(false, "\(name) 컬러 로드 실패")
            return Color(UIColor())
        }
        return Color(red: Double(uiColor.cgColor.components![0]), green: Double(uiColor.cgColor.components![1]), blue: Double(uiColor.cgColor.components![2]))
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {

    static var primaryColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor(red: 0, green: 255, blue: 255, alpha: 1) : UIColor(red: 200, green: 200, blue: 200, alpha: 1) })
    }

    
    static var whiteAndBlackColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.white : UIColor.black })
    }
    
    static var whiteAndBlackBgColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.black : UIColor.white })
    }
    
    static var whiteAndGrayBgColor: Color {
        Color(UIColor { $0.userInterfaceStyle == .dark ? UIColor.init(Color.init(hex: "#666")): UIColor.white })
    }

}

public extension R {
    enum Font {    }
    
    // 사용자폰트 최초 로딩
    static func registerCustomFont() {
        var fontName:[String] = ["GmarketSansBold", "GmarketSansMedium", "GmarketSansLight", "NotoSansCJKkr-Bold", "NotoSansCJKkr-Medium", "NotoSansCJKkr-Regular", "NotoSansCJKkr-Light"]
        
        for name in fontName {
            guard let url = R.bundle.url(forResource: name, withExtension: "otf"),
              CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
              else {
                TGSULog.log("failed to regist \(name) font")
                continue
            }
        }
    }
    
}
public extension R.Font {
    static func font_gmarket_b(size: CGFloat) -> Font { Font.load(name: "GmarketSansBold", size: size) }
    static func font_gmarket_m(size: CGFloat) -> Font { Font.load(name: "GmarketSansMedium", size: size) }
    static func font_gmarket_l(size: CGFloat) -> Font { Font.load(name: "GmarketSansLight", size: size) }
    
    static func font_noto_b(size: CGFloat) -> Font { Font.load(name: "NotoSansCJKkr-Bold", size: size) }
    static func font_noto_m(size: CGFloat) -> Font { Font.load(name: "NotoSansCJKkr-Medium", size: size) }
    static func font_noto_r(size: CGFloat) -> Font { Font.load(name: "NotoSansCJKkr-Regular", size: size) }
    static func font_noto_l(size: CGFloat) -> Font { Font.load(name: "NotoSansCJKkr-Light", size: size) }
}

extension Font {
    static func load(name: String, size : CGFloat) -> Font {
        //guard let url = Bundle(for: R.self).url(forResource: name, withExtension: "otf"),
//        guard let url = R.bundle.url(forResource: name, withExtension: "otf"),
//          CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
//          else {
//            TGSULog.log("failed to regist \(name) font")
//            return .system(size: size)
//        }
        
        return .custom(name, size: size)
    }
    
    
}

