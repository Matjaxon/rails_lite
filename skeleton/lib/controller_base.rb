require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Cannot redirect twice" if already_built_response?
    @already_built_response = true
    session.store_session(@res)
    @res.location = url
    @res.status = 302  #triggers a call to the browser to evaluate the new url
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Cannot render twice" if already_built_response?
    @res["Content-Type"] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    #extension of this file
    current_path = File.dirname(__FILE__).to_s

    #converts class name to snakecase
    class_path = self.class.name.underscore.to_s

    #combine components into a full directory path to view
    new_path = File.join(current_path, "..", "views", class_path,
      "#{template_name}.html.erb")
    template = ERB.new(File.read(new_path)).result(binding)
    render_content(template, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    unless @res.status == 200
      render(name)
    end
  end
end
