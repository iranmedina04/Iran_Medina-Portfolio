main:

	addi x30, x0, 0x0  # Contador de recibidos
	addi x31, x0, 0x0  # Contador de procesados
	
	#direccion switches x1
	 
	addi x1, x0, 0x20
	slli x1, x1, 8
	addi x1, x1, 0x0
	
	#Direccion leds
	
	addi x2, x0, 0x20
	slli x2,x2, 8
	addi x2, x2, 0x4
	
	#Direccion de los 7 segmentos 
	
	addi x3, x0, 0x20
	slli x3, x3, 8
	addi x3, x3, 0x8
	
	# Dirección control UART A
	
	addi x4, x0, 0x20
	slli x4, x4, 8
	addi x4, x4, 0x10
	
	# Direccion dato 1 UART A
	
	addi x5, x0,0x20
	slli x5, x5, 8
	addi x5, x5, 0x18
	
	# Direccion dato 2 UART A
	
	addi x6, x0,0x20
	slli x6, x6, 8
	addi x6, x6, 0x1C
	
	# Dirección control UART B
	
	addi x7, x0, 0x20
	slli x7, x7, 8
	addi x7, x7, 0x20
	
	# Direccion dato 1 UART B
	
	addi x8, x0,0x20
	slli x8, x8, 8
	addi x8, x8, 0x28
	
	# Direccion dato 2 UART B
	
	addi x9, x0,0x20
	slli x9, x9, 8
	addi x9, x9, 0x2C
	
	# Dirección control UART C
	
	addi x10, x0, 0x20
	slli x10, x10, 8
	addi x10, x10, 0x30
	
	# Direccion dato 1 UART C
	
	addi x11, x0,0x20
	slli x11, x11, 8
	addi x11, x11, 0x38
	
	# Direccion dato 2 UART C
	
	addi x12, x0,0x20
	slli x12, x12, 8
	addi x12, x12, 0x3C
	
	b reposo

reposo: 
	  		
	lw x17, (x4)   #Carga la direccion de control del UART A
	lw x18, (x7)   #Carga la direccion de control del UART B
	lw x19, (x10)  #Carga la direccion de control del UART C
	
	addi x20, x0, 0x2 #Crea la mascara para el NEW del control 
	and x21, x17, x20 #Solo deja pasar el bit del NEW
	beq x21, x20, procesamiento_a #Si el NEW de registro es 1 pasa a procesar a
	
	and x21, x18, x20 #Solo deja pasar el bit del NEW
	beq x21, x20, procesamiento_b #Si el NEW de registro es 1 pasa a procesar b 
	
	and x21, x19, x20 #Solo deja pasar el bit del NEW
	beq x21, x20, procesamiento_c #Si el NEW de registro es 1 pasa a procesar c
	
	# Si no hay ningun dato que procesar verifica si hay algun dato que enviar ##############################################################
	addi x14, x0, 0x10   #Crea la mascara para el bit del boton
	slli x14, x14, 12
	lw x13, (x1)         # Este x13, cargó los switches
	and x15, x13, x14    #Solo deja pasar el bit de envio 
	beq x15, x14, envio  #Si el bit de envio es 1 pasa a envio 
	b reposo             #Si no se queda en reposo
	

boton: 
	addi x14, x0, 0x10   #Mascara para el boton
	slli x14, x14, 12    #0x10000
	
	lw x13, (x1)   	     # Este x13, cargó los switches
	and x15, x13, x14
	beq x15, x14, boton  #Si es 1 se mantiene en el loop de boton 
	b reposo             #Si no va a reposo
	
	
envio:
	lw x13, (x1)         #Se cargan los switches
	addi x14, x0, 0xFF   #Se crea la mascara para tomar los 8 bits del paquete 
	and  x13, x13, x14   #Hace la mascara al dato de los registros
	addi x14, x0, 0x1    #Se establece el send para los registros de control
	

	sw x13, (x5)         #Guardando dato en UART A
	sw x14, (x4)         #Guarda dato de control UART A
	
	
	sw x13, (x8)         #Guardando dato en UART B
	sw x14, (x7)         #Guarda dato de control UARRT B
		
	
	sw x13 (x11)         #Guardando dato en UART C
	sw x14, (x10)        #Guardando dato de control en UART C
	
	b enviado
	
enviado:

	addi x13, x0, 0x1       #Crea la mascara para el bit send del registro de control de los UART
	
	lw x14, (x4)            #Carga el control del UART A
	and x14, x14, x13       #Aplica la mascara
	beq x14, x13, enviado	#Si sigue en uno es porque se esta enviando entonces regresa al loop
	
	lw x15, (x7)		#Carga el control del UART B
	and x15, x15, x13       #Aplica la mascara
	beq x15, x13, enviado   #Si sigue en uno es porque se esta enviando entonces regresa al loop
	
	lw x16, (x10)		#Carga el control del UART C
	and x16, x16, x13       #Aplica la mascara
	beq x16, x13, enviado   #Si sigue en uno es porque se esta enviando entonces regresa al loop
	
	b boton                 #Si todos se enviaron entonces va a esperar a que se deje de presionar el boton

procesamiento_a:
	
	lw x13, (x1)               #Dato switches
	addi x17, x0, 0xF          #Hace la mascara para los primeros cuatro bits
	slli x17, x17, 8
	and x13, x13, x17          #Aplica la mascara para obtener la direccion de identificador de los switches
	
	lw x18, (x6)               #Dato 2 UART A (dato recibido)
	addi x17, x0, 0xF
	and x19, x18, x17          #Aplica la mascara para obtener la direccion de envio del dato recibido 
	slli x19, x19, 8
	
	beq x13, x19, consumir_a   #Compara la direccion de los switches con el dato recibido y si es el mismo va a consumir paquete A
	b retransmitir_a           #Si no va a retransmitir A
	
procesamiento_b:

	lw x13, (x1)               #Dato switches
	addi x17, x0, 0xF          #Hace la mascara para los primeros cuatro bits
	slli x17, x17, 8
	and x13, x13, x17          #Aplica la mascara para obtener la direccion de envio de los switches
	
	lw x18, (x9)               #Dato 2 UART B (dato recibido)
	addi x17, x0, 0xF
	and x19, x18, x17          #Aplica la mascara para obtener la direccion de envio del dato recibido 
	slli x19, x19, 8
	
	beq x13, x19, consumir_b   #Compara la direccion de los switches con el dato recibido y si es el mismo va a consumir paquete B
	b retransmitir_b           #Si no va a retransmitir B
	
procesamiento_c:

	lw x13, (x1)               #Dato switches
	addi x17, x0, 0xF          #Hace la mascara para los primeros cuatro bits
	slli x17, x17, 8
	and x13, x13, x17          #Aplica la mascara para obtener la direccion de envio de los switches
	
	lw x18, (x12)              #Dato 2 UART C (dato recibido)
	addi x17, x0, 0xF
	and x19, x18, x17          #Aplica la mascara para obtener la direccion de envio del dato recibido 
	slli x19, x19, 8
	
	beq x13, x19, consumir_c   #Compara la direccion de los switches con el dato recibido y si es el mismo va a consumir paquete C
	b retransmitir_c           #Si no va a retransmitir C


retransmitir_a:	 #Borrar NEW 

	addi x30, x30, 0x1  #Aumento de contador recibidos
	
	lw x18, (x6)        #Carga el dato recibido
	addi x13, x0, 0x0   #Establece la instruccion sin el NEW
	sw x13, (x4)        #Guarda la instruccion sin el NEW
	sw x18, (x8)        #Guarda el dato en el registro de envio del UART B
	sw x18, (x11)       #Guarda el dato en el registro de envio del UART C
	
	addi x13, x0, 0x1   #Establece el send para el registro de control B y C
	sw x13, (x7)        #Guarda el send en el registro de control UART B
	sw x13, (x10)       #Guarda el send en el registro de control UART C
	sw x30, (x2)        #Muestra contador de recibidos en los LEDS 
	b espera_envio_a    #Pasa a esperar a que los datos sean enviados
	
retransmitir_b:

	addi x30, x30, 0x1  #Aumento de contador recibidos
	
	lw x18, (x9)	    #Carga el dato recibido
	addi x13, x0, 0x0   #Establece la instruccion sin el NEW
	sw x13, (x7)        #Guarda la instruccion sin el NEW
	sw x18, (x5)        #Guarda el dato en el registro de envio del UART A
	sw x18, (x11)       #Guarda el dato en el registro de envio del UART C
	
	addi x13, x0, 0x1   #Establece el send para el registro de control A y C
	sw x13, (x4)        #Guarda el send en el registro de control UART A
	sw x13, (x10)       #Guarda el send en el registro de control UART C
	sw x30, (x2)        #Muestra contador de recibidos en los LEDS
	b espera_envio_b    #Pasa a esperar a que los datos sean enviados
	
retransmitir_c:	

	addi x30, x30, 0x1  #Aumento de contador recibidos
	
	lw x18, (x12)       #Dato 2 UART C
	addi x13, x0, 0x0   #Establece la instruccion sin el NEW
	sw x13, (x10)        #Guarda la instruccion sin el NEW
	sw x18, (x5)        #Dato 1 UART A
	sw x18, (x8)        #Dato 1 UART B
	
	addi x13, x0, 0x1
	sw x13, (x4)        #Control UART A
	sw x13, (x7)        #Control UART B
	sw x30, (x2)        #Muestra contador de recibidos
	b espera_envio_c
		
		
espera_envio_a:    
	
	addi x13, x0, 0x1  		#Establece la comparacion con el send 
	
	lw x15, (x7)       		#Carga el registro de control del UART B
	and x15, x15, x13               #Aplica la mascara
	beq x15, x13, espera_envio_a 	#Si es 1 sigue enviando y se mantiene en el loop
	
	lw x16, (x10)      		#Carga el registro de control del UART C
	and x16, x16, x13               #Aplica la mascara
	beq x16, x13, espera_envio_a 	#Si es 1 sigue enviando y se mantiene en el loop
	b boton 			#Termino de enviar y pasa a esperar a que ya no se presione el boton 
	
espera_envio_b:
	
	addi x13, x0, 0x1 		#Establece la comparacion con el send 
	
	lw x15, (x4) 			#Carga el registro de control del UART A
	and x15, x15, x13               #Aplica la mascara
	beq x15, x13, espera_envio_b 	#Si es 1 sigue enviando y se mantiene en el loop
	
	lw x16, (x10) 			#Carga el registro de control del UART C
	and x16, x16, x13               #Aplica la mascara
	beq x16, x13, espera_envio_b 	#Si es 1 sigue enviando y se mantiene en el loop
	b boton 			#Termino de enviar y pasa a esperar a que ya no se presione el boton 

espera_envio_c:
	
	addi x13, x0, 0x1 		#Establece la comparacion con el send 
	
	lw x15, (x4) 			#Carga el registro de control del UART A
	and x15, x15, x13               #Aplica la mascara
	beq x15, x13, espera_envio_c 	#Si es 1 sigue enviando y se mantiene en el loop
	
	lw x16, (x7) 			#Carga el registro de control del UART B
	and x16, x16, x13               #Aplica la mascara
	beq x16, x13, espera_envio_c 	#Si es 1 sigue enviando y se mantiene en el loop
	b boton 			#Termino de enviar y pasa a esperar a que ya no se presione el boton 
	
	
consumir_a:
	
	addi x31, x31, 0x1  #Aumento de contador procesados
	addi x30, x30, 0x1  #Aumento de contador recibidos
	addi x17, x0, 0xF0  #Máscara para el dato a consumir
	
	lw x13, (x6)	    #Dato 2 UART A
	and x13, x13, x17   #Aplicando la mascara
	srli x13, x13, 4     #Corriendo a la derecha el dato del registro de recibidos
	slli x29, x31, 4    #Corriendo el contador de procesados a la izquierda 
	add x13, x29, x13   #Concantenando el dato y el contador
	
	sw x13, (x3)        #Muestra contador de procesados
	sw x30, (x2)        #Muestra contador de recibidos
	
	addi x13, x0, 0x0   #Borrar NEW
	sw   x13, (x4)
	
	b boton
	
consumir_b: #Agregar instruccion de correr a la derecha 
	
	addi x31, x31, 0x1  #Aumento de contador procesados
	addi x30, x30, 0x1  #Aumento de contador recibidos
	addi x17, x0, 0xF0  #Máscara para el dato a consumir
	
	lw x13, (x9)	    #Dato 2 UART B
	and x13, x13, x17   #Aplicando la mascara
	srli x13, x13, 4     #Corriendo a la derecha el dato del registro de recibidos
	slli x29, x31, 4    #Corriendo el contador de procesados a la izquierda
	add x13, x29, x13   #Concantenando el dato y el contador
	
	sw x13, (x3)        #Muestra contador de procesados
	sw x30, (x2)        #Muestra contador de recibidos
	
	addi x13, x0, 0x0   #Borrar NEW
	sw   x13, (x7)
	
	b boton

consumir_c:
	
	addi x31, x31, 0x1  #Aumento de contador procesados
	addi x30, x30, 0x1  #Aumento de contador recibidos
	addi x17, x0, 0xF0  #Máscara para el dato a consumir
	
	lw x13, (x12)	    #Dato 2 UART C
	and x13, x13, x17   #Aplicando la mascara
	srli x13, x13, 4     #Corriendo a la derecha el dato del registro de recibidos
	slli x29, x31, 4    #Corriendo el contador de procesados a la izquierda
	add x13, x13, x29   #Concantenando el dato y el contador
	
	sw x13, (x3)        #Muestra contador de procesados
	sw x30, (x2)        #Muestra contador de recibidos
	
	addi x13, x0, 0x0   #Borrar NEW
	sw   x13, (x10)
	
	b boton
	
