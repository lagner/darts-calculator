.pragma library

var GROUP_IN_GAME = "В игре";
var GROUP_LOSERS = "На Дне!";

var users;


var DEFAULT_USERS = [
            new User("sergey"),
            new User("michail"),
            new User("vadim")
];


function defaultUsers(id) {
    id.append(DEFAULT_USERS);
}


function User(username) {
    this.name = username || "";
    this.selected = false;
    this.fails = 0;
    this.gameStatus = GROUP_IN_GAME;
    this.self = this;
}
