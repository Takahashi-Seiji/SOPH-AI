import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="generate-lecture"
export default class extends Controller {
  static targets = [ "generateLectureForm" ]

  connect() {
    console.log("Hello, Stimulus!", this.element);
  }

  displayGenerateLectureForm() {
    console.log("Hey display lect summ form");
    this.generateLectureFormTarget.classList.toggle("d-none");
  }

}
