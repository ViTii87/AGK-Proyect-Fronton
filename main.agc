// Project: Fronton 
// Created: 2015-12-05
// Victor Melcon

// set window properties
SetWindowTitle("Fronton")
SetWindowSize(GetDeviceWidth(), GetDeviceHeight(), 0)

// set display properties
SetVirtualResolution(GetDeviceWidth(), GetDeviceHeight())
SetOrientationAllowed(0, 0, 1, 1)

// Guardamos en 2 variables la altura y anchura de cualquier dispositivo
rx= GetDeviceWidth()
ry= GetDeviceHeight()

//Cargamos la imagen de titulo y la ajustamos a pantalla
LoadImage(7,"titulo.png")
CreateSprite(8,7)
SetSpriteSize(8,rx,-1)

//Obtenemos el ancho y largo de la imagen
sx=GetSpriteWidth(8)
sy=GetSpriteHeight(8)
//Creamos un texto y lo ajustamos en la posicion correcta
text$="PRESS"
CreateText(1,text$) 
SetTextSize(1,sy/10)
SetTextColor(1,255,0,0,255)
SetTextPosition(1,sx/3.45,sy/1.46)

do
	//Hacemos que parpadee el texto a cada segundo
	if Mod(GetSeconds(),2)=0
		SetTextVisible(1,0)
	else
		SetTextVisible(1,1)
	endif
	
	if getPointerState()
		DeleteText(1)
		deleteSprite(8)
		gosub juego
	endif
	
	//Si presionamos el boton de volver salimos del juego
	if getRawKeyPressed(27)>0
		end
	endif
	sync()
loop


juego:
// Guardamos en 2 variables la altura y anchura de cualquier dispositivo
rx= GetDeviceWidth()
ry= GetDeviceHeight()

// Cargamos las imagenes que vamos a utilizar, 1 barra, 1 bola y 3 marcos.
LoadImage(1, "barra.png")
LoadImage(2, "bola.png")
LoadMusic(1,"music.mp3")
PlayMusic(1,1)

//Cargamos los 3 marcos
for x=3 to 5
    LoadImage(x, "marco.png")
    CreateSprite(x, x)
Next x

LoadImage(6, "coli1.png")

// Creamos y colocamos la barra
CreateSprite(1, 1)
SetSpriteX(1, rx-100)
SetSpriteY(1, 50)

// Creamos nuestra bola
CreateSprite(2, 2)
SetSpriteY(2, 400)
SetSpriteX(2,100)

// Ajustamos la posicion de la barra superior(3)
SetSpriteY(3, 0)
// Ajustamos la barra central(4) para que no se solape con la 3
SetSpriteY(4, 25)
// Ajustamos la posicion de la barra inferior(5) como el sprite mide 25, hay que restarle 25
SetSpriteY(5, ry-25)
// Cambiamos los tamaños de nuestras barras para que ocupen la pantalla
SetSpriteSize(3,rx, getSpriteHeight(3))
SetSpriteSize(4,getSpriteWidth(4),ry)
SetSpriteAngle(4, 180) 
SetSpriteSize(5,rx, getSpriteHeight(5))
SetSpriteSize(1,getSpriteWidth(1),ry/5)

//Barras colisionadoras
//Superior
CreateSprite(6, 6)
SetSpriteX(6, rx-100)
SetSpriteVisible(6,0)
//Inferior
CreateSprite(7, 6)
SetSpriteX(7, rx-100)
SetSpriteVisible(7,0)

//Inicializamos algunas variables para la velocidad, puntuacion maximo y raton en Y
velocidadX#=6
velocidadY#=6
puntuacion=0
maximo=0
b=0

//Ajustamos color y tamaño de nuestro texto
SetPrintColor(255, 0, 0) 
SetPrintSize(30)

// Bucle principal
do
	
	// Imprimimos la puntuacion
	print("Puntuacion: " + Str(puntuacion) + "            Maxima:" + Str(maximo))
	
	// Hacemos que nuestra bola se mueva por pantalla	
	//setSpritePositionByOffset(2, getSpriteXByOffSet(2)+velocidadX#,getSpriteYByOffSet(2)+velocidadY#)
	SetSpritePosition(2, getSpriteX(2)+velocidadX#,getSpriteY(2)+velocidadY#)
	
	//Comprobamos la colision con la pared inferior, cundo toque ponemos la bola justo al borde y cambiamos la velocidad
	if(GetSpriteCollision(2,5)=1)
		SetSpritePosition(2, getSpriteX(2),getSpriteY(5)-50)
		velocidadY#=velocidadY#*-1
	endif
	
	//Lo mismo para la pared superior
	if(GetSpriteCollision(2,3)=1)
		SetSpritePosition(2, getSpriteX(2),getSpriteY(3)+25)
		velocidadY#=velocidadY#*-1
	endif

	//Colision con la pala, cuando choque colocamos la pelota preparada para salir del borde de la pala, luego invertimos velocidad
	if(GetSpriteCollision(2,1)=1)
		SetSpritePosition(2, getSpriteX(1)-45,getSpriteY(2))
		velocidadX#=velocidadX#*-1
	endif
	
	//Lo mismo pero aplicado a los detectores inferior y superior de colision
	if(GetSpriteCollision(2,6)=1) 
		SetSpritePosition(2, getSpriteX(2),getSpriteY(6)-16-45)
		velocidadY#=velocidadY#*-1
	endif
	if(GetSpriteCollision(2,7)=1)
		SetSpritePosition(2, getSpriteX(2),getSpriteY(7)+16)
		velocidadY#=velocidadY#*-1
	endif

	// Si chocamos contra el muro central, añadimos mas velocidad a la bola y ademas sumamos un punto	
	if(GetSpriteCollision(2,4)=1)
		SetSpritePosition(2, getSpriteX(3)+25,getSpriteY(2))
		velocidadX#=velocidadX#*-1.05
		velocidadY#=velocidadY#*1.05
		inc puntuacion,1
	endif

	// Si no llegamos a tocar la bola con la pala resetemos la puntuacion, las velocidades y asignamos un maximo.	
	if(GetSpriteXByOffset(2)>rx-50)
		SetSpriteY(2, 400)
		SetSpriteX(2,100)
		velocidadX#=6
		velocidadY#=6
		if(puntuacion>maximo)
			maximo = puntuacion
		endif
		puntuacion=0
	endif

	// Obtenemos primero si pulsamos en pantalla
	if getPointerState()
		// Entonces calculamos si estamos pulsando dentro de nuestra barra
		if getPointerX()>getSpriteX(1) AND getPointerX()<getSpriteX(1)+45
			if getPointerY()>getSpriteY(1) AND getPointerY()<getSpriteY(1)+ry/5
				// Usaremos una bandera para poder seguir moviendo la barra aunque no estemos sobre ella
				bandera = 1
			endif
		endif
	else
		bandera = 0
	endif
	
	// Con esto vamos a poder conseguir que movamos el sprite dependiendo de la posicion de nuestro dedo
	if bandera = 1	
		// Calculamos los limites para los que queremos que la pala se mueva o no, controlamos tambien los colisionadores
		if(getPointerY()>=((ry/5)/2)+25) and (getPointerY()<=ry-(((ry/5)/2)+25))
			setSpritePositionByOffset(1, getSpriteXByOffSet(1), getPointerY())
			setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, getPointerY()-((ry/5)/2)+3)
			setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, getPointerY()+((ry/5)/2)-3)
		else
			//Si es menor que 90 se nos iria muy arriba asi que hay que dejarlo en 90
			if(getPointerY()<((ry/5)/2)+25)
				setSpritePositionByOffset(1, getSpriteXByOffSet(1), ((ry/5)/2)+25)
				setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, (((ry/5)/2)+25)-((ry/5)/2)+3)
				setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, (((ry/5)/2)+25)+((ry/5)/2)-3)
			else
				// Si es menos que el borde inferior se nos iria muy abajo asi que lo dejamos en posicion fija de pantalla -90
				if(getPointerY()>=ry-(((ry/5)/2)+25))
					setSpritePositionByOffset(1, getSpriteXByOffSet(1), ry-(((ry/5)/2)+25))
					setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, ry-(((ry/5)/2)+25)-((ry/5)/2)+3)
					setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, ry-(((ry/5)/2)+25)+((ry/5)/2)-3)
				endif	
			endif
		endif
	endif
		
	//Si presionamos el boton de volver salimos del juego
	if getRawKeyPressed(27)>0
		end
	endif

	Sync()

loop
return

