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
    func findDuplicates()
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
        fetchContacts { [weak self] in
            guard let self else { return }
            let phoneNumberDuplicates = self.findPhoneNumberDuplicates($0)
            let nameDuplicates = self.findNameDuplicates($0)
            let emailDuplicates = self.findEmailDuplicates($0)
            print(phoneNumberDuplicates)
            print(nameDuplicates)
            print(emailDuplicates)
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
    
    private func findPhoneNumberDuplicates(_ contacts: [CNContact]) -> [Set<CNContact>] {
        var contactsSet = Set(contacts)
        var duplicatesSet: [Set<CNContact>] = []

        contactsSet.forEach { contact in
            guard let result = comparePhoneNumber(contact: contact, contacts: &contactsSet) else { return }
            duplicatesSet.append(result)
        }

        return duplicatesSet
    }
    
    private func comparePhoneNumber(contact: CNContact, contacts: inout Set<CNContact>) -> Set<CNContact>? {
        var result: Set<CNContact> = Set()
        guard let numberX = contact.phoneNumbers.first?.value else { return nil }
        contacts.forEach {
            guard
                let numberY = $0.phoneNumbers.first?.value,
                numberX == numberY
            else { return }
            result.insert($0)
            contacts.remove($0)
        }
        guard result.count > 1 else { return nil }
        result.insert(contact)
        return result
    }
    
    private func findNameDuplicates(_ contacts: [CNContact]) -> [Set<CNContact>] {
        var contactsSet = Set(contacts)
        var duplicatesSet: [Set<CNContact>] = []

        contactsSet.forEach { contact in
            guard let result = compareName(contact, contacts: &contactsSet) else { return }
            duplicatesSet.append(result)
        }

        return duplicatesSet
    }
    
    private func compareName(_ contact: CNContact, contacts: inout Set<CNContact>) -> Set<CNContact>? {
        var result: Set<CNContact> = Set()
        guard let nameX = CNContactFormatter.string(from: contact, style: .fullName) else { return nil }
        contacts.forEach {
            guard
                let nameY = CNContactFormatter.string(from: $0, style: .fullName),
                nameX == nameY
            else { return }
            result.insert($0)
            contacts.remove($0)
        }
        guard result.count > 1 else { return nil }
        result.insert(contact)
        return result
    }
    
    private func findEmailDuplicates(_ contacts: [CNContact]) -> [Set<CNContact>] {
        var contactsSet = Set(contacts)
        var duplicatesSet: [Set<CNContact>] = []

        contactsSet.forEach { contact in
            guard let result = compareEmail(contact, contacts: &contactsSet) else { return }
            duplicatesSet.append(result)
        }

        return duplicatesSet
    }
    
    private func compareEmail(_ contact: CNContact, contacts: inout Set<CNContact>)  -> Set<CNContact>? {
        var result: Set<CNContact> = Set()
        guard let emailX = contact.emailAddresses.first?.value else { return nil }
        contacts.forEach {
            guard
                let emailY = $0.emailAddresses.first?.value,
                emailX == emailY
            else { return }
            result.insert($0)
            contacts.remove($0)
        }
        guard result.count > 1 else { return nil }
        result.insert(contact)
        return result
    }
}
 
extension Set {
    func setmap<U>(transform: (Element) -> U) -> Set<U> {
        return Set<U>(self.lazy.map(transform))
    }
}
