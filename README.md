constructor() {
    manager = msg.sender;
    lotteryId = 1;
}

function enter() public payable {
    require(msg.value == 0.01 ether, "Entry fee is 0.01 ETH");
    players.push(msg.sender);
}

function getPlayers() public view returns (address[] memory) {
    return players;
}

function pickWinner() public restricted {
    require(players.length > 0, "No players entered");
    uint winnerIndex = random() % players.length;
    address winner = players[winnerIndex];
    lastWinner = winner;
    lotteryHistory[lotteryId] = winner;
    lotteryId++;
    payable(winner).transfer(address(this).balance);
    players = new address[](0); // ✅ Correct way to reset the dynamic array
}

function getLastWinner() public view returns (address) {
    return lastWinner;
}

function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
}

modifier restricted() {
    require(msg.sender == manager, "Only the manager can call this function");
    _;
}

![image](https://github.com/user-attachments/assets/daeaec5a-251a-413c-ac62-a964533d6ebe)

