# Rol: controle suas despesas

Rol foi feito para registrar e categorizar suas despesas automaticamente. Usando como base e-mails do seu banco, extratos de conta e de cart�o de cr�dito, Rol interpreta essas informa��es e transforma em despesas individuais que voc� pode categorizar como quiser. Rol n�o tem uma interface na web, voc� interage com ele usando o seu e-mail. Rol n�o se conecta no seu banco nem tem acesso � sua conta, mas precisa de acesso aos seus e-mails. Se preferir, voc� pode criar uma conta de e-mail exclusiva para ele.

Uma vez carregadas suas despesas, Rol lhe envia um e-mail pedindo para categoriz�-las com tags e para mudar as descri��es, que nem sempre s�o muito intuitivas (ex: "TV a cabo e Internet NET" e "Seguro do Peugeot" s�o bem melhores que "SISDEB NET SP", ou "PORTO SEGURO PORTO SEGU") e para fazer isso basta responder aos e-mails. Rol vai aprendendo as descri��es e as categorias � medida que voc� faz isso pra que voc� precise categorizar cada vez menos, mas voc� pode sempre alterar.

� permitido, e sugerido, que voc� categorize cada despesa com mais de uma tag. Desse jeito, um presente comprado para algu�m pode ter por exemplo as categorias #presente e #eventuais, assim voc� consegue saber qual a quantidade de gastos eventuais naquele m�s, e tamb�m pode saber quanto gastou com presentes.

Rol n�o serve muito bem para quem n�o usa banco pela internet, ou para quem at� usa mas paga as coisas com dinheiro. Ele � focado no uso do cart�o de cr�dito, de d�bito e de facilidades como o d�bito autom�tico.

Para armazenagem das despesas, Rol se utiliza da excelente [CouchDb](http://couchdb.org). Rol depende ainda de uma s�rie de ruby gems fant�sticas, como [ruby-gmail](http://dcparker.github.com/ruby-gmail/) e [couchrest](http://wiki.github.com/couchrest/couchrest).

## Homepage

* [http://code.google.com/p/rol](http://code.google.com/p/rol)

## Autor

* L�cio Assis (luciolucio@gmail.com)

## Compatibilidade

* Gmail
* Alertas de e-mail Itaucard

## Instalando

### Configurando

rake config

Preencha os dados solicitados

### CouchDb

rake installdb

Voc� precisa de uma instala��o de CouchDb funcionando

### Gmail

* rake installgmail
* Crie uma regra que marque os e-mails do banco com a label *rol-unprocessed*

### Agendamento de processos

Voc� precisa de um sistema de agendamento de processos, como por exemplo o cron ou o Windows Scheduler para rodar periodicamente os scripts da pasta bin, descritos na pr�xima se��o. Voc� pode escolher a frequ�ncia de acordo com a sua prefer�ncia, mas sugere-se o seguinte:

* *LoadExpenses.rb* Uma vez por hora, ou a cada duas horas ou mais, a menos que voc� gaste o suficiente pra justificar mais do que isso :)
* *MailProcessor.rb* A cada cinco/dez minutos ou menos. Depende de quanto tempo voc� se disp�e a esperar at� que o Rol responda aos seus e-mails e de quanta capacidade de processamento voc� tem dispon�vel

## Funcionamento

### Emails

* As labels *rol-unprocessed* e *rol-processed* ser�o usadas no gmail para encontrar os e-mails

### LoadExpenses.rb

* Carrega e-mails, interpreta as despesas e grava no banco de dados
* Grava triggers que v�o orientar a a��o do MailProcessor
* Marca os e-mails como processados

### MailProcessor.rb

* Envia e recebe e-mails e os processa, alterando descri��es e tags

### MailProcessorTrigger

* Os triggers, enquanto existem, indicam que o MailProcessor tem algum trabalho a fazer, e t�m os seguintes estados:
* *Unprocessed* � o estado inicial, quando ele � criado junto com uma despesa
* *Reported* indica que a despesa relacionada foi enviada por e-mail
* *Answered* � um estado transit�rio que significa que foi recebida uma resposta a um e-mail enviado. Uma vez processada a resposta ele � deletado

## Perguntas Frequentes (FAQs)

### Por que CouchDb?

* Por que prefiro pensar em cada despesa como um documento, n�o como uma linha em uma tabela. Al�m disso, sou um cara bem tranquilo e gosto de relaxar

### Por que triggers?

* Porque eles simplificam o processo de recupera��o em caso de falha do MailProcessor

## Roadmap

### v0.2

* E-mail sum�rio de fim de m�s

### v0.3

* Colocar tags sem alterar o mapa
* Mapa de tags e de descri��es tamb�m por valor

### At� a v1.0 - Ita�

* Processar extrato do Itaucard em PDF para reconcilia��o
* Processar despesas do extrato da conta Ita� em PDF ou talvez XLS ou talvez TXT

### Algum dia

* Funcionar com outros bancos
* Multi-usu�rio

# Licen�a

(The MIT License)

Copyright (c) 2009 BehindLogic

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
