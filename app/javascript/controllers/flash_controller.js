import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "flashContainer", "messageContainer" ]

  connect() {
  }

  hide(event) {
    this.messageContainerTarget.parentNode.removeChild(this.messageContainerTarget)

  }
}
