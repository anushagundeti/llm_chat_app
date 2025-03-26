import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'input', 'messages' ]

  connect() {
    this.scrollToBottom()
  }

  resetForm(event) {
    // Clear input after successful submission
    this.inputTarget.value = ''
    
    // Scroll to bottom of chat
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      const messagesContainer = this.messagesTarget
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }
}