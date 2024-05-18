let BuildFloorSwitch = 0
let LeftRight = 0
let wall_size = 0
let TopCountdown = 0
function makeWallWithWindows (num: number) {
    agent.setSlot(1)
    for (let index = 0; index < num; index++) {
        agent.setItem(STONE, 1, 1)
        agent.place(FORWARD)
        agent.move(BACK, 1)
    }
    agent.move(UP, 1)
    agent.move(FORWARD, num)
    for (let index = 0; index < 2; index++) {
        for (let index2 = 0; index2 < num / 5; index2++) {
            agent.setItem(STONE, 1, 1)
            agent.place(FORWARD)
            agent.move(BACK, 1)
        }
        for (let index2 = 0; index2 < 2; index2++) {
            for (let index3 = 0; index3 < Math.floor(num / 5); index3++) {
                agent.setItem(LIGHT_GRAY_STAINED_GLASS_PANE, 1, 1)
                agent.place(FORWARD)
                agent.move(BACK, 1)
            }
            for (let index3 = 0; index3 < Math.floor(num / 5); index3++) {
                agent.setItem(STONE, 1, 1)
                agent.place(FORWARD)
                agent.move(BACK, 1)
            }
        }
        agent.move(UP, 1)
        agent.move(FORWARD, num)
    }
    for (let index = 0; index < num; index++) {
        agent.setItem(CHISELED_STONE_BRICKS, 1, 1)
        agent.place(FORWARD)
        agent.move(BACK, 1)
    }
    agent.move(FORWARD, 1)
    agent.turn(LEFT_TURN)
    agent.move(FORWARD, 1)
    agent.turn(LEFT_TURN)
    agent.turn(LEFT_TURN)
    agent.move(DOWN, 4)
}
function makeFloor (num: number) {
    agent.move(DOWN, 3)
    agent.turn(LEFT_TURN)
    BuildFloorSwitch = 0
    LeftRight = 0
    agent.move(FORWARD, 1)
    for (let index = 0; index < num - 1; index++) {
        for (let index2 = 0; index2 <= num - 1; index2++) {
            agent.destroy(DOWN)
            if (BuildFloorSwitch == 0) {
                agent.setItem(PLANKS_SPRUCE, 1, 1)
                BuildFloorSwitch = 1
            } else {
                agent.setItem(PLANKS_BIRCH, 1, 1)
                BuildFloorSwitch = 0
            }
            agent.place(DOWN)
            if (index2 != num - 1) {
                agent.move(FORWARD, 1)
            }
            agent.collectAll()
        }
        if (LeftRight == 0) {
            agent.turn(LEFT_TURN)
            agent.move(FORWARD, 1)
            agent.turn(LEFT_TURN)
            LeftRight = 1
        } else {
            agent.turn(RIGHT_TURN)
            agent.move(FORWARD, 1)
            agent.turn(RIGHT_TURN)
            LeftRight = 0
        }
    }
    agent.move(BACK, 1)
    agent.turn(LEFT_TURN)
}
player.onChat("castle", function () {
    wall_size = 15
    agent.teleportToPlayer()
    agent.move(FORWARD, 5)
    agent.move(LEFT, 5)
    makeWallWithWindows(wall_size)
    makeFullWall(wall_size)
    makeWallWithWindows(wall_size + 1)
    makeFloor(wall_size)
    makeCastleFront(wall_size + 1)
    makeCastleTop(wall_size)
})
function makeCastleTop (num: number) {
    agent.move(UP, 1)
    agent.move(FORWARD, 2)
    agent.turn(LEFT_TURN)
    agent.turn(LEFT_TURN)
    TopCountdown = 0
    for (let index = 0; index < 2; index++) {
        for (let index2 = 0; index2 < num; index2++) {
            agent.move(BACK, 1)
            if (TopCountdown % 2 == 0) {
                agent.setItem(BEDROCK, 1, 1)
                agent.place(FORWARD)
            }
            TopCountdown += 1
        }
        agent.turn(RIGHT_TURN)
        for (let index2 = 0; index2 < num + 1; index2++) {
            agent.move(BACK, 1)
            if (TopCountdown % 2 == 0) {
                agent.setItem(BEDROCK, 1, 1)
                agent.place(FORWARD)
            }
            TopCountdown += 1
        }
        agent.turn(RIGHT_TURN)
    }
}
function makeFullWall (num: number) {
    agent.setSlot(1)
    for (let index = 0; index < 3; index++) {
        for (let index2 = 0; index2 < num; index2++) {
            agent.setItem(STONE, 1, 1)
            agent.place(FORWARD)
            agent.move(BACK, 1)
        }
        agent.move(UP, 1)
        agent.move(FORWARD, num)
    }
    for (let index = 0; index < num; index++) {
        agent.setItem(CHISELED_STONE_BRICKS, 1, 1)
        agent.place(FORWARD)
        agent.move(BACK, 1)
    }
    agent.move(FORWARD, 1)
    agent.turn(LEFT_TURN)
    agent.move(FORWARD, 1)
    agent.turn(LEFT_TURN)
    agent.turn(LEFT_TURN)
    agent.move(DOWN, 4)
}
function makeCastleFront (num: number) {
    for (let index = 0; index < 3; index++) {
        for (let index2 = 0; index2 < Math.floor((num - 2) / 2); index2++) {
            agent.setItem(STONE, 1, 1)
            agent.place(FORWARD)
            agent.move(BACK, 1)
        }
        agent.move(BACK, num - Math.floor((num - 2) / 2) * 2)
        for (let index2 = 0; index2 < Math.floor((num - 2) / 2); index2++) {
            agent.setItem(STONE, 1, 1)
            agent.place(FORWARD)
            agent.move(BACK, 1)
        }
        agent.move(UP, 1)
        agent.move(FORWARD, num)
    }
    for (let index = 0; index < 1; index++) {
        for (let index2 = 0; index2 < num; index2++) {
            agent.setItem(CHISELED_STONE_BRICKS, 1, 1)
            agent.place(FORWARD)
            agent.move(BACK, 1)
        }
    }
}
