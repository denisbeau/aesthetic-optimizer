//
//  OnboardingQuizView.swift
//  LooksmaxxingApp
//
//  Psychological priming onboarding flow - 12 questions
//  Designed to increase paywall conversion through commitment/consistency
//

import SwiftUI

// MARK: - Quiz Data Model

struct QuizQuestion {
    let id: Int
    let question: String
    let options: [String]
    let icon: String
}

class OnboardingQuizData: ObservableObject {
    @Published var answers: [Int: String] = [:]
    
    var primaryGoal: String { answers[1] ?? "Overall improvement" }
    var age: String { answers[2] ?? "18-25" }
    var photoConfidence: String { answers[3] ?? "Sometimes" }
    var struggles: String { answers[4] ?? "" }
    var hasRoutine: String { answers[5] ?? "None" }
    var sleepHours: String { answers[6] ?? "6-7" }
    var willingToCommit: String { answers[7] ?? "Yes" }
    var timeframe: String { answers[8] ?? "1 month" }
    var previousBlocker: String { answers[9] ?? "" }
    var breathingType: String { answers[10] ?? "Nose" }
    var dedicationLevel: Int { Int(answers[11] ?? "7") ?? 7 }
}

// MARK: - Main Quiz View

struct OnboardingQuizView: View {
    @StateObject private var quizData = OnboardingQuizData()
    @State private var currentQuestion = 0
    @State private var showAnalyzing = false
    @State private var selectedOption: String? = nil
    
    let questions: [QuizQuestion] = [
        QuizQuestion(id: 1, question: "What is your primary aesthetic goal?", 
                    options: ["Sharper jawline", "Better skin", "Better facial symmetry", "Overall glow-up"],
                    icon: "target"),
        QuizQuestion(id: 2, question: "How old are you?",
                    options: ["12-16", "16-18", "18-25", "25+"],
                    icon: "calendar"),
        QuizQuestion(id: 3, question: "How often do you feel confident in photos?",
                    options: ["Always", "Sometimes", "Rarely", "I avoid photos"],
                    icon: "camera"),
        QuizQuestion(id: 4, question: "Which of these do you struggle with?",
                    options: ["Mouth breathing", "Poor posture", "Uneven skin", "Receded chin"],
                    icon: "exclamationmark.triangle"),
        QuizQuestion(id: 5, question: "Do you currently follow a grooming routine?",
                    options: ["None", "Basic", "Intermediate", "Advanced"],
                    icon: "sparkles"),
        QuizQuestion(id: 6, question: "How many hours of sleep do you average?",
                    options: ["Less than 6", "6-7 hours", "8+ hours"],
                    icon: "moon.fill"),
        QuizQuestion(id: 7, question: "Are you willing to commit 10 mins/day?",
                    options: ["Yes, I'm ready", "Maybe", "Not sure yet"],
                    icon: "clock"),
        QuizQuestion(id: 8, question: "How soon do you want visible results?",
                    options: ["2 weeks (Intense)", "1 month", "3 months"],
                    icon: "bolt.fill"),
        QuizQuestion(id: 9, question: "What has stopped you from improving before?",
                    options: ["Lack of knowledge", "Consistency issues", "No clear plan", "Just starting"],
                    icon: "questionmark.circle"),
        QuizQuestion(id: 10, question: "Do you breathe through your mouth or nose?",
                    options: ["Nose", "Mouth", "Unsure"],
                    icon: "wind"),
        QuizQuestion(id: 11, question: "How dedicated are you to your glow-up?",
                    options: ["10 - All in", "8-9 - Very dedicated", "6-7 - Motivated", "5 or below"],
                    icon: "flame.fill"),
        QuizQuestion(id: 12, question: "Ready to analyze your facial structure?",
                    options: ["Start AI Analysis"],
                    icon: "faceid")
    ]
    
    var body: some View {
        ZStack {
            // Dark gradient background
            LinearGradient(
                colors: [Color(hex: "0A0A0F"), Color(hex: "12121A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if showAnalyzing {
                AnalyzingView(quizData: quizData)
            } else {
                VStack(spacing: 0) {
                    // Progress bar
                    progressBar
                    
                    Spacer()
                    
                    // Question content
                    questionContent
                    
                    Spacer()
                    
                    // Options
                    optionsSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Progress Bar
    
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Question \(currentQuestion + 1) of \(questions.count)")
                    .font(.caption)
                    .foregroundColor(Color(hex: "6B7280"))
                Spacer()
                Text("\(Int((Double(currentQuestion + 1) / Double(questions.count)) * 100))%")
                    .font(.caption.bold())
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(hex: "1A1A24"))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "00D4FF"), Color(hex: "00A3CC")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * (Double(currentQuestion + 1) / Double(questions.count)), height: 4)
                        .cornerRadius(2)
                }
            }
            .frame(height: 4)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Question Content
    
    private var questionContent: some View {
        let question = questions[currentQuestion]
        
        return VStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "00D4FF").opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: question.icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "00D4FF"))
            }
            
            // Question text
            Text(question.question)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Options Section
    
    private var optionsSection: some View {
        let question = questions[currentQuestion]
        
        return VStack(spacing: 12) {
            ForEach(question.options, id: \.self) { option in
                Button(action: {
                    selectOption(option)
                }) {
                    HStack {
                        Text(option)
                            .font(.body.weight(.medium))
                            .foregroundColor(selectedOption == option ? .white : Color(hex: "E5E7EB"))
                        
                        Spacer()
                        
                        if selectedOption == option {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(hex: "00D4FF"))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedOption == option ? Color(hex: "00D4FF").opacity(0.15) : Color(hex: "1A1A24"))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedOption == option ? Color(hex: "00D4FF") : Color(hex: "2A2A34"), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Actions
    
    private func selectOption(_ option: String) {
        selectedOption = option
        quizData.answers[questions[currentQuestion].id] = option
        
        // Auto-advance after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                if currentQuestion < questions.count - 1 {
                    currentQuestion += 1
                    selectedOption = nil
                } else {
                    // Last question - show analyzing
                    showAnalyzing = true
                }
            }
        }
    }
}

// MARK: - Hex Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    OnboardingQuizView()
}
