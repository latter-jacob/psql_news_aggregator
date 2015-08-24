require 'sinatra'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end

get "/articles/new" do
  info = db_connection { |conn| conn.exec("SELECT * FROM info") }
  erb :index, locals: { info: info }
end


post "/posts" do

  db_connection do |conn|
    conn.exec_params("INSERT INTO info (name, url, description) VALUES ($1, $2, $3)", [params["name"], params["url"], params["description"] ])
  end

  redirect "/articles/new"
end
