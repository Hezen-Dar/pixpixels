Entity = Object:extend()

function Entity:new(x, y, image_path)
  self.x = x
  self.y = y
  self.image = love.graphics.newImage(image_path)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.last = {}
  self.last.x = self.x
  self.last.y = self.y

  self.strenght = 0
  self.tempStrenght = 0

  self.gravity = 0
  self.weight = 0
end

function Entity:update(dt)
  self.last.x = self.x
  self.last.y = self.y

  self.tempStrenght = self.strenght

  self.gravity = self.gravity + self.weight * dt

  self.y = self.y + self.gravity * dt
end

function Entity:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

--retorna true si hay colision
function Entity:checkCollision(e)
  return self.x + self.width > e.x
  and self.x < e.x + e.width
  and self.y + self.height > e.y
  and self.y < e.y + e.height
end
