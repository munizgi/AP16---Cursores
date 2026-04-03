-- QUESTÃO 1.1 -  Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tivesse video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.

DO $$
DECLARE
    yt_rank INT;
    yt_nome VARCHAR(200);
    cur_rank_yt CURSOR(ranking INT, ytbr VARCHAR) FOR 
        SELECT rank, youtuber FROM tb_top_youtubers WHERE category = 'Sports' OR category = 'Music' AND video_count >= 1000;
        tupla RECORD;
BEGIN
    OPEN cur_rank_yt (ranking := yt_rank, ytbr := yt_nome);
        LOOP
            FETCH cur_rank_yt INTO tupla;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE '%', tupla;
        END LOOP;
    CLOSE cur_rank_yt;
END;
$$









