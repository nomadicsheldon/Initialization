import UIKit

// Setting initial value for stored properties

// initializers

//init() {
//    // perform some initialization here
//}

struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}

var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Farenheit")

// default property values

struct FahrenheitDefault {
    var temperature = 32.0
}

//-----------------------------------------------------------------------------------------------//

// Customizing initialization

// initialization parameters

struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}

let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
print("boiling point of water \(boilingPointOfWater)")
print("boiling point of water \(freezingPointOfWater)")

// Parameter Names and argument labels

struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)

//let halfGreen = Color(0.0, 1.0, 0.0) // thisw reports a compile-time error - arugument labels are required.

// Initializer Parameters without argument labels

struct CelsiusExtended {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    
    init(_ celsius: Double) {
        self.temperatureInCelsius = celsius
    }
}

let bodyTemprature = CelsiusExtended(37.0)

// Optional property types

class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    
    func ask() {
        print(text)
    }
}

let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."

// Assigning constant properties during initialization

class SurveyQuestionConstant {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    
    func ask() {
        print(text)
    }
}

let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beet."

//-----------------------------------------------------------------------------------------------//

// Default Initializers

class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}

var item = ShoppingListItem()

// Memberwise initializers for structure Types

struct Size {
    var width = 0.0, height = 0.0
}

let twoByTwo = Size(width: 2.0, height: 2.0)

let zeroByTwo = Size(height: 2.0)

let zeroByZero = Size()

//-----------------------------------------------------------------------------------------------//

// Initializer Delegation for value Types

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        //        origin = Point(x: originX, y: originY)
        //        self.size = size
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))

//-----------------------------------------------------------------------------------------------//

// Class inheritance and initialization

// Designed Initializers and convenience initializers

// - syntax for designated and convenience initializers

// designated
//init( parameter ) {
//    statements
//}

//convenience init( parameter ) {
//    statement
//}

// Initializer delegation for Class Types

/*
 To simplify the relationships between designated and convenience initializers, swift applies the following three rules for delegation calls between initialzers:
 
 Rule 1
 A designated initializer must call a designated initializer from its immediate superclass.
 
 Rule 2
 A convenience initializer must call another initializer from the same class.
 
 Rule 3
 A convenience initializer must ultimately call a designated initializer.
 
 A simple way to remember this is:
 * Designated initializers must always delegate up.
 * Convenience initializers must always delegate across.
 
 */

// Two-Phase initialization

/*
 class initialization in swift is a two-phase process. In the first phase, each stored property is assigned an initial value by the class
 that introduced it. Once the initial state of every stored property has been determined, the second phase begins, and each class is given the opportunity to customize its stored properties further before the new instance is considered ready for use.
 
 Swift's compiler performs four helpful safety-checks to make sure that two-phase initialization is completed without error:
 
 Safety check 1 -
 A designated initializer must ensure that all of the properties introduced by its class are initialized before it delegate up to the superclass initializer.
 
 safety check 2 -
 A designated initialzer must delegate up to a superclass initializer before assigning a value to an inherited property. If it doesn't, the new value the designated initializer assigns will be overwritten by the superclass as part of its own initialization.
 
 safety check 3 -
 A convenience initializer must delegate to another initializer before assigning a value to any property.
 
 safety check 4 -
 An initializer can't call any instance methods, read the values of any instance property, or refer to self as a value until after the first phase of initialization is complete.
 
 Here's how two-phase initialization plays out, based on the four safety checks above:
 
 Phase 1
 * A designated and convenience initializer is called on a class.
 * Memory for new instance of that class is allocated. The memory in not yet initialized.
 * A designated initialzer for that class conforms that all stored properties introduced by that class have a value. The memory for these stored properties is now initialized.
 * The designated initializer hands off to a superclass initializer to perform the same task for its own stored properties.
 * This continues up the class inheritance chain until the top of the chain is reached.
 * Once the top of the chain is reached, and the final class in the chain has ensured that all of its stored properties have a value, the instance's memory is considered to be fully initialized, and phase 1 is complete.
 
 Phase 2
 * Working back down from the top of the chain, each designated initializer in the chain has the option to customize the instance further. Initializers are now able to access self and can modify its properties, call its instance method, and so on.
 * Finally, any convenience initializers in the chain have the option to customize the instance and to work with self.
 
 */

// Initializer inheritance and overriding


class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")

class Bicycle: Vehicle {
    override init() {
        super.init() // call the default initializer for superclass.
        numberOfWheels = 2
    }
}

let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")

class Hoverboard: Vehicle {
    var color: String
    init(color: String) {
        self.color = color
    }
    
    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}

let hoverboard = Hoverboard(color: "silver")
print("Hoverboard: \(hoverboard.description)")

//-----------------------------------------------------------------------------------------------//

// Automatic Initializer inheritance

/*
 Assuming that you provide default value for any new properties you introduce in a subclass, the following two rules apply:
 
 Rule 1 -
 If your subclass doesn't define any designated initializers, it automatically inherits all of its superclass designated initializers.
 
 Rule 2 -
 If your subclass provides an implementation of all of its superclass designated initializers - either by inheriting them as per rule 1, or by providing a custom implementation as part of its definition- then it automatically inherits all of the superclass convenience initializers.
 
 */

// Designated and convenience initializers action

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

let namedMeat = Food(name: "Bacon")

let mysteryMeat = Food()

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

let oneMysteryItem = RecipeIngredient()
let oneBecon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

class ShoppingListItemClass: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? "yes" : "no"
        return output
    }
}

var breakfastList = [ShoppingListItemClass(), ShoppingListItemClass(name: "Bacon"), ShoppingListItemClass(name: "Eggs", quantity: 6)]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

//-----------------------------------------------------------------------------------------------//

// Failable initializers

// init?

let wholeNumber = 12345.0
let pi = 3.14159

if let valueMaintained = Int(exactly: wholeNumber) {
    print("\(wholeNumber) conversion to int maintains value of \(valueMaintained)")
}

let valueChanged = Int(exactly: pi)

if valueChanged == nil {
    print("\(pi) conversion to int does not maintain value")
}

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil
        }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe")

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")

if anonymousCreature == nil {
    print("The anonymous creature chould not be initialized.")
}

// Failable initializers for enumerations

enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")

if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

// Failable initializers for Enumerations with Raw Values

enum TemperatureUnitRaw: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}

let fUnit = TemperatureUnitRaw(rawValue: "F")
if fUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknow = TemperatureUnitRaw(rawValue: "X")
if unknow != nil {
    print("This is not a defined temperature unit, so initialization failed.")
}


// Propagation of initialization Failure

class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}

if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quntity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}

if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}

// Overriding a failable initializer

class Document {
    var name: String?
    init() {}
    
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    
    override init?(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Unnamed]"
        } else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}

/*
 The init! Failable initializer
 syntax - init!
 */

//-----------------------------------------------------------------------------------------------//

// Required Initializers

class SomeClass {
    var name: String
    required init() {
        name = "default"
        // Initializer implementation goes here
    }
    
    required init(name: String) {
        self.name = name
    }
}

class SomeSubClass: SomeClass {
    var age: Int
    init(age: Int) {
        self.age = age
        super.init(name: "Himanshu")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(name: String) {
        fatalError("init(name:) has not been implemented")
    }
}

let someSubClass = SomeSubClass(age: 28)

//-----------------------------------------------------------------------------------------------//

// Setting a default property value with a closure or function

/*
 class SomeClass {
 let someProperty: SomeType = {
 // create a default value for someProperty inside this closure
 // someValue must be of the same type as SomeType
 return someValue
 }()
 }
 */

struct Chessboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row*8) + column]
    }
}

let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))
print(board.squareIsBlackAt(row: 7, column: 7))
