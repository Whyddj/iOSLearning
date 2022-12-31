//
//  gptRequest.swift
//  Chat with GPT
//
//  Created by 王浩源 on 2022/12/31.
//

import Foundation

let url = URL(string: "https://api.openai.com/v1/completions")!



func requestGPT (prompt: String, completion:@escaping (String) -> Void) {
    var request = URLRequest(url: url)
    
    var responseText: String = ""
    
    request.httpMethod = "POST"
    
    let requestData = "{\"prompt\": \"\(prompt)\", \"max_tokens\": 128, \"model\": \"text-davinci-003\"}".data(using: .utf8)!
    request.httpBody = requestData
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let decodedresponse = try? JSONDecoder().decode(Response.self, from: data!) {
            responseText = decodedresponse.choices[0].text
        }
        if let error = error {
            responseText = "Error: \(error)"
        }
        completion(responseText)
    }.resume()
}

struct Response: Codable {
    // var id: String
    // var object: String
    // var created: Int
    // var model: String
    var choices: [Choice]
    // var usage: Usage
}

struct Choice: Codable {
    var text: String
    // var index: Int
    // var logprobs: [Int]?
    // var finish_reason: String
}

//struct Usage: Codable {
//    var prompt_tokens: Int
//    var completion_tokens: Int
//    var total_tokens: Int
//}
//
