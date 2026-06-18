import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Drag-to-reorder. On drop, PATCHes the moved item's new position to the server.
// Expects the url value to contain the literal "ID" placeholder.
export default class extends Controller {
  static values = { url: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: ".drag-handle",
      animation: 150,
      onEnd: (event) => this.persist(event)
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  persist(event) {
    const id = event.item.dataset.id
    if (!id || event.oldIndex === event.newIndex) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(this.urlValue.replace("ID", id), {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "application/json"
      },
      body: JSON.stringify({ property: { position: event.newIndex + 1 } })
    })
  }
}
