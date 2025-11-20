# Tarea 3 – Sistemas Distribuidos

## Análisis Lingüístico Offline con Hadoop y Pig

### Descripción
Este proyecto corresponde al **Entregable 3** del curso Sistemas Distribuidos.
[cite_start]El objetivo de esta etapa es transicionar del procesamiento en tiempo real (Tarea 2) al **análisis offline (Batch)** de grandes volúmenes de datos[cite: 9].

[cite_start]El sistema toma el histórico de respuestas almacenadas (tanto humanas como generadas por el LLM) y utiliza el ecosistema **Apache Hadoop** para realizar un análisis lingüístico comparativo, identificando patrones de vocabulario y frecuencia de palabras mediante trabajos de MapReduce escritos en **Apache Pig**[cite: 13].

### Arquitectura
[cite_start]El sistema se compone de los siguientes servicios containerizados[cite: 35]:

* [cite_start]**Hadoop NameNode & DataNode:** Proveen el sistema de archivos distribuido (HDFS) para almacenar los datasets de entrada y salida[cite: 23, 24].
* **Pig Container:** Actúa como cliente y procesador. [cite_start]Ejecuta los scripts de Pig Latin que transforman los datos[cite: 25].
* **Orquestador (Script Bash):** Automatiza el ciclo de vida completo: espera al clúster, realiza la ingesta de datos y ejecuta el análisis.

**Flujo de Datos (Pipeline ETL):**
`Archivos de Texto (.txt)` → `Ingesta a HDFS` → `Procesamiento MapReduce (Pig)` → `Exportación a CSV`

### Lógica de Procesamiento (MapReduce)
[cite_start]El script de Pig implementa las siguientes etapas de transformación sobre los textos[cite: 27]:

1.  [cite_start]**Tokenización:** Separación de respuestas en palabras individuales[cite: 30].
2.  [cite_start]**Normalización:** Conversión a minúsculas y eliminación de signos de puntuación (Regex)[cite: 31].
3.  [cite_start]**Filtrado (Stopwords):** Eliminación de palabras comunes sin valor semántico (ej: "the", "and", "is") mediante un *Join* con una lista de exclusión[cite: 31].
4.  [cite_start]**Agregación:** Conteo de frecuencia de palabras (WordCount) y ordenamiento descendente[cite: 32].

### Ejecución con Docker

El despliegue ha sido **completamente automatizado**. No se requieren comandos manuales de HDFS ni de Pig.

#### Requisitos
* Docker y Docker Compose instalados.

#### Pasos

```bash
git clone [https://github.com/bastianseguin-bit/Tarea-3-sistemas-distribuidos.git](https://github.com/bastianseguin-bit/Tarea-3-sistemas-distribuidos.git)
cd Tarea-3-sistemas-distribuidos/batch_analysis
docker-compose up
