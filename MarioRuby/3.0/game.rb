require 'ruby2d'
require './mario.rb'
require './worldview.rb'
require './colliders.rb'

$default_tile_size = 64
$width = 704
$height = 416

$world_array = Array.new(6)
for i in 0..5 do
    $world_array[i] = Array.new()
end

$world_array[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
$world_array[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
$world_array[2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
$world_array[3] = [0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
$world_array[4] = [0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0]
$world_array[5] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

$world_index = 12

set width: $width
set height: $height

set title: "Mario"

$offset = 0

$world = WorldView.new
$mario = Mario.new
$colliders = Colliders.new

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