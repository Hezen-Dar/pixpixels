Object = require "classic"
local lume = require "lume"
require "entity"
require "pixel"
require "drop"
require "bomba"

function love.load()
  love.window.setMode(360, 640, {resizable=false})
  --love.window.setMode(360, 640, {fullscreen=true})
  --love.window.setMode(180, 320, {resizable=false})
  love.window.setFullscreen(true)
  anchoDePantalla = love.graphics.getWidth()
  altoDePantalla = love.graphics.getHeight()
  dropeos = {}
  puntajes = {
    actual = 0,
    ultimo = 0,
    mejor = 0
  }

  if love.filesystem.getInfo("puntajesPixeles.txt") then
    archivo = love.filesystem.read("puntajesPixeles.txt")
    data = lume.deserialize(archivo)

    puntajes.actual = 0
    puntajes.ultimo = data.puntajes.ultimo
    puntajes.mejor = data.puntajes.mejor
  end


  --genera al jugador al centro, abajo de la pantalla
  pixel = Pixel(anchoDePantalla / 2, love.graphics.getHeight() - love.graphics.getHeight() / 8)
  pixeles = {}
  table.insert(pixeles, pixel)

  limiteDerecho = false
  limiteIzquierdo = false
  puntaje = 0
  segundoActual = 0
  segundoCompletado = 0.5
  origen = 0
  azar = 0
  tiempoPasado = 0
  droppin = "nada"

  menuElegido = 0
  modoDebug = 0

  xTouch = anchoDePantalla / 2
  yTouch = 0
  tocado = false

end


function love.update(dt)
  if tocado == true then
    menuElegido = 1
  end

  if menuElegido == 1 then
    delta = dt

    segundoActual = segundoActual + dt
    if segundoActual > segundoCompletado then
      puntaje = puntaje + 1
      tiempoPasado = tiempoPasado + 1
      segundoActual = 0

      dibujarCuadrado()
      --posicion aleatoria entre el ancho de la pantalla
      origen = love.math.random(anchoDePantalla - 16)

      --numero al azar en cada segundo
      azar = love.math.random(100) - tiempoPasado / 2
    end

    for i,v in ipairs(dropeos) do
      v:update(dt)
      for j,q in ipairs(pixeles) do
        local choque = q:checkCollision(v)
        if choque == true then
          if v:is(Drop) then
            table.insert(pixeles, Pixel(v.x, v.y))
            puntaje = puntaje + 10
            v.x = -100
            v.y = -100
            break
          else
            data = {}
            if puntaje > puntajes.mejor then
              data.puntajes = {
                  actual = puntaje,
                  ultimo = puntaje,
                  mejor = puntaje
              }
            else
              data.puntajes = {
                  actual = puntaje,
                  ultimo = puntaje,
                  mejor = puntajes.mejor
              }
            end

            serializado = lume.serialize(data)
            love.filesystem.write("puntajesPixeles.txt", serializado)

            love.load()
          end--drop
        end--cierra el choque
      end--cierra el for jq
    end--cierra el for iv
  end--if menuelegido 1


  for i,v in ipairs(pixeles) do
    v:update(dt)
  end

end--cierra el update

function love.draw()
  if menuElegido == 0 then
    anchoDeTexto = love.graphics.getFont():getWidth("Touch to start")
    love.graphics.print("Touch to start", anchoDePantalla / 2 - anchoDeTexto / 2, love.graphics.getHeight() / 2)
    love.graphics.rectangle("line", anchoDePantalla / 2 - anchoDeTexto / 2 - 10, love.graphics.getHeight() / 2 - 5, anchoDeTexto + 20, 25)
    love.graphics.print("Last score: " .. puntajes.ultimo, 20, love.graphics.getHeight() - 20)
    anchoDeTexto = love.graphics.getFont():getWidth("Best score: XXXXX.")
    love.graphics.print("Best score: " .. puntajes.mejor, anchoDePantalla - anchoDeTexto, love.graphics.getHeight() - 20)
  end
  if menuElegido == 1 then
    if modoDebug == 1 then
      love.graphics.print("origen: " .. origen, 0, love.graphics.getHeight() - 20)
      love.graphics.print("azar: " .. azar, 0, love.graphics.getHeight() - 30)
      love.graphics.print("pos x: " .. pixel.x, anchoDePantalla - 100, love.graphics.getHeight() - 20)
      love.graphics.print("dt: " .. delta, anchoDePantalla - 100, love.graphics.getHeight() - 30)
      love.graphics.print("dropeando: " .. droppin, anchoDePantalla - 200, 30)
    end
    love.graphics.print("Puntaje: ".. puntaje, 10, 40)

    --dibuja cuadrados en las posiciones guardadas en la tabla cuadrados
    for i,v in ipairs(dropeos) do
      v:draw()
    end

    for i,v in ipairs(pixeles) do
      v:draw()
    end
  end
end

function love.touchpressed(iden, xpos, ypos, dxpos, dypos, pressure)
  if true then
    tocado = true
  end
end

--almacena una posicion para generar un cuadrado
function dibujarCuadrado()
  if azar <= 40 then
    if (azar % 3) == 0 then
      table.insert(dropeos, Bomba(origen, 0))
      droppin = "bomba"
    else
      table.insert(dropeos, Drop(origen, 0))
      droppin = "pixel"
    end
  end
end