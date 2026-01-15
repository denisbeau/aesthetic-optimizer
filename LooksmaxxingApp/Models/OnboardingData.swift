import Foundation
import SwiftUI

// MARK: - Onboarding Data Model
class OnboardingData: ObservableObject {
    static let shared = OnboardingData()
    
    // User Profile
    @Published var userName: String = ""
    @Published var userAge: String = ""
    
    // Quiz Responses (Q1-Q10)
    @Published var primaryGoal: String = ""
    @Published var checkFrequency: String = ""
    @Published var comparisonSource: String = ""
    @Published var hasGottenWorse: Bool = false
    @Published var concernOnset: String = ""
    @Published var physicalHabits: String = ""
    @Published var photoAvoidance: String = ""
    @Published var stressMirrorCheck: String = ""
    @Published var socialMediaTrigger: Bool = false
    @Published var hasSpentMoney: Bool = false
    
    // Calculated Results
    @Published var userScore: Int = 0
    @Published var averageScore: Int = 13
    
    // Symptom Selection
    @Published var selectedSymptoms: Set<String> = []
    
    // Goal Selection
    @Published var selectedGoals: Set<String> = []
    
    // Signature
    @Published var hasSignedCommitment: Bool = false
    
    // Computed Properties
    var scoreDifference: Int {
        return userScore - averageScore
    }
    
    var transformationDate: Date {
        return Calendar.current.date(byAdding: .day, value: 60, to: Date()) ?? Date()
    }
    
    var formattedTransformationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: transformationDate)
    }
    
    var todayFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: Date())
    }
    
    // Calculate score based on quiz responses
    func calculateScore() {
        var score = 20 // Base score
        
        // Add points based on frequency
        switch checkFrequency {
        case "Multiple times daily": score += 15
        case "Daily": score += 10
        case "Weekly": score += 5
        default: break
        }
        
        // Add points for worsening
        if hasGottenWorse { score += 10 }
        
        // Add points for photo avoidance
        switch photoAvoidance {
        case "Always": score += 12
        case "Sometimes": score += 8
        case "Rarely": score += 4
        default: break
        }
        
        // Add points for stress checking
        switch stressMirrorCheck {
        case "Frequently": score += 10
        case "Sometimes": score += 5
        default: break
        }
        
        // Add points for triggers
        if socialMediaTrigger { score += 8 }
        if hasSpentMoney { score += 7 }
        
        userScore = min(score, 85) // Cap at 85
    }
    
    func reset() {
        userName = ""
        userAge = ""
        primaryGoal = ""
        checkFrequency = ""
        comparisonSource = ""
        hasGottenWorse = false
        concernOnset = ""
        physicalHabits = ""
        photoAvoidance = ""
        stressMirrorCheck = ""
        socialMediaTrigger = false
        hasSpentMoney = false
        userScore = 0
        selectedSymptoms = []
        selectedGoals = []
        hasSignedCommitment = false
    }
}

// MARK: - Quiz Question Model
struct QuizQuestion: Identifiable {
    let id: Int
    let question: String
    let options: [String]
    let isYesNo: Bool
    
    init(id: Int, question: String, options: [String], isYesNo: Bool = false) {
        self.id = id
        self.question = question
        self.options = options
        self.isYesNo = isYesNo
    }
}

// MARK: - Quiz Questions Data
let quizQuestions: [QuizQuestion] = [
    QuizQuestion(id: 1, question: "What's your primary goal?", options: ["Define my jawline", "Clear my skin", "Improve symmetry", "Overall glow-up"]),
    QuizQuestion(id: 2, question: "How often do you check your appearance?", options: ["Multiple times daily", "Daily", "Weekly", "Rarely"]),
    QuizQuestion(id: 3, question: "Where do you compare yourself to others?", options: ["Social media", "Mirror", "Photos", "Dating apps", "All of the above"]),
    QuizQuestion(id: 4, question: "Has your concern gotten worse over time?", options: ["Yes", "No"], isYesNo: true),
    QuizQuestion(id: 5, question: "When did your concerns start?", options: ["Under 13", "13-17", "18-24", "25+"]),
    QuizQuestion(id: 6, question: "Do you have any of these habits?", options: ["Mouth breathing", "Poor posture", "Both", "Neither"]),
    QuizQuestion(id: 7, question: "How often do you avoid photos?", options: ["Always", "Sometimes", "Rarely", "Never"]),
    QuizQuestion(id: 8, question: "Do you check the mirror when stressed?", options: ["Frequently", "Sometimes", "Rarely"]),
    QuizQuestion(id: 9, question: "Does social media trigger appearance concerns?", options: ["Yes", "No"], isYesNo: true),
    QuizQuestion(id: 10, question: "Have you spent money on appearance products?", options: ["Yes", "No"], isYesNo: true)
]

// MARK: - Symptom Model
struct Symptom: Identifiable, Hashable {
    let id: String
    let text: String
    let category: SymptomCategory
}

enum SymptomCategory: String, CaseIterable {
    case mental = "Mental"
    case physical = "Physical"
    case social = "Social"
}

let symptoms: [Symptom] = [
    // Mental
    Symptom(id: "unmotivated", text: "Feeling unmotivated", category: .mental),
    Symptom(id: "low_confidence", text: "Low self-confidence", category: .mental),
    Symptom(id: "obsessive_thoughts", text: "Obsessive thoughts about appearance", category: .mental),
    Symptom(id: "anxiety", text: "Anxiety about how I look", category: .mental),
    Symptom(id: "comparison", text: "Constantly comparing to others", category: .mental),
    
    // Physical
    Symptom(id: "poor_posture", text: "Poor posture awareness", category: .physical),
    Symptom(id: "mouth_breathing", text: "Mouth breathing habits", category: .physical),
    Symptom(id: "skin_issues", text: "Skin texture issues", category: .physical),
    Symptom(id: "weak_jawline", text: "Weak jawline definition", category: .physical),
    Symptom(id: "asymmetry", text: "Facial asymmetry concerns", category: .physical),
    
    // Social
    Symptom(id: "avoid_photos", text: "Avoiding photos", category: .social),
    Symptom(id: "avoid_mirrors", text: "Checking mirrors constantly", category: .social),
    Symptom(id: "dating_anxiety", text: "Dating app anxiety", category: .social),
    Symptom(id: "social_avoidance", text: "Avoiding social situations", category: .social)
]

// MARK: - Goal Model
struct GoalItem: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let accentColor: Color
}

let goalItems: [GoalItem] = [
    GoalItem(id: "jawline", title: "Stronger jawline", icon: "face.smiling", accentColor: .red),
    GoalItem(id: "skin", title: "Clear, healthy skin", icon: "sparkles", accentColor: .green),
    GoalItem(id: "symmetry", title: "Better facial symmetry", icon: "square.on.square", accentColor: .blue),
    GoalItem(id: "confidence", title: "More confidence", icon: "star.fill", accentColor: .yellow),
    GoalItem(id: "routine", title: "Consistent daily routine", icon: "calendar", accentColor: .purple),
    GoalItem(id: "posture", title: "Improved posture", icon: "figure.stand", accentColor: .orange),
    GoalItem(id: "focus", title: "Better focus and clarity", icon: "target", accentColor: .cyan),
    GoalItem(id: "energy", title: "More energy", icon: "bolt.fill", accentColor: .pink)
]

// MARK: - Testimonial Model
struct Testimonial: Identifiable {
    let id: String
    let name: String
    let handle: String
    let rating: Int
    let text: String
    let isVerified: Bool
    
    init(id: String = UUID().uuidString, name: String, handle: String, rating: Int = 5, text: String, isVerified: Bool = true) {
        self.id = id
        self.name = name
        self.handle = handle
        self.rating = rating
        self.text = text
        self.isVerified = isVerified
    }
}

let testimonials: [Testimonial] = [
    Testimonial(name: "Marcus", handle: "@marcus_fit", text: "After 30 days of mewing and following the routine, my jawline is noticeably sharper. My friends started asking what I've been doing differently."),
    Testimonial(name: "Jake", handle: "@jake_transformation", text: "I was skeptical at first, but the daily tracking kept me accountable. The progress photos don't lie - real results."),
    Testimonial(name: "Connor", handle: "@connor_glow", text: "This app changed my perspective. Instead of obsessing, I'm now taking action. The structured approach actually works."),
    Testimonial(name: "David", handle: "@david_ascend", text: "The streak system is addictive in a good way. 45 days in and I've never been more consistent with self-improvement."),
    Testimonial(name: "Alex", handle: "@alex_level_up", text: "Finally an app that takes looksmaxxing seriously. The AI analysis showed me exactly what to focus on."),
    Testimonial(name: "Ryan", handle: "@ryan_results", text: "My posture has improved dramatically. People at work commented that I seem more confident now."),
    Testimonial(name: "Chris", handle: "@chris_gains", text: "The best investment I've made. Clear skin, better jawline, and actual confidence - not just hoping for it."),
    Testimonial(name: "Mike", handle: "@mike_ascend", text: "Went from avoiding cameras to actually taking selfies. That's the real transformation.")
]

// MARK: - Problem Carousel Slide
struct ProblemSlide: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let body: String
    let isRecovery: Bool
    
    init(id: Int, icon: String, title: String, body: String, isRecovery: Bool = false) {
        self.id = id
        self.icon = icon
        self.title = title
        self.body = body
        self.isRecovery = isRecovery
    }
}

let problemSlides: [ProblemSlide] = [
    ProblemSlide(id: 1, icon: "brain.head.profile", title: "Your brain is wired for comparison", body: "Social media has hijacked your dopamine system, making you constantly compare yourself to filtered, edited images."),
    ProblemSlide(id: 2, icon: "iphone", title: "The algorithm feeds your insecurity", body: "Every scroll shows you 'perfect' faces, triggering comparison loops that destroy your self-image."),
    ProblemSlide(id: 3, icon: "arrow.triangle.2.circlepath", title: "The cycle destroys confidence", body: "Compare → Feel bad → Check mirror → Compare again. This loop keeps you stuck and anxious."),
    ProblemSlide(id: 4, icon: "chart.bar.xaxis", title: "Most don't realize the damage", body: "70% of young men report appearance anxiety. You're not alone, but most never break the cycle."),
    ProblemSlide(id: 5, icon: "leaf.arrow.circlepath", title: "Recovery is possible", body: "With structured daily habits and proper guidance, you can rewire your brain and build real confidence.", isRecovery: true)
]

// MARK: - Feature Value Prop
struct FeatureValueProp: Identifiable {
    let id: Int
    let icon: String
    let title: String
    let description: String
}

let featureValueProps: [FeatureValueProp] = [
    FeatureValueProp(id: 1, icon: "waveform.path.ecg", title: "AI-Powered Analysis", description: "Advanced facial scanning identifies your unique strengths and areas for improvement."),
    FeatureValueProp(id: 2, icon: "flame.fill", title: "Streak System", description: "Build unbreakable habits with our proven daily routine and streak tracking."),
    FeatureValueProp(id: 3, icon: "chart.line.uptrend.xyaxis", title: "Track Your Progress", description: "Visual progress tracking so you can see your transformation over time."),
    FeatureValueProp(id: 4, icon: "person.3.fill", title: "Join 12,000+ Users", description: "A community of men committed to becoming their best selves.")
]
