# Learning Record: Rc for Shared Ownership

**Date**: 2026-09-01  
**Lesson**: 0006-rc-shared-ownership.html  
**Zone**: Smart Pointers (building on Box foundation from lesson 5)

## What Was Learned

Created lesson 6 covering `Rc<T>` (Reference Counted smart pointer) for shared ownership in Rust.

### Key Concepts Covered

1. **Why Rc exists**: Single ownership is Rust's default, but some data structures (graphs, shared nodes) need multiple owners. `Rc<T>` enables this via reference counting.

2. **Rc vs Box alignment**:
   - Both heap-allocate
   - `Box<T>`: single owner, moves ownership
   - `Rc<T>`: multiple owners, shared ownership via cloning (cheap pointer copy + count increment)

3. **Java memory model parallels**:
   - Every Java object reference behaves like an invisible `Rc` 
   - GC tracks reachability (similar to ref counting) but via tracing + pauses, not compile-time + deterministic drop
   - Key difference: Java hides this, Rust makes it explicit

4. **Reference counting mechanics**:
   - `Rc::clone(&data)` increments count, copies pointer (cheap)
   - When each `Rc` drops, count decrements
   - Data freed when count reaches zero (deterministic, unlike GC)

5. **Limitations taught**:
   - `Rc<T>` data is immutable by default (multiple owners = can't get `&mut`)
   - Doesn't handle cycles (leaks memory; need `Weak<T>`)
   - Single-threaded only (use `Arc` for thread safety)

## Teaching Approach

- Contrasted with Java throughout (user is Java/Kotlin developer per MISSION.md)
- Built on lesson 5's Box foundation (same structure, quiz format, styling)
- Used graph nodes as the motivating example (classic multi-ownership case)
- Included comparison table: Java GC vs Rust Rc
- Memory layout diagrams to show `Box` vs `Rc` heap structure

## Non-Obvious Insights

1. **`&T` vs `Rc<T>` distinction**: References borrow (can't outlive owner). `Rc` has no single owner — data lives as long as any `Rc` exists. This is dynamic lifetime management, not compile-time borrow checking.

2. **`Rc::clone(&a)` convention**: Always use this instead of `a.clone()` to signal you're bumping a count, not deep-copying. Rust idiom for making cost explicit.

3. **Java parallel**: In Java, every object reference IS shared ownership via GC. In Rust, `&T` is compile-time borrow, `Rc<T>` is runtime shared ownership. This explicit choice prevents hidden GC costs.

## What's Next

User asked about `Rc` specifically. Next natural progression in smart pointers sequence:
- Lesson 7: `RefCell<T>` for interior mutability (solves Rc's immutability limitation)
- Exercise: `exercises/19_smart_pointers/rc1.rs`

## Questions to Revisit

- Does user understand the Rc cycle leak problem? (Mentioned but not deeply explored — could do a follow-up if they ask)
- Thread safety: `Arc` vs `Rc` comparison might be needed later
