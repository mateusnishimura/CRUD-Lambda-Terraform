# CRUD-Lambda-Terraform
Implementation of a CRUD in Lambda Functions using Terraform to deploy

## Métodos 

- POST: createFuncionario(nome, idade, cargo): Criará um funcionário com os atributos nome, idade e cargo, esses dados serão recebidos no formato JSON, será gerado um id para ele.

	:heavy_check_mark: Caso seja bem sucedida, cria o funcionário e retorna status code 201.

	:x: Caso ocorra um erro, retorna 500.
	
	(Link no email)

- GET: getFuncionarios: Retornará um JSON de todos os funcionários cadastrados.

	:heavy_check_mark: Caso seja bem sucedida, retorna JSON dos funcionários e status code 200

	:x: Caso ocorra um erro, retorna 500.
	
	(Link no email)
  
- PUT: updateFuncionario(nome, idade, cargo): Atualiza as informações de um dado funcionário, este funcionário será selecionado através do id que terá que ser passado através dos parâmetros de rota. O funcionário precisa existir, os atributos que serão atualizados serão recebidos no formato JSON.

	:heavy_check_mark: Caso seja bem sucedida, atualiza o funcionário escolhido e retorna status code 204
	
	:x: Caso o funcionário não exista, retorna status code 404, qualquer outro tipo de erro retornará status code 500.
	
		(Link no email)

- DELETE: deleteFuncionario(): Deleta um funcionário dado o seu id, o id será recebido pelos parâmetros de rota.

	:heavy_check_mark: Caso seja bem sucedida, delete o funcionário e retorna status code 204.
	
	:x: Caso o funcionário não exista, retorna status code 404, qualquer outro tipo de erro retornará status code 500.
	
	(Link no email)
