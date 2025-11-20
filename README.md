Tarea 3 – Sistemas Distribuidos
Análisis Lingüístico Offline con Hadoop y Pig
Descripción
Este proyecto corresponde al Entregable 3 del curso Sistemas Distribuidos. El objetivo de esta etapa es transicionar del procesamiento en tiempo real (Tarea 2) al análisis offline (Batch) de grandes volúmenes de datos.


El sistema toma el histórico de respuestas almacenadas (tanto humanas como generadas por el LLM) y utiliza el ecosistema Apache Hadoop para realizar un análisis lingüístico comparativo, identificando patrones de vocabulario y frecuencia de palabras mediante trabajos de MapReduce escritos en Apache Pig.


Arquitectura
El sistema se compone de los siguientes servicios containerizados:


Hadoop NameNode & DataNode: Proveen el sistema de archivos distribuido (HDFS) para almacenar los datasets de entrada y salida.

Pig Container: Actúa como cliente y procesador. Ejecuta los scripts de Pig Latin que transforman los datos.

Orquestador (Script Bash): Automatiza el ciclo de vida completo: espera al clúster, realiza la ingesta de datos y ejecuta el análisis.

Flujo de Datos (Pipeline ETL): Archivos de Texto (.txt) → Ingesta a HDFS → Procesamiento MapReduce (Pig) → Exportación a CSV

Lógica de Procesamiento (MapReduce)
El script de Pig implementa las siguientes etapas de transformación sobre los textos:

Tokenización: Separación de respuestas en palabras individuales.

Normalización: Conversión a minúsculas y eliminación de signos de puntuación (Regex).

Filtrado (Stopwords): Eliminación de palabras comunes sin valor semántico (ej: "the", "and", "is") mediante un Join con una lista de exclusión.

Agregación: Conteo de frecuencia de palabras (WordCount) y ordenamiento descendente.

Ejecución con Docker
El despliegue ha sido completamente automatizado. No se requieren comandos manuales de HDFS ni de Pig.

Requisitos
Docker y Docker Compose instalados.

Pasos
Bash

git clone https://github.com/bastianseguin-bit/Tarea-3-sistemas-distribuidos.git
cd Tarea-3-sistemas-distribuidos/batch_analysis
docker-compose up
¿Qué sucede al ejecutar esto?

Se levanta el clúster de Hadoop.

El contenedor pig ejecuta automáticamente el script run_analysis.sh.

El script espera a que Hadoop salga del "Safe Mode".

Se suben los datasets (humanas.txt, llm.txt) y stopwords.txt a HDFS.

Se ejecutan los trabajos de análisis.

Los resultados finales se descargan automáticamente a tu carpeta local data/.

Resultados
Al finalizar la ejecución (cuando veas el mensaje 🎉 ¡ANÁLISIS COMPLETADO!), encontrarás dos archivos en la carpeta data/:

resultado_humanas.csv: Top de palabras más usadas por usuarios reales.

resultado_llm.csv: Top de palabras más usadas por la IA.

Estos datos permiten comparar la riqueza léxica y formalidad entre humanos y máquinas.

Video de Demostración
