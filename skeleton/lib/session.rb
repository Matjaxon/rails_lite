require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    # @cookie = req.cookies["_rails_lite_app"]
    # unless @cookie
    #   req.cookies["_rails_lite_app"] = "{}"
    #   @cookie = if req.cookies["_rails_lite_app"]
    # end

    if req.cookies["_rails_lite_app"]
      @cookie = JSON.parse(req.cookies["_rails_lite_app"])
    else
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app' , @cookie.to_json)
    res
  end
end
