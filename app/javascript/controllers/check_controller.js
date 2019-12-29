import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "tcpForm", "httpForm", "cronForm", "heartbeatForm" ]

  connect() {
    this.hideAuth = true
  }

  hide() {
    this.tcpFormTarget.classList.add("is-hidden")
    this.httpFormTarget.classList.add("is-hidden")
    this.cronFormTarget.classList.add("is-hidden")
  }

  pick(event) {
    event.preventDefault()
    const element = event.target
    const checkType = element.dataset.checkType
    this.hide()

    switch (checkType) {
      case "tcp":
        this.tcpFormTarget.classList.remove("is-hidden")
        break;
      case "http":
        this.httpFormTarget.classList.remove("is-hidden")
        break;
      case "heartbeat":
        this.heartbeatFormTarget.classList.remove("is-hidden")
        break;
    }
  }

  toggleAuth() {
    this.hideAuth = !this.hideAuth
  }
}
