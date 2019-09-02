class GithubService
  attr_reader :access_token
  def initialize(access_hash=nil)
    @access_token = access_hash ? access_hash['access_token'] : nil
  end

  def authenticate!(client_id, client_secret, code)
    response = Faraday.post "https://github.com/login/oauth/access_token",
     {client_id: client_id, client_secret: client_secret, code: code},
      {'Accept' => 'application/json'}
    access_hash = JSON.parse(response.body)
    @access_token = access_hash["access_token"]
    @access_token
  end

  def get_username
    user_response = Faraday.get "https://api.github.com/user", {},
    {'Authorization' => "token #{self.access_token}",
      'Accept' => 'application/json'}
    user_json = JSON.parse(user_response.body)
    user_json['login']
  end

  def get_repos
    repos_response = Faraday.get "https://api.github.com/user/repos", {},
    {'Authorization' => "token #{self.access_token}",
      'Accept' => 'application/json'}
    repos_json = JSON.parse(repos_response.body)
    repos_json.map{|repo| GithubRepo.new(repo)}
  end

  def create_repo
    response = Faraday.post "https://api.github.com/user/repos",
     {name: params[:name]}.to_json,
      {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
  end
end