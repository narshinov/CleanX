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
    func fetchContacts(completion: @escaping ([CNContact]) -> Void)
    
    func findIncompletedContacts(_ contacts: [CNContact]) -> [CNContact]
    func findDuplicatedContacts(_ contacts: [CNContact]) -> [Set<CNContact>]
    func deleteContacts(_ contacts: [CNContact]) throws
    func saveContact(_ contact: CNMutableContact) throws
    func mergeDuplicates(_ contacts: Set<CNContact>) -> CNMutableContact
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
    
    func findIncompletedContacts(_ contacts: [CNContact]) -> [CNContact] {
        let noName = findIncompletedNameContacts(contacts)
        let noNumber = findIncompletedNumbersContacts(contacts)
        return noName + noNumber
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
    
    func deleteContacts(_ contacts: [CNContact]) throws {
        let request = CNSaveRequest()
        contacts.forEach {
            guard let mutableContact = $0.mutableCopy() as? CNMutableContact else { return }
            request.delete(mutableContact)
        }
        try store.execute(request)
    }
    
    func saveContact(_ contact: CNMutableContact) throws {
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: nil)
        try store.execute(request)
    }
    
    func mergeDuplicates(_ contacts: Set<CNContact>) -> CNMutableContact {
        var namePrefix = Set<String>()
        var givenName = Set<String>()
        var middleName = Set<String>()
        var familyName = Set<String>()
        var previousFamilyName = Set<String>()
        var nameSuffix = Set<String>()
        var nickname = Set<String>()
        var organizationName = Set<String>()
        var departmentName = Set<String>()
        var jobTitle = Set<String>()
        var phoneNumbers = Set<CNPhoneNumber>()
        var emailAddresses = Set<NSString>()
        var postalAddresses = Set<CNPostalAddress>()
        var urlAddresses = Set<NSString>()
        var contactRelations = Set<CNContactRelation>()
        var socialProfiles = Set<CNSocialProfile>()
        var instantMessageAddresses = Set<CNInstantMessageAddress>()
        
        contacts.forEach { contact in
            if !contact.namePrefix.isEmpty {
                namePrefix.insert(contact.namePrefix)
            }
            
            if !contact.givenName.isEmpty {
                givenName.insert(contact.givenName)
            }
            
            if !contact.middleName.isEmpty {
                middleName.insert(contact.middleName)
            }
            
            if !contact.familyName.isEmpty {
                familyName.insert(contact.familyName)
            }
            
            if !contact.previousFamilyName.isEmpty {
                previousFamilyName.insert(contact.previousFamilyName)
            }
            
            if !contact.nameSuffix.isEmpty {
                nameSuffix.insert(contact.nameSuffix)
            }
            
            if !contact.nickname.isEmpty {
                nickname.insert(contact.nickname)
            }
            
            if !contact.organizationName.isEmpty {
                organizationName.insert(contact.organizationName)
            }
            
            if !contact.departmentName.isEmpty {
                departmentName.insert(contact.departmentName)
            }
            
            if !contact.jobTitle.isEmpty {
                jobTitle.insert(contact.jobTitle)
            }
            
            for number in contact.phoneNumbers {
                phoneNumbers.insert(number.value)
            }
            for email in contact.emailAddresses {
                emailAddresses.insert(email.value)
            }
            for postal in contact.postalAddresses {
                postalAddresses.insert(postal.value)
            }
            for url in contact.urlAddresses {
                urlAddresses.insert(url.value)
            }
            for relation in contact.contactRelations {
                contactRelations.insert(relation.value)
            }
            for social in contact.socialProfiles {
                socialProfiles.insert(social.value)
            }
            for message in contact.instantMessageAddresses {
                instantMessageAddresses.insert(message.value)
            }
        }
        
        var newContact = CNMutableContact()
        newContact.namePrefix = namePrefix.first.orEmpty
        newContact.givenName = givenName.first.orEmpty
        newContact.middleName = middleName.first.orEmpty
        newContact.familyName = familyName.first.orEmpty
        newContact.previousFamilyName = previousFamilyName.first.orEmpty
        newContact.nameSuffix = nameSuffix.first.orEmpty
        newContact.nickname = nickname.first.orEmpty
        newContact.organizationName = organizationName.first.orEmpty
        newContact.departmentName = departmentName.first.orEmpty
        newContact.jobTitle = jobTitle.first.orEmpty

        for item in Array(phoneNumbers) {
            newContact.phoneNumbers.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(emailAddresses) {
            newContact.emailAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(postalAddresses) {
            newContact.postalAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(urlAddresses) {
            newContact.urlAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(contactRelations) {
            newContact.contactRelations.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(socialProfiles) {
            newContact.socialProfiles.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        for item in Array(instantMessageAddresses) {
            newContact.instantMessageAddresses.append(CNLabeledValue(label: CNLabelHome, value: item))
        }
        
        return newContact
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
