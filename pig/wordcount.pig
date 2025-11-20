-- wordcount.pig

-- 1. Cargar datos usando la variable $INPUT
raw_data = LOAD '$INPUT' USING PigStorage('\n') AS (line:chararray);

-- 2. Tokenizar y pasar a minúsculas
words = FOREACH raw_data GENERATE FLATTEN(TOKENIZE(LOWER(line))) AS word;

-- 3. Limpieza: Usamos REPLACE (corregido) para quitar lo que no sea letras
clean_words = FOREACH words GENERATE REPLACE(word, '[^a-z]', '') AS word;

-- Filtramos palabras vacías
non_empty_words = FILTER clean_words BY SIZE(word) > 0;

-- 4. Cargar Stopwords usando la variable $STOPPATH
stopwords = LOAD '$STOPPATH' AS (stopword:chararray);

-- 5. Join para filtrar stopwords
joined_words = JOIN non_empty_words BY word LEFT, stopwords BY stopword;

filtered_words = FILTER joined_words BY stopwords::stopword IS NULL;

final_words = FOREACH filtered_words GENERATE non_empty_words::word AS word;

-- 6. Agrupar y Contar
grouped_words = GROUP final_words BY word;
word_counts = FOREACH grouped_words GENERATE group AS word, COUNT(final_words) AS count;

-- 7. Ordenar
ordered_counts = ORDER word_counts BY count DESC;

-- 8. Guardar usando la variable $OUTDIR
STORE ordered_counts INTO '$OUTDIR' USING PigStorage(',');