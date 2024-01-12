import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["conversationDisplay", "messageContent"]
  static values = ["chat_id"]

  connect() {
    console.log("Hello, Stimulus From Chat!");
  }

  message(event) {
    event.preventDefault()
    const messageContent = this.messageContentTarget.value
    const messageElement = document.createElement("p")
    messageElement.innerHTML = `<strong>Student:</strong> ${messageContent}`
    this.conversationDisplayTarget.appendChild(messageElement)
    this.messageContentTarget.value = ""
    console.log(event);
    // this.createDBMessage(messageContent)
  }

  createDBMessage(messageContent) {
    fetch("/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ content: messageContent })
    })
      .then(response => response.json())
      .then((data) => {
        this.appendMessage(data.message.content, "user")
        this.appendMessage(data.ai_message.content, "assistant")
      })
  }
}
