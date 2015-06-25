# -*- encoding : utf-8 -*-
class Wechat::BaseController < ApplicationController
  layout false

  def verify
    if params[:signature] and params[:echostr] and params[:timestamp] and params[:nonce] and Digest::SHA1.hexdigest([params[:timestamp], params[:nonce], Setting.key[:wechat][:token]].sort.join) == params[:signature]
      render text: params[:echostr]
    else
      render text: 'failure'
    end
  end
end