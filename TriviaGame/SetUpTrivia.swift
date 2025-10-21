//
//  SetUpTrivia.swift
//  TriviaGame
//
//  Created by Jesus Casasanta on 10/20/25.
//


import SwiftUI


struct SetUpTrivia: View {
    
    @State private var category: String = ""
    @State private var numberOfQuestions: Int = 0
    @State private var difficulty: Double = 0
    
    @State private var type: String = ""
    @State private var startTrivia: Bool = false
    @State private var timerDuration: Int = 30
    
    let timerOptions = [30, 60, 180]
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Trivia Game")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                    
                }//HStack
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                
                
                Form {
                    TextField(numberOfQuestions == 0 ? "Enter number of questions" : "", value: $numberOfQuestions, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    Picker("Category of questions", selection: $category) {
                        Text("Sports").tag("Sports")
                        Text("Mythology").tag("Mythology")
                        Text("Music").tag("Music")
                        Text("Movies").tag("Movies")
                        Text("Literature").tag("Literature")
                        Text("General Knowledge").tag( "General Knowledge")
                        Text("Books").tag("Books")
                        Text("Television").tag("Television")
                        Text("Video Games").tag("Video Games")
                        Text("Science & Nature").tag("Science & Nature")
                        Text("Computers").tag("Computers")
                        Text("Mathematics").tag("Mathematics")
                        Text("Geography").tag("Geography")
                        Text("History").tag("History")
                        Text("Politics").tag("Politica")
                        Text("Art").tag("Art")
                        Text("Celebrities").tag("Celebrities")
                        Text("Animals").tag("Animals")
                        Text("Vehicles").tag("Vehicles")
                        Text("Comics").tag("Comics")
                        Text("Gadgets").tag("Gadgets")
                        Text("Cartoons & Animations").tag("Cartoons & Animations")
                    }
                    
                    HStack {
                        Text("Difficulty: \(difficultyLevel)")
                        Slider(value: $difficulty, in: 0...100, step: 1)
                    }
                    
                    //Type of questions
                    Picker("Type of questions", selection: $type){
                        Text("True or False").tag("True or False")
                        Text("Multiple Choice").tag("Multiple Choice")
                    }
                    Picker("Timer Duration (seconds)", selection: $timerDuration) {
                        ForEach(timerOptions, id: \.self) { time in
                            Text("\(time) seconds").tag(time)
                        }
                    }
                    
                    
                }
                Spacer()
                Button("Start Trivia") {
                    if let url = GameLogic.createURL(amount: numberOfQuestions, category: category, difficulty: difficultyLevel, type: type) {
                        print("Trivia URL: \(url)")
                        startTrivia = true
                        
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundStyle(Color.white)
                .navigationDestination(isPresented: $startTrivia) {
                    TriviaView(
                        numberOfQuestions: numberOfQuestions, category: category, difficulty: difficultyLevel, type: type, timerDuration: timerDuration
                    )
                }
            }//VStack
        }
    }
    
    var difficultyLevel: String {
        switch difficulty {
        case 0..<33.33:
            return "Easy"
        case 33..<66.66:
            return "Medium"
        default:
            return "Hard"
        }
    }
    
    
}




#Preview {
    SetUpTrivia()
}
