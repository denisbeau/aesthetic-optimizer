//
//  CoreDataEntities.swift
//  LooksmaxxingApp
//
//  Manual Core Data entity definitions
//  These mirror the .xcdatamodeld file
//

import Foundation
import CoreData

// MARK: - Streak Entity

@objc(StreakEntity)
public class StreakEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var currentStreak: Int16
    @NSManaged public var lastCompletionDate: Date?
    @NSManaged public var totalDays: Int16
}

extension StreakEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StreakEntity> {
        return NSFetchRequest<StreakEntity>(entityName: "StreakEntity")
    }
}

// MARK: - Daily Task Entity

@objc(DailyTaskEntity)
public class DailyTaskEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var taskType: String?
    @NSManaged public var completedDate: Date?
    @NSManaged public var isCompleted: Bool
}

extension DailyTaskEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTaskEntity> {
        return NSFetchRequest<DailyTaskEntity>(entityName: "DailyTaskEntity")
    }
}

// MARK: - Face Analysis Entity

@objc(FaceAnalysisEntity)
public class FaceAnalysisEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var rating: Double
    @NSManaged public var strengths: NSArray?
    @NSManaged public var weaknesses: NSArray?
    @NSManaged public var scanDate: Date?
    @NSManaged public var frontImage: Data?
    @NSManaged public var sideImage: Data?
}

extension FaceAnalysisEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FaceAnalysisEntity> {
        return NSFetchRequest<FaceAnalysisEntity>(entityName: "FaceAnalysisEntity")
    }
    
    var strengthsArray: [String] {
        (strengths as? [String]) ?? []
    }
    
    var weaknessesArray: [String] {
        (weaknesses as? [String]) ?? []
    }
}
