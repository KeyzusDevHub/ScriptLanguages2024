require 'ruby2d'
require './mario.rb'
require './worldview.rb'
require './colliders.rb'
require './enemy.rb'
require './generator.rb'

set width: $width
set height: $height

set title: "Mario"

$default_tile_size = 64
$width = 704
$height = 416

$lives = 4

@texts = Array.new()

if ARGV.length == 2 and ARGV[0] == "generate" then
    $generator = Generator.new(ARGV[1].to_i())
end

def read_file(name)
    index = 0
    if File.exists?(name) then
        File.readlines(name, chomp: true).each do |line|
            line.split().each do |integer|
                $world_array[index].push(integer.to_i())
            end
            index += 1
        end
    else
        default_map()
    end
end

def default_map
    $world_array[0] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[2] = [0, 0, 0, 3, 0, 0, 0, 0, 0, 2, 0, 0, 2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[3] = [0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    $world_array[4] = [0, 0, 0, 0, 6, 0, 5, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0]
    $world_array[5] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
end

def reset_world
    if @texts then
        @texts.each() do |text|
            text.remove()
        end
    end

    @texts = Array.new()

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
        return
    end
    
    $world_array = Array.new(6)
    
    for i in 0..5 do
        $world_array[i] = Array.new()
    end

    if ARGV.length > 0 then
        if ARGV.length == 1 then
            read_file('save.data')
        elsif ARGV.length == 2 and ARGV[0] == "generate" then
            $generator.set_generated()
        else
            default_map()
        end
    else
        default_map()
    end
    
    $world_index = 12
       
    $offset = 0
    $total_distance = 0
    $distance_coin = 0
    $points = 0
    
    $world = WorldView.new
    $mario = Mario.new
    $colliders = Colliders.new
end

def end_screen
    $mario.reset_everything()
    $world.reset_everything()
    $colliders.reset_everything()

    @texts.each() do |text|
        text.remove()
    end

    texts = Array.new()
    if $mario.is_dead()
        text = Text.new(
            "You died",
            x: ($width - 6 * $default_tile_size) / 2,
            y: ($height - $default_tile_size) / 2,
            z: 5,
            size: $default_tile_size,
            font: "resources/SuperMario256.ttf",
            color: "red"
        )
        @texts.push(text)
    else
        text1 = Text.new(
            "You won",
            x: ($width - 5 * $default_tile_size) / 2,
            y: ($height - $default_tile_size) / 2 - $default_tile_size / 2,
            z: 5,
            size: $default_tile_size,
            font: "resources/SuperMario256.ttf",
            color: "red"
        )
        text2 = Text.new(
            "Points: #{$points}",
            x: ($width - 7 * $default_tile_size) / 2,
            y: ($height - $default_tile_size) / 2 + $default_tile_size / 2,
            z: 5,
            size: $default_tile_size,
            font: "resources/SuperMario256.ttf",
            color: "red"
        )
        @texts.push(text1)
        @texts.push(text2)
    end
end

reset_world()

on :key_down do |event|
    $mario.set_velocity(event.key)
    if ($lives == 0 or $mario.did_win()) and event.key == "return" then
        $lives = 4
        if $generator then
            $generator = Generator.new(ARGV[1].to_i())
        end
        reset_world()
    elsif ($lives == 0 or $mario.did_win()) and event.key == "escape" then
        exit(0)
    end
end

on :key_up do |event|
    $mario.reset_velocity(event.key)
end

update do
    if $lives != 0 and not $mario.did_win() then
        $world.set_everything()
        $mario.do_everything()
        $colliders.set_all_colliders()
    else
        end_screen()
    end
end

show