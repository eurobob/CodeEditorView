//
//  TextView.swift
//  
//
//  Created by Manuel M T Chakravarty on 28/09/2020.
//
//  Text view protocol that extracts common functionality between 'UITextView' and 'NSTextView'.

import Foundation


// MARK: -
// MARK: The protocol

/// A protocol that bundles up the commonalities of 'UITextView' and 'NSTextView'.
///
protocol TextView {
  associatedtype Color
  associatedtype Font

  var optLayoutManager: NSLayoutManager? { get }
  var optTextContainer: NSTextContainer? { get }
  var optTextStorage:   NSTextStorage?   { get }

  var textBackgroundColor: Color? { get }
  var textFont:            Font? { get }
  var textContainerOrigin: CGPoint { get }

  /// If the current selection is an insertion point, return its location.
  var insertionPoint: Int? { get }

  /// The visible portion of the text view. (This only accounts for portions of the text view that are obscured through
  /// visibility in a scroll view.
  var documentVisibleRect: CGRect { get }
}

extension TextView {
  var optLineMap: LineMap<LineInfo>? {
    return (optTextStorage?.delegate as? CodeStorageDelegate)?.lineMap
  }
}


#if os(iOS)

// MARK: -
// MARK: UIKit version

import UIKit

extension UITextView: TextView {
  typealias Color = UIColor
  typealias Font  = UIFont

  var optLayoutManager: NSLayoutManager? { layoutManager }
  var optTextContainer: NSTextContainer? { textContainer }
  var optTextStorage:   NSTextStorage?   { textStorage }

  var textBackgroundColor: Color? { backgroundColor }
  var textFont:            Font? { font }
  var textContainerOrigin: CGPoint { return CGPoint(x: textContainerInset.left, y: textContainerInset.top) }

  var insertionPoint: Int? { selectedRange.length == 0 ? selectedRange.location : nil }

  var documentVisibleRect: CGRect { return bounds }
}


#elseif os(macOS)

// MARK: -
// MARK: AppKit version

import AppKit

extension NSTextView: TextView {
  typealias Color = NSColor
  typealias Font  = NSFont

  var optLayoutManager: NSLayoutManager? { layoutManager }
  var optTextContainer: NSTextContainer? { textContainer }
  var optTextStorage:   NSTextStorage?   { textStorage }

  var textBackgroundColor: Color? { backgroundColor }
  var textFont:            Font? { font }
  var textContainerOrigin: CGPoint { return CGPoint(x: textContainerInset.width, y: textContainerInset.height) }

  var insertionPoint: Int? {
    if let selection = selectedRanges.first as? NSRange, selection.length == 0 { return selection.location }
    else { return nil }
  }

  var documentVisibleRect: CGRect { enclosingScrollView?.documentVisibleRect ?? bounds }
}

#endif