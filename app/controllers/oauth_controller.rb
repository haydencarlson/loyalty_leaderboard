class OauthController < ApplicationController

  def index
    @code = params[:code]
    render :oauth
  end

  def create
    # Check if user exists for given twitch name
    return render json: { error: 'Twitch name is already registered.'} if User.exists?(twitch_name: params[:twitch_name])

    # Get oauth code from params
    code = params[:code]

    # Create payload to retrieve access token
    payload = {
      grant_type: 'authorization_code',
      client_id: Rails.application.credentials.streamlabs_client_id,
      client_secret: Rails.application.credentials.streamlabs_client_secret,
      redirect_uri: Rails.application.credentials.streamlabs_redirect_uri,
      code: code
    }

    # Get access token
    response = RestClient.post('https://streamlabs.com/api/v1.0/token', payload)

    # Parse response
    parsed_response = JSON.parse(response)

    # Create new user
    user = User.create({
      access_token: parsed_response['access_token'],
      refresh_token: parsed_response['refresh_token'],
      token_expires_at: Time.now + 3600,
      twitch_name: params[:twitch_name]
    })

    # user_points = RestClient.get("https://streamlabs.com/api/v1.0/points/user_points?access_token=#{user.access_token}&sort=time_watched&order=desc")
    user_points = RestClient.get("https://streamlabs.com/api/v1.0/donations?access_token=#{user.access_token}")
    
    # Render response with token that be used to query user points
    render json: { success: "Access granted. Please use #{user.user_token} for your points command"}
  rescue => e
    render json: { error: 'Error while authorizing'}
  end
end
