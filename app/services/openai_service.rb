class OpenaiService
  def generate_response(prompt)
    begin
    api_key = ENV['OPENAI_ACCESS_TOKEN']
    raise "OpenAI API key is missing!" if api_key.nil? || api_key.strip.empty?
      @client = OpenAI::Client.new(
      access_token: api_key,
      log_errors: true
      )
      response = @client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: prompt }],
          max_tokens: 100
        }
      )

      return response.dig("choices", 0, "message", "content")
    rescue Faraday::UnauthorizedError => e
      Rails.logger.error "❌ Unauthorized Error: Check API Key"
      "Authentication error. Check your API key."
    rescue Faraday::TimeoutError => e
      Rails.logger.error "❌ Timeout Error: #{e.message}"
      "The request took too long."
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error "❌ Connection Failed: #{e.message}"
      "Failed to connect to OpenAI."
    rescue StandardError => e
      Rails.logger.error "❌ Unknown Error: #{e.message}"
      "An unexpected error occurred."
    end
  end
end