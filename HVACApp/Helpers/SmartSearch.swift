//
//  SmartSearch.swift
//  HVACApp
//
//  Created by Yury Kudreika on 16.04.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import Foundation

struct SmartSearch {
    
    static func checkMatch(for string: String, with query: String) -> Bool {
        guard !query.isEmpty else { return true }
        
        let lowerQuery = query.lowercased()
        
        // Primary filter: Exact and prefix matches
        let exactMatch = string.localizedCaseInsensitiveContains(lowerQuery)

        // Secondary filter: Fuzzy matching using Levenshtein Distance
        let fuzzyMatch = levenshteinDistance(string, lowerQuery) <= 2
        
        return (exactMatch || fuzzyMatch)
    }
    
    // Function to filter strings based on search query
    static func filterMaterials(from list: [MaterialModel], with query: String) -> [MaterialModel] {
        guard !query.isEmpty else { return list }
        
        let lowerQuery = query.lowercased()
        
        // Primary filter: Exact and prefix matches
//        let exactMatches = list.filter { $0.name.lowercased() == lowerQuery }
//        let prefixMatches = list.filter { $0.name.lowercased().hasPrefix(lowerQuery) }
        let exactMatches = list.filter { $0.name.localizedCaseInsensitiveContains(lowerQuery) }

        // Secondary filter: Fuzzy matching using Levenshtein Distance
        let fuzzyMatches = list
            .filter { levenshteinDistance($0.name.lowercased(), lowerQuery) <= 2 }
        
        // Combine and remove duplicates while prioritizing exact matches
        let combinedResults = (exactMatches + fuzzyMatches).removingDuplicates()
        
        return combinedResults
    }
    
    // Function to calculate Levenshtein Distance (edit distance)
    private static func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let empty = Array(repeating: 0, count: s2.count + 1)
        var previousRow = Array(0...s2.count)

        for (i, char1) in s1.enumerated() {
            var currentRow = empty
            currentRow[0] = i + 1

            for (j, char2) in s2.enumerated() {
                let cost = (char1 == char2) ? 0 : 1
                currentRow[j + 1] = min(
                    previousRow[j + 1] + 1,   // Insertion
                    currentRow[j] + 1,        // Deletion
                    previousRow[j] + cost     // Substitution
                )
            }
            previousRow = currentRow
        }
        
        return previousRow.last!
    }
}

// Extension to remove duplicates from an array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        return Array(Set(self))
    }
}
