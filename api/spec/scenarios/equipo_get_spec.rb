describe "GET /equipos/[equipo_id]" do
  before(:all) do
    payload = { email: "to@mate.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter unico equipo" do
    before(:all) do
      #Dado que eu tenho um novo equipamento
      @payload = {
        thumbnail: Helpers::get_thumb("sanfona.jpg"),
        name: "Sanfona",
        category: "Outros",
        price: 666,
      }

      MongoDB.new.remove_equipo(@payload[:name], @user_id)

      #e eu tenho o id desse equipamento
      equipo = Equipos.new.create(@payload, @user_id)
      @equipo_id = equipo.parsed_response["_id"]

      # quando faço uma requisição get pelo id
      @result = Equipos.new.find_by_id(@equipo_id, @user_id)
    end

    it "Deve retornar 200" do
      expect(@result.code).to eql 200
    end

    it "Deve retornar o nome" do
      expect(@result.parsed_response).to include("name" => @payload[:name])
    end
  end

  context "Equipo nao existe" do
    before(:all) do
      @result = Equipos.new.find_by_id(MongoDB.new.get_mongo_id, @user_id)
    end

    it "Deve retornar 404" do
      expect(@result.code).to eql 404
    end
  end
end

describe "GET /equipos" do
  before(:all) do
    payload = { email: "jimmy@hendrix.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @user_id = result.parsed_response["_id"]
  end

  context "obter uma lista" do
    before(:all) do
      # dado que eu tenho uma lista de equipos
      payloads = [
        {
          thumbnail: Helpers::get_thumb("sanfona.jpg"),
          name: "Sanfona",
          category: "Outros",
          price: 584,
        }, {
          thumbnail: Helpers::get_thumb("amp.jpg"),
          name: "Amplificador",
          category: "Outros",
          price: 150,
        }, {
          thumbnail: Helpers::get_thumb("baixo.jpg"),
          name: "Baixo",
          category: "Cordas",
          price: 999,
        },
      ]

      payloads.each do |payload|
        MongoDB.new.remove_equipo(payload[:name], @user_id)
        Equipos.new.create(payload, @user_id)
      end

      # quando faço uma requisição get para /equipos
      @result = Equipos.new.list(@user_id)
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end

    it "deve retornar lista de equipos" do
      puts @result.parsed_response
      puts @result.parsed_response.class
    end
  end
end
