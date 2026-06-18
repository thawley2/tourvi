import { Controller } from "@hotwired/stimulus"

// Toggles a menu panel and closes it on outside click or Escape.
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.closeOnOutside = this.closeOnOutside.bind(this)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
    if (!this.menuTarget.classList.contains("hidden")) {
      document.addEventListener("click", this.closeOnOutside)
    }
  }

  closeOnOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  close() {
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.closeOnOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnOutside)
  }
}
