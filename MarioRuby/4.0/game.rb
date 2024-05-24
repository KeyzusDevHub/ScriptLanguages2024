require 'ruby2d'
require './mario.rb'
require './worldview.rb'
require './colliders.rb'
require './enemy.rb'

set width: $width
set height: $height

set title: "Mario"

$default_tile_size = 64
$width = 704
$height = 416

$lives = 4

def reset_world()

    if $mario then
        $mario.reset_everything()
    end
    if $world then
        $world.reset_everything()
    end
    if $colliders then
        $colliders.reset_everything()
    end
    $lives -= 1
    if $lives == 0 then
        exit(0)
    end

    $world_array = Array.new(6)
    
    for i in 0..5 do
        $world_array[i] = Array.new()
    end
    
    $world_array[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[2] = [0, 0, 0, 3, 0, 0, 0, 0, 0, 2, 0, 0, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[3] = [0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[4] = [0, 0, 0, 0, 6, 0, 5, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0]
    $world_array[5] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    
    $world_index = 12
       
    $offset = 0
    $total_distance = 0
    $distance_coin = 0
    $points = 0
    $create_coins = false
    
    $world = WorldView.new
    $mario = Mario.new
    $colliders = Colliders.new
end

reset_world()

on :key_down do |event|
    $mario.set_velocity(event.key)
end

on :key_up do |event|
    $mario.reset_velocity(event.key)
end

update do
    $world.update_offset()
    $world.set_everything()
    $mario.check_win()
    $mario.check_death()
    $mario.move()
    $mario.gravity()
    $mario.animate()
    $colliders.set_all_colliders()
end

show