/* Shared quiz widget for lessons. Usage:
<div class="quiz" data-correct="b">
  <p class="quiz-q">Question text?</p>
  <button class="quiz-opt" data-choice="a">Option A text here</button>
  <button class="quiz-opt" data-choice="b">Option B text here</button>
  <button class="quiz-opt" data-choice="c">Option C text here</button>
  <p class="quiz-feedback" hidden></p>
</div>
Feedback text is read from data-feedback-correct / data-feedback-wrong on the .quiz div, or defaults are used.
*/
(function () {
  function initQuiz(quiz) {
    var correct = quiz.dataset.correct;
    var feedback = quiz.querySelector(".quiz-feedback");
    var opts = quiz.querySelectorAll(".quiz-opt");

    opts.forEach(function (opt) {
      opt.addEventListener("click", function () {
        opts.forEach(function (o) {
          o.disabled = true;
          o.classList.remove("quiz-correct", "quiz-wrong");
        });

        var chosen = opt.dataset.choice;
        var isCorrect = chosen === correct;

        opt.classList.add(isCorrect ? "quiz-correct" : "quiz-wrong");
        if (!isCorrect) {
          var correctOpt = quiz.querySelector('[data-choice="' + correct + '"]');
          if (correctOpt) correctOpt.classList.add("quiz-correct");
        }

        if (feedback) {
          var msg = isCorrect
            ? quiz.dataset.feedbackCorrect || "Right."
            : quiz.dataset.feedbackWrong || "Not quite — see the highlighted answer.";
          feedback.textContent = msg;
          feedback.hidden = false;
          feedback.className = "quiz-feedback " + (isCorrect ? "quiz-feedback-good" : "quiz-feedback-bad");
        }
      });
    });
  }

  document.querySelectorAll(".quiz").forEach(initQuiz);
})();
