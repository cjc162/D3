require 'sinatra'
require 'sinatra/reloader'

not_found do
    status 404
    erb :bad_route
end

get '/' do
    true_symbol = params["true_symbol"]
    false_symbol = params["false_symbol"]
    size = params["size"]

    if true_symbol.nil? || false_symbol.nil? || size.nil?
        erb :index
    else
        if true_symbol.size != 1 || false_symbol.size != 1 || true_symbol == false_symbol || size.to_i < 2
            erb :error
        else 
            table = Array.new
            n = params[:size].to_i

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
        


            erb :show, :locals => {trueSym: true_symbol, falseSym: false_symbol, size: size, table: table}
        end
    end
end