//
//  IncompletedContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Contacts

@Observable
final class IncompletedContactsViewModel {
    
    let contacts: [CNContact]
    
    init(contacts: [CNContact]) {
        self.contacts = contacts
        
        datasource = contacts.map {
            let model: IncompletedContactCell.Model = .init(title: "\($0.givenName) \($0.familyName)")
            return model
        }
    }
    
    var datasource: [IncompletedContactCell.Model] = []
    
    func selectAll(_ isSelected: Bool) {
        datasource = datasource.map {
            var new = $0
            new.isSelected = !isSelected
            return new
        }
    }
}
