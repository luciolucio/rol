# Rol: controle suas despesas

Rol foi feito para registrar e categorizar suas despesas automaticamente. Usando como base e-mails do seu banco, extratos de conta e de cartão de crédito, Rol interpreta essas informações e transforma em despesas individuais que você pode categorizar como quiser. Rol não tem uma interface na web, você interage com ele usando o seu e-mail. Rol não se conecta no seu banco nem tem acesso à sua conta, mas precisa de acesso aos seus e-mails. Se preferir, você pode criar uma conta de e-mail exclusiva para ele.

Uma vez carregadas suas despesas, Rol lhe envia um e-mail pedindo para categorizá-las com tags e para mudar as descrições, que nem sempre são muito intuitivas (ex: "TV a cabo e Internet NET" e "Seguro do Peugeot" são bem melhores que "SISDEB NET SP", ou "PORTO SEGURO PORTO SEGU") e para fazer isso basta responder aos e-mails. Rol vai aprendendo as descrições e as categorias à medida que você faz isso pra que você precise categorizar cada vez menos, mas você pode sempre alterar.

É permitido, e sugerido, que você categorize cada despesa com mais de uma tag. Desse jeito, um presente comprado para alguém pode ter por exemplo as categorias #presente e #eventuais, assim você consegue saber qual a quantidade de gastos eventuais naquele mês, e também pode saber quanto gastou com presentes.

Rol não serve muito bem para quem não usa banco pela internet, ou para quem até usa mas paga as coisas com dinheiro. Ele é focado no uso do cartão de crédito, de débito e de facilidades como o débito automático.

Para armazenagem das despesas, Rol se utiliza da excelente [CouchDb](http://couchdb.org). Rol depende ainda de uma série de ruby gems fantásticas, como [ruby-gmail](http://dcparker.github.com/ruby-gmail/) e [couchrest](http://wiki.github.com/couchrest/couchrest).

## Homepage

* [http://code.google.com/p/rol](http://code.google.com/p/rol)

## Autor

* Lúcio Assis (luciolucio@gmail.com)

## Compatibilidade

* Gmail
* Alertas de e-mail Itaucard

## Instalando

### Configurando

rake config

Preencha os dados solicitados

### CouchDb

rake installdb

Você precisa de uma instalação de CouchDb funcionando

### Gmail

* rake installgmail
* Crie uma regra que marque os e-mails do banco com a label *rol-unprocessed*

### Agendamento de processos

Você precisa de um sistema de agendamento de processos, como por exemplo o cron ou o Windows Scheduler para rodar periodicamente os scripts da pasta bin, descritos na próxima seção. Você pode escolher a frequência de acordo com a sua preferência, mas sugere-se o seguinte:

* *LoadExpenses.rb* Uma vez por hora, ou a cada duas horas ou mais, a menos que você gaste o suficiente pra justificar mais do que isso :)
* *MailProcessor.rb* A cada cinco/dez minutos ou menos. Depende de quanto tempo você se dispõe a esperar até que o Rol responda aos seus e-mails e de quanta capacidade de processamento você tem disponível

## Funcionamento

### Emails

* As labels *rol-unprocessed* e *rol-processed* serão usadas no gmail para encontrar os e-mails

### LoadExpenses.rb

* Carrega e-mails, interpreta as despesas e grava no banco de dados
* Grava triggers que vão orientar a ação do MailProcessor
* Marca os e-mails como processados

### MailProcessor.rb

* Envia e recebe e-mails e os processa, alterando descrições e tags

### MailProcessorTrigger

* Os triggers, enquanto existem, indicam que o MailProcessor tem algum trabalho a fazer, e têm os seguintes estados:
* *Unprocessed* é o estado inicial, quando ele é criado junto com uma despesa
* *Reported* indica que a despesa relacionada foi enviada por e-mail
* *Answered* é um estado transitório que significa que foi recebida uma resposta a um e-mail enviado. Uma vez processada a resposta ele é deletado

## Perguntas Frequentes (FAQs)

### Por que CouchDb?

* Por que prefiro pensar em cada despesa como um documento, não como uma linha em uma tabela. Além disso, sou um cara bem tranquilo e gosto de relaxar

### Por que triggers?

* Porque eles simplificam o processo de recuperação em caso de falha do MailProcessor

## Roadmap

### v0.2

* E-mail sumário de fim de mês

### v0.3

* Colocar tags sem alterar o mapa
* Mapa de tags e de descrições também por valor

### Até a v1.0 - Itaú

* Processar extrato do Itaucard em PDF para reconciliação
* Processar despesas do extrato da conta Itaú em PDF ou talvez XLS ou talvez TXT

### Algum dia

* Funcionar com outros bancos
* Multi-usuário

# Licença

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
