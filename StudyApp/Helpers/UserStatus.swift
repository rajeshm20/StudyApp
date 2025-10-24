enum UserStatus: Codable {
    case active
    case inactive(reason: String)
    case suspended(until: Date, reason: String)
    case banned(permanently: Bool)
    
    enum CodingKeys: String, CodingKey {
        case type
        case reason
        case until
        case permanently
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "active":
            self = .active
        case "inactive":
            let reason = try container.decode(String.self, forKey: .reason)
            self = .inactive(reason: reason)
        case "suspended":
            let until = try container.decode(Date.self, forKey: .until)
            let reason = try container.decode(String.self, forKey: .reason)
            self = .suspended(until: until, reason: reason)
        case "banned":
            let permanently = try container.decode(Bool.self, forKey: .permanently)
            self = .banned(permanently: permanently)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown user status type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .active:
            try container.encode("active", forKey: .type)
        case .inactive(let reason):
            try container.encode("inactive", forKey: .type)
            try container.encode(reason, forKey: .reason)
        case .suspended(let until, let reason):
            try container.encode("suspended", forKey: .type)
            try container.encode(until, forKey: .until)
            try container.encode(reason, forKey: .reason)
        case .banned(let permanently):
            try container.encode("banned", forKey: .type)
            try container.encode(permanently, forKey: .permanently)
        }
    }
}

// This handles JSON like:
// {"type": "active"}
// {"type": "inactive", "reason": "User requested deactivation"}
// {"type": "suspended", "until": "2025-09-01T00:00:00Z", "reason": "Terms violation"}
// {"type": "banned", "permanently": true}