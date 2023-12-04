//
//  NSDiffableDataSourceSectionSnapshot.swift
//  ListAdapter
//
//  Created by tanxl on 2023/11/27.
//

import Foundation
import UIKit

public extension NSDiffableDataSourceSnapshot {
    
    
    // MARK: - ItemIdentifierType
    
    mutating func safeAppendItems(_ identifiers: [ItemIdentifierType], toSection sectionIdentifier: SectionIdentifierType? = nil) {
        if isContainsTheSameItem(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same item and terminate the append.")
            return
        }
        appendItems(identifiers, toSection: sectionIdentifier)
    }
    
    mutating func safeInsertItems(_ identifiers: [ItemIdentifierType], beforeItem beforeIdentifier: ItemIdentifierType) {
        if isContainsTheSameItem(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same item and terminate the insert.")
            return
        }
        insertItems(identifiers, beforeItem: beforeIdentifier)
    }
    
    mutating func safeInsertItems(_ identifiers: [ItemIdentifierType], afterItem afterIdentifier: ItemIdentifierType) {
        if isContainsTheSameItem(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same item and terminate the insert.")
            return
        }
        insertItems(identifiers, afterItem: afterIdentifier)
    }
    
    mutating func safeReloadItems(_ identifiers: [ItemIdentifierType]) {
        if !isContainsTheCollection(itemIdentifiers, identifiers) {
            debugPrint("【ListAdapter Log】- Include the different item and terminate the reload.")
            return
        }
        reloadItems(identifiers)
    }
    
    
    // MARK: - SectionIdentifierType
    
    mutating func safeAppendSections(_ identifiers: [SectionIdentifierType]) {
        if isContainsTheSameSection(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same section and terminate the append.")
            return
        }
        appendSections(identifiers)
    }

    mutating func safeInsertSections(_ identifiers: [SectionIdentifierType], beforeSection toIdentifier: SectionIdentifierType) {
        if isContainsTheSameSection(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same section and terminate the insert.")
            return
        }
        insertSections(identifiers, beforeSection: toIdentifier)
    }

    mutating func safeInsertSections(_ identifiers: [SectionIdentifierType], afterSection toIdentifier: SectionIdentifierType) {
        if isContainsTheSameSection(identifiers) {
            debugPrint("【ListAdapter Log】- Include the same section and terminate the insert.")
            return
        }
        insertSections(identifiers, afterSection: toIdentifier)
    }
    
    mutating func safeReloadSections(_ identifiers: [SectionIdentifierType]) {
        if !isContainsTheCollection(sectionIdentifiers, identifiers) {
            debugPrint("【ListAdapter Log】- Include the different section and terminate the reload.")
            return
        }
        reloadSections(identifiers)
    }
    
    
    // MARK: - private helper
    
    private func isContainsTheSameItem(_ identifiers: [ItemIdentifierType]) -> Bool {
        var itemIdentifiers = itemIdentifiers
        itemIdentifiers.append(contentsOf: identifiers)
        return itemIdentifiers.count != Set(itemIdentifiers).count
    }
    
    private func isContainsTheSameSection(_ identifiers: [SectionIdentifierType]) -> Bool {
        var sectionIdentifiers = sectionIdentifiers
        sectionIdentifiers.append(contentsOf: identifiers)
        return sectionIdentifiers.count != Set(sectionIdentifiers).count
    }
    
    private func isContainsTheCollection(_ big: [any Hashable & Sendable], _ small: [any Hashable & Sendable]) -> Bool {
        var outEqualable: Bool = true
        for sIdentifier in small {
            var internalEqualable: Bool = false
            for bIdentifier in big {
                if let objc1 = sIdentifier as? NSObject,
                   let objc2 = bIdentifier as? NSObject,
                   objc1 === objc2 {
                    internalEqualable = true
                    break
                }
            }
            if !internalEqualable {
                outEqualable = internalEqualable
                break
            }
        }
        return outEqualable
    }
}
