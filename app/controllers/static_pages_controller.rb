class StaticPagesController < ApplicationController
  def home
    environment = ENV.fetch("RAILS_ENV")

    render locals: { environment: environment }
  end
end
