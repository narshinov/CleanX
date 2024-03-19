//
//  ContactsService.swift
//  CleanX
//
//  Created by Nikita Arshinov on 13.03.24.
//

import Foundation
import Contacts

struct ContactsModel {
    var allContacts: [CNContact]
    var incompleted: IncompletedContactsView.Model
    var duplicateNumber: [Set<CNContact>]
    var duplicateName: [Set<CNContact>]
    var duplicateEmail: [Set<CNContact>]
    
    var allCount: Int {
        allContacts.count
    }
    
    var incompleteCount: Int {
        incompleted.noName.count + incompleted.noNumber.count
    }
    
    var duplicatesCount: Int {
        duplicateName.count + duplicateNumber.count + duplicateEmail.count
    }
}

protocol ContactsServiceProtocol {
    func requestAccess() async -> Bool
    func configureContacts(completion: @escaping (ContactsModel) -> Void)
    func fetchContacts(completion: @escaping ([CNContact]) -> Void)
    
    func findIncompletedContacts(_ contacts: [CNContact]) -> IncompletedContactsView.Model
    func findDuplicatedContacts(_ contacts: [CNContact]) -> [Set<CNContact>]
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
    
    func findDuplicatedContacts(_ contacts: [CNContact]) -> [Set<CNContact>] {
        let numberDuplicates = findPhoneNumberDuplicates(contacts)
        let nameDuplicates = findNameDuplicates(contacts)
        return numberDuplicates + nameDuplicates
    }
    
    func findIncompletedContacts(_ contacts: [CNContact]) -> IncompletedContactsView.Model {
        let noName = findIncompletedNameContacts(contacts)
        let noNumber = findIncompletedNumbersContacts(contacts)
        return .init(noName: noName, noNumber: noNumber)
    }
    
    func configureContacts(completion: @escaping (ContactsModel) -> Void) {
        fetchContacts { [weak self] in
            guard let self else { return }
            let noName = findIncompletedNameContacts($0)
            let noNumber = findIncompletedNumbersContacts($0)
            let duplicateNumber = self.findPhoneNumberDuplicates($0)
            let duplicateName = self.findNameDuplicates($0)
            let duplicateEmail = self.findEmailDuplicates($0)
            
            let model = ContactsModel(
                allContacts: $0,
                incompleted: .init(noName: noName, noNumber: noNumber),
                duplicateNumber: duplicateNumber,
                duplicateName: duplicateName,
                duplicateEmail: duplicateEmail
            )
            completion(model)
        }
    }
    
    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
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

    private func findIncompletedNumbersContacts(_ contacts: [CNContact]) -> [CNContact] {
        return contacts.filter { $0.phoneNumbers.isEmpty == true }
    }
    
    private func findIncompletedNameContacts(_ contacts: [CNContact]) -> [CNContact] {
        return contacts.filter { contact in
            let name = CNContactFormatter.string(from: contact, style: .fullName)
            return name == nil
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
