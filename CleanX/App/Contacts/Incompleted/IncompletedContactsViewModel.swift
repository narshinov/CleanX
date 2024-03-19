//
//  IncompletedContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Contacts

@Observable
final class IncompletedContactsViewModel {
    private let contactsService: ContactsServiceProtocol = ContactsService()
    
    var noNameDatasource: [IncompletedContactCell.Model] = []
    var noNumberDatasource: [IncompletedContactCell.Model] = []
    
    func fetchContacts() {
        contactsService.fetchContacts { [weak self] in
            guard let self else { return }
            let incomletedContacts = self.contactsService.findIncompletedContacts($0)
            noNameDatasource = incomletedContacts.noName.map({ .init(contact: $0) })
            noNumberDatasource = incomletedContacts.noNumber.map({ .init(contact: $0) })
        }
    }
    
    func selectAll(_ isSelected: Bool) {
//        datasource = datasource.map {
//            var new = $0
//            new.isSelected = !isSelected
//            return new
//        }
    }
}
