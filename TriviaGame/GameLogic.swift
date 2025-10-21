//
//  GameLogic.swift
//  TriviaGame
//
//  Created by Jesus Casasanta on 10/20/25.
//
import Foundation

struct GameLogic {
    
    // Build URL dynamically based on user inputs
    static func createURL(amount: Int, category: String, difficulty: String, type: String) -> URL? {
        var components = URLComponents(string: "https://opentdb.com/api.php")
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "amount", value: "\(amount)")
        ]
        
        // Add category code (OpenTDB uses numeric codes)
        if let categoryCode = categoryMapping[category] {
            queryItems.append(URLQueryItem(name: "category", value: "\(categoryCode)"))
        }
        
        // Add difficulty if not empty
        if !difficulty.isEmpty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty.lowercased()))
        }
        
        // Add type if not empty
        if !type.isEmpty {
            let typeValue = type == "Multiple Choice" ? "multiple" : "boolean"
            queryItems.append(URLQueryItem(name: "type", value: typeValue))
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    // Map categories to OpenTDB codes
    static let categoryMapping: [String: Int] = [
        "General Knowledge": 9,
        "Books": 10,
        "Movies": 11,
        "Music": 12,
        "Television": 14,
        "Video Games": 15,
        "Science & Nature": 17,
        "Computers": 18,
        "Mathematics": 19,
        "Mythology": 20,
        "Sports": 21,
        "Geography": 22,
        "History": 23,
        "Politics": 24,
        "Art": 25,
        "Celebrities": 26,
        "Animals": 27,
        "Vehicles": 28,
        "Comics": 29,
        "Gadgets": 30,
        "Cartoons & Animations": 32
    ]
    

    // 1. Create structs for decoding OpenTDB JSON
    struct TriviaResponse: Codable {
        let response_code: Int
        let results: [Question]
    }

    struct Question: Codable, Identifiable {
        let id = UUID()
        let category: String
        let type: String
        let difficulty: String
        let question: String
        let correct_answer: String
        let incorrect_answers: [String]
    }

    // 2. Fetch questions function
    func fetchQuestions(amount: Int, category: String, difficulty: String, type: String, completion: @escaping ([Question]?) -> Void) {
        guard let url = GameLogic.createURL(amount: amount, category: category, difficulty: difficulty, type: type) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error:", error ?? "")
                completion(nil)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.results)
                }
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
}
