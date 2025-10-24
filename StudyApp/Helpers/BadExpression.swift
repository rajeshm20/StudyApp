// ❌ This won't compile - infinite size
enum BadExpression {
    case number(Int)
    case addition(BadExpression, BadExpression) // Error: recursive enum case
}

// ✅ This works - indirect cases are heap-allocated
indirect enum Expression {
    case number(Int)
    case addition(Expression, Expression)
    case multiplication(Expression, Expression)
    case subtraction(Expression, Expression)
    case division(Expression, Expression)
    
    func evaluate() -> Int {
        switch self {
        case .number(let value):
            return value
        case .addition(let left, let right):
            return left.evaluate() + right.evaluate()
        case .multiplication(let left, let right):
            return left.evaluate() * right.evaluate()
        case .subtraction(let left, let right):
            return left.evaluate() - right.evaluate()
        case .division(let left, let right):
            return left.evaluate() / right.evaluate()
        }
    }
}

// You can build complex expressions:
let expression = Expression.addition(
    .multiplication(.number(2), .number(3)),
    .division(.number(10), .number(2))
)
print(expression.evaluate()) // Prints: 11