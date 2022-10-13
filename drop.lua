Drop = Entity:extend()

--se le da la posicion
function Drop:new(x, y)
  Drop.super.new(self, x, y, "pixel.png")

  self.gravity = 250
end
