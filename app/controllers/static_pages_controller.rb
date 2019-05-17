
class StaticPagesController < ApplicationController
  def home
    environment = ENV.fetch("RAILS_ENV")
    branch = `git rev-parse --abbrev-ref HEAD`
    app_version = `git describe --tag`

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    changelog = markdown.render(File.read("#{Rails.root}/CHANGELOG.md"))
    render locals: { environment: environment, branch: branch, version: app_version, changelog: changelog }
  end
end
