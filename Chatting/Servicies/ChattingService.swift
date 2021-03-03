//
//  ChattingService.swift
//  Chatting
//
//  Created by Yuriy Balabin on 20.12.2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Starscream

protocol ChattingServiceProtocol {
    var inputMessages: BehaviorRelay<[Message]> { get }
    func connect(user: User)
    func send(_ message: Message, completion: @escaping (RequestResult<Bool>) -> Void)
    func getAllUsers(completion: @escaping (RequestResult<[User]>) -> Void)
}

class ChattingService: ChattingServiceProtocol {
  
    private var request: URLRequest
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    var socket: WebSocket!
    var isConnected = false
    
    var inputMessages = BehaviorRelay<[Message]>(value: [])
    
    init() {
        self.request = URLRequest(url: URL(string: "ws://localhost:8080/chat")!)
    }
    
    func connect(user: User) {
      
        request.setValue("\(user.username)", forHTTPHeaderField: "user")
        socket = WebSocket(request: request)
        
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
    
    func send(_ message: Message, completion: @escaping (RequestResult<Bool>) -> Void) {

        do {
            let messageData = try encoder.encode(message)
            socket.write(data: messageData, completion: nil)
        } catch(let error) {
            print(error)
        }
    }
    
    
    func getAllUsers(completion: @escaping (RequestResult<[User]>) -> Void) {
        
       let path = "http://localhost:8080/api/users"
        guard let url = URL(string: path) else {
          fatalError()
        }
        
        let getAllRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: getAllRequest) { data, response, _ in
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure)
                    return
                }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: jsonData)
               completion(.success(users))
           } catch {
               completion(.failure)
           }
           
        }
        dataTask.resume()
    }
    
    
}


extension ChattingService: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
       
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            do {
                let message = try decoder.decode(MessageContent.self, from: data)
            
                switch message {
                case .handshake(let hs):
                    shakes.append(hs)
                    print(hs)
                case .message(let message):
                    print(message)
                    inputMessages.accept([message])
                }
                
            } catch(let error) {
                print(error)
            }
            
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
           // handleError(error)
        }
    }
    
    
    
}


