class Tile {
  constructor(isBomb) {
    this.value = isBomb ? "b" : undefined;
    this.revealed = false;
    this.flagged = false;
  }

  static makeGrid(rows, cols, numBombs) {
    let bombArray = new Array(rows * cols);
    bombArray.fill(false);
    bombArray.fill(true, 0, numBombs);
    function _shuffleBombs() {
      for (let i = bombArray.length; i; i--) {
        let j = Math.floor(Math.random() * i);
        [bombArray[i - 1], bombArray[j]] = [bombArray[j], bombArray[i - 1]];
      }
    }
    _shuffleBombs();
    let grid = [];
    for (let i = 0; i < rows; i++) {
      let row = [];
      for (let j = 0; j < cols; j++) {
        row.push(new Tile(bombArray.pop()));
      }
      grid.push(row);
    }
    return grid;
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
    return this.value;
  }
}
