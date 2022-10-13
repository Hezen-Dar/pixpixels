Bomba = Entity:extend()

--se le da la posicion
function Bomba:new(x, y)
  Bomba.super.new(self, x, y, "bomba.png")

  self.gravity = 250
end
