//
//  DuplicatedContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import Foundation
import Contacts

@Observable
final class DuplicatedContactsViewModel {
    private let contactsService: ContactsServiceProtocol = ContactsService()
    
    var datasource = [Set<CNContact>]()
    
    func findDuplicates() {
        contactsService.fetchContacts { [weak self] in
            guard let self else { return }
            datasource = self.contactsService.findDuplicatedContacts($0)
        }
    }
}
