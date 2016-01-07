.pragma library

var GROUP_IN_GAME = "В игре";
var GROUP_LOSERS = "На Дне!";

var users;

function User(username) {
    this.name = username || "";
    this.selected = false;
    this.fails = 0;
    this.gameStatus = GROUP_IN_GAME;
    this.self = this;
}
