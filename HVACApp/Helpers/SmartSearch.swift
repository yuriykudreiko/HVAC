//
//  SmartSearch.swift
//  HVACApp
//
//  Created by Yury Kudreika on 16.04.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import Foundation

struct SmartSearch {
    
    private static let exactMatchWeight = 1.0
    private static let prefixMatchWeight = 0.8
    private static let substringMatchWeight = 0.7
    private static let fuzzyMatchWeight = 0.6
    private static let maxFuzzyDistance = 3
    
    static func checkMatch(for string: String, with query: String) -> Bool {
        guard !query.isEmpty else { return true }
        
        let lowerQuery = query.lowercased()
        let lowerString = string.lowercased()
        
        // Primary filter: Exact and prefix matches
        let exactMatch = lowerString == lowerQuery
        let prefixMatch = lowerString.hasPrefix(lowerQuery)
        let substringMatch = lowerString.contains(lowerQuery)
        
        // Secondary filter: Fuzzy matching using Levenshtein Distance
        let fuzzyMatch = levenshteinDistance(lowerString, lowerQuery) <= maxFuzzyDistance
        
        return exactMatch || prefixMatch || substringMatch || fuzzyMatch
    }
    
    // Function to filter strings based on search query
    static func filterMaterials(from list: [MaterialModel], with query: String) -> [MaterialModel] {
        guard !query.isEmpty else { return list }
        
        let lowerQuery = query.lowercased()
        
        // Score and sort materials based on match quality
        let scoredMaterials = list.map { material -> (material: MaterialModel, score: Double) in
            let lowerName = material.name.lowercased()
            
            // Calculate match scores
            let exactMatchScore = lowerName == lowerQuery ? exactMatchWeight : 0
            let prefixMatchScore = lowerName.hasPrefix(lowerQuery) ? prefixMatchWeight : 0
            let substringMatchScore = lowerName.contains(lowerQuery) ? substringMatchWeight : 0
            
            // Fuzzy match score with distance-based weighting
            let fuzzyDistance = levenshteinDistance(lowerName, lowerQuery)
            let fuzzyMatchScore = fuzzyDistance <= maxFuzzyDistance 
                ? fuzzyMatchWeight * (1.0 - Double(fuzzyDistance) / Double(maxFuzzyDistance))
                : 0
            
            // Combine scores, prioritizing exact matches
            let totalScore = max(exactMatchScore, prefixMatchScore, substringMatchScore, fuzzyMatchScore)
            
            return (material: material, score: totalScore)
        }
        .filter { $0.score > 0 } // Remove non-matches
        .sorted { $0.score > $1.score } // Sort by score
        .map { $0.material } // Extract materials
        
        return scoredMaterials
    }
    
    // Optimized Levenshtein Distance calculation
    private static func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        // Early exit for exact matches
        if s1 == s2 { return 0 }
        
        // Early exit for empty strings
        if s1.isEmpty { return s2.count }
        if s2.isEmpty { return s1.count }
        
        // Use character arrays for better performance
        let s1Array = Array(s1)
        let s2Array = Array(s2)
        
        var previousRow = Array(0...s2Array.count)
        
        for (i, char1) in s1Array.enumerated() {
            var currentRow = Array(repeating: 0, count: s2Array.count + 1)
            currentRow[0] = i + 1
            
            for (j, char2) in s2Array.enumerated() {
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
