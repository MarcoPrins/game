module Draw
  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end