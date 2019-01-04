//
//  main.swift
//  ServerMonitor
//
//  Created by 20eml5 on 1/4/19.
//  Copyright © 2019 20eml5. All rights reserved.
//

import Foundation
import TuvioMacOSServer

print("Hello, World!")

let port = 1337
let server = EchoServer(port: port)
print("Swift Echo Server Sample")
print("Connect with a command line window by entering 'telnet ::1 \(port)'")

server.run()
