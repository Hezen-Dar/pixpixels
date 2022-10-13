Pixel = Entity:extend()


function Pixel:new(x, y)
  Pixel.super.new(self, x, y, "pixel.png")

end

function Pixel:update(dt)
  Pixel.super.update(self, dt)

  if love.keyboard.isDown("left") then
    limiteDerecho = false
    if self.x >= 0 and limiteIzquierdo == false then
      self.x = self.x - 250 * dt
    else
      self.x = self.x
      limiteIzquierdo = true
    end
  end

  if love.keyboard.isDown("right") then
    limiteIzquierdo = false
    if self.x + self.width < love.graphics.getWidth() and limiteDerecho == false then
      self.x = self.x + 250 * dt
    else
      self.x = self.x
      limiteDerecho = true
    end
  end

end
