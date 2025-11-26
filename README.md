# SwLibTidy

## About

This Xcode project delivers the `SwLibTidy` library for LibTidy development on
any platform that supports the Swift language and the Swift Package Manager.
It’s a native Swift wrapper for HTML Tidy (LibTidy), and is a nearly purely
procedural and mostly faithful wrapper of the C library, with native
Swift types and some convenient replacements.

## SwLibTidy

`SwLibTidy` proper is the procedural wrapper for `LibTidy` (referred to as
`CLibTidy` within this project). As it consists of Swift top-level functions,
this is not useful in Objective-C. In most cases, developers will prefer to use
the `TidyKit` and associated classes, which are available as a separate library
(or will be, someday).

## Package.swift

This library is released as a Swift Package Manager library, and is nominally
self-contained. The LibTidy source code is brought in as a Git submodule, and
SwiftPM will fetch the contents automatically as required. You'll still have
to pull upstream updates as desired, though.

LibTidy is fetched from the `next` (development) branch. As this is the active
next version development branch, there is not API or ABI stability guarantee.
In general, however, the API is source-stable, and you should have no problems
rebuilding this library from source.

## Testing

The included XCTests are intended to run SwLibTidy through its API, but **also**
provide close to 100% API coverage (not code coverage!) of LibTidy. Thus it’s
likely that this library will eventually be part of the automated integration
strategy for upstream HTML Tidy.

## Usage

### TidyKit Library

Here's a basic example of how to use `TidyKit` to clean an HTML string:

```swift
import TidyKit

let html = "<h1>Hello, world!</b>"

Task {
    do {
        let result = try await TidyKit.clean(html: html)
        print(result.tidyHtml)
        // Prints:
        // <!DOCTYPE html>
        // <html>
        // <head>
        // <title></title>
        // </head>
        // <body>
        // <h1>Hello, world!</h1>
        // </body>
        // </html>

        for message in result.messages {
            print("\(message.level): \(message.message)")
        }
    } catch {
        print("An error occurred: \(error)")
    }
}
```

### Command-Line Tool

This package also includes a command-line tool named `Console`. You can use it to tidy HTML from standard input.

**Build the tool:**

```bash
swift build
```

**Usage:**

```bash
echo "<h1>Mismatched tag" | .build/debug/Console
```

This will output the tidied HTML to standard output and any diagnostic messages to standard error.
