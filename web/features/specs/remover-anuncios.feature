#language: pt

Funcionalidade: Remover anuncios
    Sendo um anunciante que possui um equipamento indesejado
    Quero poder remover esse anúncios
    Para que eu possa manter o meu dashboard atualizado

    Contexto: Login
        * Login com "miranha@gmail.com" e "pwd123"

    
    Cenario: Remover um anúncio

        Dado que eu tenho um anúncio indesejado:
            | thumb     | telecaster.jpg |
            | nome      | Telecaster     |
            | categoria | Cordas         |
            | preco     | 50             |
            Quando eu solicito a exclusão desse item
                E confirmo a exclusão 
            Então não devo ver esse item no Dashboard

    @temp
    Cenario: Desistir da exclusão

        Dado que eu tenho um anúncio indesejado:
            | thumb     | conga.jpg |
            | nome      | Conga     |
            | categoria | outros    |
            | preco     | 100       |
            Quando eu solicito a exclusão desse item
                Mas não confirmo a solicitação
            Então esse item deve permanecer no meu Dashboard