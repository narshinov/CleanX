//
//  MergeContactsViewModel.swift
//  CleanX
//
//  Created by Nikita Arshinov on 19.03.24.
//

import Foundation
import Contacts

@Observable
final class MergeContactsViewModel {
    private let contactService: ContactsServiceProtocol = ContactsService()
    
    var contacts: Set<CNContact>
    
    var mergeResultContact = CNMutableContact()

    init(_ contacts: Set<CNContact>) {
        self.contacts = contacts
        
        mergeResultContact = contactService.mergeDuplicates(contacts)
    }
    
    func mergeContacts() {
        do {
            try contactService.saveContact(mergeResultContact)
            try contactService.deleteContacts(Array(contacts))
        } catch { 
            print(error)
        }
    }
}

extension Set {
    func setmap<U>(transform: (Element) -> U) -> Set<U> {
        return Set<U>(self.lazy.map(transform))
    }
    
    func setcompactMap<U>(transform: (Element) -> U) -> Set<U> {
        return Set<U>(self.lazy.compactMap(transform))
    }
}
