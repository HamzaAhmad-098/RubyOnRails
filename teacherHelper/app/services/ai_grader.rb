require "net/http"
require "json"
require "uri"

class AiGrader
  def initialize
    @uri = URI("https://openrouter.ai/api/v1/chat/completions")
    @headers = {
      "Authorization" => "Bearer #{ENV['OPENROUTER_API_KEY']}",
      "Content-Type" => "application/json",
      "HTTP-Referer" => "http://localhost:3000",
      "X-Title" => "TeacherAiAssistant"
    }
  end

  def evaluate(question_text, student_answer, marks, instructions = nil, image_url = nil)
    prompt = build_prompt(question_text, student_answer, marks, instructions, image_url)
    response = send_to_deepseek(prompt)
    parse_response(response, marks)
  rescue => e
    handle_error(e)
  end

  private

def build_prompt(question, answer, marks, instructions, image_url)
  # Check for image-only case
  is_image_only = answer.include?("[Answer provided in uploaded image]")
  
  <<~PROMPT
    ### ROLE ###
    You are a professional exam evaluator.
    
    ### TASK ###
    Evaluate this student answer:
    
    Question: #{question}
    #{instructions.present? ? "Instructions: #{instructions}" : ""}
    Maximum Marks: #{marks}
    
    #{"[IMPORTANT: Student answer is in the uploaded image]" if is_image_only}
    #{"[Image URL: #{image_url}]" if image_url}
    
    #{"Student Answer: #{answer}" unless is_image_only}
    
    ### RESPONSE FORMAT ###
    Return ONLY JSON in this exact structure:
    {
      "score": (integer between 0-#{marks}),
      "feedback": (string under 50 words),
      "mistakes_summary": (array of 1-3 strings)
    }
  PROMPT
end
  def send_to_deepseek(prompt)
    body = {
      model: "deepseek/deepseek-chat",  # CORRECTED MODEL ID
      messages: [
        { role: "system", content: "You are an exam evaluator. Only return valid JSON." },
        { role: "user", content: prompt }
      ],
      temperature: 0.3,
      max_tokens: 500
    }

    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(@uri.path, @headers)
    request.body = body.to_json

    http.request(request)
  end

  def parse_response(response, max_marks)
    data = JSON.parse(response.body)
    
    # Check for API errors
    if data["error"]
      raise "API Error: #{data['error']['message']}"
    end

    content = data.dig("choices", 0, "message", "content")
    
    # Handle empty content
    if content.nil? || content.empty?
      raise "Empty AI response content"
    end

    # Handle JSON wrapped in code blocks
    json_match = content.match(/\{.*\}/m)
    parsed = json_match ? JSON.parse(json_match[0]) : JSON.parse(content)

    {
      score: parsed["score"].to_i.clamp(0, max_marks),
      feedback: parsed["feedback"].to_s,
      mistakes: parsed["mistakes_summary"] || []
    }
  rescue JSON::ParserError => e
    raise "JSON Parse Error: #{e.message}\nContent: #{content[0..100]}"
  end

  def handle_error(error)
    {
      score: 0,
      feedback: "AI evaluation failed: #{error.message[0..100]}",
      mistakes: ["Evaluation system error"]
    }
  end
end