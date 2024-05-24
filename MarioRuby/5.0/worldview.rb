class WorldView
    def initialize
        @mario_background = Ruby2D::Tileset.new('./resources/background.png', spacing: 0, tile_width: 32, tile_height: 208, scale: 2, z: 0)
        @mario_blocks = Ruby2D::Tileset.new('./resources/block_sprites.png', spacing: 0, tile_width: 16, tile_height: 16, scale: 4, z: 2)
        @mario_castle = Ruby2D::Tileset.new('./resources/castle.png', spacing: 0, tile_width: 80, tile_height: 80, scale: 4, z: 0)
        @mario_castle.define_tile('castle', 0, 0)
        @mario_blocks.define_tile('path_block', 0, 0)
        @mario_blocks.define_tile('ground_block', 1, 0)
        @mario_blocks.define_tile('hit_block', 2, 0)
        @mario_blocks.define_tile('after_hit_block', 3, 0)
        @block_names = ['', 'path_block', 'ground_block', 'hit_block', 'after_hit_block']
        
        @coins = Array.new()
        @coins_cleanup = Array.new()
        @text = nil
        @enemies = Array.new()
        load_background()
        create_coins()
        spawn_enemies()
    end

    def load_background()
        for i in 0...24 do
            name = "background" + i.to_s
            @mario_background.define_tile(name, i, 0)
        end
    end

    def spawn_enemies
        for i in 0..5 do
            for j in 0..$world_array[i].length-1 do
                if $world_array[i][j] and $world_array[i][j] == 6 then
                    enemy = Enemy.new(j * $default_tile_size, $height - (6 - i) * $default_tile_size)
                    @enemies.push(enemy)
                end
            end
        end
    end

    def create_text
        if @text then
            @text.remove()
        end

        @text = Text.new(
            "Points: #{$points}   Lives: #{$lives}",
            x: 0,
            y: 0,
            z: 5,
            size: $default_tile_size / 2,
            font: "resources/SuperMario256.ttf",
            color: "red"
        )
    end

    def create_coins

        for i in 0..5 do
            for j in 0..$world_array[i].length() - 1 do
                if $world_array[i][j] and $world_array[i][j] == 5 then
                    coin = Sprite.new(
                    'resources/minicoin.png',
                    clip_width: 16,
                    x: j * $default_tile_size,
                    y: $height - (6 - i) * $default_tile_size,
                    z: 1,
                    height: 64,
                    width: 64,
                    time: 250,
                    )
                    coin.play loop: true
                    @coins.push(coin)
                elsif $world_array[i][j] and $world_array[i][j] == 3 then
                    coin = Sprite.new(
                    'resources/fullcoin.png',
                    clip_width: 16,
                    x: j * $default_tile_size,
                    y: $height - (7 - i) * $default_tile_size,
                    z: 1,
                    height: 128,
                    width: 64,
                    time: 10
                    )
                    @coins.push(coin)
                end
            end
        end
    end

    def update_coins
        @coins_cleanup.each do |item|
            item.remove()
        end

        @coins_cleanup = Array.new()

        @coins.each do |item|
            item.x -= $distance_coin
        end
        $distance_coin = 0
    end

    def get_coins
        return @coins
    end

    def remove_coin(coin)
        @coins_cleanup.push(coin)
        @coins.delete(coin)
    end

    def update_offset()
        if $offset >= $default_tile_size then
            
            $world_index += 1
            $offset -= $default_tile_size
        end
    end

    def set_background()
        for i in ($world_index - 12)..($world_index - 1) do
            index = i % 24
            name = "background" + index.to_s
            @mario_background.set_tile(name, [
                {x: (i - $world_index + 12) * $default_tile_size - $offset, y: 0, z: 0}
            ])
        end
    end

    def set_foreground()
        for i in 0..5 do
            for j in ($world_index - 12)..($world_index - 1) do
                if $world_array[i][j] and $world_array[i][j] == 9 then
                    @mario_castle.set_tile('castle', [
                        {x: (j - $world_index + 10) * $default_tile_size - $offset, y: $height - 6 * $default_tile_size}
                    ])
                elsif $world_array[i][j] and $world_array[i][j] != 0 and $world_array[i][j] < 5 then
                    @mario_blocks.set_tile(@block_names[$world_array[i][j]], [
                        {x: (j - $world_index + 12) * $default_tile_size - $offset, y: $height - (6 - i) * $default_tile_size}
                    ])
                end
            end
        end
    end


    def set_everything()
        update_offset()
        @mario_blocks.clear_tiles()
        @mario_background.clear_tiles()
        @mario_castle.clear_tiles()
        @enemies.each do |enemy|
            enemy.offset($distance_coin)
            enemy.move()
            if enemy.deadly_collision_mario($mario.get_hitbox()) then
                $mario.die()
            end
        end
        update_coins()
        create_text()
        set_background()
        set_foreground()
    end

    def reset_everything
        @mario_blocks.clear_tiles()
        @mario_background.clear_tiles()
        @mario_castle.clear_tiles()
        @enemies.each do |enemy|
            enemy.reset_everything()
        end
        @coins.each do |coin|
            coin.remove()
        end
        @text.remove()
    end
    
end