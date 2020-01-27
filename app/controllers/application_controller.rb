class ApplicationController < ActionController::API

    #Punto 1
    def create_array
        length_array = params[:num_elements].to_i
        if length_array >= 10 && length_array <= 30 # Validar que la cantidad solicitada esté entre 10 y 30
            @elements = Array.new(length_array) { rand(0...30) }.uniq! # Uso el uniq! para eliminar los repetidos
            if @elements.length < length_array
                while @elements.length < length_array # Mientras la cantidad de números no sea el solicitado
                    rand_number = rand(0...30) # Siga generando números aleatorios
                    if !@elements.include? rand_number # Y verifique que ese número no esté ya en el array
                        @elements.push(rand_number) # Si no está, agreguelo
                    end
                end
            end
            Element.create! :elements=>@elements # Guardo el arreglo en un campo en la base de datos
            @response = Element.all.order(id: :desc) # Preparo una respuesta que trae todos los array ordenados, esto con el fin de que el usuario tenga presnete el id que requiere para el punto 2
            @status= 202
        else
            @response = "El número de elementos debe ser mínimo 10 y máximo 30"
            @status = 404
        end

        render json: @response, serializer: ApplicationController, status: @status
    end

    #Punto 2
    def return_array
        begin
            array = Element.find(params[:element]).elements.sort # Me traigo el array solicitado
            result = array.slice_when { |prev, curr| curr != prev.next }.to_a # Dentro del array principal genero "mini arrays", estos son con las secuencias de números que pueda encontrar
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
        rescue
            render json: "El Array solicitado no existe", serializer: ApplicationController, status: @status
        end
    end

end
