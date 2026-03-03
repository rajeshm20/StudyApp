// import RegexBuilder
//
// let emailPattern = Regex {
//    OneOrMore(.word, .minus, .plus, .period)
//    "@"
//    OneOrMore(.word, .minus, .period)
//    "."
//    OneOrMore(.word)
//    QuantifierRange(2...6)  // TLD length 2-6 chars
// }
//
// func isValidEmail(_ email: String) -> Bool {
//    email.contains(emailPattern)
// }
//
//// Usage
// let testEmails = [
//    "user+tag@example.co.uk",
//    "first.last@sub.domain.com",
//    "invalid@.com",
// ]
