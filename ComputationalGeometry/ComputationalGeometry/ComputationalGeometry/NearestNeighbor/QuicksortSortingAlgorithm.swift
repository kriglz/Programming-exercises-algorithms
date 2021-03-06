//
//  QuicksortSortingAlgorithm.swift
//  ComputationalGeometry
//
//  Created by Kristina Gelzinyte on 10/9/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class QuicksortSortingAlgorithm {
    
    private(set) var sortingArray: [CGPoint]
    private let dimension: Int
    
    init(sortingArray: [CGPoint], dimension: Int) {
        self.sortingArray = sortingArray
        self.dimension = dimension
    }
    
    @discardableResult func select(mediumIndex: Int, leftIndex: Int, rightIndex: Int) -> CGPoint {
        var left = leftIndex
        var right = rightIndex
        var medium = mediumIndex
        
        while true {
            if left == right {
                return sortingArray[left]
            }
            
            let pivotIndexOfThree = pivot(leftIndex: left, rightIndex: right)
            let pivotIndex = partition(leftIndex: left, rightIndex: right, pivotIndex: pivotIndexOfThree)
            
            if left + medium - 1 == pivotIndex {
                return sortingArray[pivotIndex]
            }
            
            // Continue the loop narrowing the range as appropriate
            if left + medium - 1 < pivotIndex {
                // Left side of the pivot.
                right = pivotIndex - 1
            } else {
                // Right side of the pivot.
                medium -= pivotIndex - left + 1
                left = pivotIndex + 1
            }
        }
    }
    
    private func partition(leftIndex: Int, rightIndex: Int, pivotIndex: Int) -> Int {
        let pivot = sortingArray[pivotIndex]
        
        // Move pivot index number to the end of the range.
        sortingArray.swapAt(pivotIndex, rightIndex)

        var storeIndex = leftIndex
        
        for index in leftIndex..<rightIndex {
            if compare(sortingArray[index], pivot) <= 0 {
                
                if index != storeIndex {
                    sortingArray.swapAt(index, storeIndex)
                }
                storeIndex += 1
            }
        }
        
        if rightIndex != storeIndex {
            sortingArray.swapAt(rightIndex, storeIndex)
        }
        
        return storeIndex   
    }
    
    private func pivot(leftIndex: Int, rightIndex: Int) -> Int {
        var midIndex = (leftIndex + rightIndex) / 2
        var lowerBound = leftIndex
        
        if compare(sortingArray[lowerBound], sortingArray[midIndex]) > 0 {
            lowerBound = midIndex
            midIndex = leftIndex
        }
        
        // Select middle of [low, mid] and sortingArray[right]
        if compare(sortingArray[rightIndex], sortingArray[lowerBound]) < 0 {
            // right .. low .. mid
            return lowerBound
            
        }
        
        if compare(sortingArray[rightIndex], sortingArray[midIndex]) < 0 {
            // low .. right .. mid
            return rightIndex
        }
        
        return midIndex
    }
    
    private func randomIndex(leftIndex: Int, rightIndex: Int) -> Int {
        return Int.random(in: leftIndex..<rightIndex)
    }
    
    private func compare(_ i: (CGPoint), _ j: (CGPoint)) -> Int {
        switch dimension {
        case 1:
            if i.x > j.x {
                return 1
            } else if i.x == j.x {
                return 0
            }
            return -1

        default:
            if i.y > j.y {
                return 1
            } else if i.y == j.y {
                return 0
            }
            return -1
        }        
    }
}
