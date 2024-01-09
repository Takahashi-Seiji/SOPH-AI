import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lecture"
export default class extends Controller {
  static targets = ["code", "editForm", "notes", "noteForm", "noteContent"]

  connect() {
    console.log("Hello, Stimulus!")


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
    event.preventDefault()

    const note = this.notesTarget
    const noteContent = this.noteContentTarget.value


    const noteElement = document.createElement("h3")
    noteElement.innerHTML = noteContent
    note.appendChild(noteElement)
  }
}
