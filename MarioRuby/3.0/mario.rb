class Mario
    def initialize
        @mario = Sprite.new(
            'resources/mario.png',
            clip_width: 29,
            x: 0,
            y: 200,
            height: 64,
            width: 64,
            time: 250,
            animations: {
                jump_left: 0..0,
                walk_left: 2..4,
                idle_left: 5..5,
                idle_right: 6..6,
                walk_right: 7..9,
                jump_right: 11..11,
                death: 12..12
            }
        )
        @hitbox = Rectangle.new(
            x: 0,
            y: 216,
            height: 64,
            width: 32
        )
        @hitbox.color.opacity = 0.0
        @rotation = 'right'
        @dead = false
        @flying = false
        @velocity_x = 0
        @velocity_y = 0
        @mario.play animation: :idle_right, loop: true
    end

    def animate()
        if @dead then
            @mario.play animation: :death, loop: true
        elsif @flying and @rotation == 'left' then
            @mario.play animation: :jump_left, loop: true
        elsif @flying and @rotation == 'right' then
            @mario.play animation: :jump_right, loop: true
        elsif @rotation == 'left' and @velocity_x != 0 then
            @mario.play animation: :walk_left, loop: true
        elsif @rotation == 'right' and @velocity_x != 0 then
            @mario.play animation: :walk_right, loop: true
        elsif @rotation == 'left' then
            @mario.play animation: :idle_left, loop: true
        elsif @rotation == 'right' then
            @mario.play animation: :idle_right, loop: true
        end
    end

    def set_velocity(key)
        if @dead then
            return
        end
        
        if key == 'right' then
            @velocity_x = 5
            @rotation = 'right'
        elsif key == 'left' then
            @velocity_x = -5
            @rotation = 'left'
        end

        if key == 'up' and not @flying then
            @velocity_y = -10
            @flying = true
        end
    end

    def reset_velocity(key)
        if @dead then
            return
        elsif key == 'right' and @velocity_x == 5 then
            @velocity_x = 0
        elsif key == 'left' and @velocity_x == -5 then
            @velocity_x = 0
        end
    end

    def move()

        if $colliders.collision_ground(@hitbox) == 2 or $colliders.collision_hitblock(@hitbox) == 2 or $colliders.collision_ground(@hitbox) == 3 then
            @velocity_x = 0
        end
        
        @mario.x = @mario.x + @velocity_x
        @mario.y = @mario.y + @velocity_y
        
        if @mario.x < 0 then
            @mario.x = 0
        elsif @mario.x > ($width / 2) - $default_tile_size then
            $offset += @mario.x - ($width / 2) + $default_tile_size
            @mario.x = ($width / 2) - $default_tile_size
            @hitbox.x = @hitbox.x + @velocity_x
        end
        
        @hitbox.x = @mario.x + $default_tile_size / 4
        @hitbox.y = @mario.y
    end

    def gravity
        if $colliders.collision_ground(@hitbox) == 1 or $colliders.collision_hitblock(@hitbox) == 1 or $colliders.collision_ground(@hitbox) == 3 then
            @velocity_y = 0
            @flying = false
        else
            @velocity_y += 0.4
            if @velocity_y > 7.0 then
                @velocity_y = 7.0
            end
        end
    end

    def check_death
        if @mario.y + $default_tile_size > $height and not @dead then
            @dead = true
            @velocity_y = -4
            @velocity_x = 0
        elsif @dead and @mario.y > $height then
            exit(0)  
        end
    end

    def check_win
        if $colliders.collision_endpoint(@hitbox) == 1 then
            puts "You win"
            exit(0)
        end
    end

end