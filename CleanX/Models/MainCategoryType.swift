//
//  MainCategoryType.swift
//  CleanX
//
//  Created by Nikita Arshinov on 27.02.24.
//

import SafeSFSymbols

enum MainCategoryType: CaseIterable {
    case photo
    case contacts
    case calendar
    
    var title: String {
        switch self {
        case .photo:
            R.string.localizable.homePhotoCategoryTitle()
            
        case .contacts:
            R.string.localizable.homeContactsCategoryTitle()
            
        case .calendar:
            R.string.localizable.homeCalendarCategoryTitle()
        }
    }
    
    var subtitle: String {
        switch self {
        case .photo:
            R.string.localizable.homePhotoCategorySubtitle()
            
        case .contacts:
            R.string.localizable.homeContactsCategorySubtitle()
            
        case .calendar:
            R.string.localizable.homeCalendarCategorySubtitle()
        }
    }
    
    var icon: SafeSFSymbol {
        switch self {
        case .photo:
            .photo.onRectangle
            
        case .contacts:
            .person._2
            
        case .calendar:
            .calendar
        }
    }
}
