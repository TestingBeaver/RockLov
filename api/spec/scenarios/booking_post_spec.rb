describe "POST /equipos/{equipo_id}/bookings" do
  before(:all) do
    payload = { email: "eddie@hallen.com", password: "pwd123" }
    result = Sessions.new.login(payload)
    @eddie_id = result.parsed_response["_id"]
  end
  context "solicitar locacao" do
    before(:all) do
      #Dado que "Gerard Way" tem uma "Fender Strato" para alugar

      result = Sessions.new.login({ email: "gerard@way.com", password: "pwd123" })
      gerard_id = result.parsed_response["_id"]

      fender = {
        thumbnail: Helpers::get_thumb("fender-sb.jpg"),
        name: "Fender Strato",
        category: "Cordas",
        price: 150,
      }

      MongoDB.new.remove_equipo(fender[:name], gerard_id)

      result = Equipos.new.create(fender, gerard_id)
      fender_id = result.parsed_response["_id"]

      #quando solicito a locação da fender do gerard way
      @result = Equipos.new.booking(fender_id, @eddie_id)
    end

    it "deve retornar 200" do
      expect(@result.code).to eql 200
    end
  end
end
