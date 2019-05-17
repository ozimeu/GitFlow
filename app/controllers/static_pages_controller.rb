
class StaticPagesController < ApplicationController
  def home
    environment = ENV.fetch("RAILS_ENV")

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    changelog = markdown.render(File.read("#{Rails.root}/CHANGELOG.md"))
    render locals: { environment: environment, changelog: changelog }
  end
end
