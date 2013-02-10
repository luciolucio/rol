# Rol: controle suas despesas

Rol foi feito para registrar suas despesas automaticamente. Usando como base e-mails do seu banco, extratos de conta e de cartão de crédito, Rol interpreta essas informações e transforma em despesas individuais que você pode categorizar como quiser. Rol não tem uma interface na web, você conversa com ele usando o seu e-mail. Rol não se conecta no seu banco nem tem acesso à sua conta, mas precisa de acesso aos seus e-mails.

Para armazenagem das despesas, Rol se utiliza da excelente [CouchDb](http://couchdb.org). Rol depende ainda de uma série de ruby gems fantásticas, como [ruby-gmail](http://dcparker.github.com/ruby-gmail/) e [couchrest](http://wiki.github.com/couchrest/couchrest).

## Notas

* Estou procurando pessoas que usam Itaucard para testar e dar feedback

## Homepage

* [http://code.google.com/p/rol](http://code.google.com/p/rol)

## Autor

* Lúcio Assis (luciolucio@gmail.com)

## Compatibilidade

* Gmail
* Alertas de e-mail Itaucard

## Instalando

### CouchDb

Você precisa de uma instalação de CouchDb funcionando

### Configurando

rake config

Preencha os dados solicitados

### Agendamento de processos

Você precisa de um scheduler de processos, como por exemplo o cron ou o Windows Scheduler para rodar periodicamente os scripts da pasta bin, descritos abaixo. Você pode escolher a frequência de acordo com a sua preferência, mas sugere-se o seguinte:

* *LoadExpenses.rb* Uma vez por hora, ou a cada duas horas ou mais, a menos que você gaste o suficiente pra justificar mais do que isso :)
* *MailProcessor.rb* A cada cinco/dez minutos ou menos. Depende de quanto tempo você se dispõe a esperar até o Rol responder os seus e-mails e de quanta capacidade de processamento você tem disponível

## Funcionamento

### LoadExpenses.rb

* Carrega e-mails de "Últimas transações realizadas com o cartão" do Itaucard
* Grava triggers que vão orientar a ação do MailProcessor

### MailProcessor.rb

* Envia e recebe e-mails e os processa

### MailProcessorTrigger

* Os triggers, enquanto existem, indicam que o MailProcessor tem algum trabalho a fazer, e têm os seguintes estados:
* *Unprocessed* é o estado inicial, quando ele é criado junto com uma despesa
* *Reported* indica que a despesa relacionada foi reportada por e-mail
* *Answered* é um estado transitório que significa que foi recebida uma resposta do e-mail. Depois de processada a resposta ele é deletado
* *Error* será encontrado em caso de problemas inesperados durante as transições de estado

## Perguntas Frequentes (FAQs)

### Por que CouchDb?

* Por que prefiro pensar em cada despesa como um documento, não como uma linha em uma tabela. Além disso, sou bem tranquilo e gosto de relaxar

### Por que triggers?

* Porque eles simplificam o processo de recuperação em caso de falha do MailProcessor

## Roadmap

### Até a v1.0 - Itaú

* Processar extrato do Itaucard em PDF para reconciliação
* Processar despesas do extrato da conta Itaú em PDF ou talvez XLS ou talvez TXT

### v2.0

* Extratos e e-mails de outros bancos

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
