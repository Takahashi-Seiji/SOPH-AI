import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "generateQuizButton", "loadingButton", "quizContainer", "fakeQuizContainer", "code", "editForm", "notes", "noteForm", "noteContent", "editNoteForm", "addNoteButton"]

  connect() {
  }

  toggleLoadingMessage() {
    this.generateQuizButtonTarget.classList.add("d-none")
    this.loadingButtonTarget.classList.remove("d-none")
  }

  toggleQuiz() {
    this.fakeQuizContainerTarget.classList.toggle("d-none")
  }

  displayCode(event) {
    event.preventDefault()
    const code = this.codeTarget
    code.classList.toggle("d-none")
  }

  displayEditForm(event) {
    event.preventDefault()
    const editForm = this.editFormTarget
    editForm.classList.toggle("d-none")
  }

  displayNoteForm(event) {
    event.preventDefault()
    const noteForm = this.noteFormTarget
    noteForm.classList.toggle("d-none")
  }

  addNote(event) {
    const note = this.notesTarget
    const noteContent = this.noteContentTarget.value
    const noteElement = document.createElement("h3")
    noteElement.innerHTML = noteContent
    note.appendChild(noteElement)
    this.addNoteButtonTarget.classList.add("d-none")
  }

  displayEditNoteForm(event) {
    event.preventDefault()
    const editNoteForm = this.editNoteFormTarget
    editNoteForm.classList.toggle("d-none")
  }
}
