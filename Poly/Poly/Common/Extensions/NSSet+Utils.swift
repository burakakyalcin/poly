import Foundation

extension NSSet {
  func toArray<T>() -> [T] {
      let array = self.compactMap({ $0 as? T})
      return array
  }
}
