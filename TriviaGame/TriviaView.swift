import SwiftUI

public struct TriviaView: View {
    public init(numberOfQuestions: Int, category: String, difficulty: String, type: String, timerDuration: Int ) {
        self.numberOfQuestions = numberOfQuestions
        self.category = category
        self.difficulty = difficulty
        self.type = type
        self.timerDuration = timerDuration
    }
    
    // Passed from SetUpTrivia
    let numberOfQuestions: Int
    let category: String
    let difficulty: String
    let type: String
    let timerDuration: Int
    
    
    
    // State to store questions
    @State private var questions: [GameLogic.Question] = []
    @State private var correctNumberOfAnswers: Int = 0
    @State private var showAlert = false
    @State private var selectedAnswers: [UUID: String] = [:]
    @State private var showCorrectAnswers = false
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil
    @State private var shuffledAnswerDict: [UUID: [String]] = [:]
    @Environment(\.dismiss) private var dismiss
    
    
    public var body: some View {
        ZStack {
            // Fondo
            Color.green.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            //            ScrollView{
            VStack {
                // Título arriba
                Text("Time Left: \(timeRemaining) sec")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                
                //                Spacer()
                
                // Form centrado
                Form {
                    ForEach(questions) { question in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(question.question)
                                .font(.headline)
                            let answerLabels = ["A.", "B.", "C.", "D."]
                            ForEach(Array((shuffledAnswerDict[question.id] ?? []).enumerated()), id: \.element) { index, answer in
                                Button(action: {
                                    selectedAnswers[question.id] = answer
                                }) {
                                    HStack {
                                        Text("\(answerLabels[index]) \(answer)")
                                        Spacer()
                                        if showCorrectAnswers && answer == question.correct_answer {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        }
                                    }
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(selectedAnswers[question.id] == answer ? Color.gray.opacity(0.2) : Color.clear)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                HStack {
                    Button("Submit") {
                        stopTimer()
                        correctNumberOfAnswers = questions.filter { question in
                            selectedAnswers[question.id] == question.correct_answer
                        }.count
                        showCorrectAnswers = true
                        showAlert = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .alert("Trivia Submitted!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("You got \(correctNumberOfAnswers) correct answers.")
                }
                
            }
            .padding()
            
            
          
        }
        .onAppear {
            GameLogic().fetchQuestions(amount: numberOfQuestions, category: category, difficulty: difficulty, type: type) { result in
                if let result = result {
                    self.questions = result
                    for question in result {
                        self.shuffledAnswerDict[question.id] = shuffledAnswers(for: question)
                    }
                    startTimer()
                }
            }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // Helper to shuffle correct and incorrect answers
    func shuffledAnswers(for question: GameLogic.Question) -> [String] {
        var allAnswers = question.incorrect_answers
        allAnswers.append(question.correct_answer)
        return allAnswers.shuffled()
    }

    func startTimer() {
        timeRemaining = timerDuration
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                showCorrectAnswers = true
                showAlert = true
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    TriviaView(numberOfQuestions: 5, category: "Sports", difficulty: "Easy", type: "Multiple Choice", timerDuration: 30)
}
