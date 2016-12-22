print(wifi.sta.getip())
--nil
wifi.setmode(wifi.STATION)
wifi.sta.config("WS_MOSESCU","4168684byyqg")
print(wifi.sta.getip())
--192.168.18.110

pin_salida=2
pin_entrada=0
salida_rele=7
gpio.mode(pin_salida,gpio.OUTPUT)
gpio.mode(salida_rele,gpio.OUTPUT)
gpio.mode(pin_entrada,gpio.INPUT)

gpio.write(pin_salida,gpio.LOW)
gpio.write(salida_rele,gpio.LOW)

function recibir(sck,data)
    --print(data)
    if data=="prender" then
        gpio.write(pin_salida,gpio.HIGH)
        gpio.write(salida_rele,gpio.HIGH)
        print("LED Prendido")
    elseif data=="apagar" then
        gpio.write(pin_salida,gpio.LOW)
        gpio.write(salida_rele,gpio.LOW)
        print("LED Apagado")
    end
    sck:close()
end

function chk_in()
    if gpio.read(pin_entrada)==1 then
        --print(gpio.read(pin_salida))
        if gpio.read(pin_salida)==0 then
            gpio.write(pin_salida,gpio.HIGH)
            gpio.write(salida_rele,gpio.HIGH)
        else
            gpio.write(pin_salida,gpio.LOW)
            gpio.write(salida_rele,gpio.LOW)
        end
    end
end
print("Inicio de sistema")

tmr.alarm(0,1000,1,chk_in)

-- a simple telnet server
s=net.createServer(net.TCP,30) 
s:listen(3200,function(conexion) 
    print("Cliente conectado")
    conexion:on("receive",recibir)
    --conexion:send("HOLA") 
    end)     
