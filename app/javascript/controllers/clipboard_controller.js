import { Controller } from "@hotwired/stimulus"

// Copies the source field's value (or data-clipboard-text) to the clipboard
// and briefly confirms on the button.
export default class extends Controller {
  static targets = ["source", "button"]

  async copy() {
    const text = this.hasSourceTarget ? this.sourceTarget.value : this.element.dataset.clipboardText
    try {
      await navigator.clipboard.writeText(text)
    } catch {
      if (this.hasSourceTarget) {
        this.sourceTarget.select()
        document.execCommand("copy")
      }
    }
    this.confirm()
  }

  confirm() {
    if (!this.hasButtonTarget) return
    const label = this.buttonTarget.textContent
    this.buttonTarget.textContent = "Copied!"
    setTimeout(() => { this.buttonTarget.textContent = label }, 1500)
  }
}
