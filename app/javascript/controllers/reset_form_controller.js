import { Controller } from "@hotwired/stimulus"

// Clears the form after a successful Turbo submission.
export default class extends Controller {
  reset(event) {
    if (event.detail.success) this.element.reset()
  }
}
