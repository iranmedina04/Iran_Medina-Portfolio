import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Especifica la ubicación del archivo CSV
archivo_csv = "Reporte_Anchos_de_banda_Tiempo_promedio.csv"

# Carga los datos en un DataFrame de pandas, omitiendo las primeras 3 filas de encabezado
data = pd.read_csv(archivo_csv)

result = data.groupby(['Profundidad'])[['Tiempo_promedio', 'Ancho_de_banda']].mean().reset_index()
result = result.drop(0)
print(result)

# Encuentra el valor máximo de Tiempo_promedio
max_tiempo_promedio = result['Tiempo_promedio'].max()

# Encuentra el valor máximo de Ancho_de_banda
max_ancho_de_banda = result['Ancho_de_banda'].max()

# Encuentra la fila correspondiente al valor máximo de Tiempo_promedio
fila_max_tiempo = result[result['Tiempo_promedio'] == max_tiempo_promedio]

# Encuentra la fila correspondiente al valor máximo de Ancho_de_banda
fila_max_ancho = result[result['Ancho_de_banda'] == max_ancho_de_banda]

print("Máximo Tiempo_promedio:", max_tiempo_promedio)
print("Máximo Ancho_de_banda:", max_ancho_de_banda)
print("\nProfundidad para Tiempo_promedio máximo:")
print(fila_max_tiempo[['Profundidad']])
print("\nProfundidad para Ancho_de_banda máximo:")
print(fila_max_ancho[['Profundidad']])


result.to_csv('Reporte_anchos_de_banda_tiempos_promedio_purificado.csv', index=False)

fig = plt.figure(figsize=(10, 10))
ax = fig.add_subplot(121)

# Graficar los datos 3D
ax.plot(result['Profundidad'], result['Tiempo_promedio'], marker='o', linestyle='-', color='b', label='Tiempo_promedio')

# Configurar etiquetas de ejes
ax.set_xlabel('Profundidad Fifos', labelpad=10)
ax.set_ylabel('Tiempo promedio', labelpad=10)


# Configurar título
ax.set_title('Tiempo_promedio')

ax2 = fig.add_subplot(122)

# Graficar los datos 3D
result['Ancho_de_banda'] = result['Ancho_de_banda'] / 10**6
ax2.plot(result['Profundidad'], result['Ancho_de_banda'], marker='o', linestyle='-', color='r', label='Ancho_de_banda [Mbits/s]')

# Configurar etiquetas de ejes
ax2.set_xlabel('Profundidad Fifos', labelpad=10)
ax2.set_ylabel('Ancho_de_banda [Mbits/s]', labelpad= 10)

# Configurar título
ax2.set_title('Ancho_de_banda [bits/s]')

# Mostrar el gráfico 3D

plt.show()

espera = input("Presione ENTER para terminar el proceso")
