# Learning Record: Mission Expansion to Include Smart Pointers

**Date**: 2026-08-31  
**Context**: After completing foundation lessons on ownership, borrowing, and lifetimes

## What Changed
Mission expanded from "Ownership, Borrowing & Lifetimes" to include smart pointers (`Box`, `Rc`, `RefCell`). These were previously marked "out of scope" until the foundation was solid.

## Why the Expansion
User explicitly requested to learn about `Box`, indicating readiness to move beyond plain references. The rustlings repo includes `exercises/19_smart_pointers/` which is the natural next step after completing move semantics and lifetimes exercises.

## Key Insight for Teaching
Smart pointers will be taught by contrasting with Java's heap allocation model:
- Java: `new Object()` creates heap object, GC manages lifetime, references are freely copyable
- Rust `Box<T>`: heap allocation with single ownership, no GC, Box itself moves like any owned value
- This contrast helps leverage Java experience while highlighting Rust's ownership rules

## What This Means for Future Lessons
- Lesson 0005+ will cover `Box`, `Rc`, `RefCell` in that order
- Each smart pointer lesson should relate back to Java mental model (heap allocation, reference counting, mutability)
- Smart pointer lessons should tie directly to `exercises/19_smart_pointers/*.rs`
