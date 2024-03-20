//
//  AllContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import Foundation
import Contacts

@Observable
final class AllContactsViewModel {
    private let contactsService: ContactsServiceProtocol = ContactsService()
    
    var datasource: [CNContact] = []
    
    func fetchContacts() {
        contactsService.fetchContacts { [weak self] in
            self?.datasource = $0
        }
    }
}
