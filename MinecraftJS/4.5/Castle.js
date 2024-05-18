let BuildFloorSwitch = 0
let LeftRight = 0
let wall_size = 0
let TopCountdown = 0
function makeCastleTower (num: number, bool: boolean) {
    for (let index = 0; index < 7; index++) {
        for (let index2 = 0; index2 < 4; index2++) {
            for (let index3 = 0; index3 < (Math.floor(num / 2) - 1) / 2 - 1; index3++) {
                agent.setItem(POLISHED_ANDESITE, 1, 1)
                agent.place(DOWN)
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
        }
        agent.move(UP, 1)
    }
    agent.move(LEFT, 1)
    agent.move(BACK, 1)
    for (let index = 0; index < 2; index++) {
        for (let index2 = 0; index2 < 4; index2++) {
            for (let index3 = 0; index3 < (Math.floor(num / 2) - 1) / 2 + 1; index3++) {
                agent.setItem(POLISHED_ANDESITE, 1, 1)
                agent.place(DOWN)
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
        }
        agent.move(UP, 1)
    }
    if (bool) {
        agent.move(RIGHT, (Math.floor(num / 2) - 1) / 2)
        agent.turn(LEFT_TURN)
        agent.turn(LEFT_TURN)
        agent.move(FORWARD, Math.ceil(num / 2))
        agent.move(DOWN, 9)
    }
}
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
function makeBridge (num: number) {
    for (let index = 0; index <= num - 1; index++) {
        agent.setItem(PLANKS_DARK_OAK, 1, 1)
        agent.destroy(DOWN)
        agent.collectAll()
        agent.place(DOWN)
        if (index != num - 1) {
            agent.move(LEFT, 1)
        }
    }
    for (let index = 0; index < 3; index++) {
        agent.move(BACK, 1)
        agent.move(RIGHT, 1)
        for (let index2 = 0; index2 <= num - 1; index2++) {
            agent.setItem(PLANKS_DARK_OAK, 1, 1)
            agent.place(DOWN)
            if (index2 != num - 1) {
                agent.move(LEFT, 1)
            }
        }
    }
    agent.move(FORWARD, 4)
    agent.turn(LEFT_TURN)
    agent.move(FORWARD, (Math.floor(num / 2) - 1) / 2)
    agent.move(FORWARD, 1)
    agent.move(UP, 1)
}
player.onChat("tryBuild", function () {
    agent.turn(RIGHT_TURN)
    agent.teleportToPlayer()
    agent.move(FORWARD, 4)
    agent.turn(LEFT_TURN)
    agent.move(FORWARD, (Math.floor(15 / 2) - 1) / 2)
    agent.move(FORWARD, 1)
    agent.move(UP, 1)
    makeCastleTower(15, true)
    makeCastleTower(15, false)
})
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
            if (index != num - 1) {
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
    agent.dropAll(FORWARD)
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
    digHole(wall_size)
    digAndWater(wall_size)
    makeBridge(wall_size - Math.floor((wall_size - 2) / 2) * 2 - 1)
    makeCastleTower(wall_size, true)
    makeCastleTower(wall_size, false)
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
function digAndWater (num: number) {
    agent.setSlot(1)
    for (let index = 0; index <= 2; index++) {
        agent.setItem(WATER_BUCKET, 1, 1)
        for (let index2 = 0; index2 < 2; index2++) {
            for (let index3 = 0; index3 < num + (index * 2 + 2); index3++) {
                agent.destroy(DOWN)
                agent.place(DOWN)
                agent.collectAll()
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
            for (let index3 = 0; index3 < num + (index * 2 + 3); index3++) {
                agent.destroy(DOWN)
                agent.place(DOWN)
                agent.collectAll()
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
        }
        agent.move(BACK, 1)
        agent.move(LEFT, 1)
    }
    for (let index = 0; index < 2; index++) {
        agent.move(FORWARD, 1)
        agent.move(RIGHT, 1)
    }
    agent.move(UP, 1)
    agent.move(FORWARD, Math.ceil(num / 2))
    agent.turn(RIGHT_TURN)
    agent.move(FORWARD, 1)
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
function digHole (num: number) {
    agent.move(FORWARD, 1)
    agent.move(DOWN, 4)
    agent.turn(RIGHT_TURN)
    agent.move(FORWARD, 2)
    agent.turn(RIGHT_TURN)
    for (let index = 0; index <= 2; index++) {
        for (let index2 = 0; index2 < 2; index2++) {
            for (let index3 = 0; index3 < num + (index * 2 + 2); index3++) {
                agent.destroy(DOWN)
                agent.collectAll()
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
            for (let index2 = 0; index2 < num + (index * 2 + 3); index2++) {
                agent.destroy(DOWN)
                agent.collectAll()
                agent.move(FORWARD, 1)
            }
            agent.turn(RIGHT_TURN)
        }
        agent.move(BACK, 1)
        agent.move(LEFT, 1)
    }
    for (let index = 0; index < 3; index++) {
        agent.move(FORWARD, 1)
        agent.move(RIGHT, 1)
    }
    agent.move(DOWN, 1)
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
