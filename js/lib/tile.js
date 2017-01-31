class Tile {
  constructor(isBomb) {
    this.value = isBomb ? "b" : undefined;
    this.revealed = false;
    this.flagged = false;
  }

  reveal () {
    this.unflag();
    this.revealed = true;
  }

  flag () {
    this.flagged = true;
  }

  unflag () {
    this.flagged = false;
  }

  isEmpty() {
    return (this.value === 0);
  }

  isBomb() {
    return (this.value === "b");
  }

  public() {
    if (this.flagged) return "f";
    if (!this.revealed) return "o";
    if (this.isBomb()) return "b";
    return value;
  }
}
