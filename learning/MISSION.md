# Mission: Rust Ownership, Borrowing, Lifetimes & Smart Pointers

## Why
You're working through this repo's rustlings exercises as an experienced Java/Kotlin developer. Initial blocker was understanding `&`, `&mut`, `*`, and lifetime annotations — Java/Kotlin references look similar but follow completely different rules. Now expanding to smart pointers (`Box`, `Rc`, `RefCell`) to understand when and why Rust code uses heap allocation and shared ownership instead of plain references.

## Success looks like

### Foundation (completed)
- Explain in one sentence why `&s1` in Rust is not the same thing as an object reference in Java/Kotlin
- Predict whether a snippet compiles under the borrow checker's aliasing-XOR-mutability rule, without running `rustc`
- Add `&`, `&mut`, or `*` to fix a compile error deliberately — not by guessing until it builds
- Read `fn longest<'a>(x: &'a str, y: &'a str) -> &'a str` and explain what `'a` constrains
- Complete `exercises/06_move_semantics/*.rs` and `exercises/16_lifetimes/*.rs` unaided

### Smart Pointers (current focus)
- Explain why `Box<T>` exists when stack allocation is cheaper (relate to Java's `new` but with single ownership)
- Know when to use `Box` vs `&` (recursive types, trait objects, large values)
- Understand `Rc<T>` for shared ownership and how it differs from Java's reference counting via GC
- Understand `RefCell<T>` for interior mutability and how it differs from Java's mutable fields
- Complete `exercises/19_smart_pointers/*.rs` unaided

## Constraints
- Learning happens inside this rustlings repo; lessons live under `learning/` (not the workspace root)
- Sessions are likely short and interleaved with actually running `rustlings` / `rustc` on the exercises
- Prior background: strong Java and Kotlin experience, first real exposure to a non-garbage-collected ownership model

## Out of scope (for now)
- `unsafe` Rust
- Async lifetimes, trait object lifetimes (`dyn Trait + 'a`)
- Advanced smart pointer patterns (`Weak<T>`, `Cow<T>`, custom smart pointers)
