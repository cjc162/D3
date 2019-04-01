require 'sinatra'
require 'sinatra/reloader'

def generate_table(size)
    table = Array.new
    n = size.to_i

    (2**n).times do |i|
        expression = Array.new
        logical_and = true
        logical_or = false
        num_true = 0

        n.times do |j|
            bit = ((i / 2**j) % 2)
            if (bit == 1)
                expression << true
                logical_or = true
                num_true += 1
            else
                expression << false
                logical_and = false
            end
        end
        expression.reverse!

        expression << logical_and
        expression << logical_or
        expression << !logical_and
        expression << !logical_or
        expression << (num_true % 2 == 1)
        expression << (num_true == 1)

        table << expression
    end
    table
end

not_found do
    status 404
    erb :bad_route
end

get '/' do
    erb :index
end

get '/display' do
    ts = params[:ts]
    fs = params[:fs]
    size = params[:size]

    ts = "T" if ts.empty?
    fs = "F" if fs.empty?
    size = "3" if size.empty?

    if ts.size != 1 || fs.size != 1 || ts == fs || size.to_i < 2
        erb :error
    else
        table = generate_table(size)
        erb :show, :locals => {trueSym: ts, falseSym: fs, size: size.to_i, table: table}
    end

end