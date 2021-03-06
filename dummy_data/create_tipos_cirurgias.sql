-- Projeto CBD - 2021/2022
-- Grupo 5 (Afonso Santos - 2210640, Iúri Raimundo - 2210651)
-- Descrição: Script para criação de tipos de cirurgias.


SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line('> Creating tipos de cirurgias...');


INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (1, 'processo não cirúrgico de lesões traumáticas ou degenerativas');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (1, 'processo cirúrgico, incluindo artroscópico, das instabilidades e luxações do ombro e cotovelo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (1, 'processo cirúrgico, nomeadamente artroscópico, das roturas e tendinites cálcicas dos tendões do ombro');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (1, 'processo cirúrgico das fraturas na região do ombro e cotovelo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (1, 'Artroplastias do ombro e cotovelo em situações degenerativas ou traumáticas');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (2, 'processo cirúrgico à anca');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (2, 'processo cirúrgico à bacia');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Cirurgia da hérnia discal cervical');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Cirurgia da hérnia discal lombar');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Fusão da coluna cervical / lombar');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Substituição dos discos cervicais por discos artificiais (próteses)');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Descompressão da medula cervical');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Descompresssão do canal lombar');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Vertebroplastia (colocação de cimento na vértebra)');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'processo de fraturas de vértebras');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'processo da dor ciática');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (3, 'Correção das deformidades da coluna no adulto (escolioses ou cifoses)');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (4, 'Cirurgia funcional do membro superior em Paralisia cerebral e Tetraplegia');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (4, 'Cirurgia à mão');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (4, 'Cirurgia ao punho');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (5, 'Alterações dos Joelhos e Deformidades dos Membros');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (5, 'Alterações dos Pés: Pé Chato, Pé Boto, Pé Planos e Pé Cavo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Joanete');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Deformidades dos dedos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Roturas e Tendinite do Tendão de Aquiles');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Entorses do tornozelo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Instabilidades do tornozelo (interna ou externa)');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Artrose do tornozelo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Fraturas dos ossos do pé ou tornozelo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (6, 'Fraturas do Calcâneo');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Tumores Ósseos malignos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Tumores Ósseos benignos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Tumores Musculares malignos e benignos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Quistos ósseos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Metástases dos ossos dos membros Superiores ou Inferiores');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (7, 'Fraturas patológicas');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (8, 'Lesões da Cartilagem');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (8, 'Lesões do Menisco');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (8, 'Lesões dos Ligamentos');

INSERT INTO PROJETO.tipo_cirurgia (id_area_atuacao, nome)
    VALUES (8, 'Luxação da Rótula');

COMMIT;
