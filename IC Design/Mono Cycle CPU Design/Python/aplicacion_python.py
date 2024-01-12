import serial.tools.list_ports
import serial
import tkinter as tk
from tkinter import ttk

# Puertos seriales disponibles
puertos_disponibles = serial.tools.list_ports.comports()
puertos = [p.device for p in puertos_disponibles]

#Contadores de paquetes recibidos y enviados
contador_recibidos = 0
contador_procesados = 0

# Funcion para enviar un dato a la FPGA 
def enviar_dato():
    dato_enviar = int(entry2.get(), 16)
    ser.write(bytes([dato_enviar]))

############################### GUI #############################################################################################

# Crear la ventana principal de la GUI
ventana = tk.Tk()
ventana.geometry("520x500")
ventana.title('Interfaz para comunicación con FPGA')
ventana.resizable(False,False)

# Label de "Dato recibido" 
label_1_frame = tk.Frame(ventana)
label_1_frame.pack()
label_1 = tk.Label(label_1_frame, text="Dato recibido")
label_1.pack(pady=10)

# Display del dato recibido
dato_label_frame = tk.Frame(ventana)
dato_label_frame.pack()

dato_label = tk.Label(dato_label_frame, width=25, font=("Arial", 16), bg="#D3D3D3", fg="black",bd=1.5, height=2)
dato_label.grid(row=0, column=0, padx=20, pady=20)

#Label del combobox puerto
label_comb1_frame = tk.Frame(ventana)
label_comb1_frame.pack()
label_comb1 = tk.Label(label_comb1_frame, text="Seleccionar puerto")
label_comb1.grid(row=0, column=0, padx=10, pady=10)

#Label del combobox baud rate
label_comb2 = tk.Label(label_comb1_frame, text="Seleccionar baud rate")
label_comb2.grid(row=0, column=1, padx=10, pady=10)

# COMBOBOX
#Puertos
combobox_frame = tk.Frame(ventana)
combobox_frame.pack()
puerto_var = tk.StringVar(value="")
puerto_combo = ttk.Combobox(combobox_frame, textvariable=puerto_var, values=puertos)
puerto_combo.pack(side=tk.LEFT, padx=10, pady=10)
#Baudios
velocidades = [300, 1200, 2400, 4800, 9600, 19200, 38400, 57600, 115200]
baudios_var = tk.StringVar(value=str(velocidades[0]))  # Inicializar la variable con la primera velocidad
baudios_combo = ttk.Combobox(combobox_frame,textvariable=baudios_var, values=velocidades )
baudios_combo.pack(side=tk.LEFT, padx=10, pady=10)


# Label de "enviar dato" 
label_2_frame = tk.Frame(ventana)
label_2_frame.pack()
label_2 = tk.Label(label_2_frame, text="Dato a enviar")
label_2.pack(pady=10)

# Entry para el dato a enviar
entry2_frame = tk.Frame(ventana)
entry2_frame.pack()
entry2 = ttk.Entry(entry2_frame, width=25, font=("Arial", 15))
entry2.grid(row=0, column=0, padx=10, pady=10)

# Boton de enviar dato
boton_frame = tk.Frame(ventana)
boton_frame.pack()
boton1 = ttk.Button(entry2_frame, text="Enviar dato ", padding=10, command=enviar_dato,)
boton1.grid(row=0, column=1, padx=10, pady=10)

#Label de los paquetes recibidos
label_3_frame = tk.Frame(ventana)
label_3_frame.pack()
label_3 = tk.Label(label_3_frame, text="Paquetes recibidos")
label_3.grid(row=0, column=0, padx=10, pady=10)
#Label de los paquetes procesados
label_4 = tk.Label(label_3_frame, text="Paquetes procesados")
label_4.grid(row=0, column=10, padx=10, pady=10)
#Paquetes recibidos
label_5_frame = tk.Frame(ventana)
label_5_frame.pack()
contador_recibidos_label = tk.Label(label_5_frame, width=20, font=("Arial", 15))
contador_recibidos_label.grid(row=0, column=0, padx=10, pady=10)
#Paquetes procesados
contador_procesados_label = tk.Label(label_5_frame, width=20, font=("Arial", 15))
contador_procesados_label.grid(row=0, column=2, padx=10, pady=10)
#Inicializar los contadores en cero en la GUI
contador_procesados_label.config(text=f'{0}')
contador_recibidos_label.config(text=f'{0}')

#######################################################################################################################3


#Funciones para observar en consola el elemento del combobox seleccionado
def on_port_selected(event):
    global port
    port = puerto_var.get()
    print(f"Puerto seleccionado: {port}")

    comunicacion_serial()

def on_baud_rate_selected(event):
    global baud_rate
    baud_rate = int(baudios_var.get())
    print(f"Baudios seleccionado: {baud_rate}")

    comunicacion_serial()


baudios_combo.bind("<<ComboboxSelected>>", on_baud_rate_selected)
puerto_combo.bind("<<ComboboxSelected>>", on_port_selected)

#Valores por defecto
port = ""
baud_rate = 9600
ser = None

#Funcion para la comunicacion serial
def comunicacion_serial():
    global ser, port, baud_rate
    ser = serial.Serial(
        
        port= port,
        baudrate=baud_rate,
        bytesize=8,
        parity='N',
        stopbits=1,
        timeout=0.1
    )


def leer_dato():
    global contador_procesados, contador_recibidos
    # Verificar si se recibió un dato
    if ser is not None and ser.in_waiting > 0:
        dato_recibido = ser.read(1) 
        
        # Verifica que los 4 LSB (identificador) sea 0
        if dato_recibido[0] & 0x0F == 0:  # >> 4:
            dato_a_mostrar = dato_recibido[0] >> 4
            contador_procesados +=1
            contador_recibidos +=1 
            print(f"Paquetes procesados: {contador_procesados}")
            print(f"Dato recibido: {dato_a_mostrar}")
            contador_procesados_label.config(text=f'{contador_procesados}')
            contador_recibidos_label.config(text=f'{contador_recibidos}')
            dato_label.config(text=f'Dato: {dato_a_mostrar}')
        else:
            contador_recibidos +=1 
            print(f"Paquetes recibidos: {contador_recibidos}")
            contador_recibidos_label.config(text=f'{contador_recibidos}')
            print("El dato no es procesado")
           
    
    # Llamada para que se ejecute la funcion 'leer_dato' despues de 100 milisegundos
    ventana.after(100, leer_dato)

# Ejecuta la función leer_dato por primera vez
leer_dato()

# Iniciar el bucle principal de la GUI
ventana.mainloop()



