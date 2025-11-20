echo "[1/5] Esperando a que Hadoop salga del 'Safe Mode'..."

until hdfs dfsadmin -safemode wait; do
    echo "   Hadoop iniciando... reintentando en 5s..."
    sleep 5
done

echo "[2/5] Hadoop listo. Preparando entorno HDFS..."

printf 'the\nand\nto\nof\na\nin\nthat\nis\ni\nit\nfor\nas\nwith\nwas\nhe\nyou\nbe\nare\non\nat\nthis\nhave\nfrom\nor\nby\none\nhad\nnot\nbut\nwhat\nall\nwere\nwhen\nwe\nthere\ncan\nan\nyour\nwhich\ntheir\nif\ndo\nwill\neach\nhow\nthey\nits' > /clean_stopwords.txt

hdfs dfs -rm -r -f /input /output /data > /dev/null 2>&1
hdfs dfs -mkdir -p /input
hdfs dfs -mkdir -p /data

echo "[3/5] Ingestando datos al Clúster (HDFS)..."
hdfs dfs -put /data/humanas.txt /input/humanas.txt
hdfs dfs -put /data/llm.txt /input/llm.txt
hdfs dfs -put /clean_stopwords.txt /data/stopwords.txt

echo "[4/5] Ejecutando trabajos MapReduce con Apache Pig..."
echo "   > Procesando Humanas..."
pig -p INPUT=/input/humanas.txt -p OUTDIR=/output/humanas_result -p STOPPATH=/data/stopwords.txt pig/wordcount.pig 2> pig_error.log

echo "   > Procesando LLM..."
pig -p INPUT=/input/llm.txt -p OUTDIR=/output/llm_result -p STOPPATH=/data/stopwords.txt pig/wordcount.pig 2>> pig_error.log

echo "[5/5] Exportando resultados finales a Windows..."

rm -f /data/resultado_humanas.csv
rm -f /data/resultado_llm.csv

hdfs dfs -getmerge /output/humanas_result /data/resultado_humanas.csv
hdfs dfs -getmerge /output/llm_result /data/resultado_llm.csv

echo "Análisis completado. Revisar los archivos .csv en carpeta 'data'."