
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["conversationDisplay", "messageContent"]
  static values = {
    chatId: Number,
    userFirstName: String
  }

  connect() {
    console.log("Hello, Stimulus From Chat!");
  }

  message(event) {
    event.preventDefault()
    const messageContent = this.messageContentTarget.value
    const messageElement = document.createElement("h5")
    messageElement.innerHTML = `<strong class="message-role-user">${this.userFirstNameValue}</strong> ${messageContent}`
    this.conversationDisplayTarget.appendChild(messageElement)
    this.messageContentTarget.value = ""
    console.log(messageContent, this.chatIdValue);

    const thinkingElement = document.createElement("h5")
    thinkingElement.innerHTML = `<strong class="message-role-assistant">SOPHAI:</strong> Thinking...`
    this.conversationDisplayTarget.appendChild(thinkingElement)

    fetch("/messages", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ content: messageContent, chat_id: this.chatIdValue })
    })
      .then(response => response.json())
      .then((data) => {
        this.conversationDisplayTarget.removeChild(thinkingElement)
        this.appendAiResponse(data.ai_message)
      })
  }

  appendAiResponse(messageContent) {
    const messageElement = document.createElement("h5")
    messageElement.innerHTML = `<strong class="message-role-assistant">SOPHAI:</strong> ${messageContent}`
    this.conversationDisplayTarget.appendChild(messageElement)
  }
}
