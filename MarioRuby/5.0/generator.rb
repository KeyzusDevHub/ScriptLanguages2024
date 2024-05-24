class Generator
    def initialize(num)
        @generated_array = Array.new(6)
    
        for i in 0..5 do
            @generated_array[i] = Array.new()
        end

        generate(num)
    end

    def generate(num)
        generated = 0
        while generated < num do
            random = rand(10)

            if generated <= 7 then
                generate_ground()
                generated += 1
            elsif num - generated == 5
                generate_castle()
                generated = num
            elsif random == 0 and num - generated > 17 then
                generate_bridge()
                generated += 8
            elsif random == 1 then
                generate_enemy()
                generated += 1
            elsif random == 2 then
                generate_hitblock()
                generated += 1
            else
                generate_ground()
                generated += 1
            end
        end
    end

    def set_generated
        $world_array[0] = Marshal.load( Marshal.dump(@generated_array[0]))
        $world_array[1] = Marshal.load( Marshal.dump(@generated_array[1]))
        $world_array[2] = Marshal.load( Marshal.dump(@generated_array[2]))
        $world_array[3] = Marshal.load( Marshal.dump(@generated_array[3]))
        $world_array[4] = Marshal.load( Marshal.dump(@generated_array[4]))
        $world_array[5] = Marshal.load( Marshal.dump(@generated_array[5]))
    end


    def generate_ground
        @generated_array[0].push(0)
        @generated_array[1].push(0)
        if rand(2) == 1 then
            @generated_array[2].push(5)
        else
            @generated_array[2].push(0)
        end
        @generated_array[3].push(0)
        @generated_array[4].push(0)
        @generated_array[5].push(1)
    end

    def generate_bridge
        random = rand(4)
        if random == 0 then
            @generated_array[0].push(0, 0, 0, 0, 0, 0, 0, 0)
            @generated_array[1].push(0, 0, 0, 0, 0, 0, 0, 0)
            @generated_array[2].push(0, 0, 2, 0, 0, 2, 0, 0)
            @generated_array[3].push(0, 2, 2, 0, 0, 2, 2, 0)
            @generated_array[4].push(2, 2, 2, 0, 0, 2, 2, 2)
            @generated_array[5].push(1, 1, 1, 0, 0, 1, 1, 1)
        elsif random == 1 then
            @generated_array[0].push(0, 0, 0, 0, 0, 0, 0, 0)
            @generated_array[1].push(0, 0, 5, 0, 0, 5, 0, 0)
            @generated_array[2].push(0, 0, 2, 0, 0, 2, 0, 0)
            @generated_array[3].push(5, 2, 2, 0, 0, 2, 2, 5)
            @generated_array[4].push(2, 2, 2, 0, 0, 2, 2, 2)
            @generated_array[5].push(1, 1, 1, 0, 0, 1, 1, 1)
        elsif random == 2 then
            @generated_array[0].push(0, 0, 0, 0, 5, 0, 0, 0)
            @generated_array[1].push(0, 0, 0, 0, 0, 0, 0, 0)
            @generated_array[2].push(0, 5, 2, 0, 0, 2, 0, 0)
            @generated_array[3].push(0, 2, 2, 0, 0, 2, 2, 5)
            @generated_array[4].push(2, 2, 2, 0, 0, 2, 2, 2)
            @generated_array[5].push(1, 1, 1, 0, 0, 1, 1, 1)
        elsif random == 3 then
            @generated_array[0].push(0, 5, 0, 0, 0, 0, 5, 0)
            @generated_array[1].push(5, 0, 5, 0, 0, 5, 0, 5)
            @generated_array[2].push(0, 0, 2, 0, 0, 2, 0, 0)
            @generated_array[3].push(0, 2, 2, 0, 0, 2, 2, 0)
            @generated_array[4].push(2, 2, 2, 0, 0, 2, 2, 2)
            @generated_array[5].push(1, 1, 1, 0, 0, 1, 1, 1)
        end
    end

    def generate_hitblock
        @generated_array[0].push(0)
        @generated_array[1].push(0)
        @generated_array[2].push(3)
        @generated_array[3].push(0)
        @generated_array[4].push(0)
        @generated_array[5].push(1)
    end

    def generate_enemy
        @generated_array[0].push(0)
        @generated_array[1].push(0)
        if rand(2) == 1 then
            @generated_array[2].push(5)
        else
            @generated_array[2].push(0)
        end
        @generated_array[3].push(0)
        @generated_array[4].push(6)
        @generated_array[5].push(1)
    end

    def generate_castle
        @generated_array[0].push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        @generated_array[1].push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        @generated_array[2].push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        @generated_array[3].push(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        @generated_array[4].push(0, 0, 9, 0, 0, 0, 0, 0, 0, 0)
        @generated_array[5].push(1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
    end
end