//
//  CoreDataManager.swift
//  LooksmaxxingApp
//
//  Singleton manager for Core Data operations
//  All data stored locally for privacy
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LooksmaxxingApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                // Log error but don't crash in production
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Save Context
    
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Core Data save error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Streak Operations
    
    func fetchStreak() -> StreakEntity? {
        let request: NSFetchRequest<StreakEntity> = StreakEntity.fetchRequest()
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }
    
    func getOrCreateStreak() -> StreakEntity {
        if let existing = fetchStreak() {
            return existing
        }
        let streak = StreakEntity(context: viewContext)
        streak.id = UUID()
        streak.currentStreak = 0
        streak.totalDays = 0
        streak.lastCompletionDate = nil
        saveContext()
        return streak
    }
    
    func updateStreak(currentStreak: Int, lastCompletion: Date) {
        let streak = getOrCreateStreak()
        streak.currentStreak = Int16(currentStreak)
        streak.lastCompletionDate = lastCompletion
        streak.totalDays += 1
        saveContext()
    }
    
    func resetStreak() {
        let streak = getOrCreateStreak()
        streak.currentStreak = 0
        streak.lastCompletionDate = nil
        saveContext()
    }
    
    // MARK: - Daily Task Operations
    
    func fetchDailyTasks(for date: Date) -> [DailyTaskEntity] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return []
        }
        
        let request: NSFetchRequest<DailyTaskEntity> = DailyTaskEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "completedDate >= %@ AND completedDate < %@",
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func createDailyTask(type: String, completed: Bool) {
        let task = DailyTaskEntity(context: viewContext)
        task.id = UUID()
        task.taskType = type
        task.completedDate = Date()
        task.isCompleted = completed
        saveContext()
    }
    
    func getCompletedTaskTypes(for date: Date) -> Set<String> {
        let tasks = fetchDailyTasks(for: date)
        return Set(tasks.filter { $0.isCompleted }.compactMap { $0.taskType })
    }
    
    // MARK: - Face Analysis Operations
    
    func fetchFaceAnalyses() -> [FaceAnalysisEntity] {
        let request: NSFetchRequest<FaceAnalysisEntity> = FaceAnalysisEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "scanDate", ascending: false)]
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func fetchLatestAnalysis() -> FaceAnalysisEntity? {
        let request: NSFetchRequest<FaceAnalysisEntity> = FaceAnalysisEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "scanDate", ascending: false)]
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }
    
    func createFaceAnalysis(
        rating: Double,
        strengths: [String],
        weaknesses: [String],
        frontImage: Data? = nil,
        sideImage: Data? = nil
    ) {
        let analysis = FaceAnalysisEntity(context: viewContext)
        analysis.id = UUID()
        analysis.rating = rating
        analysis.strengths = strengths as NSArray
        analysis.weaknesses = weaknesses as NSArray
        analysis.scanDate = Date()
        analysis.frontImage = frontImage
        analysis.sideImage = sideImage
        saveContext()
        
        // Update last scan date
        UserDefaults.standard.lastScanDate = Date()
    }
    
    // MARK: - Utility Methods
    
    func getCurrentStreak() -> Int {
        Int(fetchStreak()?.currentStreak ?? 0)
    }
    
    func getLastScanDate() -> Date? {
        fetchLatestAnalysis()?.scanDate
    }
    
    func getAnalysisCount() -> Int {
        fetchFaceAnalyses().count
    }
    
    // MARK: - Delete All Data (for testing/reset)
    
    func deleteAllData() {
        let entities = ["StreakEntity", "DailyTaskEntity", "FaceAnalysisEntity"]
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try viewContext.execute(deleteRequest)
            } catch {
                print("Failed to delete \(entity): \(error)")
            }
        }
        saveContext()
    }
}
