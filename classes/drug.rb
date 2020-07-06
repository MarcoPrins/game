require_relative '../modules/draw.rb'

class Drug
  include Draw
  attr_accessor :window,
                :x,
                :y,
                :timer,
                :exists

  def initialize(window)
    @timer = rand(1300) + 100
    @window = window
    @angle = 0
    @image = Gosu::Image.new(@window, "images/drug.png", false)

    randomize_coordinates
  end

  def draw_if
    if @timer == 0
      draw
    end
  end

  def touching? player
    player.is_this_point_touching_me?(@x, @y, 30)
  end

  def check_collisions
    [@window.player_1, @window.player_2].each do |player|
      if touching? player
        collide_with player
      end
    end
  end

  def collide_with player
    player.health += 1
    @window.drug = Drug.new(@window)
  end

  def randomize_coordinates
    @x = rand(@window.width * 0.8) + (@window.width * 0.1)
    @y = rand(@window.height * 0.8) + (@window.height * 0.1)
  end

  def update
    if @timer > 0
      @timer -= 1
    end
    check_collisions
  end
end