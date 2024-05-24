class WorldView
    def initialize
        @mario_background = Ruby2D::Tileset.new('./resources/background.png', spacing: 0, tile_width: 32, tile_height: 208, scale: 2)
        @mario_blocks = Ruby2D::Tileset.new('./resources/block_sprites.png', spacing: 0, tile_width: 16, tile_height: 16, scale: 4)
        @mario_castle = Ruby2D::Tileset.new('./resources/castle.png', spacing: 0, tile_width: 80, tile_height: 80, scale: 4)
        @mario_castle.define_tile('castle', 0, 0)
        @mario_blocks.define_tile('path_block', 0, 0)
        @mario_blocks.define_tile('ground_block', 1, 0)
        @mario_blocks.define_tile('hit_block', 2, 0)
        @mario_blocks.define_tile('after_hit_block', 3, 0)
        @block_names = ['', 'path_block', 'ground_block', 'hit_block', 'after_hit_block']
        load_background()
    end

    def load_background()
        for i in 0...24 do
            name = "background" + i.to_s
            @mario_background.define_tile(name, i, 0)
        end
    end

    def update_offset()
        if $offset >= $default_tile_size then
            
            $world_index += 1
            $offset = 0
        end
    end

    def set_background()
        for i in ($world_index - 12)..($world_index - 1) do
            index = i % 24
            name = "background" + index.to_s
            @mario_background.set_tile(name, [
                {x: (i - $world_index + 12) * $default_tile_size - $offset, y: 0}
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
                elsif $world_array[i][j] and $world_array[i][j] != 0 then
                    @mario_blocks.set_tile(@block_names[$world_array[i][j]], [
                        {x: (j - $world_index + 12) * $default_tile_size - $offset, y: $height - (6 - i) * $default_tile_size}
                    ])
                end
            end
        end
    end


    def set_everything()
        @mario_blocks.clear_tiles()
        @mario_background.clear_tiles()
        @mario_castle.clear_tiles()
        set_background()
        set_foreground()
    end

end