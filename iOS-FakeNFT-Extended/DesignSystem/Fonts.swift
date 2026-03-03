import SwiftUI

extension Font {
    
    static func appSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default
    ) -> Font {
        .system(size: size, weight: weight, design: design)
    }
    
    // MARK: - Custom App Fonts
    
    static let medium10 = Font.appSystem(
        size: 10,
        weight: .medium
    )
    
    static let bold22 = Font.appSystem(
        size: 22,
        weight: .bold
    )
    
    static let bold17 = Font.appSystem(
        size: 17,
        weight: .bold
    )
    
    static let regular13 = Font.appSystem(
        size: 13,
        weight: .regular
    )
    
    static let regular15 = Font.appSystem(
        size: 15,
        weight: .regular
    )
    
    static let regular17 = Font.appSystem(
        size: 17,
        weight: .regular
    )
    
    static let bold34 = Font.appSystem(
        size: 34,
        weight: .bold
    )
    
    static let bold32 = Font.appSystem(
        size: 32,
        weight: .bold
    )
}
