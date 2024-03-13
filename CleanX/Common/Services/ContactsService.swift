//
//  ContactsService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Foundation
import Contacts

protocol ContactsServiceProtocol {
    func requestAccess() async -> Bool
    func findIncompleteContacts(completion: @escaping ([CNContact]) -> Void)
}

final class ContactsService {
    private let store = CNContactStore()
}

extension ContactsService: ContactsServiceProtocol {
    func requestAccess() async -> Bool {
        do {
            return try await store.requestAccess(for: .contacts)
        } catch {
            return false
        }
    }
    
    func findDuplicates() {
        fetchContacts {
            let allContacts = $0
            
        }
    }
    
    func findIncompleteContacts(completion: @escaping ([CNContact]) -> Void) {
        fetchContacts {
            let noNumbers = $0.filter { $0.phoneNumbers.isEmpty == true }
            let unnamed = $0.filter { $0.givenName.isEmpty == true && $0.familyName.isEmpty == true }
            completion(noNumbers + unnamed)
        }
    }
    
    private func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var contacts : [CNContact] = []
            let request = CNContactFetchRequest(
                keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()]
            )
            do {
                try self?.store.enumerateContacts(with: request) { contact, _ in
                    contacts.append(contact)
                }
                completion(contacts)
                
            } catch {
                completion([])
            }
        }
    }
    
    private func findDuplicateNamesContacts(contacts : [CNContact]) -> [CNContact] {
        let names = contacts.map {
            CNContactFormatter.string(from: $0, style: .fullName).orEmpty
        }
        let uniqueNames = Array(Set(names))
        var contactGroupedByDuplicated : [Array<CNContact>] = []
        var contactGroupedByUnique: [Array<CNContact>] = []
        var result: [CNContact] = []
        
        uniqueNames.forEach { fullName in
            let group = contacts.filter {
                CNContactFormatter.string(from: $0, style: .fullName) == fullName
            }
            contactGroupedByUnique.append(group)
        }
        
        contactGroupedByUnique.forEach {
            guard $0.count > 1 else { return }
            contactGroupedByDuplicated.append($0)
        }

        contactGroupedByDuplicated.forEach {
            $0.forEach { contact in
                result.append(contact)
            }
        }

        return result
    }
    
    private func findDuplicateNumberContacts(contacts: [CNContact]) -> [CNContact] {
        var contactsMap = [String: [CNContact]]()
        var duplicateContacts = [CNContact]()
        
        contacts.forEach { contact in
            contact.phoneNumbers.forEach { email in
                let number = email.value.stringValue as String
                guard let existingContacts = contactsMap[number] else {
                    contactsMap[number] = [contact]
                    return
                }
                existingContacts.forEach { existingContact in
                    if !duplicateContacts.contains(existingContact) {
                        duplicateContacts.append(existingContact)
                    }
                    if !duplicateContacts.contains(contact) {
                        duplicateContacts.append(contact)
                    }
                }
                contactsMap[number]?.append(contact)
            }
        }
        
        return duplicateContacts
    }
    
    private func findDuplicateEmailContacts(contacts: [CNContact]) -> [CNContact] {
        var emailToContactsMap = [String: [CNContact]]()
        var duplicateContacts = [CNContact]()
        
        contacts.forEach { contact in
            contact.emailAddresses.forEach { email in
                let emailAddress = email.value as String
                guard let existingContacts = emailToContactsMap[emailAddress] else {
                    emailToContactsMap[emailAddress] = [contact]
                    return
                }
                existingContacts.forEach { existingContact in
                    if !duplicateContacts.contains(existingContact) {
                        duplicateContacts.append(existingContact)
                    }
                    if !duplicateContacts.contains(contact) {
                        duplicateContacts.append(contact)
                    }
                }
                emailToContactsMap[emailAddress]?.append(contact)
            }
        }
        
        return duplicateContacts
    }
}
 
