//
//  Matcher.swift
//  Mocky
//
//  Created by Andrzej Michnia on 25.10.2017.
//

import Foundation

/// Matcher is container class, responsible for storing and resolving comparators for given types.
public class Matcher {
    /// Shared **Matcher** instance
    public static var `default` = Matcher()
    private var matchers: [(Mirror,Any)] = []

    /// Create new clean matcher instance.
    public init() {
        registerBasicTypes()
        register(GenericAttribute.self) { [unowned self] (a, b) -> Bool in
            return a.compare(a.value,b.value,self)
        }
    }

    /// Creante new matcher instance, copying existing comparator from another instance.
    ///
    /// - Parameter matcher: other matcher instance
    public init(matcher: Matcher) {
        self.matchers = matcher.matchers
    }

    /// Registers array comparators for all basic types, their optional versions
    /// and arrays containing elements of that type. For all of them, no manual
    /// registering of comparator is needed.
    ///
    /// We defined basic types as:
    ///
    /// - Bool
    /// - String
    /// - Float
    /// - Double
    /// - Character
    /// - Int
    /// - Int8
    /// - Int16
    /// - Int32
    /// - Int64
    /// - UInt
    /// - UInt8
    /// - UInt16
    /// - UInt32
    /// - UInt64
    ///
    /// Called automatically in every Matcher init.
    ///
    internal func registerBasicTypes() {
#if swift(>=4.1)
        register([Bool].self)
        register([String].self)
        register([Float].self)
        register([Double].self)
        register([Character].self)
        register([Int].self)
        register([Int8].self)
        register([Int16].self)
        register([Int32].self)
        register([Int64].self)
        register([UInt].self)
        register([UInt8].self)
        register([UInt16].self)
        register([UInt32].self)
        register([UInt64].self)
        register([Data].self)
        register([Bool?].self)
        register([String?].self)
        register([Float?].self)
        register([Double?].self)
        register([Character?].self)
        register([Int?].self)
        register([Int8?].self)
        register([Int16?].self)
        register([Int32?].self)
        register([Int64?].self)
        register([UInt?].self)
        register([UInt8?].self)
        register([UInt16?].self)
        register([UInt32?].self)
        register([UInt64?].self)
        register([Data?].self)

        // Types
        register(Bool.self)
        register(String.self)
        register(Float.self)
        register(Double.self)
        register(Character.self)
        register(Int.self)
        register(Int8.self)
        register(Int16.self)
        register(Int32.self)
        register(Int64.self)
        register(UInt.self)
        register(UInt8.self)
        register(UInt16.self)
        register(UInt32.self)
        register(UInt64.self)
        register(Data.self)
        register(Bool?.self)
        register(String?.self)
        register(Float?.self)
        register(Double?.self)
        register(Character?.self)
        register(Int?.self)
        register(Int8?.self)
        register(Int16?.self)
        register(Int32?.self)
        register(Int64?.self)
        register(UInt?.self)
        register(UInt8?.self)
        register(UInt16?.self)
        register(UInt32?.self)
        register(UInt64?.self)
        register(Data?.self)
#else
        register([Bool].self)
        register([String].self)
        register([Float].self)
        register([Double].self)
        register([Character].self)
        register([Int].self)
        register([Int8].self)
        register([Int16].self)
        register([Int32].self)
        register([Int64].self)
        register([UInt].self)
        register([UInt8].self)
        register([UInt16].self)
        register([UInt32].self)
        register([UInt64].self)
        register([Data].self)
        register([Bool?].self)
        register([String?].self)
        register([Float?].self)
        register([Double?].self)
        register([Character?].self)
        register([Int?].self)
        register([Int8?].self)
        register([Int16?].self)
        register([Int32?].self)
        register([Int64?].self)
        register([UInt?].self)
        register([UInt8?].self)
        register([UInt16?].self)
        register([UInt32?].self)
        register([UInt64?].self)
        register([Data?].self)
#endif

        // Types
        register(Any.Type.self) { _, _ in return true }
        register(Bool.Type.self)
        register(String.Type.self)
        register(Float.Type.self)
        register(Double.Type.self)
        register(Character.Type.self)
        register(Int.Type.self)
        register(Int8.Type.self)
        register(Int16.Type.self)
        register(Int32.Type.self)
        register(Int64.Type.self)
        register(UInt.Type.self)
        register(UInt8.Type.self)
        register(UInt16.Type.self)
        register(UInt32.Type.self)
        register(UInt64.Type.self)
        register(Data.Type.self)
        register(Any?.Type.self) { _, _ in return true }
        register(Bool?.Type.self)
        register(String?.Type.self)
        register(Float?.Type.self)
        register(Double?.Type.self)
        register(Character?.Type.self)
        register(Int?.Type.self)
        register(Int8?.Type.self)
        register(Int16?.Type.self)
        register(Int32?.Type.self)
        register(Int64?.Type.self)
        register(UInt?.Type.self)
        register(UInt8?.Type.self)
        register(UInt16?.Type.self)
        register(UInt32?.Type.self)
        register(UInt64?.Type.self)
        register(Data?.Type.self)
    }

    /// Registers comparator for given type **T**.
    ///
    /// Comparator is a closure of `(T,T) -> Bool`.
    ///
    /// When several comparators for same type  are registered to common
    /// **Matcher** instance - it will resolve the most receont one.
    ///
    /// - Parameters:
    ///   - valueType: compared type
    ///   - match: comparator closure
    public func register<T>(_ valueType: T.Type, match: @escaping (T,T) -> Bool) {
        let mirror = Mirror(reflecting: valueType)
        matchers.append((mirror, match as Any))
    }

    /// Registers comparator for type, like comparing Int.self to Int.self. These types of comparators always returns true
    ///
    /// - Parameter valueType: Type.Type.self
    public func register<T>(_ valueType: T.Type.Type) {
        self.register(valueType, match: { _, _ in return true })
    }

#if swift(>=3.2)
    /// Register sequence comparator, based on elements comparing.
    ///
    /// - Parameters:
    ///   - valueType: Sequence type
    ///   - match: Element comparator closure
    public func register<T,E>(_ valueType: T.Type, match: @escaping (E,E) -> Bool) where T: Sequence, E == T.Element {
        let mirror = Mirror(reflecting: E.self)
        matchers.append((mirror, match as Any))
        register(T.self) { (l: T, r: T) -> Bool in
            let lhs = l.map { $0 }
            let rhs = r.map { $0 }
            guard lhs.count == rhs.count else { return false }

            for i in 0..<lhs.count {
                guard match(lhs[i],rhs[i]) else { return false }
            }

            return true
        }
    }
#else
    /// Register sequence comparator, based on elements comparing.
    ///
    /// - Parameters:
    ///   - valueType: Sequence type
    ///   - match: Element comparator closure
    public func register<T>(_ valueType: T.Type, match: @escaping (T.Iterator.Element,T.Iterator.Element) -> Bool) where T: Sequence {
        let mirror = Mirror(reflecting: T.Iterator.Element.self)
        matchers.append((mirror, match as Any))
        register(T.self) { (l: T, r: T) -> Bool in
            let lhs = l.map { $0 }
            let rhs = r.map { $0 }
            guard lhs.count == rhs.count else { return false }

            for i in 0..<lhs.count {
                guard match(lhs[i],rhs[i]) else { return false }
            }

            return true
        }
    }
#endif

    /// Register default comparatot for Equatable types. Required for generic mocks to work.
    ///
    /// - Parameter valueType: Equatable type
    public func register<T>(_ valueType: T.Type) where T: Equatable {
        let mirror = Mirror(reflecting: valueType)
        matchers.append((mirror, comparator(for: T.self) as Any))
    }

    /// Returns comparator closure for given type (if any).
    ///
    /// Comparator is a closure of `(T,T) -> Bool`.
    ///
    /// When several comparators for same type  are registered to common
    /// **Matcher** instance - it will resolve the most receont one.
    ///
    /// - Parameter valueType: compared type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? {
        let mirror = Mirror(reflecting: valueType)
        let comparator = matchers.reversed().first { (current, _) -> Bool in
            return current.subjectType == mirror.subjectType
        }?.1

        return comparator as? (T,T) -> Bool
    }

#if swift(>=3.2)
    /// Default Sequence comparator, compares count, and then element by element.
    ///
    /// - Parameter valueType: Sequence type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Sequence {
        let mirror = Mirror(reflecting: valueType)
        let comparator = matchers.reversed().first { (current, _) -> Bool in
            return current.subjectType == mirror.subjectType
        }?.1

        if let compare = comparator as? (T,T) -> Bool {
            return compare
        } else if let compare = self.comparator(for: T.Element.self) {
            return { (l: T, r: T) -> Bool in
                let lhs = l.map { $0 }
                let rhs = r.map { $0 }
                guard lhs.count == rhs.count else { return false }

                for i in 0..<lhs.count {
                    guard compare(lhs[i],rhs[i]) else { return false }
                }

                return true
            }
        } else {
            return nil
        }
    }
#else
    /// Default Sequence comparator, compares count, and then element by element.
    ///
    /// - Parameter valueType: Sequence type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Sequence {
        let mirror = Mirror(reflecting: valueType)
        let comparator = matchers.reversed().first { (current, _) -> Bool in
            return current.subjectType == mirror.subjectType
        }?.1

        if let compare = comparator as? (T,T) -> Bool {
            return compare
        } else if let compare = self.comparator(for: T.Iterator.Element.self) {
            return { (l: T, r: T) -> Bool in
                let lhs = l.map { $0 }
                let rhs = r.map { $0 }
                guard lhs.count == rhs.count else { return false }

                for i in 0..<lhs.count {
                    guard compare(lhs[i],rhs[i]) else { return false }
                }

                return true
            }
        } else {
            return nil
        }
    }
#endif

    /// Default Equatable comparator, compares if elements are equal.
    ///
    /// - Parameter valueType: Equatable type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Equatable {
        return { $0 == $1 }
    }

    /// Default Equatable Sequence comparator, compares count, and then for every element equal element.
    ///
    /// - Parameter valueType: Equatable Sequence type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Equatable, T: Sequence {
        return { $0 == $1 }
    }
}

