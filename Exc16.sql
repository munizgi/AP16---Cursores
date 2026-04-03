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

-- QUESTÃO 1.2 -  Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
-- - O SELECT deverá ordenar em ordem não reversa
-- - O Cursor deverá ser movido para a última tupla
-- - Os dados deverão ser exibidos de baixo para cima

DO $$
DECLARE
    yt_nome VARCHAR(200);
    cur_nome REFCURSOR;
BEGIN
    OPEN cur_nome SCROLL FOR SELECT youtuber FROM tb_top_youtubers;
        LOOP
            FETCH cur_nome INTO yt_nome;
            EXIT WHEN NOT FOUND;
        END LOOP;
        LOOP
            FETCH BACKWARD FROM cur_nome INTO yt_nome;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE '%', yt_nome;
        END LOOP;
    CLOSE cur_nome;
END;
$$

-- QUESTÃO 1.3 -PESQUISA RBAR (Row By Agonizing Row)
/*

  O termo RBAR, cunhado por Jeff Moden, refere-se ao anti-padrão de processar 
  dados uma linha por vez (procedural) em vez de usar operações de conjunto (set-based).
  
  EM MINHAS PALAVRAS:
  Trata-se de "trazer a lógica de programação convencional" para dentro do banco de dados. 
  Em vez de dar uma única ordem para o banco resolver (ex: "Aumente o salário de todos"), 
  o desenvolvedor usa um cursor para pegar o primeiro funcionário, aumentar o salário, 
  pegar o segundo, aumentar o salário, e assim por diante. 
  
  Isso é chamado de "Agonizante" porque destrói a performance: o banco de dados 
  foi feito para trabalhar com grandes blocos de dados de uma vez, e forçá-lo a 
  repetir o processo para cada linha gera um custo de processamento (overhead) 
  gigantesco e desnecessário.
*/

-- Exemplo de como EVITAR o RBAR (usando Set-based em vez de Cursor):
-- UPDATE tb_top_youtubers SET subscribers = subscribers + 1 WHERE category = 'Music';
