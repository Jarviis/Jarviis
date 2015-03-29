module Search
  class Manager

    attr_reader :keyword, :klass, :operator, :options, :response

    def initialize(keyword, klass=Issue, operator="and", options={})
      @keyword = Search::QuerySanitizer.sanitize(keyword)

      @klass =
        if klass.is_a?(String)
          klass = klass.titleize.constantize
        else
          klass
        end

      @operator = operator
      @options = options
    end

    # Performs the global_search method on the given class
    #
    # @return [Elasticsearch::Model::Response]
    def global_search
      answer = klass.global_search(keyword, operator, options)
      @response = answer.response

      answer
    end

    # Retruns the ids of the search query ordered by the ES score
    #
    # @return [Array<Fixnum>] the ids
    def ids
      return [] if empty?

      response["hits"]["hits"].map { |h| h["_id"].to_i }
    end

    # Whether or not the query had 0 results
    #
    # @return [Boolean] true if the query gave 0 results
    def empty?
      true if response.nil?

      response["hits"]["total"].zero?
    end
  end
end
