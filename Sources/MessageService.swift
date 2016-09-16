import Vapor
import HTTP
import Foundation

let ACCESS_TOKEN = ""

typealias ParserMessageService = (
    pass: Bool,
    recipientID: String?,
    messageText: String?
)

func parseJSONMessage(_ json: JSON) -> ParserMessageService {
    guard let entrys = json["entry"]?.array else {
        return (false, nil, nil)
    }
    
    let entry = entrys[0] as! JSON
    
    guard let messages = entry["messaging"]?.array else {
        return (false, nil, nil)
    }
    
    let messageNode = messages[0] as! JSON
    
    guard let senderJson = messageNode["sender"]?.object else {
        return (false, nil, nil)
    }
    
    guard let senderMsg = messageNode["message"]?.object else {
        return (false, nil, nil)
    }
    
    guard let recipientID = senderJson["id"]?.string else {
        return (false, nil, nil)
    }
    
    guard let message = senderMsg["text"]?.string else {
        return (false, nil, nil)
    }
    
    return (true, recipientID, message)
}

func sendTextMessage(_ messageText: String?, toRecipientID: String?) {
    let url = "https://graph.facebook.com/v2.6/me/messages?access_token=" + ACCESS_TOKEN
    
    guard let recipientID = toRecipientID, let messageText = messageText else {
        print("recipientID or messageText is nil")
        return
    }
    
    let id = ["id": recipientID]
    let message = ["text": messageText]
    
    let botMessage = ["recipient": id,
                      "message": message
    ]

    let jsonData = try! JSONSerialization.data(withJSONObject: botMessage, options: .prettyPrinted)
    
    var urlRequest = URLRequest(url: URL(string: url)!)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = jsonData
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
        if let err = error {
            print(err)
            return
        }
    })
    
    task.resume()
}
