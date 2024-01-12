import pandas as pd
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# Especifica la ubicación del archivo CSV
archivo_csv = "Reporte_Anchos_de_banda_Tiempo_promedio.csv"

# Carga los datos en un DataFrame de pandas, omitiendo las primeras 3 filas de encabezado
data = pd.read_csv(archivo_csv)

result = data.groupby(['Drivers', ' Profundidad'])[[' Tiempo_promedio [ns]', ' Ancho_de_banda [bits/s]']].mean().reset_index()

print(result)

# Encuentra el valor máximo de Tiempo_promedio
max_tiempo_promedio = result[' Tiempo_promedio [ns]'].max()

# Encuentra el valor máximo de Ancho_de_banda
max_ancho_de_banda = result[' Ancho_de_banda [bits/s]'].max()

# Encuentra la fila correspondiente al valor máximo de Tiempo_promedio
fila_max_tiempo = result[result[' Tiempo_promedio [ns]'] == max_tiempo_promedio]

# Encuentra la fila correspondiente al valor máximo de Ancho_de_banda
fila_max_ancho = result[result[' Ancho_de_banda [bits/s]'] == max_ancho_de_banda]

print("Máximo Tiempo_promedio:", max_tiempo_promedio)
print("Máximo Ancho_de_banda:", max_ancho_de_banda)
print("\nCombinación de Drivers y Profundidad para Tiempo_promedio máximo:")
print(fila_max_tiempo[['Drivers', ' Profundidad']])
print("\nCombinación de Drivers y Profundidad para Ancho_de_banda máximo:")
print(fila_max_ancho[['Drivers', ' Profundidad']])





result.to_csv('Reporte_anchos_de_banda_tiempos_promedio_purificado.csv', index=False)

fig = plt.figure(figsize=(10, 10))
ax = fig.add_subplot(121, projection='3d')

# Graficar los datos 3D
ax.scatter(result['Drivers'], result[' Profundidad'], result[' Tiempo_promedio [ns]'])

# Configurar etiquetas de ejes
ax.set_xlabel('Drivers', labelpad=10)
ax.set_ylabel('Profundidad', labelpad=10)
ax.set_zlabel('Tiempo_promedio [ns]', labelpad= 10)

# Configurar título
ax.set_title('Tiempo_promedio [ns]')

ax2 = fig.add_subplot(122, projection='3d')

# Graficar los datos 3D
result[' Ancho_de_banda [bits/s]'] = result[' Ancho_de_banda [bits/s]'] / 10**6
ax2.scatter(result['Drivers'], result[' Profundidad'], result[' Ancho_de_banda [bits/s]'])

# Configurar etiquetas de ejes
ax2.set_xlabel('Drivers', labelpad=10)
ax2.set_ylabel('Profundidad', labelpad=10)
ax2.set_zlabel('Ancho_de_banda [Mbits/s]', labelpad= 10)

# Configurar título
ax2.set_title('Ancho_de_banda [bits/s]')

# Mostrar el gráfico 3D

plt.show()

espera = input("Presione ENTER para terminar el proceso")
