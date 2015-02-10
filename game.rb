require 'gosu'

class GameWindow < Gosu::Window
  attr_accessor :width, :height, :bullets

  def initialize
    # Window width and height
    @width = 1200
    @height = 700

    # Create window
    super @width, @height, false
    self.width = @width
    self.height = @height
    self.caption = "==========GAME==========="
    Dir['./**/*.rb'].each{ |f| require f } # review

    # Create players
    @player_1 = Player.new(self, "images/player_white.png")
    @player_1.warp( (@width/3)*2 , @height/2 )
    @player_2 = Player.new(self, "images/player_pink.png")
    @player_2.warp( (@width/3)*1 , @height/2 )
    # Boolean that prevents multiple collisions at once
    @collision_possible = true

    # List of all bullets
    @bullets = []
  end

  def update
    listen_player_1
    listen_player_2

    detect_collisions

    @player_2.move
    @player_1.move
  end

  def draw
    @player_1.draw
    @player_2.draw

    draw_bullets
  end

  private
    def draw_bullets
      self.bullets.each do |bullet|
        bullet.draw
      end
    end

    def detect_collisions
      if ((@player_2.x - @player_1.x).abs < 30) and ((@player_2.y - @player_1.y).abs < 30)
        collide if @collision_possible
        @collision_possible = false
      else
        @collision_possible = true
      end
    end

    def collide
      ratio = 0.8

      @player_1.vel_x += (@player_2.vel_x * ratio)
      @player_2.vel_x += (@player_1.vel_x * ratio)

      @player_1.vel_y += (@player_2.vel_y * ratio)
      @player_2.vel_y += (@player_1.vel_y * ratio)
    end

    def listen_player_1
      if button_down? Gosu::KbLeft
        @player_1.turn_left
      end
      if button_down? Gosu::KbRight
        @player_1.turn_right
      end
      if button_down? Gosu::KbUp
        @player_1.accelerate
      end
      if button_down? Gosu::KbDown
        @player_1.decelerate
      end

      if button_down? Gosu::KbComma
        @player_1.fire_bullet
      end
    end

    def listen_player_2
      if button_down? Gosu::KbA
        @player_2.turn_left
      end
      if button_down? Gosu::KbD
        @player_2.turn_right
      end
      if button_down? Gosu::KbW
        @player_2.accelerate
      end
      if button_down? Gosu::KbS
        @player_2.decelerate
      end
    end
end

window = GameWindow.new
window.show