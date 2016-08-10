require 'erb'

class ShowExceptions
  attr_reader :app

  def initialize(app)
    puts "Initializing Exception Handler"
    @app = app
  end

  def call(env)
    puts "Calling Exception Handler"
    begin
      app.call(env)
    rescue StandardError => e
      @res = Rack::Response.new
      @res.status = 500
      render_exception(e)
      @res.finish

      # Array below is for spec clearing.  Comment out to see actual error page.
      # ['500', {'Content-type' => 'text/html'}, @e.message]
    end
  end

  private

  def render_exception(e)
    @e = e
    current_path = File.dirname(__FILE__).to_s
    rescue_path = File.join(current_path, "templates", "rescue.html.erb")
    content = ERB.new(File.read(rescue_path)).result(binding)
    @res["Content-Type"] = "text/html"
    @res.write(content)
  end

end
