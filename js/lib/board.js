// const Tile = require("./tile.js");

class Board {
  constructor (rows, cols, numBombs) {
    this._grid = Tile.makeGrid(rows, cols, numBombs);
    this._populateCounts();
  }

  static deltas () {
    return [[-1, -1],
            [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 0],
            [1, 1]];
  }

  revealBombs () {
    this._flatGrid.forEach((tile) => {
      if (tile.isBomb()) tile.reveal();
    });
  }

  reveal (pos) {
    let tile = this.getPos(pos);
    tile.reveal();
    if (tile.isEmpty()) {
      let neighbors = this.neighbors(pos);
      neighbors.forEach((neighbor) => {
        if (!this.getPos(neighbor).revealed) this.reveal(neighbor);
      });
    } else if (tile.isBomb()) {
      this.revealBombs();
      return true;
    }
    return false;
  }

  flag (pos) {
    this.getPos(pos).flag();
  }

  unflag (pos) {
    this.getPos(pos).unflag();
  }

  _populateCounts () {
    this._grid.forEach((row, rowIdx) => {
      row.forEach((tile, colIdx) => {
        if (!tile.isBomb()) {
          tile.value = this._countBombNeighbors([rowIdx, colIdx]);
        }
      });
    });
  }

  _countBombNeighbors (pos) {
    let numBombNeighbors = 0;
    let neighborTiles = this.neighbors(pos).map(this.getPos.bind(this));
    neighborTiles.forEach((tile) => {
      if (tile.isBomb()) numBombNeighbors++;
    });
    return numBombNeighbors;
  }

  isValid (pos) {
    return (pos[0] >= 0
      && pos[0] < this._grid.length
      && pos[1] >= 0
      && pos[1] < this._grid[0].length);
  }

  render () {
    this.publicGrid().forEach((row) => {
      console.log(row.join(""));
    });
  }

  publicGrid () {
    return this._grid.map((row) => {
      return row.map((tile) => {
        return tile.public();
      });
    });
  }

  isWon () {
    let isWon = true;
    this._flatGrid().forEach((tile) => {
      if (!(tile.revealed || tile.isBomb())) isWon = false;
    });
    return isWon;
  }

  /* Returns a one-dimensional version of the grid for ease of iteration.
  */
  _flatGrid () {
    let flattened = [];
    this._grid.forEach((row) => {
      flattened = flattened.concat(row);
    });
    return flattened;
  }

  neighbors (pos) {
    let neighbors = [];
    Board.deltas().forEach((delta) => {
      let newPos = [pos[0] + delta[0], pos[1] + delta[1]];
      if (this.isValid(newPos)) neighbors.push(newPos);
    });
    return neighbors;
  }

  getPos (pos) {
    return this._grid[pos[0]][pos[1]];
  }
}
