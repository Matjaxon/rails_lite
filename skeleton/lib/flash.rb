require 'json'

class Flash

  attr_accessor :cookie

  def initialize(res)
    if res.cookies["_rails_lite_app_flash"]
      @flash = JSON.parse(res.cookies["_rails_lite_app_flash"])
    else
      @flash = {}
    end
    @cookie = {}
  end

  def [](key)
    if @flash.keys.include?(key)
      @flash[key]
    elsif @cookie.keys.include?(key)
      @cookie[key]
    else
      nil
    end
  end

  def []=(key, value)
    @cookie[key] = value
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash' , @cookie.to_json)
  end

  def now
    @flash
  end
end
