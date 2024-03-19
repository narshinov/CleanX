//
//  ContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Foundation
import Contacts

@Observable
final class ContactsViewModel {    
    private let contactsService: ContactsServiceProtocol = ContactsService()
    
    var allContactsCount: Int = .zero
    var duplicatedContactsCount: Int = .zero
    var incompletedContacts = IncompletedContactsView.Model()
    
    func fetchContacts() {
        Task {
            let isAvailable = await contactsService.requestAccess()
            guard isAvailable else { return }
            contactsService.fetchContacts { [weak self] contacts in
                guard let self else { return }
                self.incompletedContacts = self.contactsService.findIncompletedContacts(contacts)
                self.allContactsCount = contacts.count
                self.duplicatedContactsCount = self.contactsService.findDuplicatedContacts(contacts).count
            }

        }
    }
    
//    func findIncompletedNameContacts(_ contacts: [CNContact]) -> [CNContact]
//    func findIncompletedNumbersContacts(_ contacts: [CNContact]) -> [CNContact]
}
