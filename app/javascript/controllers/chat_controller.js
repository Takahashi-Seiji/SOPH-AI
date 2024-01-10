import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["conversationDisplay", "messageContent"]

  connect() {
    console.log("Hello, Stimulus From Chat!");
  }

  message(event) {
    event.preventDefault()
    const messageContent = this.messageContentTarget.value
    const messageElement = document.createElement("p")
    messageElement.innerHTML = messageContent
    this.conversationDisplayTarget.appendChild(messageElement)
    this.messageContentTarget.value = ""
  }
}
