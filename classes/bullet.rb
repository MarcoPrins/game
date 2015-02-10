require_relative '../modules/draw.rb'

class Bullet
  include Draw
  attr_accessor :x, :y, :index, :lethal_counter

  def initialize window, x, y, vel_x, vel_y, angle, index
    @window = window
    @image = Gosu::Image.new(window, "images/bullet.png", false)

    # Position in window.bullets array
    @index = index

    # Lethal to self yet?
    @lethal_counter = 9

    @x = x
    @y = y
    @angle = angle

    # Initial boost from moving of man
    @boost_vel_x = (vel_x * 2.3)
    @boost_vel_y = (vel_y * 2.3)
  end

  def check_collisions
    [@window.player_1, @window.player_2].each do |player|
      check_collisions_with player
    end
  end

  def check_collisions_with player
    if Gosu::distance(@x,@y,player.x,player.y) < 30
      collide_with player
    end
  end

  def collide_with player
    if @lethal_counter == 0
      player.health -= 1
      @window.bullets.delete_at @index
      puts 'OUCH'
    end
  end

  def update_and_move
    if @lethal_counter > 0
      @lethal_counter -= 1
    end

    @x += @boost_vel_x + Gosu::offset_x(@angle, 4)
    @y += @boost_vel_y + Gosu::offset_y(@angle, 4)

    @boost_vel_x *= 0.95
    @boost_vel_y *= 0.95
  end
end