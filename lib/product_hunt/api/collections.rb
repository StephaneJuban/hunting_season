module ProductHunt
  module API
    module Collections

      PATH = "/collections"

      def collection(id, options = {})
        process(PATH + "/#{id}", options) do |response|
          Collection.new(response["collection"], self)
        end
      end

      def collections(options = {})
        process(PATH, options) do |response|
          response["collections"].map{ |collection| Collection.new(collection, self) }
        end
      end

    end
  end
end
