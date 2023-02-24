use fcc_sql_guides_database; -- seleciona o banco de dados da amostra, chamado fcc_sql_guides



select studentID, FullName, 3+2 as five, now() as currentDate
    from student;
    
    select studentID, FullName, sat_score, recordUpdated
    from student
    where (
		studentID between 1 and 5
		or studentID = 8
        or FullName like '%Maximo%'
		);
    
    
    Instrução WHERE (AND/OR, IN, BETWEEN e LIKE)
A instrução WHERE é usada para limitar o número de linhas retornado.

    select studentID, FullName, sat_score, recordUpdated
    from student
    where (
		studentID between 1 and 5
		or studentID = 8
        or FullName like '%Maximo%'
		);
Neste caso, usar todas as propriedades torna a instrução WHERE bastante ridícula.

Compare o resultado com a instrução SQL acima para seguir a lógica.

Serão apresentadas linhas que:

Têm studentIDs entre 1 e 5 (incluindo os extremos)
ou studentID = 8
ou ainda que tenha "Maximo" no nome
O exemplo a seguir é semelhante, mas especifica ainda mais excluindo os alunos com pontuações de SAT que estiverem entre 1000 e 1400. Esses não serão apresentados:

    select studentID, FullName, sat_score, recordUpdated
    from student
    where (
		studentID between 1 and 5
		or studentID = 8
        or FullName like '%Maximo%'
		)
		and sat_score NOT in (1000, 1400);
syntax02
ORDER BY (ASC, DESC)
ORDER BY nos oferece uma maneira de ordenar o conjunto de resultados por um ou mais itens da seção SELECT. Abaixo veremos a mesma lista que vemos acima, mas ordenada pelo Full Name (nome completo) dos alunos. A ordem padrão é a ascendente (ASC), mas para ordenar em ordem inversa (descendente), é possível usar DESC.

SELECT studentID, FullName, sat_score
FROM student
ORDER BY FullName DESC;
+-----------+------------------------+-----------+
| studentID | FullName               | sat_score |
+-----------+------------------------+-----------+
|         2 | Teri Gutierrez         |       800 |
|         3 | Spencer Pautier        |      1000 |
|         6 | Sophie Freeman         |      1200 |
|         9 | Raymond F. Boyce       |      2400 |
|         1 | Monique Davis          |       400 |
|         4 | Louis Ramsey           |      1200 |
|         7 | Edgar Frank "Ted" Codd |      2400 |
|         8 | Donald D. Chamberlin   |      2400 |
|         5 | Alvin Greene           |      1200 |
+-----------+------------------------+-----------+
9 rows in set (0.00 sec)
Abaixo vemos a lista NÃO ORDENADA, atual e completa dos alunos, para comparar à lista acima.

SELECT studentID, FullName, sat_score, rcd_updated FROM student;
+-----------+------------------------+-----------+---------------------+
| studentID | FullName               | sat_score | rcd_updated         |
+-----------+------------------------+-----------+---------------------+
|         1 | Monique Davis          |       400 | 2017-08-16 15:34:50 |
|         2 | Teri Gutierrez         |       800 | 2017-08-16 15:34:50 |
|         3 | Spencer Pautier        |      1000 | 2017-08-16 15:34:50 |
|         4 | Louis Ramsey           |      1200 | 2017-08-16 15:34:50 |
|         5 | Alvin Greene           |      1200 | 2017-08-16 15:34:50 |
|         6 | Sophie Freeman         |      1200 | 2017-08-16 15:34:50 |
|         7 | Edgar Frank "Ted" Codd |      2400 | 2017-08-16 15:35:33 |
|         8 | Donald D. Chamberlin   |      2400 | 2017-08-16 15:35:33 |
|         9 | Raymond F. Boyce       |      2400 | 2017-08-16 15:35:33 |
+-----------+------------------------+-----------+---------------------+
9 rows in set (0.00 sec)
Podemos limitar ainda mais. Nesse caso, com studentIDs entre 1 e 5 OU studentID de 8 OU nome completo que contenha "Maximo" E pontuação do SAT que não seja de 1000 ou 1400

    select studentID, FullName, sat_score
    from student
    where (studentID between 1 and 5 -- incluindo os extremos
		or studentID = 8
        or FullName like '%Maximo%')
		and sat_score NOT in (1000, 1400)
	order by FullName DESC;
syntax03
GROUP BY e HAVING
GROUP BY nos dá uma maneira de combinar linhas e dados agregados. A instrução HAVING é como a instrução WHERE acima, com a exceção de que ela atua nos dados agrupados.

Os dados abaixo pertencem aos dados de contribuições de campanha que usamos em alguns desses guias.

A instrução em SQL que segue responde a pergunta: "quais candidatos receberam o menor número de contribuições (não em termos de dinheiro, mas de contagem (*)) em 2016, mas somente aqueles que tiveram mais de 80 contribuições?"

Ordenar esse conjunto de dados em uma ordem descendente (DESC) coloca os candidatos com o maior número de contribuições na parte de cima da lista.

    select Candidate, Election_year, sum(Total_$), count(*)
    from combined_party_data
    where Election_year = 2016
    group by Candidate, Election_year
    having count(*) > 80
    order by count(*) DESC;
syntax04
O operador BETWEEN em SQL
O operador BETWEEN é útil, por causa do otimizador de consultas do SQL (ou SQL Query Optimizer). Embora BETWEEN seja, funcionalmente, o mesmo que: x <= elemento <= y, o otimizador de consultas do SQL reconhecerá esse comando mais rápido e terá um código otimizado para executá-lo.

Esse operador é usado em uma instrução WHERE ou em uma instrução GROUP BY/HAVING.

As linhas selecionadas são as que têm um valor maior que o mínimo e menor que o máximo.

É importante lembrar de que os valores inseridos no comando são excluídos do resultado. Obtemos apenas os valores entre eles.

Essa é a sintaxe para usar a função em uma instrução WHERE:

select field1, testField
from table1
where testField between min and max
Aqui temos um exemplo usando a tabela student e a instrução WHERE:

-- sem a instrução WHERE
select studentID, FullName, studentID
from student;
    
-- com a instrução WHERE e com BETWEEN
select studentID, FullName, studentID
from student
where studentID between 2 and 7;
between01
Aqui temos um exemplo de uso na tabela de fundos de campanha com a instrução HAVING. Ele retornará linhas onde a soma das doações para um candidato estavam ente US$3 milhões e US$18 milhões com base na instrução HAVING e na parte GROUP BY da instrução. Veja mais sobre agregação no guia específico.

select Candidate, Office_Sought, Election_Year, format(sum(Total_$),2)
from combined_party_data
where Election_Year = 2016
group by Candidate, Office_Sought, Election_Year
having sum(Total_$) between 3000000 and 18000000
order by sum(Total_$) desc; 
between02
Uma tabela é um grupo de dados armazenado em um banco de dados.

Para criar uma tabela em um banco de dados, use a instrução CREATE TABLE. Você dá um nome à tabela e uma lista de colunas com seus tipos de dados.

CREATE TABLE TABLENAME(Attribute1 Datatype, Attribute2 Datatype,........);
Aqui temos um exemplo de criação da tabela Person:

CREATE TABLE Person(
  Id int not null,
  Name varchar not null,
  DateOfBirth date not null,
  Gender bit not null,
  PRIMARY KEY( Id )
);
No exemplo acima, cada Person (pessoa) tem um Name (nome), uma Date of Birth (data de nascimento) e um Gender (gênero). A coluna Id é a chave que identifica uma pessoa na tabela. Você usa a palavra-chave PRIMARY KEY para configurar uma ou mais colunas como uma chave primária.

Uma coluna pode ser not null ou null, indicando se ela é ou não obrigatória.

Consultas do tipo INSERT são uma maneira de inserir dados em uma tabela. Digamos que tenhamos criado uma tabela usando o seguinte:

CREATE TABLE example_table ( name varchar(255), age int)

example_table

Name|Age
--- | --- 
Agora, para adicionar dados a essa tabela, usaremos INSERT, dessa forma:

INSERT INTO example_table (column1,column2) VALUES ("Andrew",23)

example_table

Name|Age
--- | --- 
Andrew|23
Até mesmo a instrução abaixo funcionará. Sempre é bom, no entanto, especificar quais dados estão sendo inseridos em quais colunas.

INSERT INTO table_name VALUES ("John", 28)

example_table

Name|Age
--- | --- 
Andrew|23
John|28
AND é usado em uma instrução WHERE ou em uma instrução GROUP BY/HAVING para limitar as linhas retornadas pela instrução executada. Use AND quando é necessário atender a mais de uma condição.

Usamos a tabela student para apresentar exemplos.

Aqui temos a tabela student sem usar uma instrução WHERE:

select * from student;
and_operator01
Agora, a instrução WHERE é adicionada para que sejam exibidos apenas os alunos de programação:

select * from student 
where programOfStudy = 'Programming';
and_operator02

Em seguida, a instrução WHERE é atualizada com AND para mostrar resultados dos alunos de programação que também tenham uma pontuação no SAT maior que 800:

select * from student 
where programOfStudy = 'Programming' 
and sat_score > 800;
and_operator03
Abaixo temos um exemplo mais complexo da tabela de contribuições de campanha. O exemplo tem uma instrução GROUP BY com uma instrução HAVING usando um AND para restringir o número de registros retornados a candidatos de 2016 com contribuições entre US$3 milhões e US$18 milhões no total.

select Candidate, Office_Sought, Election_Year, FORMAT(sum(Total_$),2) from combined_party_data
where Office_Sought = 'PRESIDENT / VICE PRESIDENT'
group by Candidate, Office_Sought, Election_Year
 having Election_Year = 2016 and sum(Total_$) between 3000000 and 18000000
order by sum(Total_$) desc;
and_operator06
