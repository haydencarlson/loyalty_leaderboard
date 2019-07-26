namespace :points do
  desc "Goes through users and updates points in database"
  task update_points: :environment do
    # Loop each user
    User.each do |user|

      # Is token expired?
      if Time.now >= user.token_expires_at

        # Refresh token
        response = RestClient.post('https://streamlabs.com/api/v1.0/token', {
          grant_type: 'refresh_token',
          client_id: Rails.application.credentials.streamlabs_client_id,
          client_secret: Rails.application.credentials.streamlabs_client_secret,
          redirect_uri: Rails.application.credentials.streamlabs_redirect_uri,
          refresh_token: user.refresh_token
        })

        # Parse response
        parsed_response = JSON.parse(response)

        # Update user
        user.update({ 
          access_token: parsed_response[:access_token],
          refresh_token: parsed_response[:refresh_token],
          token_expires_at: Time.now + 3600
        })
        get_user_points(parsed_response[:access_token])
      end
      get_user_points(user.access_token)
    end
  end

  def get_user_points(access_token)
    RestClient.get("https://streamlabs.com/api/v1.0/points/user_points?access_token=#{access_token}&sort=time_watched&order=desc")
  end

end
