import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "show", "dialog" ]

  show(event) {
    event.preventDefault()
    this.dialogTarget.classList.toggle("is-active", true)
  }

  hide(event) {
    event.preventDefault()
    this.dialogTarget.classList.toggle("is-active", false)
  }
}
