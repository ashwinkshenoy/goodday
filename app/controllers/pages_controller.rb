require 'RMagick'
include Magick

class PagesController < ApplicationController

  # Home page
  def home
  end

  # The text is written to the image
  def tweet
    img = ImageList.new("#{Rails.root}/public/base_img.jpg")
    txt = Draw.new
    c = 0

    # 50 characters in one row
    (params[:message].length/50 + 1).times do |i|
      img.annotate(txt, 0, 0, 0, 400 - c, params[:message][(0 + 50 * i)..50*(i+1)]) {
        txt.gravity = Magick::SouthGravity
        txt.pointsize = 20
        txt.stroke = '#de9007'
        txt.fill = '#de9007'
        # txt.font_weight = Magick::BoldWeight
        c += 50
      }
    end

    img.annotate(txt, 0, 0, 0, 400 - c, '#SmileMoreForAGoodDay') {
      txt.gravity = Magick::SouthGravity
      txt.pointsize = 20
      txt.stroke = '#cf0a2c'
      txt.fill = '#cf0a2c'
      # txt.font_weight = Magick::BoldWeight
      c += 50
    }

    # Giving file name and writing to file
    img.format = 'jpeg'
    fname = SecureRandom.hex(20)
    path = "#{Rails.root}/public/#{fname}.jpg"
    img.write(path)
    render json: { status: 200, path: path }
  end

  # Omniauth to twitter with path of file passed along
  def connect_twitter
    redirect_to "/auth/twitter?path=#{params['path']}"
  end

  # Return from omniauth along with path of file
  def return_twitter
    token = request.env['omniauth.auth'].credentials['token']
    secret = request.env['omniauth.auth'].credentials['secret']
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = token
      config.access_token_secret = secret
    end

    # Posting to twitter
    client.update_with_media('#SmileMoreForAGoodDay', File.new(params[:path]))
    flash[:success] = 'Tweet Successful!! #SmileMoreForAGoodDay'

    # Deleting file
    File.delete(params['path']) if File.exist?(params['path'])
    redirect_to root_path
  end

end
