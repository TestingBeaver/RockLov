describe "POST /signup" do
  context "novo usuario" do
    before(:all) do
      payload = { name: "Sting", email: "police@google.com", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])
      @result = Signup.new.create(payload)
    end

    it "valida status code" do
      expect(@result.code).to eql 200
    end

    it "valida id do usuário" do
      expect(@result.parsed_response["_id"].length).to eql 24
    end
  end

  context "usuario ja existe" do
    before(:all) do
      # dado que eu tenho um novo usuario
      payload = { name: "Joao da Silva", email: "joao@ig.com.br", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])
      # e o email desse usuario ja foi cadastrado no sistema
      Signup.new.create(payload)

      # quando faco uma requisição para a rota /signup
      @result = Signup.new.create(payload)
    end

    it "valida status code 409" do
      # então, deve retornar 409
      expect(@result.code).to eql 409
    end

    it "deve retornar mensagem" do
      expect(@result.parsed_response["error"]).to eql "Email already exists :("
    end
  end

  context "Nome obrigatorio" do
    before(:all) do
      # dado que eu tento o cadastro sem nome
      payload = { name: "", email: "joao@ig.com.br", password: "pwd123" }
      MongoDB.new.remove_user(payload[:email])

      # e o está sem nome
      Signup.new.create(payload)

      # quando faço a requisição para a rota /signup
      @result = Signup.new.create(payload)
    end

    it "Deve retornar 412" do
      expect(@result.code).to eql 412
    end

    it "Deve retornar mensagem: required name" do
      expect(@result.parsed_response["error"]).to eql "required name"
    end
  end

  context "Email obrigatorio" do
    before(:all) do
      # dado que tento cadastro sem email
      payload = { name: "Joao da Silva", email: "", password: "pwd123" }
      MongoDB.new.remove_user(payload[:name])

      # quando faço a requisição para a rota /signup
      @result = Signup.new.create(payload)
    end

    it "Deve retornar 412" do
      expect(@result.code).to eql 412
    end

    it "Deve retornar mensagem: required email" do
      expect(@result.parsed_response["error"]).to eql "required email"
    end
  end

  context "Password obrigatorio" do
    before(:all) do
      # dado que tento o cadastro sem senha
      payload = { name: "Joao da Silva", email: "joao@ig.com.br", password: "" }
      MongoDB.new.remove_user(payload[:email])

      # quando faço a requisição para a rota /signup
      @result = Signup.new.create(payload)
    end

    it "Deve retornar 412" do
      expect(@result.code).to eql 412
    end

    it "Deve retornar mensagem: required password" do
      expect(@result.parsed_response["error"]).to eql "required password"
    end
  end
end
