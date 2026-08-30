# Mission: Rust Ownership, Borrowing & Lifetimes

## Why
You're working through this repo's rustlings exercises as an experienced Java/Kotlin developer, and you're stuck on the exercises that involve `&`, `&mut`, `*`, and lifetime annotations (`exercises/06_move_semantics/*.rs`, `exercises/16_lifetimes/*.rs`). Java/Kotlin references and Rust references *look* similar but follow completely different rules, and that false-familiarity is the actual blocker. The goal is to replace the Java/Kotlin reference mental model with Rust's ownership model, so you can read and write borrowed function signatures deliberately instead of by trial-and-error compiler-appeasement.

## Success looks like
- Explain in one sentence why `&s1` in Rust is not the same thing as an object reference in Java/Kotlin
- Predict whether a snippet compiles under the borrow checker's aliasing-XOR-mutability rule, without running `rustc`
- Add `&`, `&mut`, or `*` to fix a compile error deliberately — not by guessing until it builds
- Read `fn longest<'a>(x: &'a str, y: &'a str) -> &'a str` and explain what `'a` constrains
- Complete `exercises/06_move_semantics/*.rs` and `exercises/16_lifetimes/*.rs` unaided

## Constraints
- Learning happens inside this rustlings repo; lessons live under `learning/` (not the workspace root)
- Sessions are likely short and interleaved with actually running `rustlings` / `rustc` on the exercises
- Prior background: strong Java and Kotlin experience, first real exposure to a non-garbage-collected ownership model

## Out of scope (for now)
- Smart pointers (`Box`, `Rc`, `RefCell`) — revisit once plain `&`/`&mut`/lifetimes are solid
- `unsafe` Rust
- Async lifetimes, trait object lifetimes (`dyn Trait + 'a`)
