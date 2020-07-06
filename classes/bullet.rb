require_relative '../modules/draw.rb'

class Bullet
  include Draw
  attr_accessor :x,
                :y,
                :lethal
  @@speed = 9
  @@hit_sound = Gosu::Sample.new("sounds/ouch.mp3")

  def initialize window, player, x, y, vel_x, vel_y, angle
    @window = window
    @image = Gosu::Image.new(window, "images/bullet.png", false)
    @player = player

    # Lethal to self yet?
    @lethal = false

    @x = x
    @y = y
    @angle = angle

    # Initial boost from moving of man
    @boost_vel_x = (vel_x * 2)
    @boost_vel_y = (vel_y * 2)
  end

  def check_collisions
    [@window.player_1, @window.player_2].each do |player|
      check_collisions_with player
    end
  end

  def check_collisions_with player
    # Update lethal boolean
    if !@lethal and !(touching? @player, 30)
      @lethal = true
    end

    # Check collisions
    if touching? player, 30
      collide_with player
    end
  end

  def touching? player, threshold
    player.is_this_point_touching_me? @x, @y, threshold
  end

  def collide_with player
    if @lethal
      @@hit_sound.play
      player.health -= 1
      remove
      if (player.health <= 0)
        @window.end_game player
      end
    end
  end

  def remove
    @window.bullets.delete self
  end

  def update_and_move
    @x += @boost_vel_x + Gosu::offset_x(@angle, @@speed)
    @y += @boost_vel_y + Gosu::offset_y(@angle, @@speed)

    if (@x <= 0) or (@x >= @window.width) or (@y <= 0) or (@y >= @window.height)
      remove
    end

    @boost_vel_x *= 0.95
    @boost_vel_y *= 0.95
  end
end