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
    private let analyticService: AnalyticServiceProtocol = AnalyticService()
    
    var datasource: [IncompletedContactCell.Model] = []
    
    var selectedContactsCount: Int {
        datasource.filter({ $0.isSelected }).count
    }
    
    var selectedContacts: [CNContact] {
        datasource.filter({ $0.isSelected }).map { $0.contact }
    }
    
    func fetchContacts() {
        contactsService.fetchContacts { [weak self] in
            guard let self else { return }
            let contacts = self.contactsService.findIncompletedContacts($0)
            self.datasource = contacts.map {
                IncompletedContactCell.Model(contact: $0)
            }
        }
    }
    
    func selectAll(_ isSelected: Bool) {
        datasource = datasource.map {
            var new = $0
            new.isSelected = isSelected
            return new
        }
    }
    
    func deleteContacts() {
        do {
            try contactsService.deleteContacts(selectedContacts)
            analyticService.sendEvent(.сontactDeleted)
            fetchContacts()
        } catch { }
    }
}
