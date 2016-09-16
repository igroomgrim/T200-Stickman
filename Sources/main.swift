import Vapor

let drop = Droplet()

drop.get("/hello") { _ in
    return "Hello T200"
}

drop.serve()
