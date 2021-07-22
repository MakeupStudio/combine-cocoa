//
//  UIScrollView+Combine.swift
//  CombineCocoa
//
//  Created by Joan Disho on 09/08/2019.
//  Copyright © 2020 Combine Community. All rights reserved.
//

#if canImport(Combine) && os(iOS)
  import UIKit
  import CombineExtensions

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  extension PublishersProxy where Base: UIScrollView {

    /// A publisher emitting if the bottom of the UIScrollView is reached.
    ///
    /// - parameter offset: A threshold indicating how close to the bottom of the UIScrollView this publisher should emit.
    ///                     Defaults to 0
    /// - returns: A publisher that emits when the bottom of the UIScrollView is reached within the provided threshold.
    public func reachedBottom(offset: CGFloat = 0) -> AnyPublisher<Void, Never> {
      base.publisher(for: \.contentOffset)
        .map { [weak base] contentOffset -> Bool in
          guard let base = base else { return false }
          let visibleHeight = base.frame.height - base.contentInset.top - base.contentInset.bottom
          let yDelta = contentOffset.y + base.contentInset.top
          let threshold = max(offset, base.contentSize.height - visibleHeight)
          return yDelta > threshold
        }
        .removeDuplicates()
        .filter { $0 }
        .map { _ in () }
        .eraseToAnyPublisher()
    }
  }
#endif
