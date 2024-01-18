import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "quizContainer", "summaryContainer", "quizCarousel" ]

  connect() {
  }

  generateQuiz(event) {
    event.preventDefault();
    this.quizContainerTarget.classList.remove('d-none');
    this.summaryContainerTarget.classList.add('d-none');
    fetch(`/lectures/${event.target.dataset.lectureId}/quizzes`, {
       method: 'POST',
       headers: {
         'Content-Type': 'application/json',
         "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
       },
       body: JSON.stringify({ lecture_id: event.target.dataset.lectureId })
     })
     .then(response => response.text())
     .then((html) => {
      this.quizContainerTarget.innerHTML = html;
     })
     .catch((error) => {
       console.error('Error:', error);
     });
  }

  nextQuestion(event) {
    event.preventDefault();
    let activeItem = this.quizCarouselTarget.querySelector('.carousel-item.active');
    let carouselItems = Array.from(this.quizCarouselTarget.querySelectorAll('.carousel-item'));
    let isLastItem = carouselItems.indexOf(activeItem) >= 9;

    if (!isLastItem) {
      activeItem.classList.remove('active');
      carouselItems[carouselItems.indexOf(activeItem) + 1].classList.add('active');
    } else {
      this.quizContainerTarget.classList.add('d-none');
    }
  }
}
