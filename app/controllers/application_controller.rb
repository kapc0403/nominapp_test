class ApplicationController < ActionController::API

    #Punto 1
    def create_array
        length_array = params[:num_elements].to_i
        if length_array >= 10 && length_array <= 30
            @elements = Array.new(length_array) { rand(0...30) }.uniq!
            if @elements.length < length_array
                while @elements.length < length_array
                    rand_number = rand(0...30)
                    if !@elements.include? rand_number
                        @elements.push(rand_number)
                    end
                end
            end
            Element.create! :elements=>@elements
            @response = Element.all.order(id: :desc)
            @status= 202
        else
            @response = "El número de elementos debe ser mínimo 10 y máximo 30"
            @status = 404
        end

        render json: @response, serializer: ApplicationController, status: @status
    end

    #Punto 2
    def return_array
        array = Element.find(params[:element]).elements.sort
        result = array.slice_when { |prev, curr| curr != prev.next }.to_a
        range_length = 0
        range_selected = []
        result.each do |r|
            if r.length > range_length
                range_selected = r
                range_length = r.length
            end
        end

        final_range = [range_selected.first, range_selected.last]

        render json: final_range, serializer: ApplicationController, status: @status
    end

end
