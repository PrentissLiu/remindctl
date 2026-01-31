<div align="center">
  <img src="https://img.shields.io/badge/Swift-6.2+-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.2+">
  <img src="https://img.shields.io/badge/platform-macOS%2013+-blue?style=for-the-badge" alt="macOS 13+">
  <a href="https://github.com/steipete/Commander/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/steipete/Commander/ci.yml?style=for-the-badge&label=tests" alt="CI Status"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="MIT License"></a>

  # Commander

  **Swift-first parsing. Total command over your CLI.**<br>
  **One signature. Infinite tooling.**<br>
  **All the ergonomics, none of the forks.**
</div>

Commander is Peekaboo's Swift-native command-line framework. It combines declarative property wrappers, a lightweight parser/router, and runtime helpers that integrate tightly with async/await + approachable concurrency.

## Highlights

- **Property-wrapper ergonomics** – `@Option`, `@Argument`, `@Flag`, and `@OptionGroup` mirror the Swift Argument Parser API but simply register metadata. You keep writing declarative commands while Commander handles parsing and validation centrally.
- **Command signatures everywhere** – `CommandSignature` reflects every option/flag/argument so docs, help output, agent metadata, and tests all rely on the exact same definitions.
- **Program router** – `Program.resolve(argv:)` walks the descriptor tree (root command → subcommand → default subcommand) and produces a `CommandInvocation` with parsed values and the fully-qualified path.
- **Binder APIs** – `CommanderCLIBinder` (living in PeekabooCLI) shows how to hydrate existing command structs by conforming them to `CommanderBindableCommand`. This keeps runtime logic untouched while swapping in Commander incrementally.
- **Approachable concurrency ready** – the package enables `StrictConcurrency`, `ExistentialAny`, and `NonisolatedNonsendingByDefault` so anything that depends on Commander inherits Peekaboo's concurrency guarantees.

## Getting Started

Add Commander as a local dependency (it currently lives in `/Commander` inside the Peekaboo repo):

```swift
// Package.swift
dependencies: [
    .package(path: "../Commander"),
    // ...
],
targets: [
    .executableTarget(
        name: "my-cli",
        dependencies: [
            .product(name: "Commander", package: "Commander")
        ]
    )
]
```

Then declare your command using the familiar property-wrapper style:

```swift
import Commander

@MainActor
struct ScreenshotCommand: ParsableCommand {
    @Argument(help: "Output path") var path: String
    @Option(help: "Target display index") var display: Int?
    @Flag(help: "Emit JSON output") var json = false

    static var configuration = CommandConfiguration(
        commandName: "capture",
        abstract: "Capture a screenshot"
    )

    mutating func run() async throws {
        // perform work…
    }
}
```

Then run it like any SwiftPM executable:

```bash
$ swift run capture --display 1 --json /tmp/screen.png
```

Commander handles `--help`, flag parsing, and error messages based on the metadata in your struct.

If you need more control over how parsed values reach your command type, conform to `CommanderBindableCommand` and use the helper APIs (`decodeOption`, `makeFocusOptions`, etc.). PeekabooCLI's window/agent commands are good examples.

## Repository Layout

- `Sources/Commander` – Core types (property wrappers, tokenizer, parser, program descriptors, metadata helpers).
- `Tests/CommanderTests` – Unit tests for the parser/router plus tokenizer edge cases. Run them with `swift test --package-path Commander`.

## Options & Flags Support

Commander mirrors the ergonomics of Swift Argument Parser while keeping the parsing logic centralized. Key building blocks:

| Wrapper | Description | Notable Parameters |
| --- | --- | --- |
| `@Argument` | Positional values. Commander automatically enforces optionals/non-optionals. | `help` |
| `@Option` | Named options (supports short, long, and custom spellings). | `name`, `names`, `parsing` (`singleValue`, `upToNextOption`, `remaining`) |
| `@Flag` | Boolean switches. Commander automatically wires both short & long spellings. | `name`, `names`, `help` |
| `@OptionGroup` | Reusable sets of options/flags (e.g., focus/window option structs). | – |

Every command automatically gets the standard runtime flags `--verbose` / `-v` and `--json-output`, courtesy of `CommandSignature.withStandardRuntimeFlags()`.

`OptionParsingStrategy` mirrors the most common CLI behaviors:

- `singleValue`: exactly one argument follows the option (default).
- `upToNextOption`: consume all values until the next option/flag (perfect for `--include foo bar`).
- `remaining`: consume the rest of `argv` (after `--`).

For advanced scenarios, `CommanderBindableValues` gives you helpers (`decodeOption`, `requireOption`, `makeWindowOptions`, etc.) so existing command types can conform to `CommanderBindableCommand` and hydrate themselves from parsed values without rewriting runtime logic.

## Contributing

If you need an API or notice a bug, open an issue/PR in https://github.com/steipete/Commander. Please include repro steps and any command metadata involved so we can extend the shared test suites.

## License

Commander is released under the MIT license. Refer to `LICENSE` for details.
