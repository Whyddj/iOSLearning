//
//  ContentView.swift
//  Chat with GPT
//
//  Created by 王浩源 on 2022/12/29.
//

import SwiftUI

struct ContentView: View {
    @State var chatMessage = [
        ChatMessage(sender: "GPT", message: "I'm text-davinci-003, you can ask me anything!")]
    @State var newMessage: String = ""
    
    var body: some View {
        VStack {
            ChatFlowView(messages: chatMessage)
            InputView(chatMessage: $chatMessage, newMessage: $newMessage)
        }
    }
}

struct InputView: View {
    @Binding var chatMessage: [ChatMessage]
    @Binding var newMessage: String
    
    var body: some View {
        HStack {
            TextField("", text: self.$newMessage)
                .padding(10)
                .border(.gray, width: 3)
                .cornerRadius(4)
                .padding(.leading)
            Button(action: {
                chatMessage.append(ChatMessage(sender: "Me", message: newMessage))
                requestGPT(prompt: newMessage){ data in
                    chatMessage.append(ChatMessage(sender: "GPT", message: data))
                }
                newMessage = ""
            }) {
                Text("Send")
                    .padding(.horizontal)
            }
        }
    }
}

struct ChatFlowView: View {
    var messages: [ChatMessage]
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView (showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(messages, id: \.self) { message in
                        SingleChatMessageView(singleMessage: message).onAppear() {
                            scrollView.scrollTo(message)
                        }
                    }
                }
            }.background(Color.gray)
        }
    }
}



struct SingleChatMessageView: View {
    var singleMessage: ChatMessage
    var body: some View {
        HStack {
            VStack {
                Image(systemName: singleMessage.sender == "Me" ? "person.circle.fill" : "circle.hexagongrid.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                Spacer()
            }
                
            Text(singleMessage.message)
                .padding()
                .background(singleMessage.sender == "Me" ? Color.blue : Color.white)
                .cornerRadius(20)
                .foregroundColor(singleMessage.sender == "Me" ? .white : .black)
            Spacer()
        }
        .environment(\.layoutDirection, singleMessage.sender == "Me" ? .rightToLeft : .leftToRight)
        .padding(10)
    }
}

struct ChatMessage: Hashable{
    var sender: String
    var message: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
