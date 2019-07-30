class UserPointsService

  def initialize(user_points, user)
    @user_points = user_points
    @user = user
  end

  def save_user_points
    @user_points[:data].each_with_index do |user, index|
      @user.user_points.create(
        points: user[:points], 
        hours: user[:time_watched],
        username: user[:username],
        rank: index + 1
      )
    end
  end
end