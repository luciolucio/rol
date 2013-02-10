# Rol: controle suas despesas

Rol foi feito para registrar suas despesas automaticamente. Usando como base e-mails do seu banco, extratos de conta e de cart�o de cr�dito, Rol interpreta essas informa��es e transforma em despesas individuais que voc� pode categorizar como quiser. Rol n�o tem uma interface na web, voc� conversa com ele usando o seu e-mail. Rol n�o se conecta no seu banco nem tem acesso � sua conta, mas precisa de acesso aos seus e-mails.

Para armazenagem das despesas, Rol se utiliza da excelente [CouchDb](http://couchdb.org). Rol depende ainda de uma s�rie de ruby gems fant�sticas, como [ruby-gmail](http://dcparker.github.com/ruby-gmail/) e [couchrest](http://wiki.github.com/couchrest/couchrest).

## Notas

* Estou procurando pessoas que usam Itaucard para testar e dar feedback

## Homepage

* [http://code.google.com/p/rol](http://code.google.com/p/rol)

## Autor

* L�cio Assis (luciolucio@gmail.com)

## Compatibilidade

* Gmail
* Alertas de e-mail Itaucard

## Instalando

### CouchDb

Voc� precisa de uma instala��o de CouchDb funcionando

### Configurando

rake config

Preencha os dados solicitados

### Agendamento de processos

Voc� precisa de um scheduler de processos, como por exemplo o cron ou o Windows Scheduler para rodar periodicamente os scripts da pasta bin, descritos abaixo. Voc� pode escolher a frequ�ncia de acordo com a sua prefer�ncia, mas sugere-se o seguinte:

* *LoadExpenses.rb* Uma vez por hora, ou a cada duas horas ou mais, a menos que voc� gaste o suficiente pra justificar mais do que isso :)
* *MailProcessor.rb* A cada cinco/dez minutos ou menos. Depende de quanto tempo voc� se disp�e a esperar at� o Rol responder os seus e-mails e de quanta capacidade de processamento voc� tem dispon�vel

## Funcionamento

### LoadExpenses.rb

* Carrega e-mails de "�ltimas transa��es realizadas com o cart�o" do Itaucard
* Grava triggers que v�o orientar a a��o do MailProcessor

### MailProcessor.rb

* Envia e recebe e-mails e os processa

### MailProcessorTrigger

* Os triggers, enquanto existem, indicam que o MailProcessor tem algum trabalho a fazer, e t�m os seguintes estados:
* *Unprocessed* � o estado inicial, quando ele � criado junto com uma despesa
* *Reported* indica que a despesa relacionada foi reportada por e-mail
* *Answered* � um estado transit�rio que significa que foi recebida uma resposta do e-mail. Depois de processada a resposta ele � deletado
* *Error* ser� encontrado em caso de problemas inesperados durante as transi��es de estado

## Perguntas Frequentes (FAQs)

### Por que CouchDb?

* Por que prefiro pensar em cada despesa como um documento, n�o como uma linha em uma tabela. Al�m disso, sou bem tranquilo e gosto de relaxar

### Por que triggers?

* Porque eles simplificam o processo de recupera��o em caso de falha do MailProcessor

## Roadmap

### At� a v1.0 - Ita�

* Processar extrato do Itaucard em PDF para reconcilia��o
* Processar despesas do extrato da conta Ita� em PDF ou talvez XLS ou talvez TXT

### v2.0

* Extratos e e-mails de outros bancos

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
