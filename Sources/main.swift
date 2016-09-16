import Vapor
import HTTP
import Foundation

let VALIDATION_TOKEN = "SKYNET"
let ACCESS_TOKEN = ""

let drop = Droplet()

drop.get("/hello") { _ in
    return "Hello T200"
}

drop.get("fbwebhook") { request -> ResponseRepresentable in
    
    guard let token = request.data["hub.verify_token"]?.string else {
        return Response(status: .badRequest, body: "Token is nil")
    }
    
    guard let mode = request.data["hub.mode"]?.string else {
        return Response(status: .badRequest, body: "Not subscribe mode")
    }
    
    guard let response = request.data["hub.challenge"]?.string else {
        return Response(status: .badRequest, body: "Response is nil")
    }
    
    guard mode == "subscribe" && token == VALIDATION_TOKEN else {
        return Response(status: .other(statusCode: 403, reasonPhrase: "Failed validation. Make sure the validation tokens match."), body: "Failed validation. Make sure the validation tokens match.")
    }

    return Response(status: .ok, body: response)
}

drop.post("fbwebhook") { request -> ResponseRepresentable in
    
    return Response(status: .ok, body: "The request has succeeded.")
}

drop.serve()
