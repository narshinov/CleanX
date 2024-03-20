//
//  CNContact+Extensions.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import Contacts

extension CNContact {
    var title: String {
        if let name = CNContactFormatter.string(from: self, style: .fullName) {
            return name
        } else if let number = self.phoneNumbers.first?.value.stringValue {
            return number
        } else {
            return "Full empty contact"
        }
    }
    
    var name: String {
        guard let name = CNContactFormatter.string(from: self, style: .fullName) else { return "" }
        return name
    }
    
    var phoneNumber: String {
        guard let phone = self.phoneNumbers.first?.value.stringValue else { return "" }
        return phone
    }
}
