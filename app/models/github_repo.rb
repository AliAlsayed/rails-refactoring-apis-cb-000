class GithubRepo
  attr_reader :name, :url
  def initialize(params)
    @name = params['name']
    @url = params['html_url']
  end
end
