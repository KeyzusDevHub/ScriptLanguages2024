class Enemy
    def initialize(x_loc, y_loc)
        @shroom = Sprite.new(
            'resources/enemy.png',
            clip_width: 16,
            x: x_loc,
            y: y_loc,
            height: 64,
            width: 64,
            time: 250,
            animations: {
                walk: 0..1,
                death: 2..2
            }
        )
        @hitbox = Rectangle.new(
            x: x_loc,
            y: y_loc,
            height: 64,
            width: 64,
            color: 'red'
        )
        @hitbox.color.opacity = 0.0
        @rotation = 'left'
        @dead = false
        @velocity_x = 0
        @shroom.play animation: :walk, loop: true
    end

    def animate
        if @dead then
            @shroom.play animation: :death, loop: true
        else
            @shroom.play animation: :walk, loop: true
        end
    end

    def offset(o)
        @shroom.x -= o
    end

    def move

        animate()

        if @dead or @shroom.x > $width or @shroom.x < -$default_tile_size then
            return
        elsif @rotation == 'right' then
            @shroom.x += 5
        else
            @shroom.x -= 5
        end

        if @shroom.x > $width then
            @shroom.x = $width
            @rotation = 'left'
        elsif @shroom.x < 0 then
            @shroom.x = 0
            @rotation = 'right'
        elsif $colliders.collision_ground(@hitbox) == 3 or $colliders.collision_endpoint(@hitbox) == 1 then
            if @rotation == 'right' then
                @rotation = 'left'
                @shroom.x -= 10
            else
                @rotation = 'right'
                @shroom.x += 10
            end
        end

        @hitbox.x = @shroom.x
    end

    def deadly_collision_mario(mario_hitbox)
        if @dead then
            return false
        elsif $mario.is_dead()
            return false
        elsif $colliders.collision_between_two(@hitbox, mario_hitbox) == 2 then
            return true
        elsif $colliders.collision_between_two(@hitbox, mario_hitbox) == 1 and not $mario.is_going_up() then
            @dead = true
            return false
        elsif $colliders.collision_between_two(@hitbox, mario_hitbox) == 1 and $mario.is_going_up() then
            return true
        elsif $colliders.collision_between_two(@hitbox, mario_hitbox) == 0
            return false
        end
    end

    def reset_everything
        @shroom.remove()
        @hitbox.remove()
    end
    
end