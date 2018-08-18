# Mecânicas do jogo

## Movimentação

Mover-se para direita e esquerda, podendo haver possibilidade de olhar para cima e abaixar-se, bem como pular. As teclas correspondente são:

* Esquerda: Seta Esquerda
* Direita: Seta Direita
* Olhar para cima: Seta Cima
* Olhar para baixo: Seta Baixo
* Pular: Espaço

## Customização

Será possível customizar os controles utilizados numa tela de configuração

## Multiplas formas de atingir o inimigo

Haverão diferentes habilidades para que sejam lançados projéteis nos inimigos (como diferentes armas de jogo)

* Haverá uma arma principal que irá possuir, teoricamente, munição infinita, porém a quantidade de tiros a ser dado, depende da quantidade de dinheiro que o jogador possui
* Quando a munição de uma arma especial acabar, deverá ser utilizada novamente a arma principal
* A diferença de cada projétil será o tamanho do mesmo, e velocidade de movimento
* Os projéteis poderão ser disparados no ar, olhando para cima, e agachado

## Dificuldade

* Tem vida, e quando tiver com saúde baixa, tem de pagar pelo hospital
* Plano de saúde - Funciona durante toda a fase (de forma que não tem de pagar toda hora o hospital)
* No final da fase tem de pagar um valor

## Vida é o dinheiro restante da sua Família

Cada tiro levado irá consumir um coração de vida. Ao total serão 4 corações de vida, e quando os mesmos acabarem o dinheiro total da família será consumido para que o jogador volte à vida. Caso a quantidade de dinheiro chegue em estado crítico, é game over.

* Cada projétil inimigo que acertar o personagem principal, irá diminuir a saúde do personagem de forma que o mesmo deverá gastar dinheiro com o hospital para recuperar a saúde.
* É possível no início de cada fase comprar um plano de saúde, para que dessa forma não seja necessário gastar dinheiro com conta hospitalar
* A cada 12 passos dados, o dinheiro da família é decrementado devido à insumos de energia (comida) que o personagem irá usar para continuar a aventura
* Coletáveis Especiais irão garantir mais dinheiro
* Para facilitar a experiência do jogador, haverão checkpoints

## Habilidades

* Pechincha - Faz que o jogador gaste menos
* Mais Defesa

## Cenários

* Tomba (Caixa d'água) - De fundo
* Super Mercado
* Bairro qualquer
* SpaceX (Fase Bônus, para chegar tem que coletar bagulhos)

## Camera

O script de camera funciona da seguinte forma:

* Começará a seguir o personagem principal sempre que o mesmo chega ao meio da tela depois de mudar a orientação
* Caso o personagem se encontre nas bordas da tela, a camera permanecerá fixa e não seguirá o mesmo
* A camera não seguirá o personagem quando o mesmo salta, apenas quando o mesmo cai em uma plataforma que a posição vertical da camera será atualizada

## Inteligência dos Inimigos

Os inimigos irão cegamente para cima do jogador, atirando com tudo

* Seu Barriga - Ele irá correr atrás do jogador, o qual deve fugir do mesmo para que dessa forma não precise pagar o dinheiro do aluguel naquele momento e economize para as fases posteriores. É possível atirar no mesmo para que dessa forma o atrase
