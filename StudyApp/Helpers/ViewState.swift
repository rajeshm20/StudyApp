// ✅ Use enums for state machines
enum ViewState {
    case loading
    case loaded([Item])
    case error(Error)
    case empty
}

// ✅ Use enums for mutually exclusive data
enum MediaContent {
    case image(UIImage)
    case video(URL)
    case audio(URL, duration: TimeInterval)
}

// ✅ Use enums for configuration options
enum CachePolicy {
    case never
    case memory(maxSize: Int)
    case disk(maxAge: TimeInterval)
    case hybrid(memorySize: Int, diskAge: TimeInterval)
}

// ❌ Don't use enums when you need inheritance
// ❌ Don't use enums when all cases need the same stored properties
// ❌ Don't use enums when you need reference semantics
