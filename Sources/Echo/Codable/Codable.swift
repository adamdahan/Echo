enum JSON: Decodable, CustomStringConvertible {
    var description: String {
        switch self {
        case .string(let string): return "\"\(string)\""
        case .number(let double):
            if let int = Int(exactly: double) {
                return "\(int)"
            } else {
                return "\(double)"
            }
        case .object(let object):
            return "\(object)"
        case .array(let array):
            return "\(array)"
        case .bool(let bool):
            return "\(bool)"
        case .null:
            return "null"
        }
    }

    var isEmpty: Bool {
        switch self {
        case .string(let string): return string.isEmpty
        case .object(let object): return object.isEmpty
        case .array(let array): return array.isEmpty
        case .null: return true
        case .number, .bool: return false
        }
    }

    struct Key: CodingKey, Hashable, CustomStringConvertible {
        var description: String {
            return stringValue
        }

        static func ==(lhs: JSON.Key, rhs: JSON.Key) -> Bool {
            return lhs.stringValue == rhs.stringValue
        }

        let stringValue: String
        init(_ string: String) { self.stringValue = string }
        init?(stringValue: String) { self.init(stringValue) }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }

    case string(String)
    case number(Double) // FIXME: Split Int and Double
    case object([Key: JSON])
    case array([JSON])
    case bool(Bool)
    case null

    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) { self = .string(string) }
        else if let number = try? decoder.singleValueContainer().decode(Double.self) { self = .number(number) }
        else if let object = try? decoder.container(keyedBy: Key.self) {
            var result: [Key: JSON] = [:]
            for key in object.allKeys {
                result[key] = (try? object.decode(JSON.self, forKey: key)) ?? .null
            }
            self = .object(result)
        }
        else if var array = try? decoder.unkeyedContainer() {
            var result: [JSON] = []
            for _ in 0..<(array.count ?? 0) {
                result.append(try array.decode(JSON.self))
            }
            self = .array(result)
        }
        else if let bool = try? decoder.singleValueContainer().decode(Bool.self) { self = .bool(bool) }
        else {
            self = .null
        }
    }

    var objectValue: [String: JSON]? {
        switch self {
        case .object(let object):
            let mapped: [String: JSON] = Dictionary(uniqueKeysWithValues:
                object.map { (key, value) in (key.stringValue, value) })
            return mapped
        default: return nil
        }
    }

    var arrayValue: [JSON]? {
        switch self {
        case .array(let array): return array
        default: return nil
        }
    }

    subscript(key: String) -> JSON? {
        guard let jsonKey = Key(stringValue: key),
            case .object(let object) = self,
            let value = object[jsonKey]
            else { return nil }
        return value
    }

    var stringValue: String? {
        switch self {
        case .string(let string): return string
        default: return nil
        }
    }

    var doubleValue: Double? {
        switch self {
        case .number(let number): return number
        default: return nil
        }
    }

    var intValue: Int? {
        switch self {
        case .number(let number): return Int(number)
        default: return nil
        }
    }

    subscript(index: Int) -> JSON? {
        switch self {
        case .array(let array): return array[index]
        default: return nil
        }
    }

    var boolValue: Bool? {
        switch self {
        case .bool(let bool): return bool
        default: return nil
        }
    }
}
