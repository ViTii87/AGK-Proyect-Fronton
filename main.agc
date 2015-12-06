// Project: Fronton 
// Created: 2015-12-05

// set window properties
SetWindowTitle( "Fronton" )
SetWindowSize( GetDeviceWidth(), GetDeviceHeight(), 0 )

// set display properties
SetVirtualResolution( GetDeviceWidth(), GetDeviceHeight() )
SetOrientationAllowed( 0, 0, 1, 1 )

// Guardamos en 2 variables la altura y anchura de cualquier dispositivo
rx= GetDeviceWidth()
ry= GetDeviceHeight()

// Cargamos las imagenes que vamos a utilizar, 1 barra, 1 bola y 3 marcos.
LoadImage(1, "barra.png")
LoadImage(2, "bola.png")
LoadMusic(1,"music.mp3")
//PlayMusic(1,1)

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
SetSpriteAngle( 4, 180 ) 
SetSpriteSize(5,rx, getSpriteHeight(5))

//Barras colisionadoras
CreateSprite(6, 6)
SetSpriteX(6, rx-100)
SetSpriteVisible(6,0)

CreateSprite(7, 6)
SetSpriteX(7, rx-100)
SetSpriteVisible(7,0)


//Inicializamos algunas variables para la velocidad, puntuacion maximo y raton en Y
velocidadX#=3
velocidadY#=3
puntuacion=0
maximo=0
atrapado=0

//Ajustamos color y tamaño de nuestro texto
SetPrintColor( 255, 0, 0 ) 
SetPrintSize(30)


// Bucle principal
do
	// Imprimimos la puntuacion
	print("Puntuacion: " + Str(puntuacion) + "            Maxima:" + Str(maximo))
	
	// Si la bola choca con pared inferior o superior simplemente cambiamos la velocidad del eje y por la contratia
	if(GetSpriteCollision(2,5)=1) or (GetSpriteCollision(2,3)=1) 
		velocidadY#=velocidadY#*-1
	endif

	// Si chocamos contra la pala solo cambiamos la del eje x a la contraria	
	if(GetSpriteCollision(2,1)=1)
		if(GetSpriteCollision(2,6)=1) or (GetSpriteCollision(2,7)=1)
			velocidadY#=velocidadY#*-1
		else
			velocidadX#=velocidadX#*-1
		endif
	endif	

	// Si chocamos contra el muro central, añadimos mas velocidad a la bola y ademas sumamos un punto	
	if(GetSpriteCollision(2,4)=1)
		velocidadX#=velocidadX#*-1.05
		velocidadY#=velocidadY#*1.05
		inc puntuacion,1
	endif

	// Si no llegamos a tocar la bola con la pala resetemos la puntuacion, las velocidades y asignamos un maximo.	
	if(GetSpriteXByOffset(2)>rx-50)
		SetSpriteY(2, 400)
		SetSpriteX(2,100)
		velocidadX#=3
		velocidadY#=3
		if(puntuacion>maximo)
			maximo = puntuacion
		endif
		puntuacion=0
	endif

	// Hacemos que nuestra bola se mueva por pantalla	
	setSpritePositionByOffset(2, getSpriteXByOffSet(2)+velocidadX#,getSpriteYByOffSet(2)+velocidadY#)

	// Obtenemos primero si pulsamos en pantalla
	if getPointerState()
		// Entonces calculamos si estamos pulsando dentro de nuestra barra
		if getPointerX()>getSpriteX(1) AND getPointerX()<getSpriteX(1)+45
			if getPointerY()>getSpriteY(1) AND getPointerY()<getSpriteY(1)+130
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
			if(getPointerY()>=90) and (getPointerY()<=ry-90)
				setSpritePositionByOffset(1, getSpriteXByOffSet(1), getPointerY())
				setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, getPointerY()-58)
				setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, getPointerY()+58)
			else
				//Si es menor que 90 se nos iria muy arriba asi que hay que dejarlo en 90
				if(getPointerY()<90)
					setSpritePositionByOffset(1, getSpriteXByOffSet(1), 90)
					setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, 90-58)
					setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, 90+58)
				else
					// Si es menos que el borde inferior se nos iria muy abajo asi que lo dejamos en posicion fija de pantalla -90
					if(getPointerY()>=ry-90)
						setSpritePositionByOffset(1, getSpriteXByOffSet(1), ry-90)
						setSpritePositionByOffset(6, getSpriteXByOffSet(1)+1, ry-90-58)
						setSpritePositionByOffset(7, getSpriteXByOffSet(1)+1, ry-90+58)
					endif	
				endif
			endif
		endif

	Sync()
loop
