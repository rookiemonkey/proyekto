class HTMLElementToaster {
  initialize() {
    this.hideTimeout = null;
    this.element = document.createElement("div");
    this.element.className = "toast";
    document.body.appendChild(this.element);
  }

  showMessage = (message, state) => {
    clearTimeout(this.hideTimeout);
    this.element.textContent = message;
    this.element.className = "toast toast--visible";

    if (state) {
      this.element.classList.add(`toast--${state}`);
    }

    this.hideTimeout = setTimeout(() => {
      this.element.classList.remove("toast--visible");
    }, 3000);
  }
}

window.HTMLElementToaster = HTMLElementToaster