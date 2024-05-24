class Colliders
    def initialize
        @colliders_ground = Array.new()
        @colliders_coins = Array.new()
        @colliders_hit = Array.new()
        @collider_end = nil
    end

    def set_all_colliders
        clear_colliders()
        create_all_colliders()
    end

    def clear_colliders
        @colliders_ground.each do |item|
            item.remove()
        end
        @colliders_coins.each do |item|
            item.remove()
        end
        @colliders_hit.each do |item|
            item.remove()
        end
        if @collider_end then
            @collider_end.remove()
        end

        @colliders_ground = Array.new()
        @colliders_coins = Array.new()
        @colliders_hit = Array.new()
        @collider_end = nil
    end

    def collision_ground(hitbox)
        @colliders_ground.each do |item|
            if (item.contains?(hitbox.x3, (hitbox.y3 + hitbox.y1) / 2) or item.contains?(hitbox.x4, (hitbox.y3 + hitbox.y1) / 2)) then
                return 3 # object - middle colision
            elsif (item.contains?(hitbox.x3, hitbox.y3) or item.contains?(hitbox.x4, hitbox.y4)) and (item.y1 + $default_tile_size / 8) <= hitbox.y3 then
                return 2 # under top object - bottom collision
            elsif (item.contains?(hitbox.x3, hitbox.y3) or item.contains?(hitbox.x4, hitbox.y4)) and (item.y1 + $default_tile_size / 8) > hitbox.y3 then
                return 1 # top object - bottom collision
            end
        end
        return 0
    end

    def collision_coin(hitbox)
        @colliders_coins.each do |item|
            if item.contains?(hitbox.x1, hitbox.y1) or item.contains?(hitbox.x2, hitbox.y2) or item.contains?(hitbox.x3, hitbox.y3) or item.contains?(hitbox.x4, hitbox.y4) then
                i = item.y / $default_tile_size
                j = (item.x + $total_distance) / $default_tile_size
                $world_array[i][j] = 0
                $points += 100
                $world.create_coins()
            end
        end
        return 0
    end

    def collision_hitblock(hitbox)
        @colliders_hit.each do |item|
            if (item.contains?(hitbox.x1, hitbox.y1) or item.contains?(hitbox.x2, hitbox.y2)) and (item.y3 - $default_tile_size / 8) <= hitbox.y1 and $mario.is_going_up() then
                i = item.y / $default_tile_size
                j = (item.x + $total_distance) / $default_tile_size
                if $world_array[i][j] == 3 then
                    $world_array[i][j] = 4
                    $points += 100
                    $world.get_coins().each do |coin|
                        if (coin.x - item.x).abs <= $default_tile_size and (coin.y - item.y).abs <= $default_tile_size then
                            coin.play do
                                $create_coins = true
                                $world.remove_coin(coin)
                            end
                            break
                        end
                    end
                end
                return 1 # bottom object - top collision
            elsif (item.contains?(hitbox.x1, hitbox.y1) or item.contains?(hitbox.x2, hitbox.y2)) and (item.y3 - $default_tile_size / 8) > hitbox.y1 then
                return 2 # over bottom object - top collision
            end
        end
        return 0
    end

    def collision_endpoint(hitbox)
        if @collider_end then
            if @collider_end.contains?(hitbox.x1, hitbox.y1) or @collider_end.contains?(hitbox.x2, hitbox.y2) or @collider_end.contains?(hitbox.x3, hitbox.y3) or @collider_end.contains?(hitbox.x4, hitbox.y4) or @collider_end.contains?(hitbox.x2, (hitbox.y3 + hitbox.y1) / 2) then
                return 1 # any collision
            end
        end
        return 0
    end

    def collision_between_two(hitbox1, hitbox2)
        if (hitbox1.contains?(hitbox2.x3, hitbox2.y3) or hitbox1.contains?(hitbox2.x4, hitbox2.y4)) and (hitbox1.y1 + $default_tile_size / 4) > hitbox2.y3 then
            return 1 # top object - bottom collision
        elsif hitbox1.contains?(hitbox2.x1, hitbox2.y1) or hitbox1.contains?(hitbox2.x2, hitbox2.y2) or hitbox1.contains?(hitbox2.x3, hitbox2.y3) or hitbox1.contains?(hitbox2.x4, hitbox2.y4) then
            return 2 # any colision
        end
        return 0
    end

    def create_all_colliders
        for i in 0..5 do
            for j in ($world_index - 12)..($world_index - 1) do
                if $world_array[i][j] and $world_array[i][j] != 0 then
                    hitbox = Square.new(
                        x: (j - $world_index + 12) * $default_tile_size - $offset,
                        y: $height - (6 - i) * $default_tile_size,
                        size: $default_tile_size
                    )
                    hitbox.color.opacity = 0.0
                    
                    if $world_array[i][j] == 1 or $world_array[i][j] == 2 then
                        @colliders_ground.push(hitbox)
                    elsif $world_array[i][j] == 3 or $world_array[i][j] == 4 then
                        @colliders_hit.push(hitbox)
                    elsif $world_array[i][j] == 5 then
                        @colliders_coins.push(hitbox)
                    elsif $world_array[i][j] == 9 then
                        @collider_end = hitbox
                    end
                end
            end
        end
    end

    def reset_everything
        clear_colliders()
    end
end