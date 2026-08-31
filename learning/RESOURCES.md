# Rust Ownership/Borrowing/Lifetimes/Smart Pointers Resources

## Knowledge

### Foundation (Ownership, Borrowing, Lifetimes)
- [The Rust Book — ch4.2 "References and Borrowing"](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
  The primary source for `&` and `&mut`, and the aliasing-XOR-mutability rule. Use for: lessons 1 and 2.
- [The Rust Book — ch10.3 "Validating References with Lifetimes"](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html)
  Primary source for `'a` syntax, the `longest` example, and elision rules. Use for: lesson 4.
- [The Rust Book — ch8.1 "Storing Lists of Values with Vectors"](https://doc.rust-lang.org/book/ch08-01-vectors.html)
  Listing 8-8 is the canonical minimal example of `*` used to mutate through a `&mut` reference. Use for: lesson 3.
- In-repo: `exercises/06_move_semantics/*.rs` and `solutions/06_move_semantics/*.rs`
  The mission's direct practice ground for `&` vs owned values.
- In-repo: `exercises/16_lifetimes/*.rs` and `solutions/16_lifetimes/*.rs`
  The mission's direct practice ground for lifetime annotations.
- [The Rustonomicon — "Ownership"](https://doc.rust-lang.org/nomicon/ownership.html)
  Deeper, more precise treatment for when the Book's version feels hand-wavy. Use for: follow-up questions once lessons 1–4 are done, not first pass.

### Smart Pointers
- [The Rust Book — ch15 "Smart Pointers"](https://doc.rust-lang.org/book/ch15-00-smart-pointers.html)
  Primary source for `Box<T>`, `Rc<T>`, `RefCell<T>`, and when to use each. Includes the cons list example.
- [The Rust Book — ch15.1 "Using Box to Point to Data on the Heap"](https://doc.rust-lang.org/book/ch15-01-box.html)
  Specific deep-dive on `Box<T>`: recursive types, trait objects, large values. Use for: lesson 5 (Box).
- [The Rust Book — ch15.4 "Rc, the Reference Counted Smart Pointer"](https://doc.rust-lang.org/book/ch15-04-rc.html)
  Primary source for `Rc<T>` and shared ownership patterns.
- [The Rust Book — ch15.5 "RefCell and Interior Mutability"](https://doc.rust-lang.org/book/ch15-05-interior-mutability.html)
  Primary source for `RefCell<T>` and the interior mutability pattern.
- In-repo: `exercises/19_smart_pointers/*.rs` and `solutions/19_smart_pointers/*.rs`
  The mission's direct practice ground for smart pointers.

## Wisdom (Communities)

- [users.rust-lang.org](https://users.rust-lang.org)
  Official user forum, high signal, very beginner-friendly — explicitly welcomes "why doesn't this compile" questions. Use for: getting unstuck on a specific borrow-checker error with your own code.
- [r/rust](https://reddit.com/r/rust)
  Large, moderated, good for broader "is this idiomatic" questions once past the basics.

Not yet confirmed whether you want to actually join either — noting them here for when a question needs real-world wisdom rather than an explainer.

## Gaps
- No resource yet for advanced smart pointer patterns (`Weak<T>`, `Cow<T>`, custom smart pointers) — out of scope per `MISSION.md`.
