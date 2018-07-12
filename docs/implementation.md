# Implementação
Esse arquivo visa informar o papel de cada arquivo e pacote (pasta) para os futuros desenvolvedores que forem utilizar os códigos, e/ou contribuir com o projeto

## docs
Pasta que armazena todos os arquivos MarkDown de documentação do projeto

## src/assets
Essa pasta tem o intuito de armazenar todos os arquivos de imagem, áudio e fontes do jogo, visando dessa forma uma maior organização do projeto como um todo

## src/controllers
Essa pasta contém os principais controladores que são utilizados no jogo.

* CameraController - Controller que possui os scripts de camera para realizar a movimentação e manipulação do mundo do jogo.
* CharacterController - É o controller que irá ser responsável pela manipulação do personagem do jogador no jogo. Dessa forma, essa classe detecta os eventos de input no teclado para que o jogador possa se locomover e realizar ações.
* DataPersistence - Tem o intuito de armazenar os dados de jogo para carregamento futuro, como checkpoints.
* EnemiesController - Controller que armazena os inimigos, bem como faz a gerencia dos seus recursos.
* GameDirector - Controller mais importante de todos, ele manipula todo o jogo, faz a inclusão de cenas, e gerencia os métodos necessários para o funcionamento do game. Ele fica armazenada na tabela global do interpretador, para assim ser acessado em qualquer local.

## src/libs
Essa pasta contém os arquivos de biblioteca externos utilizados

## src/models/actors
Pasta que contém todos os scripts de atores do jogo, como balas, inimigos, dentre outros

* Bullet - Script que determina cada bala na tela de forma individual
* Enemy - Classe que contém os sprites e funcionamento dos inimigos no jogo

## src/models/business
Pasta que contém classes de modelagem que servem como uma abstração para manipulação de recursos importantes

* Ground - Manipula o terreno do game
* World - Faz as manipulações no Mundo do game, alterando seus efeitos na física do mesmo

## src/scenes
Pasta que contém as cenas do game, ou seja, cada uma das telas do jogo
* MainMenuScene - Tela de Menu do Game

## src/util
Pasta que contém os scripts para auxiliar o desenvolvimento do jogo

* Stack - Uma pilha, estrutura de dados do tipo LIFO
* SpriteSheet - Script para gerenciamento dos sprites do jogo. Foi desenvolvido para configurar esses sprites a partir de um arquivo JSON gerado a partir da ferramenta Piskell na versão 0.14

## src/main.lua
Arquivo principal para inicio da execução do game. É o arquivo que irá ser executado primeiro pela engine Love2D
