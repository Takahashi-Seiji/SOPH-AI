import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = [ "calendarForm" ]

  connect() {
  }

  displayCalendarForm() {
    const calendarForm = this.calendarFormTarget
    calendarForm.classList.toggle("d-none")
  }
}
