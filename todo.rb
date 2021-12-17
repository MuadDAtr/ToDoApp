require 'sinatra/reloader'

class Todo < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do                                  # wyswietlanie listy
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    @items = data_hash.sort_by! { |item| item['completed'] ? 1 : 0}
    erb :index
     
  end

  post '/item' do
      # tworzenie nowego elementu
    new_item = {
      id: SecureRandom.uuid,
      name: params["name"],
      completed: false
    }
    file = File.read('./data.json')
    data_hash = JSON.parse(file)              #robimy hasha
    data_hash << new_item                     #dodajemy do hasha nowy element
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'                              #powrot na strone glowna
  end

  post '/done' do                             #oznaczanie elementu jako ukonczonego
    file = File.read('./data.json')
    data_hash = JSON.parse(file)
    element = data_hash.find{ |e| e['id'] == params['id']}
    element["completed"] = true
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

  post '/delete' do                           #usuwanie elementu
    file = File.read('./data.json')
    data_hash = JSON.parse(file)            
    data_hash.delete_if { |element| element["id"] == params["id"]}
    File.write('./data.json', JSON.dump(data_hash))
    redirect '/'
  end

end