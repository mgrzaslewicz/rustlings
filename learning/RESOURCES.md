# Rust Ownership/Borrowing/Lifetimes Resources

## Knowledge

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

## Wisdom (Communities)

- [users.rust-lang.org](https://users.rust-lang.org)
  Official user forum, high signal, very beginner-friendly — explicitly welcomes "why doesn't this compile" questions. Use for: getting unstuck on a specific borrow-checker error with your own code.
- [r/rust](https://reddit.com/r/rust)
  Large, moderated, good for broader "is this idiomatic" questions once past the basics.

Not yet confirmed whether you want to actually join either — noting them here for when a question needs real-world wisdom rather than an explainer.

## Gaps
- No resource yet for smart-pointer ownership (`Rc`/`RefCell`) — out of scope per `MISSION.md` until later.
