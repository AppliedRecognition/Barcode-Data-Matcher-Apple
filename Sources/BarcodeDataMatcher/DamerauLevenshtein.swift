//
//  DamerauLevenshtein.swift
//  Barcode-Data-Matcher
//
//  Created by Jakub Dolejs on 28/06/2021.
//

import Foundation

public struct DamerauLevenshtein {
    
    private init() {        
    }
    
    public static func distance(between s1: String, and s2: String) throws -> StringDistance {
        if s1 == s2 {
            return StringDistance(steps: 0, similarity: 1)
        }
        let inf: Int = s1.count + s2.count
        var distanceMatrix: [Character:Int] = [:]
        for i in 0..<s1.count {
            distanceMatrix[s1[s1.index(s1.startIndex, offsetBy: i)]] = 0
        }
        for i in 0..<s2.count {
            distanceMatrix[s2[s2.index(s2.startIndex, offsetBy: i)]] = 0
        }
        var h: [[Int]] = Array(repeating: Array(repeating: 0, count: s2.count+2), count: s1.count+2)
        for i in 0...s1.count {
            h[i+1][0] = inf
            h[i+1][1] = i
        }
        for i in 0...s2.count {
            h[0][i+1] = inf
            h[1][i+1] = i
        }
        for i in 1...s1.count {
            var db: Int = 0
            for j in 1...s2.count {
                guard let i1: Int = distanceMatrix[s2[s2.index(s2.startIndex, offsetBy: j-1)]] else {
                    throw NSError()
                }
                let j1: Int = db
                var cost: Int = 1
                if s1[s1.index(s1.startIndex, offsetBy: i-1)] == s2[s2.index(s2.startIndex, offsetBy: j-1)] {
                    cost = 0
                    db = j
                }
                h[i+1][j+1] = min(h[i][j]+cost, h[i+1][j]+1, h[i][j+1]+1, h[i1][j1]+(i-i1-1)+1+(j-j1-1))
            }
            distanceMatrix[s1[s1.index(s1.startIndex, offsetBy: i-1)]] = i
        }
        let distance = h[s1.count+1][s2.count+1]
        let similarity: Float = 1 - Float(distance) / Float(max(s1.count, s2.count))
        return StringDistance(steps: distance, similarity: similarity)
    }
}

public struct StringDistance {
    public let steps: Int
    public let similarity: Float
}
