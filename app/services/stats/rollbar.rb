module Stats
  class Rollbar
    # Rollbar types to differentiate between javascript/ruby/sidekiq
    # Supported framworks are browser-js, rails, sidekiq, ruby
    def self.weekly_stats(from_date=DateTime.now - 7.days, environment="production", framework="rails", level="error", status="active")
      api_params = api_params(environment, framework, level, status)
      total_items = results(api_params)
      filter_results(total_items, from_date)
    end

    def self.filter_results(total_items, from_date)
      total_items.select do |item|
        DateTime.strptime(item["last_occurrence_timestamp"].to_s, '%s') > from_date &&
        DateTime.strptime(item["first_occurrence_timestamp"].to_s, '%s') > from_date
      end
    end

    def self.api_params(environment, framework, level, status)
      params = {}
      params[:environment] = environment unless environment.nil?
      params[:framework] = framework unless framework.nil?
      params[:level] = level unless level.nil?
      params[:status] = status unless status.nil?
      params[:access_token] = ENV["ROLLBAR_ACCESS_TOKEN"]
      params
    end

    def self.results(api_params)
      results = []
      page = 1
      loop do
        api_params[:page] = page
        result = JSON.parse(call(api_params))
        results += result["result"]["items"]
        break if result["result"]["total_count"] <= results.count
        page += 1
      end
      results
    end

    def self.call(api_params)
      RestClient.get items_url, params: api_params
    end

    def self.items_url
      ApiEndpoints::Rollbar::ITEMS
    end
  end
end
