import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "tab", "panel" ]

  change(event) {
    this.index = this.tabTargets.indexOf(event.currentTarget)
  }

  initialize() {
    this.showTab()
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const panel = this.panelTargets[index]
      console.log(panel.getAttribute("href"))
      history.pushState("changetab", panel.getAttribute("title"), panel.getAttribute("href"))
      tab.classList.toggle("is-active", index == this.index)
      panel.classList.toggle("is-hidden", index != this.index)
    })
  }

  get index() {
    return parseInt(this.data.get("index") || 0)
  }

  set index(value) {
    this.data.set("index", value)
    this.showTab()
  }
}
